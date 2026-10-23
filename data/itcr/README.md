# ITCR Data CLI

Herramienta CLI para descargar y procesar datos del Instituto Tecnológico de Costa Rica (ITCR).
Los comandos pueden ejecutarse indistintamente como `uv run itcr <comando>` o `uv run tec-data <comando>`.

## Requisitos

- Python 3.11+
- uv (gestor de paquetes)

## Instalación

```bash
uv sync
```

## Flujo de Trabajo Completo

Esta sección describe todos los comandos necesarios para descargar y procesar todas las entidades de datos.

### Dependencias entre Entidades

```
campus
   └── academic_unit (requiere campus)
            └── academic_unit_campus (generado durante process)
   └── study_plan (requiere academic_unit_campus)
            └── course (generado durante process)

academic_period (independiente)

course_offer (requiere academic_unit)
   └── schedule_guia (requiere course_offer)

course_offering (requiere course_offer, schedule_guia, campus, academic_unit, academic_term, course, professor)
```

### Descarga de Datos

#### Paso 1: Descargar datos base

```bash
uv run tec-data download
```

Este comando descarga:

- `data/raw/campus/` - Sedes del TEC
- `data/raw/academic_unit/` - Escuelas/carreras
- `data/raw/academic_period/` - Modalidades y períodos académicos

#### Paso 2: Descargar planes de estudio

```bash
uv run tec-data download --scope catalog
```

**Nota**: Este comando requiere que primero se ejecute `uv run tec-data process` para generar `academic_unit_campus`.

#### Paso 3: Descargar oferta de cursos

```bash
uv run tec-data download --scope offering --years 2026

# O varios años en una sola ejecución
uv run tec-data download --scope offering --years 2024,2025,2026
```

**Parámetros**:

- `--years`: Lista separada por coma para múltiples años (ej: 2024,2025,2026)

**Requiere**: `academic_unit/data.json` generado durante el process.

Archivos generados:

- `data/raw/course_offer/{year}/*.json`

#### Paso 4: Descargar horarios (schedule_guia)

```bash
uv run tec-data download --scope offering --years 2026

# O varios años en una sola ejecución
uv run tec-data download --scope offering --years 2024,2025,2026
```

**Requiere**: Datos de `course_offer` del mismo año.

Archivos generados:

- `data/raw/schedule_guia/{year}/*.json`

#### Paso 4.1: Descargar oferta + horarios en un solo comando

```bash
uv run tec-data download --scope offering --years 2024,2025,2026
```

Este comando descarga por cada año:

- `course_offer`
- `schedule_guia`

### Procesamiento de Datos

#### Paso 1: Procesar datos base

```bash
uv run tec-data process
```

Este comando procesa:

- `data/raw/country/` y `data/raw/university/` (datos de referencia estáticos)
- `data/raw/campus/data.json`
- `data/raw/academic_unit/data.json` y `data/raw/academic_unit_campus/data.json`
- `data/raw/academic_modality/data.json` y `data/raw/academic_term/data.json`

#### Paso 2: Procesar planes de estudio

```bash
uv run tec-data process --scope catalog
```

**Requiere**: `academic_unit_campus/data.json` generado en el paso 1.

Genera:

- `data/raw/study_plan/data.json`
- `data/raw/study_plan_campus/data.json`
- `data/raw/study_plan_level/data.json`
- `data/raw/study_plan_level_course/data.json`
- `data/raw/course/data.json`
- `data/raw/course_relation/data.json`

#### Paso 3: Procesar oferta de cursos y horarios

```bash
uv run tec-data process --scope offering --years 2026
```

**Requiere**:

- `data/raw/course_offer/2026/`
- `data/raw/schedule_guia/2026/`
- `data/raw/campus/data.json`
- `data/raw/academic_unit/data.json`
- `data/raw/academic_term/data.json`
- `data/raw/course/data.json`
- `data/raw/professor/data.json`

**Acciones**:

- Mezcla datos de `course_offer` y `schedule_guia`
- Actualiza nombres de cursos vacíos en `course/data.json`
- Genera 875 profesores nuevos
- Genera registros en:
  - `data/raw/course_offering/data.json` (1140 ofertas)
  - `data/raw/course_offering_group/data.json` (2845 grupos)
  - `data/raw/course_offering_group_professor/data.json` (2751 relaciones)
  - `data/raw/course_offering_meeting/data.json` (2845 reuniones)

## Comandos por Entity

### Download

| Entity            | Requiere                       | Genera                                                            |
| ----------------- | ------------------------------ | ----------------------------------------------------------------- |
| `campus`          | -                              | `data/raw/campus/`                                                |
| `academic_unit`   | campus                         | `data/raw/academic_unit/`                                         |
| `academic_period` | -                              | `data/raw/academic_period/`                                       |
| `study_plan`      | process (academic_unit_campus) | `data/raw/study_plan/`                                            |
| `course_offer`    | process (academic_unit)        | `data/raw/course_offer/{year}/`                                   |
| `schedule_guia`   | course_offer                   | `data/raw/schedule_guia/{year}/`                                  |
| `offering`        | process (academic_unit)        | `data/raw/course_offer/{year}/`, `data/raw/schedule_guia/{year}/` |

### Process

| Entity            | Requiere                                                                  | Genera                                                                     |
| ----------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| `campus`          | -                                                                         | `data/raw/campus/data.json`                                                |
| `academic_unit`   | campus                                                                    | `data/raw/academic_unit/data.json`, `academic_unit_campus/data.json`       |
| `academic_period` | -                                                                         | `data/raw/academic_modality/data.json`, `data/raw/academic_term/data.json` |
| `study_plan`      | campus, academic_unit, academic_period, academic_unit_campus              | `data/raw/study_plan/`, `data/raw/course/data.json`                        |
| `course_offering` | course_offer, schedule_guia, campus, academic_unit, academic_term, course | `data/raw/course_offering/`, `data/raw/professor/data.json`                |

## Resumen de Comandos en Orden

```bash
# 1. Descargar datos base
uv run tec-data download

# 2. Procesar datos base
uv run tec-data process

# 3. Descargar planes de estudio
uv run tec-data download --scope catalog

# 4. Procesar planes de estudio
uv run tec-data process --scope catalog

# 5. Descargar oferta de cursos (año específico)
uv run tec-data download --scope offering --years 2026

# 6. Descargar horarios (año específico)
uv run tec-data download --scope offering --years 2026

# Alternativa: descargar oferta + horarios para varios años
uv run tec-data download --scope offering --years 2024,2025,2026

# 7. Procesar oferta de cursos y horarios (año específico)
uv run tec-data process --scope offering --years 2026
```

## Generación de SQL

Por defecto `itcr sql` (o `tec-data sql`) ahora genera un delta versionado con timestamp UTC en
`../seeds/itcr/seed_YYYYMMDDTHHMMSSZ.sql`.

```bash
uv run itcr sql
```

Para generar un archivo puntual (modo full tradicional) en una ruta fija:

```bash
uv run itcr sql --mode full --output ../seed.sql
```

O para entidades específicas:

```bash
uv run itcr sql --tables campus,university,country
```

Opciones nuevas relevantes:

- `--mode delta|full`: `delta` (default) genera archivos versionados, `full` mantiene salida fija.
- `--scope catalog|offering|all`: define alcance lógico de la corrida para trazabilidad.
- `--years 2026,2027`: metadata de años sincronizados.
- `--terms 2026_A_1,2026_A_2`: metadata de periodos sincronizados.
- `--history-dir ../seeds/itcr`: carpeta de salida para deltas.
- `--manifest`: genera JSON acompañante con metadata del seed.

## Sincronización unificada de catálogo + oferta (local/prod)

Para ejecutar una sincronización idempotente completa (catálogo, planes, cursos, relaciones,
profesores y oferta), usa el comando unificado `sync`:

```bash
# Local (usa postgres local)
uv run itcr sync --target local --years 2026

# Remoto (lee .env.prod por defecto)
uv run itcr sync --target remote --years 2026

# O especificando archivo explícito
uv run itcr sync --target remote --years 2026 --env-file ../../.env.prod

# DB URL explícita
uv run itcr sync --target db-url --db-url "postgresql://..." --years 2026

# Historial de seeds con Postgres efimero
uv run itcr sync --target seed-history --seed-dir ../seeds/itcr --scope offering --years 2026 --no-apply

# En CI (GitHub service container) URL explicita
uv run itcr sync --target seed-history --seed-history-db-url "postgresql://postgres:postgres@127.0.0.1:5432/postgres" --seed-dir ../seeds/itcr --scope offering --years 2026 --no-apply
```

`--target seed-history` aplica las migraciones Drizzle (`drizzle/`) y luego replaya
los seeds históricos. No requiere `--skip-migrations` ni Supabase CLI: si se pasa
`--seed-history-db-url` se usa esa base; si no, se levanta un contenedor temporal.

Qué hace `sync`:

1. Ejecuta el pipeline completo de `download + process`.
2. Remapea IDs de todas las tablas sincronizadas por llaves naturales contra la DB destino.
3. Genera SQL delta mínimo (solo inserts/updates/soft-delete necesarios).
4. Aplica el seed generado en la DB destino.
5. Ejecuta verificaciones post-sync.

Opciones útiles:

- `--skip-pipeline`: no vuelve a descargar/procesar; usa `data/raw` actual.
- `--no-apply`: solo genera SQL (no aplica).
- `--keep-sql/--no-keep-sql`: conserva o elimina el SQL generado (por defecto se conserva).
- `--scope catalog|offering|all`: alcance lógico para diff/soft-delete.
- `--seed-dir ../seeds/itcr`: carpeta de historial para `--target seed-history`.
- `--baseline-seed seed_YYYYMMDDTHHMMSSZ_*.sql`: seed inicial opcional para replay parcial.
- `--seed-history-db-url`: URL Postgres para `--target seed-history` (por defecto `127.0.0.1:5432`).

### Ledger de seeds aplicados

Cada seed delta se registra en `public.sync_seed_run` con:

- hash SHA256 del archivo
- alcance (`scope`), años y periodos sincronizados
- timestamps UTC de generación/aplicación
- estado: `generated`, `applied`, `failed`, `skipped_duplicate`

Esto permite histórico tipo migraciones y evita reaplicar el mismo archivo.

### Metadata estricta por entorno

Cada seed generado incluye metadata `environment_id` (project_ref + host + db) y
`data_fingerprint` en cabecera SQL y manifest. Al aplicar, `sync` valida de forma
estricta que el seed corresponda al entorno destino:

- si no coincide, aborta la ejecución
- no existe override para cross-environment apply

Si no hay cambios de datos, `sync` genera un seed **NOOP** para auditoría.

### Garantías de alcance por periodo

- Para oferta (`course_offering*`), los soft-delete se aplican solo a términos sincronizados en la corrida.
- Correr `--years 2026` no afecta oferta 2025.
- No se generan `DELETE`, solo `INSERT/UPDATE` y soft-delete (`is_active=false`).
