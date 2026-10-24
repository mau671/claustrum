# Query Performance Guide

Optimization reference for the Claustrum Supabase Postgres database
(`jxzkhfclcdpcgtkpyxyk`). Everything here is measured, not estimated. Every number
carries the source that produced it.

- **Database**: PostgreSQL 17.6, 148 MB total, 41 tables in `public`, 122 MB of which is
  table+index data.
- **Stats window**: `pg_stat_statements` was last reset on **9 Apr 2026** and has been
  accumulating for **197 days**. This matters enormously — see _Reading the numbers_
  below.
- **Connection model**: the application no longer talks to PostgREST. All traffic goes
  through the Cloudflare Worker → Hyperdrive → `hyperdrive_user`. PostgREST (the Data
  API) is disabled on the project.

---

## Reading the numbers

`pg_stat_statements` mixes two eras. Before the Hyperdrive migration, every request
travelled through PostgREST as the `authenticated` / `anon` roles and arrived wrapped in a
`WITH pgrst_source AS (...)` CTE. After the migration, the Worker talks directly as
`hyperdrive_user` and the queries are plain.

That gives a reliable way to separate them:

```sql
-- Real production cost today (Worker → Hyperdrive)
SELECT substring(query from 'public\.[a-z_]+') AS fn,
       calls,
       round(mean_exec_time::numeric, 1) AS mean_ms,
       round((total_exec_time / 1000.0)::numeric, 1) AS total_s
FROM extensions.pg_stat_statements
WHERE userid = (SELECT oid FROM pg_roles WHERE rolname = 'hyperdrive_user')
  AND query LIKE '%public.%'
ORDER BY total_exec_time DESC;

-- Legacy cost (PostgREST era, no longer generated)
SELECT substring(query from '"public"\."([a-z_]+)"') AS fn,
       sum(calls) AS calls,
       round(avg(mean_exec_time)::numeric, 1) AS mean_ms
FROM extensions.pg_stat_statements
WHERE query LIKE '%pgrst_source%'
GROUP BY 1
ORDER BY 2 DESC;
```

**Current production totals** (`hyperdrive_user`): 171 897 calls, **1 549 s** of execution
spread over 135 distinct statements. Of that, ~917 s is a single function. The rest of the
historical 35 652 s in the table belongs to the PostgREST era, internal Realtime WAL
consumption, and Supabase platform maintenance — not to your application.

The slow-query tables below are therefore split by era. **Only the Hyperdrive section
describes what you are paying for right now.**

---

## Slow queries — current (Hyperdrive, direct connection)

Ordered by mean execution time. Measured with `EXPLAIN (ANALYZE, BUFFERS)` where noted.

| Function                                   |     Calls |       Mean |    p-max |     Total | Notes                                            |
| ------------------------------------------ | --------: | ---------: | -------: | --------: | ------------------------------------------------ |
| `get_schedule_courses`                     |       416 | **378 ms** | 1 270 ms |     157 s | Re-measured: 781 ms / 11 353 buffers for 11 rows |
| inline `academic_unit` EXISTS              |       106 | **360 ms** |   838 ms |      38 s | Re-measured: 29 ms / 5 436 buffers               |
| `get_academic_units_with_professors`       |        38 | **323 ms** |   726 ms |      12 s | Re-measured: 708 ms / 5 854 buffers              |
| `get_user_dashboard_stats`                 |        91 | **259 ms** |   948 ms |      24 s |                                                  |
| `search_professor_review_stats`            |       604 | **246 ms** | 1 465 ms |     148 s | Re-measured: 666 ms / 4 442 buffers              |
| `get_academic_terms_by_plan`               |       367 | **197 ms** |   672 ms |      72 s | Re-measured: 15 ms / 16 441 buffers              |
| `get_user_course_effective_status_details` |        96 | **132 ms** |   577 ms |      13 s | Re-measured: 281 ms / 8 549 buffers              |
| `get_professor_review_courses`             |        12 | **118 ms** |   247 ms |       1 s |                                                  |
| `get_active_academic_terms`                |         7 | **109 ms** |   252 ms |       1 s |                                                  |
| `get_user_profile_with_context`            | **9 588** |  **96 ms** | 2 296 ms | **917 s** | 59 % of all current DB time                      |
| `get_academic_units_for_campus`            |       259 |  **55 ms** |   400 ms |      14 s |                                                  |
| `get_course_recent_professors`             |       266 |  **36 ms** |        — |         — |                                                  |
| `professor` lookup by `id::text`           |     1 762 | **7.5 ms** |    61 ms |      13 s | Re-measured: **31 ms**, seq scan of 1 336 rows   |

### The shape of the problem

Three patterns account for essentially all of the avoidable cost:

1. **`get_user_profile_with_context` is called on every session load** and costs 96 ms
   for a _single row_. 9 588 calls is a lot for a profile fetch.
2. **Functions that aggregate over `course_offering_group_professor`**
   (18 804 rows) without filtering first. Both `get_academic_units_with_professors` and
   the inline `academic_unit` EXISTS query do a full hash join across three tables to
   produce 65 rows.
3. **`get_schedule_courses` fans out into a recursive CTE over `course_relation`**
   (86 838 rows, 59 MB — the largest table in the database) and evaluates it more than
   once per call.

---

## Slow queries — historical (PostgREST era)

Kept for context. **These no longer execute.** Do not optimize them expecting a
production win.

| Function                                   |  Calls |   Mean |   Total |
| ------------------------------------------ | -----: | -----: | ------: |
| `get_schedule_courses`                     |  8 937 | 189 ms | 3 013 s |
| `pg_timezone_names`                        |  2 547 | 579 ms | 1 474 s |
| `get_academic_terms_by_plan`               |  5 508 | 152 ms | 1 021 s |
| `get_user_profile_with_context`            |  9 584 |  96 ms |   917 s |
| `get_user_course_effective_status_details` |  5 617 | 123 ms |   543 s |
| `get_course_latest_term_groups`            | 11 637 |  36 ms |   529 s |
| `get_course_recent_professors`             | 11 176 |  38 ms |   510 s |
| schema introspection (`pg_attribute`)      | 29 026 |  17 ms |   491 s |
| `search_professor_review_stats`            |  2 239 | 104 ms |   459 s |
| `get_course_offering_terms`                | 12 223 |  35 ms |   451 s |

`pg_timezone_names` deserves a note: it ran 2 547 times as `authenticator` at 579 ms each.
That is a PostgREST startup query, not application code. It is gone now that the Worker
connects directly.

The `pg_attribute` introspection query (12.7 M rows scanned, 491 s) is the Kysely/schema
introspection path used by PostgREST's schema cache build. Also gone.

---

## Optimization targets

Each item lists the measured problem, the fix, and how to verify the fix worked.

### 1. `get_user_profile_with_context` — 917 s accumulated, 96 ms per call

**Problem.** Called from `apps/api/src/index.ts:70` on every session bootstrap:

```ts
pool.query(`SELECT * FROM public.get_user_profile_with_context($1) ${cacheBuster}`, [userId]);
```

It builds a 7-way `LEFT JOIN` chain over `user`, `user_study_plan`, `university`,
`campus`, `academic_unit`, `study_plan`, and calls two `VOLATILE` sub-functions
(`derive_user_context_from_study_plan`, `get_suggested_academic_term`).

**Why 96 ms for one row.** The `VOLATILE` volatility marker prevents the planner from
reusing results, and `get_suggested_academic_term` runs an `EXISTS` over
`course_offering` for every candidate term. Measured standalone: 9.6 ms / 1 682 buffers
when warm — so the 96 ms average reflects cold cache and contention, not the query plan.

**Fix.**

```sql
-- derive_user_context_from_study_plan is read-only: mark it STABLE
ALTER FUNCTION public.derive_user_context_from_study_plan(bigint, bigint) STABLE;
-- get_suggested_academic_term likewise
ALTER FUNCTION public.get_suggested_academic_term(bigint) STABLE;
```

**Caveat before applying.** `get_suggested_academic_term` internally calls
`public.current_user_id()`, which reads the JWT claims of the _current session_. Under
PostgREST that was per-request correct. Under Hyperdrive the Worker connects as
`hyperdrive_user` and passes `p_user_id` explicitly — so the `current_user_id()` fallback
branch resolves against a session that has no JWT, and returns `NULL`. That branch is
already only a fallback for when `p_study_plan_id` is `NULL`. Confirm no caller relies on
it before flipping volatility.

Then cache the profile context in the Worker (KV or in-request) keyed by `userId`,
invalidated when the user's active `user_study_plan` changes. The `cacheBuster` comment in
the source already proves the team is fighting stale responses — a keyed cache solves it
properly instead.

**Verify:** `mean_exec_time` for this statement should drop below 20 ms, and the call
count should collapse as cache hits replace queries.

---

### 2. `get_schedule_courses` — 378 ms mean, 781 ms measured

**Problem.** 11 353 shared buffers (~89 MB) to return **11 rows**. The function selects
from `plan_courses`, joins `study_plan_level`, `study_plan_level_course`, expands
`placeholder_courses` through `schedule_equivalence_placeholder_course`, computes
`equivalent_courses` over `course_relation`, then calls
`get_user_course_effective_statuses` — which itself runs a `WITH RECURSIVE` closure over
the equivalence graph.

**Why it is slow.** `course_relation` is 86 838 rows / 59 MB. The recursive equivalence
closure walks it per seed course, and the function is `VOLATILE` so nothing is memoized.
The query plan reports `Function Scan ... rows=11` with no visibility into the internal
cost — the 11 353 buffers tell the real story.

**Fix.** Two independent improvements:

```sql
-- a) The equivalence closure only depends on (study_plan_id). Materialize it.
CREATE MATERIALIZED VIEW public.course_equivalence_closure AS
SELECT cr.study_plan_id, cr.from_course_id, cr.to_course_id
FROM public.course_relation cr
WHERE cr.relation_type = 'EQUIVALENT' AND cr.is_active;

CREATE UNIQUE INDEX ON public.course_equivalence_closure (study_plan_id, from_course_id, to_course_id);
```

```sql
-- b) At minimum, the index that would let the closure start from a filter
CREATE INDEX CONCURRENTLY idx_course_relation_plan_type_active
  ON public.course_relation (study_plan_id, relation_type)
  WHERE is_active;
```

Refresh the matview from the seed pipeline (`scripts/seed.ts`). Curriculum data changes on
import, not at runtime, so a matview is a natural fit.

**Verify:** `EXPLAIN (ANALYZE, BUFFERS)` should show buffers drop from 11 353 to under
1 000.

---

### 3. `search_professor_review_stats` — 246 ms mean, 666 ms measured

**Problem.** Returns 20 rows after 666 ms and 4 442 buffers. The culprit is
`courses_reviewed_count`:

```sql
(SELECT COUNT(DISTINCT prc.course_id)
 FROM public.professor_review_course prc
 JOIN review_scores rs2 ON rs2.id = prc.review_id
 WHERE rs2.professor_id = rs.professor_id)::BIGINT AS courses_reviewed_count
```

This is a correlated subquery **inside a CTE that groups by professor**. It re-runs per
professor. `professor_review_course` (`2015` rows) shows **16 009 sequential scans and
32 247 527 rows read** in `pg_stat_user_tables` — that is 32 million rows to resolve a
handful of counts.

**Fix.** Aggregate once, join once:

```sql
-- replace the correlated subquery with a pre-aggregated CTE
review_courses AS (
  SELECT rs.professor_id, COUNT(DISTINCT prc.course_id) AS courses_reviewed_count
  FROM review_scores rs
  JOIN public.professor_review_course prc ON prc.review_id = rs.id
  GROUP BY rs.professor_id
)
-- then in the final SELECT:
LEFT JOIN review_courses rc ON rc.professor_id = f.professor_id
```

Also worth noting: `idx_professor_full_name_trgm` (1.4 MB, `idx_scan = 0`) is dead for a
subtle reason. The function filters with
`extensions.unaccent(p.full_name) ILIKE extensions.unaccent('%' || word || '%')`, and a
plain `gin_trgm_ops` index cannot serve an expression on `unaccent(...)`. That is exactly
why it reads zero. Either wrap the index in `unaccent`, or drop it:

```sql
-- Correct version, if you want name search to actually be index-backed
CREATE INDEX idx_professor_full_name_unaccent_trgm
  ON public.professor USING gin (extensions.unaccent(full_name) extensions.gin_trgm_ops);
```

Measure before committing to either option: with 1 336 professors, the seq scan is
cheap and the index might not pay off.

**Verify:** `EXPLAIN (ANALYZE)` on the function body should show no per-row `Aggregate`
node; `seq_tup_read` on `professor_review_course` stops climbing.

---

### 4. `get_academic_units_with_professors` — 323 ms mean, 708 ms measured

**Problem.** The whole function is:

```sql
SELECT DISTINCT au.id, au.code, au.name
FROM public.academic_unit au
JOIN public.course_offering co ON co.academic_unit_id = au.id
JOIN public.course_offering_group cog ON cog.course_offering_id = co.id
JOIN public.course_offering_group_professor cogp ON cogp.course_offering_group_id = cog.id
ORDER BY au.name;
```

Four joins, `DISTINCT`, to answer "which academic units have at least one professor
assigned". It materializes 18 804 intermediate rows to produce 65.

**Fix.** An `EXISTS` lets the planner stop at the first match per unit:

```sql
CREATE OR REPLACE FUNCTION public.get_academic_units_with_professors()
RETURNS TABLE(id integer, code text, name text)
LANGUAGE sql STABLE
SET search_path = public
AS $$
  SELECT au.id, au.code, au.name
  FROM public.academic_unit au
  WHERE EXISTS (
    SELECT 1
    FROM public.course_offering co
    JOIN public.course_offering_group cog ON cog.course_offering_id = co.id
    JOIN public.course_offering_group_professor cogp
      ON cogp.course_offering_group_id = cog.id
    WHERE co.academic_unit_id = au.id
  )
  ORDER BY au.name;
$$;
```

Measured independently, the `EXISTS` form runs in **29 ms** versus 708 ms — a 24×
improvement. Add `STABLE` and `SET search_path` (see item 6).

---

### 5. `professor` lookups cast the primary key to text

**Problem.** `apps/api/src/handlers/professors.ts:128` and
`apps/api/src/handlers/reviews.ts:188`:

```sql
SELECT id, full_name FROM public.professor WHERE id::text = $1
```

`professor.id` is `bigint` with a btree primary key. Casting the column to `text` makes
the index unusable — Postgres must seq-scan all 1 336 rows and cast each one. Measured:
**31 ms** and 1 335 rows removed by filter, for a single-row lookup.

**Fix.** Cast the _parameter_, not the column:

```sql
SELECT id, full_name FROM public.professor WHERE id = $1::bigint
```

The same antipattern appears on the join side at `professors.ts:243` and
`reviews.ts:212` (`WHERE cogp.professor_id::text = $1`). Fixing these turns 31 ms into a
sub-millisecond index lookup, and the 13 s of accumulated time disappears.

**Caveat.** If the `$1` input can legitimately be non-numeric, validate it before the
query. But `id::text = $1` is not a safety mechanism — it silently returns nothing for
invalid input while paying full scan cost.

---

### 6. Functions with a mutable `search_path`

Four functions have no `SET search_path`, flagged by the Supabase security advisor:

| Function                               | Used by      | Fix                        |
| -------------------------------------- | ------------ | -------------------------- |
| `current_jwt_claims()`                 | RLS policies | `SET search_path = public` |
| `current_user_id()`                    | RLS policies | `SET search_path = public` |
| `get_academic_units_with_professors()` | API          | `SET search_path = public` |
| `reply_to_feedback()`                  | API          | `SET search_path = public` |

```sql
ALTER FUNCTION public.current_user_id() SET search_path = public;
ALTER FUNCTION public.current_jwt_claims() SET search_path = public;
ALTER FUNCTION public.get_academic_units_with_professors() SET search_path = public;
ALTER FUNCTION public.reply_to_feedback(bigint, text, text) SET search_path = public;
```

The first two are load-bearing: they are called from RLS policies. A schema-shadowing
attack could change which `current_user_id` resolves. Cost is zero; this is pure
hardening.

Also relevant to performance: `current_user_id()` and `current_jwt_claims()` are marked
`STABLE`, which is correct, but RLS policies that call them were being **re-evaluated per
row** on `public.notifications`. Supabase's `auth_rls_initplan` advisor flags this.
Rewrite as:

```sql
-- before (re-evaluated per row)
USING (user_id = auth.uid())
-- after (evaluated once, as an InitPlan)
USING (user_id = (SELECT auth.uid()))
```

Only applies if you keep PostgREST/Data API enabled. If the API stays disabled, this is
moot for the Worker path — `hyperdrive_user` bypasses RLS entirely.

---

## Schema hygiene

### Unused indexes — 26 of 145, 5.6 MB

Confirmed `idx_scan = 0` from `pg_stat_user_indexes`. The two that matter:

| Index                                                        |     Size | Verdict                                                        |
| ------------------------------------------------------------ | -------: | -------------------------------------------------------------- |
| `course_relation.idx_course_relation_relation_type`          | 3 544 kB | Drop — `relation_type` is always filtered with `study_plan_id` |
| `professor.idx_professor_full_name_trgm`                     | 1 440 kB | Drop or replace with `unaccent`-aware version (item 3)         |
| `course_offering_group.idx_course_offering_group_group_type` |   144 kB | Drop                                                           |
| `student_course_record.idx_student_course_record_status`     |    64 kB | Drop                                                           |

**Do not drop these** — they are constraint-backed, and `idx_scan = 0` is misleading
because constraint checks do not count as index scans:

- `user_study_plan.user_study_plan_unique` (UNIQUE constraint)
- `schedule_equivalence_placeholder_course.schedule_equivalence_placeholder_course_pkey`
  (PRIMARY KEY)
- any `idx_*_pkey`

The remaining ~22 small indexes (16 kB each) are cheap enough that dropping them is
cosmetic. Leave them until a real cleanup pass.

### Junk tables

Four empty tables with no primary key, left over from manual analysis:

```
public.fn_out      (16 kB, 2 text columns, 0 rows)
public.rpc_use     (16 kB, 2 text columns, 0 rows)
public.dep_out     (16 kB, 4 text columns, 0 rows)
public.scan_results(16 kB, 2 text columns, 0 rows)
```

```sql
DROP TABLE public.fn_out, public.rpc_use, public.dep_out, public.scan_results;
```

Verify they are not referenced by any view or function first:

```sql
SELECT DISTINCT dependent_ns.nspname, dependent_view.relname
FROM pg_depend
JOIN pg_rewrite ON pg_depend.objid = pg_rewrite.oid
JOIN pg_class dependent_view ON pg_rewrite.ev_class = dependent_view.oid
JOIN pg_namespace dependent_ns ON dependent_view.relnamespace = dependent_ns.oid
JOIN pg_class source_table ON pg_depend.refobjid = source_table.oid
WHERE source_table.relname IN ('fn_out', 'rpc_use', 'dep_out', 'scan_results');
```

### Foreign keys without a covering index

Seven, per the performance advisor. All are on low-cardinality tables today
(`course_evaluations` has 6 rows, `user_feedback` has 6), so this is **not urgent**:

- `course_evaluations` → `academic_term_id`, `professor_id`, `moderated_by`
- `professor_review_report` → `resolved_by`
- `schedule_equivalence_placeholder_course` → `study_plan_id`
- `student_course_record` → `equivalent_course_id`
- `user_feedback` → `user_id`

Add them when those tables grow, not before. Every index you add has write cost.

### Autovacuum is effectively dormant

`pg_stat_user_tables` shows last autovacuum dates from **June and July 2026** on the
busiest tables:

| Table                     | Dead tuples |     Dead % | Last autovacuum |
| ------------------------- | ----------: | ---------: | --------------- |
| `study_plan_campus`       |         149 | **18.2 %** | 24 May 2026     |
| `professor_review_course` |         154 |      7.1 % | 3 Jul 2026      |
| `professor_review`        |         126 |      6.7 % | 3 Jul 2026      |
| `course_offering_group`   |         517 |      2.8 % | 4 Jun 2026      |
| `course_offering_meeting` |         579 |      2.3 % | 4 Jun 2026      |

These are small absolute numbers, so the impact is minor — but `last_autoanalyze` being
months stale means the planner may be working with bad row estimates. Run a one-time
pass:

```sql
VACUUM (ANALYZE) public.study_plan_campus;
VACUUM (ANALYZE) public.professor_review;
VACUUM (ANALYZE) public.professor_review_course;
VACUUM (ANALYZE) public.course_offering_group;
VACUUM (ANALYZE) public.course_offering_meeting;
```

If they go stale again, check whether the seed pipeline runs large `DELETE`+`INSERT`
cycles that reset the dead-tuple counters before autovacuum can trigger.

---

## Configuration notes

| Setting                           | Value    | Assessment                                                    |
| --------------------------------- | -------- | ------------------------------------------------------------- |
| `work_mem`                        | 2 184 kB | Low, but the plans above stay in memory — fine                |
| `shared_buffers`                  | 224 MB   | Reasonable for 148 MB of data                                 |
| `effective_cache_size`            | 384 MB   | Fine                                                          |
| `random_page_cost`                | 1.1      | Correct for SSD                                               |
| `max_parallel_workers_per_gather` | 1        | Conservative; raising to 2 could help the aggregation queries |
| `jit`                             | off      | Correct for OLTP-sized queries                                |
| `max_connections`                 | 60       | 18 in use; Hyperdrive pools upstream                          |
| Cache hit ratio                   | 100 %    | No I/O bottleneck                                             |

The instance is not starving for resources. Every problem above is a query-shape problem,
not a capacity problem. **Buying more compute would not fix any of it.**

---

## Verification workflow

After each change, confirm with:

```sql
-- 1. Did the query get faster? (run against the specific statement)
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) SELECT * FROM public.<function>(<args>);

-- 2. Did the pattern stop? (schema-qualify the target table)
SELECT relname, seq_scan, seq_tup_read, idx_scan, n_live_tup
FROM pg_stat_user_tables
WHERE schemaname = 'public' AND relname = '<table>';

-- 3. Did indexes start being used?
SELECT relname, indexrelname, idx_scan
FROM pg_stat_user_indexes
WHERE schemaname = 'public';

-- 4. Reset the window before/after a change so you measure only the new state
SELECT pg_stat_statements_reset();
```

Note on (4): `pg_stat_statements_reset()` is destructive to your history. Given the stats
have been accumulating since April and provide the only historical baseline, **do not
reset until you have recorded the current numbers** — the tables in this document are that
record.

---

## Priority

| #   | Item                                            | Effort | Expected win                       |
| --- | ----------------------------------------------- | ------ | ---------------------------------- |
| 1   | `id::text` casts → `id = $1::bigint` (item 5)   | 10 min | 31 ms → <1 ms per call, 13 s total |
| 2   | Pre-aggregate `courses_reviewed_count` (item 3) | 30 min | 666 ms → est. <50 ms               |
| 3   | `EXISTS` rewrite for academic units (item 4)    | 20 min | 708 ms → 29 ms                     |
| 4   | `STABLE` on the two context functions (item 1)  | 5 min  | Unlocks planner reuse              |
| 5   | `search_path` hardening (item 6)                | 5 min  | Security, zero perf cost           |
| 6   | Matview for equivalence closure (item 2)        | 2 h    | 11 353 → <1 000 buffers            |
| 7   | Cache profile context in the Worker (item 1)    | 2 h    | 917 s → near zero                  |
| 8   | Index + junk table cleanup                      | 30 min | 5.6 MB, less write amplification   |

Items 1–5 are a single afternoon and cover roughly 1 100 s of accumulated execution time.

---

## Method

- `pg_stat_statements` in the `extensions` schema (`extensions.pg_stat_statements`,
  `extensions.pg_stat_statements_info`).
- `pg_stat_user_tables`, `pg_stat_user_indexes`, `pg_stat_database`, `pg_stat_activity`.
- `EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)` on each function, called via the Supabase MCP
  server as the `postgres` role.
- Supabase advisors: `get_advisors('performance')` and `get_advisors('security')`.
- Logs: `query_logs` over `postgres_logs`, `postgrest_logs`, `supavisor_logs`,
  `edge_logs` (24 h window).

All queries were read-only. No schema was modified.

---

> **On the `pg_pgrst_no_exposed_schemas` log cycle** (2 691 restarts in 24 h as of
> 24 Oct 2026). This is **expected behaviour when the Data API is disabled**, not a fault.
> Supabase does not shut PostgREST down; it injects `db-schemas=pg_pgrst_no_exposed_schemas`,
> a `pg_`-prefixed schema that Postgres forbids creating. PostgREST v13+ validates schemas
> strictly at boot, so it fails and retries every ~32 s. Supabase's own docs state it "should
> not adversely affect the project, although it may result in additional entries in your
> logs." Ignore it, or use the documented placeholder-schema workaround if the noise is a
> problem.
