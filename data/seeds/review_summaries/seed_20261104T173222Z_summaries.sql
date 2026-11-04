-- ============================================================================
-- PROFESSOR REVIEW AI SUMMARIES SEED
-- ============================================================================
-- TEC-DATA-META scope=review_summaries
-- TEC-DATA-META generated_at_utc=2026-11-04T17:32:22.652Z
-- TEC-DATA-META total_professors=1

BEGIN;
SET LOCAL search_path = public;

INSERT INTO public.professor_review_summary (
  professor_id,
  summary,
  reviews_analyzed_count,
  last_review_id_analyzed,
  model_used,
  updated_at
)
VALUES
    (34, 'Las clases se caracterizan por una **dinámica explicativa paciente y personalizada**, apoyada en lecciones asincrónicas en video donde se detallan los procedimientos paso a paso. No obstante, las soluciones no suelen publicarse en documentos escritos y las guías de estudio frecuentemente contienen ejercicios reciclados con erratas, por lo que resulta indispensable **tomar notas rigurosas de las grabaciones**. Asimismo, las evaluaciones y pruebas cortas semanales tienden a presentar enunciados retadores o enredados, aunque el criterio de calificación es accesible para quienes entregan oportunamente todas las tareas y dedican tiempo constante a la práctica independiente.', 14, 20770, 'cliproxy/gemini-3.8-flash#medium', NOW())
ON CONFLICT (professor_id) DO UPDATE SET
  summary = EXCLUDED.summary,
  reviews_analyzed_count = EXCLUDED.reviews_analyzed_count,
  last_review_id_analyzed = EXCLUDED.last_review_id_analyzed,
  model_used = EXCLUDED.model_used,
  updated_at = NOW();

COMMIT;
