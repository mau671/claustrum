-- 0107_group_remaining_equivalent_attempts.sql
-- Groups remaining attempts (like IN_PROGRESS or FAILED) of an equivalent course
-- to the exact same placeholder course that claimed the APPROVED attempt.

BEGIN;

ALTER TABLE public.student_course_record
  DROP CONSTRAINT IF EXISTS student_course_record_user_course_attempt_unique;

DO $$
DECLARE
  v_count INTEGER;
BEGIN
  -- Update all attempts that are still directly on an equivalent course,
  -- if that equivalent course has already been claimed by a placeholder course
  -- for the same user and study plan.
  UPDATE public.student_course_record scr
  SET 
    course_id = claimed.course_id,
    equivalent_course_id = scr.course_id
  FROM (
    -- Find which equivalent courses have been assigned to which placeholders
    SELECT DISTINCT user_id, study_plan_id, equivalent_course_id as eq_id, course_id
    FROM public.student_course_record
    WHERE equivalent_course_id IS NOT NULL
  ) claimed
  WHERE scr.user_id = claimed.user_id
    AND scr.study_plan_id = claimed.study_plan_id
    AND scr.course_id = claimed.eq_id
    AND scr.equivalent_course_id IS NULL;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  RAISE NOTICE 'Grouped % additional attempts to their claimed placeholders', v_count;
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

-- Restore the unique constraint
ALTER TABLE public.student_course_record
  ADD CONSTRAINT student_course_record_user_course_attempt_unique
  UNIQUE (user_id, study_plan_id, course_id, attempt_number);

COMMIT;
