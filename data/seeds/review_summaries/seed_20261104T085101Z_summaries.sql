-- ============================================================================
-- PROFESSOR REVIEW AI SUMMARIES SEED
-- ============================================================================
-- TEC-DATA-META scope=review_summaries
-- TEC-DATA-META generated_at_utc=2026-11-04T08:51:01.244Z
-- TEC-DATA-META total_professors=1

BEGIN;
SET LOCAL search_path = public;

INSERT INTO public.professor_review_ai_summary (
  professor_id,
  summary,
  reviews_analyzed_count,
  last_review_id_analyzed,
  model_used,
  updated_at
)
VALUES
    (494, 'Las lecciones destacan por una **metodología interactiva y amena** en la que los contenidos matemáticos se desglosan paso a paso mediante abundantes ejemplos prácticos, lo que facilita enormemente la asimilación conceptual. Existe una **alta disposición para resolver dudas** con paciencia tanto durante las clases como por correo electrónico, sumado a una notable flexibilidad en los espacios de consulta individual. Respecto a la medición del aprendizaje, el curso se caracteriza por **evaluaciones accesibles y calificación flexible**, por lo que mantener una **atención constante en clase** y evidenciar interés genuino resulta suficiente para superar la materia con excelentes calificaciones.', 157, 1355, 'cliproxy/gemini-3.8-flash#medium', NOW())
ON CONFLICT (professor_id) DO UPDATE SET
  summary = EXCLUDED.summary,
  reviews_analyzed_count = EXCLUDED.reviews_analyzed_count,
  last_review_id_analyzed = EXCLUDED.last_review_id_analyzed,
  model_used = EXCLUDED.model_used,
  updated_at = NOW();

COMMIT;
