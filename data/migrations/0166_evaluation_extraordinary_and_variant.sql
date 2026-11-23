-- Add structured fields for the source dataset's alternative exam versions.
-- "extraordinary" maps the source `_E` token; "variant" maps `_V2`, `_V3`, ...

ALTER TABLE public.course_evaluations
  ADD COLUMN IF NOT EXISTS extraordinary boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS variant integer;

ALTER TABLE public.course_evaluations
  DROP CONSTRAINT IF EXISTS course_evaluations_variant_check;
ALTER TABLE public.course_evaluations
  ADD CONSTRAINT course_evaluations_variant_check
  CHECK (variant IS NULL OR variant BETWEEN 1 AND 99);

-- "Parcial N (Extraordinario)", "Parcial N (V2)", "Parcial N (Extraordinario - V2)"
WITH parsed AS (
  SELECT
    id,
    (regexp_match(name, 'Parcial\s*(\d+)', 'i'))[1]::int AS num,
    (regexp_match(name, 'V(\d+)', 'i'))[1]::int AS v,
    name ILIKE '%Extraordinario%' AS extra
  FROM public.course_evaluations
  WHERE type = 'otro'::evaluation_type
    AND name ~* '^Parcial\s*\d+\s*\('
)
UPDATE public.course_evaluations e
SET
  type = 'parcial'::evaluation_type,
  number = p.num,
  extraordinary = p.extra,
  variant = p.v,
  name = NULL
FROM parsed p
WHERE e.id = p.id;

-- "Extraordinario" alone: the importer already set type = 'reposicion'
UPDATE public.course_evaluations
SET
  extraordinary = true,
  name = NULL
WHERE name = 'Extraordinario';
