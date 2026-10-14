#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <db-url> [seed-dir]"
  exit 1
fi

DB_URL="$1"
SEED_DIR="${2:-../seeds/itcr}"
RESET_BEFORE_BASELINE="${SEED_HISTORY_RESET_BEFORE_BASELINE:-0}"

if [[ ! -d "$SEED_DIR" ]]; then
  echo "Seed directory does not exist: $SEED_DIR"
  exit 1
fi

to_int_array_literal() {
  local csv="$1"
  if [[ -z "$csv" ]]; then
    printf '{}'
    return
  fi
  local cleaned
  cleaned="$(printf '%s' "$csv" | tr -d '[:space:]')"
  if [[ -z "$cleaned" ]]; then
    printf '{}'
    return
  fi
  printf '{%s}' "$cleaned"
}

to_text_array_literal() {
  local csv="$1"
  if [[ -z "$csv" ]]; then
    printf '{}'
    return
  fi
  local cleaned
  cleaned="$(printf '%s' "$csv" | tr -d '[:space:]')"
  if [[ -z "$cleaned" ]]; then
    printf '{}'
    return
  fi
  printf '{%s}' "$cleaned"
}

mapfile -t seed_files < <(ls "$SEED_DIR"/seed_*.sql 2>/dev/null | sort)

if [[ ${#seed_files[@]} -eq 0 ]]; then
  echo "No seed files found in $SEED_DIR"
  exit 1
fi

echo "Fetching applied seed SHAs from database..."
declare -A APPLIED_SHAS
while read -r sha; do
  if [[ -n "$sha" ]]; then
    APPLIED_SHAS["$sha"]=1
  fi
done < <(psql "$DB_URL" -At -v ON_ERROR_STOP=1 -c "SELECT seed_sha256 FROM public.sync_seed_run WHERE status = 'applied';" 2>/dev/null || true)

for seed_path in "${seed_files[@]}"; do
  seed_file="$(basename "$seed_path")"
  seed_sha="$(sha256sum "$seed_path" | awk '{print $1}')"

  if [[ "${APPLIED_SHAS[$seed_sha]:-}" == "1" ]]; then
    echo "[skip] $seed_file already applied"
    continue
  fi

  scope_line="$(grep -m1 '^-- TEC-DATA-META scope=' "$seed_path" || true)"
  years_line="$(grep -m1 '^-- TEC-DATA-META years=' "$seed_path" || true)"
  terms_line="$(grep -m1 '^-- TEC-DATA-META term_external_keys=' "$seed_path" || true)"

  scope="${scope_line#-- TEC-DATA-META scope=}"
  years_csv="${years_line#-- TEC-DATA-META years=}"
  terms_csv="${terms_line#-- TEC-DATA-META term_external_keys=}"

  if [[ -z "$scope" || "$scope" == "$scope_line" ]]; then
    scope="all"
  fi

  years_literal="$(to_int_array_literal "$years_csv")"
  terms_literal="$(to_text_array_literal "$terms_csv")"

  if [[ "$seed_file" == *"_initial.sql" ]]; then
    if [[ "$RESET_BEFORE_BASELINE" == "1" ]]; then
      echo "[prep] truncating public tables before baseline seed"
      psql "$DB_URL" -v ON_ERROR_STOP=1 -c \
        "DO \$\$ DECLARE tbls TEXT; BEGIN SELECT string_agg(format('%I.%I', schemaname, tablename), ', ') INTO tbls FROM pg_tables WHERE schemaname = 'public'; IF tbls IS NOT NULL THEN EXECUTE 'TRUNCATE TABLE ' || tbls || ' RESTART IDENTITY CASCADE'; END IF; END \$\$;"

    else
      existing_rows="$({
        psql "$DB_URL" -At -v ON_ERROR_STOP=1 -c "SELECT count(*) FROM public.schedule_equivalence_placeholder_course;"
      } || true)"
      if [[ "$existing_rows" != "0" && -n "$existing_rows" ]]; then
        echo "[error] baseline seed requires empty public tables (found schedule_equivalence_placeholder_course rows=$existing_rows)."
        echo "        rerun with SEED_HISTORY_RESET_BEFORE_BASELINE=1 to truncate public tables before applying baseline."
        exit 1
      fi
    fi
  fi

  echo "[apply] $seed_file"
  psql "$DB_URL" -v ON_ERROR_STOP=1 -f "$seed_path"

  psql "$DB_URL" -v ON_ERROR_STOP=1 \
    -v seed_file_name="$seed_file" \
    -v seed_sha256="$seed_sha" \
    -v scope="$scope" \
    -v years_literal="$years_literal" \
    -v terms_literal="$terms_literal" <<'SQL'
INSERT INTO public.sync_seed_run (
  seed_file_name,
  seed_sha256,
  scope,
  years,
  term_external_keys,
  generated_at_utc,
  applied_at_utc,
  status,
  metadata
)
VALUES (
  :'seed_file_name',
  :'seed_sha256',
  :'scope',
  :'years_literal'::integer[],
  :'terms_literal'::text[],
  NOW(),
  NOW(),
  'applied',
  '{}'::jsonb
)
ON CONFLICT (seed_sha256) DO UPDATE
SET
  seed_file_name = EXCLUDED.seed_file_name,
  scope = EXCLUDED.scope,
  years = EXCLUDED.years,
  term_external_keys = EXCLUDED.term_external_keys,
  applied_at_utc = NOW(),
  status = 'applied',
  error_message = NULL,
  updated_at = NOW();
SQL

  echo "[ok] $seed_file"
done

echo "Done."
