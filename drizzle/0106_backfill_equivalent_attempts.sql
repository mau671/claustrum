-- 0106_backfill_equivalent_attempts.sql
-- Backfills equivalent course attempts to explicitly link them to their placeholder courses.
-- Uses a partitioned greedy match to assign the oldest/best attempts to the earliest placeholders.

BEGIN;

-- Temporarily drop the unique constraint so we can shuffle records without collisions
ALTER TABLE public.student_course_record
  DROP CONSTRAINT IF EXISTS student_course_record_user_course_attempt_unique;

DO $$
DECLARE
  v_count INTEGER := 0;
BEGIN
  -- Create a temporary table to hold the results of the greedy match
  CREATE TEMP TABLE attempt_updates (
    attempt_id BIGINT,
    new_course_id BIGINT,
    equivalent_course_id BIGINT
  );

  WITH RECURSIVE
  -- 1. Get all active courses in active plans
  plan_courses AS (
    SELECT 
      spl.study_plan_id,
      splc.course_id,
      spl.level_number,
      splc.sort_order
    FROM public.study_plan_level_course splc
    JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
    JOIN public.course c ON c.id = splc.course_id
    WHERE splc.is_active = true
      AND spl.is_active = true
      AND c.is_active = true
  ),
  -- 2. Rank the placeholder slots (earliest levels first)
  ranked_pc AS (
    SELECT 
      study_plan_id,
      course_id,
      ROW_NUMBER() OVER (
        PARTITION BY study_plan_id 
        ORDER BY level_number ASC, sort_order ASC, course_id ASC
      ) as pc_rank
    FROM plan_courses
  ),
  -- 3. Get all active equivalence edges
  equivalence_edges AS (
    SELECT cr.study_plan_id, cr.from_course_id, cr.to_course_id
    FROM public.course_relation cr
    JOIN public.course from_course ON from_course.id = cr.from_course_id
    JOIN public.course to_course ON to_course.id = cr.to_course_id
    WHERE cr.relation_type = 'EQUIVALENT'
      AND cr.is_active = true
      AND from_course.is_active = true
      AND to_course.is_active = true
  ),
  -- 4. Compute transitive closure of equivalences (what satisfies what)
  equivalence_closure(study_plan_id, seed_course_id, equivalent_course_id, path) AS (
    SELECT pc.study_plan_id, pc.course_id, pc.course_id, ARRAY[pc.course_id]
    FROM plan_courses pc
    UNION ALL
    SELECT ec.study_plan_id, ec.seed_course_id, ee.to_course_id, ec.path || ee.to_course_id
    FROM equivalence_closure ec
    JOIN equivalence_edges ee ON ee.study_plan_id = ec.study_plan_id AND ee.from_course_id = ec.equivalent_course_id
    WHERE NOT ee.to_course_id = ANY(ec.path)
  ),
  -- 5. Get all attempts currently in the system
  -- Note: If an attempt is ALREADY assigned to a placeholder (equivalent_course_id IS NOT NULL),
  -- we treat its course_id as the placeholder and its equivalent_course_id as the attempt,
  -- but since this is a backfill for old data, equivalent_course_id is likely NULL.
  -- To be safe, we just use COALESCE(equivalent_course_id, course_id) as the source.
  propagated_attempts AS (
    SELECT DISTINCT ON (scr.id)
      scr.id AS attempt_id,
      scr.user_id,
      scr.study_plan_id,
      COALESCE(scr.equivalent_course_id, scr.course_id) AS pa_id,
      scr.status,
      scr.recorded_at,
      scr.attempt_number
    FROM public.student_course_record scr
    JOIN public.course c ON c.id = COALESCE(scr.equivalent_course_id, scr.course_id)
    WHERE c.is_active = true
  ),
  -- 6. Rank attempts by quality (Approved > Failed > In Progress, then oldest first)
  ranked_pa AS (
    SELECT 
      *,
      ROW_NUMBER() OVER (
        PARTITION BY user_id, study_plan_id
        ORDER BY 
          CASE status 
            WHEN 'APPROVED' THEN 1 
            WHEN 'FAILED' THEN 2 
            WHEN 'IN_PROGRESS' THEN 3 
            WHEN 'WITHDRAWN' THEN 4 
            ELSE 5 
          END ASC,
          recorded_at ASC NULLS LAST, -- Oldest attempts claim earliest placeholders
          attempt_id ASC
      ) as pa_rank
    FROM propagated_attempts
  ),
  -- 7. Generate all possible (placeholder, attempt) pairs
  possible_pairs AS (
    SELECT 
      rpa.user_id,
      rpc.study_plan_id,
      rpc.course_id as pc_id, 
      rpc.pc_rank,
      rpa.pa_id, 
      rpa.pa_rank,
      rpa.attempt_id,
      rpa.status
    FROM ranked_pc rpc
    JOIN equivalence_closure ec ON ec.study_plan_id = rpc.study_plan_id AND ec.seed_course_id = rpc.course_id
    JOIN ranked_pa rpa ON rpa.study_plan_id = ec.study_plan_id AND rpa.pa_id = ec.equivalent_course_id
    WHERE (
      rpa.pa_id = rpc.course_id
      OR NOT EXISTS (
        SELECT 1
        FROM plan_courses same_plan_course
        WHERE same_plan_course.study_plan_id = rpa.study_plan_id 
          AND same_plan_course.course_id = rpa.pa_id
      )
    )
  ),
  -- 8. Order pairs globally per user/plan
  ordered_pairs AS (
    SELECT 
      *, 
      ROW_NUMBER() OVER (
        PARTITION BY user_id, study_plan_id
        ORDER BY 
          CASE WHEN pc_id = pa_id THEN 0 ELSE 1 END ASC,
          CASE status WHEN 'APPROVED' THEN 1 WHEN 'FAILED' THEN 2 ELSE 3 END ASC,
          pc_rank ASC,
          pa_rank ASC
      ) as pair_id
    FROM possible_pairs
  ),
  -- 9. Partitioned greedy match using recursive CTE with lateral join
  greedy_match(user_id, study_plan_id, pair_id, pc_id, pa_id, attempt_id, used_pc, used_pa) AS (
    -- Base case: Pair 1 for each user_plan
    SELECT op.user_id, op.study_plan_id, op.pair_id, op.pc_id, op.pa_id, op.attempt_id, ARRAY[op.pc_id], ARRAY[op.pa_id]
    FROM ordered_pairs op
    WHERE op.pair_id = 1
    
    UNION ALL
    
    -- Recursive case: Next available pair for that user_plan
    SELECT op.user_id, op.study_plan_id, op.pair_id, op.pc_id, op.pa_id, op.attempt_id,
           gm.used_pc || op.pc_id,
           gm.used_pa || op.pa_id
    FROM greedy_match gm
    JOIN LATERAL (
      SELECT * FROM ordered_pairs sub_op
      WHERE sub_op.user_id = gm.user_id 
        AND sub_op.study_plan_id = gm.study_plan_id
        AND sub_op.pair_id > gm.pair_id
        AND NOT sub_op.pc_id = ANY(gm.used_pc)
        AND NOT sub_op.pa_id = ANY(gm.used_pa)
      ORDER BY sub_op.pair_id ASC
      LIMIT 1
    ) op ON true
  )
  -- 10. Insert into temp table
  INSERT INTO attempt_updates (attempt_id, new_course_id, equivalent_course_id)
  SELECT 
    gm.attempt_id, 
    gm.pc_id, 
    gm.pa_id
  FROM greedy_match gm
  WHERE gm.pc_id <> gm.pa_id;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  RAISE NOTICE 'Backfilled % equivalent attempts to placeholders', v_count;

  -- 11. Execute the updates on the real table
  UPDATE public.student_course_record scr
  SET 
    course_id = au.new_course_id,
    equivalent_course_id = au.equivalent_course_id
  FROM attempt_updates au
  WHERE scr.id = au.attempt_id;

END $$;

-- Recalculate attempt_number for all records to ensure no gaps or collisions
WITH ranked_attempts AS (
  SELECT
    id,
    ROW_NUMBER() OVER (
      PARTITION BY user_id, study_plan_id, course_id
      ORDER BY recorded_at ASC NULLS LAST, id ASC
    ) AS rn
  FROM public.student_course_record
)
UPDATE public.student_course_record scr
SET attempt_number = ra.rn
FROM ranked_attempts ra
WHERE scr.id = ra.id
  AND (scr.attempt_number IS NULL OR scr.attempt_number <> ra.rn);

-- Restore the unique constraint safely now that attempt_numbers are sequential and unique
ALTER TABLE public.student_course_record
  ADD CONSTRAINT student_course_record_user_course_attempt_unique
  UNIQUE (user_id, study_plan_id, course_id, attempt_number);

COMMIT;
