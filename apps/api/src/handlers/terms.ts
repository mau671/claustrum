import { Effect } from "effect";
import { HttpApiBuilder } from "effect/http-api";

import type { AcademicTerm, SuggestedTermQuery, TermsQuery } from "../domain/Terms";

import { ClaustrumApi } from "../api/index";
import { Database, type SqlClient } from "../services/Database";

export const termsHandlers = HttpApiBuilder.group(
  ClaustrumApi,
  "terms",
  Effect.fn(function* (handlers) {
    const db = yield* Database;
    const sql = db as unknown as SqlClient;

    return handlers.handleAll({
      active: () =>
        Effect.gen(function* () {
          const res = yield* sql
            .unsafe<{
              id: string | number;
              academic_modality_id: string | number;
              year: string | number;
              period_number: string | number;
              external_key: string;
              display_name: string;
              starts_on: string;
              ends_on: string;
            }>("SELECT * FROM public.get_active_academic_terms()")
            .pipe(Effect.orDie);

          return res.map((r): AcademicTerm => ({
            id: Number(r.id),
            academic_modality_id: Number(r.academic_modality_id),
            year: Number(r.year),
            period_number: Number(r.period_number),
            external_key: r.external_key,
            display_name: r.display_name,
            starts_on: r.starts_on ? String(r.starts_on) : null,
            ends_on: r.ends_on ? String(r.ends_on) : null,
          }));
        }),

      suggested: ({ query }: { query: SuggestedTermQuery }) =>
        Effect.gen(function* () {
          const res = yield* sql
            .unsafe<{
              suggested_term_id?: string | number | null;
            }>("SELECT public.get_suggested_academic_term($1) AS suggested_term_id", [
              query.studyPlanId ?? null,
            ])
            .pipe(Effect.orDie);

          return res[0]?.suggested_term_id ? Number(res[0].suggested_term_id) : null;
        }),

      list: ({ query }: { query: TermsQuery }) =>
        Effect.gen(function* () {
          if (query.studyPlanId && query.campusId) {
            const res = yield* sql
              .unsafe<{
                id: string | number;
                academic_modality_id: string | number;
                year: string | number;
                period_number: string | number;
                external_key: string;
                display_name: string;
                starts_on: string;
                ends_on: string;
              }>("SELECT * FROM public.get_academic_terms_by_plan($1, $2)", [
                query.studyPlanId,
                query.campusId,
              ])
              .pipe(Effect.orDie);

            return res.map((r): AcademicTerm => ({
              id: Number(r.id),
              academic_modality_id: Number(r.academic_modality_id),
              year: Number(r.year),
              period_number: Number(r.period_number),
              external_key: r.external_key,
              display_name: r.display_name,
              starts_on: String(r.starts_on),
              ends_on: String(r.ends_on),
            }));
          }

          if (query.studyPlanId) {
            const res = yield* sql
              .unsafe<{
                id: string | number;
                academic_modality_id: string | number;
                year: string | number;
                period_number: string | number;
                external_key: string;
                display_name: string;
                starts_on: string;
                ends_on: string;
              }>("SELECT * FROM public.get_academic_terms_by_plan($1, NULL)", [query.studyPlanId])
              .pipe(Effect.orDie);

            return res.map((r): AcademicTerm => ({
              id: Number(r.id),
              academic_modality_id: Number(r.academic_modality_id),
              year: Number(r.year),
              period_number: Number(r.period_number),
              external_key: r.external_key,
              display_name: r.display_name,
              starts_on: String(r.starts_on),
              ends_on: String(r.ends_on),
            }));
          }

          const res = yield* sql
            .unsafe<{
              id: string | number;
              academic_modality_id: string | number;
              year: string | number;
              period_number: string | number;
              external_key: string;
              display_name: string;
              starts_on: string;
              ends_on: string;
            }>("SELECT * FROM public.academic_term ORDER BY year DESC, period_number DESC")
            .pipe(Effect.orDie);

          return res.map((r): AcademicTerm => ({
            id: Number(r.id),
            academic_modality_id: Number(r.academic_modality_id),
            year: Number(r.year),
            period_number: Number(r.period_number),
            external_key: r.external_key,
            display_name: r.display_name,
            starts_on: r.starts_on ? String(r.starts_on) : null,
            ends_on: r.ends_on ? String(r.ends_on) : null,
          }));
        }),
    });
  }),
);
