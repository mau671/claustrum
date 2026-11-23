# Reviews Import

Proyecto Python con `uv` para importar reseñas de MisProfesores y asociarlas a profesores/cursos de la base local.

## Estructura

- `main.py`: entrypoint único del repo.
- `src/reviews/`: lógica de descarga, matching, procesamiento y auditoría.
- `data/state/`: estado e índices idempotentes.
  - `downloads/index.json`
  - `matching/professors.json`
  - `matching/unmatched.json`
  - `matching/decisions.json`
  - `matching/manual/*.json`
  - `courses/decisions.json`
  - `courses/variations.json`
- `data/raw/professors/{professor_id}/source-{source_id}/pages/page-XXX.json`: snapshots crudos.
- `data/raw/candidates/{source_id}/pages/page-XXX.json`: evidencia temporal de perfiles no confirmados.
- `data/processed/professors/{professor_id}/source-{source_id}/pages/page-XXX.json`: salida normalizada por página.
- `data/processed/reports/`: reportes del procesamiento.
- `data/reports/professors/`: auditorías de matching.
- `../../data/seeds/reviews/seed_YYYYMMDDTHHMMSSZ_{professor_id}.sql`: seeds SQL generados, junto a los de ITCR.

## Configuración de base de datos

El pipeline lee el catálogo (`professor`, `course`, `course_offering*`) con `psql`
directo contra `DATABASE_URL`. Ya no usa Supabase CLI ni necesita `supabase start`.

Orden de resolución de la URL:

1. `DATABASE_URL` (o `LOCAL_DB_URL`) del entorno.
2. `.env.dev`, luego `.env` y `.env.prod` en la raíz del workspace.
3. `postgresql://postgres:postgres@127.0.0.1:54322/postgres` como último recurso.

Para local: `pnpm run db:start && pnpm run db:migrate && pnpm run db:seed`.

## Comandos

```bash
uv run reviews-match
```

Genera `data/state/matching/professors.json`, `unmatched.json` y `decisions.json`.

```bash
uv run reviews-download
```

Descarga reseñas confirmadas de forma idempotente. Siempre revisa la página 1 y sigue hacia atrás hasta encontrar solapamiento conocido.

```bash
uv run reviews-download --include-unmatched --candidate-pages 2
```

Descarga evidencia limitada para perfiles unmatched en `data/raw/candidates/`.

```bash
uv run reviews-process --write-sql
```

Procesa `data/raw/professors/` hacia `data/processed/professors/` y genera SQL por profesor.

```bash
uv run reviews-import --professor-id 278 --complete-history --write-sql --no-openrouter
```

Descarga y procesa uno o varios profesores confirmados. `--complete-history` y `--write-sql` son opcionales y se activan manualmente. Con `--write-sql`, el seed se escribe en `data/seeds/reviews/seed_YYYYMMDDTHHMMSSZ_{professor_id}.sql`. `reviews-import-professor` queda como alias compatible.

```bash
uv run reviews-refresh-matches
```

Scrapea profesores, aplica matches automáticos y manuales, descarga evidencia limitada para unmatched, rematchea usando evidencia de cursos y ejecuta auditoría sin procesar reseñas.

```bash
uv run reviews-refresh-matches --update-reviews
```

Hace lo anterior y además actualiza reseñas crudas confirmadas de forma idempotente.

```bash
uv run reviews-audit
```

Audita matches existentes contra la evidencia.

```bash
uv run reviews-sync --include-unmatched --write-sql
```

Ejecuta el flujo completo: matching, evidencia unmatched, rematch, descarga, procesamiento y auditoría.

```bash
uv run reviews-sync-daily               # Python directo
pnpm run sync:reviews                   # Tarea diaria unificada (detecta, descarga, procesa y aplica seeds)
pnpm run sync:reviews -- --dry-run      # Vista previa sin descargar ni alterar la base
pnpm run sync:reviews -- --prod         # Aplica a base de datos en producción
pnpm run sync:reviews -- --skip-summaries  # Omite la fase de AI summaries
pnpm run sync:reviews -- --push-branch mi-rama  # Rama destino del push (default: development)
pnpm run check:models                   # Verifica los modelos LLM configurados
```

### Modelos LLM

El matching de cursos usa OpenRouter y los resúmenes usan el CLI de `opencode` con un modelo free del provider `opencode`. Todo se puede sobreescribir por entorno:

| Variable | Default | Uso |
| --- | --- | --- |
| `OPENROUTER_API_KEY` | — | Requerida para el matching con LLM |
| `OPENROUTER_API_URL` | `https://openrouter.ai/api/v1/chat/completions` | Endpoint alternativo/proxy |
| `COURSE_MATCH_MODELS` | `nvidia/nemotron-3-ultra-550b-a55b:free, baidu/ernie-5.5-flash-preview:free, particle-ai/particle-1:free, nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free` | Lista de modelos en orden de fallback |
| `OPENROUTER_TIMEOUT_SECONDS` | `20` | Timeout por llamada |
| `OPENROUTER_ATTEMPTS` | número de modelos | Intentos totales entre la lista |
| `REVIEW_SUMMARY_MODEL` | `opencode/deepseek-v4.1-flash-free` | Modelo de los resúmenes |
| `REVIEW_SUMMARY_AGENT` | `professor-reviews-summarizer` | Agente de OpenCode |
| `REVIEW_SUMMARY_TIMEOUT_MS` | `45000` | Timeout por profesor |
| `REVIEW_SUMMARY_CONCURRENCY` | `16` | Profesores en paralelo |
| `REVIEW_SUMMARY_MIN_REVIEWS` | `10` | Mínimo de reseñas aprobadas |
| `REVIEW_SUMMARY_MIN_NEW` | `5` | Mínimo de reseñas nuevas desde el último resumen |
| `OPENCODE_BIN` | `opencode` | Binario del CLI |
| `SYNC_PUSH_BRANCH` | `development` | Rama del push automático |
| `SYNC_SKIP_SUMMARIES` / `SYNC_NO_OPENROUTER` | `0` | Equivalentes a los flags |

Los mismos valores se pueden pasar por flag (`--model`, `--llm-timeout`, `--llm-attempts`, `--timeout-ms`, `--concurrency`, `--min-reviews`, `--min-new`, `--push-branch`). El modelo usado se guarda en `professor_review_summary.model_used` en cada ejecución (la columna es nullable y no tiene default).

Para usar los modelos free de `opencode` el provider debe estar habilitado en la configuración de OpenCode. Una política `provider.use` que solo permita `opencode-go` los oculta del catálogo y `check:models` lo reporta como `MISS`.

Sincronización diaria rápida basada en snapshot del directorio de ITCR. En una única llamada HTTP (~1.5s) calcula si hubo incremento en el contador de reseñas de algún profesor (`m`), descarga y procesa únicamente los perfiles con cambios, y aplica los seeds generados.

## Idempotencia

Cada reseña cruda incluye `source_review_id`, derivado de `Reportar-Comentario_*` cuando existe. Si no existe, se usa un hash estable de fecha, curso, comentario y scores. El índice global está en `data/state/downloads/index.json`, mientras que cada perfil tiene su propio `data/raw/.../index.json`.

La importación a la base es idempotente por `professor_review.import_key`: antes de emitir SQL se revisan los seeds ya generados en `data/seeds/reviews/` y, si la base está accesible, los `import_key` ya presentes en la tabla. Aplicar el mismo seed dos veces no duplica filas.

## Aplicar seeds de reviews

Los seeds de reviews se aplican con el seeder unificado (no hay script aparte):

```bash
pnpm run db:seed -- --reviews            # local
pnpm run db:seed -- --reviews --prod     # producción
```

El seeder registra cada archivo en `public.sync_seed_run` con `scope = 'reviews'`, igual que los seeds de ITCR.
