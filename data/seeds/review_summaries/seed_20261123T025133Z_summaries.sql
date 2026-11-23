-- ============================================================================
-- PROFESSOR REVIEW AI SUMMARIES SEED
-- ============================================================================
-- TEC-DATA-META scope=review_summaries
-- TEC-DATA-META generated_at_utc=2026-11-23T02:51:33.970Z
-- TEC-DATA-META total_professors=4

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
    (395, 'Las clases combinan explicaciones pausadas con tableta gráfica y ejemplos de exámenes anteriores, aunque el volumen bajo de voz obliga a sentarse adelante y el ritmo lento resulta pesado para algunos. La dinámica participativa y la paciencia en consulta se valoran mucho, igual que los quices razonables y las tareas de práctica. El punto crítico está en la evaluación, porque los exámenes de cátedra exigen bastante práctica independiente y la calificación por procedimiento se percibe exigente e incluso binaria según el semestre. **Aprovechar las tutorías y llevar la materia al día** marca la diferencia, junto con un buen formulario y el estudio en grupo, ya que las clases por sí solas no alcanzan para el nivel que se evalúa.', 45, 25104, 'opencode/deepseek-v4.1-flash-free', NOW()),
    (393, 'Las reseñas dividen las aguas entre quienes valoran una explicación clara en los temas introductorios y quienes advierten que el curso se queda en lo básico, con exámenes que exigen bastante más de lo trabajado en clase. Conviene estudiar por cuenta propia y resolver ejercicios adicionales, ya que la evaluación es **estrictamente binaria** y un error de detalle anula el procedimiento completo. La asistencia y la participación se califican, los exámenes suelen parecerse a lo explicado en clase y al final aparece crédito extra que ayuda a subir nota. Eso sí, la organización de fechas falla y el trato se vuelve tenso cuando se le contradice, así que mantener un perfil bajo y aprovechar las horas de consulta resulta la estrategia más segura.', 47, 25097, 'opencode/deepseek-v4.1-flash-free', NOW()),
    (1151, 'Domina la materia y explica con claridad, combinando teoría y práctica de modo que incluso una materia árida resulta amena y llevadera, con evaluaciones que reflejan lo trabajado en clase y una respuesta constante a las dudas. Sin embargo, **el trato interpersonal es su punto débil**, ya que varias reseñas describen actitudes prepotentes y comentarios ásperos, sobre todo en las presentaciones grupales, junto con proyectos extensos y una calificación exigente que puede sentirse desproporcionada para tres créditos. Conviene estudiar de forma constante y pulir los entregables más allá de lo indicado, porque la retroalimentación es buena pero el margen de error resulta estrecho.', 11, 25049, 'opencode/deepseek-v4.1-flash-free', NOW()),
    (308, 'La dinámica combina **aula invertida** con repasos magistrales, con videos revisados antes y clases dedicadas a reforzar los temas, lo cual exige constancia semanal porque cada semana cae un resumen de video y un laboratorio en tríos. Quien sostiene ese ritmo aprende bastante y encuentra un curso accesible, ya que el profesor da tiempo extra, crédito adicional y califica con flexibilidad, aunque la carga de trabajos y proyectos grupales es alta y suele acumularse en el último mes. La asistencia y la participación pesan, y conviene armar un buen equipo desde el inicio. Algunos advierten desorden en las entregas, exámenes más largos de lo esperado y el uso del correo como portal del curso.', 11, 25086, 'opencode/deepseek-v4.1-flash-free', NOW())
ON CONFLICT (professor_id) DO UPDATE SET
  summary = EXCLUDED.summary,
  reviews_analyzed_count = EXCLUDED.reviews_analyzed_count,
  last_review_id_analyzed = EXCLUDED.last_review_id_analyzed,
  model_used = EXCLUDED.model_used,
  updated_at = NOW();

COMMIT;
