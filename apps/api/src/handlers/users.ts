import type { PgClient } from "@effect/sql-pg";

import * as Effect from "effect/Effect";
import { HttpApiBuilder } from "effect/http-api";
import * as Option from "effect/Option";

import { ClaustrumApi } from "../api/index";
import {
  BadRequestError,
  checkAuth,
  checkRole,
  CurrentUser,
  InternalServerError,
  NotFoundError,
  type UserAdminItem,
  type UserProfileResponse,
} from "../domain/Users";
import { toIsoString } from "../lib/date";
import { Database } from "../services/Database";

interface ProfileRow {
  readonly user_study_plan_id?: number | string | null;
  readonly study_plan_id?: number | string | null;
  readonly campus_id?: number | string | null;
  readonly entry_year?: number | string | null;
  readonly study_plan_name?: string | null;
  readonly campus_name?: string | null;
  readonly university_id?: number | string | null;
  readonly academic_unit_id?: number | string | null;
  readonly term_id?: number | string | null;
  readonly carnet?: string | null;
  readonly [key: string]: unknown;
}

interface OnboardingStatusRow {
  readonly onboarding_dismissed_at?: unknown;
  readonly onboarding_completed_at?: unknown;
}

interface UserDbRow {
  readonly id: string;
  readonly name: string;
  readonly email: string;
  readonly emailVerified: boolean;
  readonly image: string | null;
  readonly role: string | null;
  readonly banned: boolean | null;
  readonly banReason: string | null;
  readonly banExpires: unknown;
  readonly createdAt: unknown;
  readonly updatedAt: unknown;
  readonly total_count?: number | string;
}

export const UsersHandlers = HttpApiBuilder.group(ClaustrumApi, "users", (handlers) =>
  Effect.gen(function* () {
    const sql = (yield* Database) as unknown as PgClient.PgClient;

    return handlers
      .handle("me", () =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));

          const onboardingRows = yield* sql<OnboardingStatusRow>`
            SELECT onboarding_dismissed_at, onboarding_completed_at
            FROM public."user"
            WHERE id = ${user.id}
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const profileRows = yield* sql<ProfileRow>`
            SELECT * FROM public.get_user_profile_with_context(${user.id})
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const onboardingStatus = onboardingRows[0] ?? null;
          const profile = profileRows[0] ?? null;

          const response: UserProfileResponse = {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role ?? "user",
            banned: user.banned ?? false,
            session: null,
            user,
            onboardingStatus,
            profileContext: profile,
            ...(profile
              ? {
                  userStudyPlanId: Number(profile.user_study_plan_id),
                  studyPlanId: Number(profile.study_plan_id),
                  campusId: Number(profile.campus_id),
                  entryYear: Number(profile.entry_year),
                  studyPlanName: profile.study_plan_name ?? null,
                  campusName: profile.campus_name ?? null,
                  universityId: profile.university_id ? Number(profile.university_id) : null,
                  departmentId: profile.academic_unit_id ? Number(profile.academic_unit_id) : null,
                  academicUnitId: profile.academic_unit_id
                    ? Number(profile.academic_unit_id)
                    : null,
                  termId: profile.term_id ? Number(profile.term_id) : null,
                  carnet: profile.carnet ?? null,
                  user_study_plan_id: Number(profile.user_study_plan_id),
                  study_plan_id: Number(profile.study_plan_id),
                  campus_id: Number(profile.campus_id),
                  entry_year: Number(profile.entry_year),
                  study_plan_name: profile.study_plan_name ?? null,
                  campus_name: profile.campus_name ?? null,
                  academic_unit_id: profile.academic_unit_id
                    ? Number(profile.academic_unit_id)
                    : null,
                  term_id: profile.term_id ? Number(profile.term_id) : null,
                }
              : {}),
          };

          return response;
        }),
      )
      .handle("updateStudyPlan", ({ payload }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));

          yield* sql
            .withTransaction(
              Effect.gen(function* () {
                if (payload.carnet) {
                  yield* sql`
                  UPDATE public."user" SET carnet = ${payload.carnet} WHERE id = ${user.id}
                `;
                }

                const activePlanRes = yield* sql<{ id: number }>`
                SELECT id FROM public.user_study_plan WHERE user_id = ${user.id} AND is_active = true
              `;

                if (activePlanRes.length > 0) {
                  const entryYear = payload.entryYear ?? null;
                  yield* sql`
                  UPDATE public.user_study_plan
                  SET study_plan_id = ${payload.studyPlanId},
                      campus_id = ${payload.campusId},
                      entry_year = COALESCE(${entryYear}, entry_year)
                  WHERE id = ${activePlanRes[0].id}
                `;
                } else {
                  const entryYear = payload.entryYear ?? new Date().getFullYear();
                  yield* sql`
                  INSERT INTO public.user_study_plan (user_id, study_plan_id, campus_id, entry_year, is_active)
                  VALUES (${user.id}, ${payload.studyPlanId}, ${payload.campusId}, ${entryYear}, true)
                `;
                }
              }),
            )
            .pipe(
              Effect.mapError(
                (e) =>
                  new InternalServerError({
                    error: `Failed to update study plan: ${e.message}`,
                  }),
              ),
            );

          return { success: true };
        }),
      )
      .handle("submitOnboarding", ({ payload }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));

          yield* sql
            .withTransaction(
              Effect.gen(function* () {
                if (payload.carnet) {
                  yield* sql`
                  UPDATE public."user" SET carnet = ${payload.carnet} WHERE id = ${user.id}
                `;
                }

                const activePlanRes = yield* sql<{ id: number }>`
                SELECT id FROM public.user_study_plan WHERE user_id = ${user.id} AND is_active = true
              `;

                const entryYear = payload.entryYear ?? null;
                if (activePlanRes.length > 0) {
                  yield* sql`
                  UPDATE public.user_study_plan
                  SET study_plan_id = ${payload.studyPlanId},
                      campus_id = ${payload.campusId},
                      entry_year = COALESCE(${entryYear}, entry_year)
                  WHERE id = ${activePlanRes[0].id}
                `;
                } else {
                  const year = entryYear ?? new Date().getFullYear();
                  yield* sql`
                  INSERT INTO public.user_study_plan (user_id, study_plan_id, campus_id, entry_year, is_active)
                  VALUES (${user.id}, ${payload.studyPlanId}, ${payload.campusId}, ${year}, true)
                `;
                }

                yield* sql`
                UPDATE public."user" SET onboarding_completed_at = NOW() WHERE id = ${user.id}
              `;
              }),
            )
            .pipe(
              Effect.mapError(
                (e) =>
                  new InternalServerError({
                    error: `Failed to submit onboarding: ${e.message}`,
                  }),
              ),
            );

          return { success: true };
        }),
      )
      .handle("dismissOnboarding", () =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));

          const res = yield* sql<{ id: string }>`
            UPDATE public."user"
            SET onboarding_dismissed_at = NOW()
            WHERE id = ${user.id}
            RETURNING id
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (res.length === 0) {
            return yield* new NotFoundError({ error: "User profile not found" });
          }

          return { success: true };
        }),
      )
      .handle("listUsers", ({ query }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin"]);

          const searchTerm = query.search?.trim() ? query.search.trim() : null;
          const roleTerm = query.role ?? null;
          const bannedBool = query.banned !== undefined ? query.banned === "true" : null;
          const limit = query.limit ?? 20;
          const offset = query.offset ?? 0;

          const rows = yield* sql<UserDbRow>`
            SELECT id, name, email, "emailVerified", image, role, banned, "banReason", "banExpires", "createdAt", "updatedAt",
                   COUNT(*) OVER()::bigint AS total_count
            FROM better_auth."user"
            WHERE (${searchTerm}::text IS NULL OR name ILIKE '%' || ${searchTerm} || '%' OR email ILIKE '%' || ${searchTerm} || '%')
              AND (${roleTerm}::text IS NULL OR role = ${roleTerm})
              AND (${bannedBool}::boolean IS NULL OR banned = ${bannedBool})
            ORDER BY "createdAt" DESC
            LIMIT ${limit} OFFSET ${offset}
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const total = rows[0]?.total_count ? Number(rows[0].total_count) : 0;
          const users: UserAdminItem[] = rows.map((r) => ({
            id: r.id,
            name: r.name,
            email: r.email,
            emailVerified: Boolean(r.emailVerified),
            image: r.image ?? null,
            role: r.role ?? null,
            banned: r.banned !== null ? Boolean(r.banned) : null,
            banReason: r.banReason ?? null,
            banExpires: toIsoString(r.banExpires),
            createdAt: toIsoString(r.createdAt) ?? "",
            updatedAt: toIsoString(r.updatedAt) ?? "",
          }));

          return { users, total };
        }),
      )
      .handle("getUserById", ({ params }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin"]);

          const rows = yield* sql<UserDbRow>`
            SELECT id, name, email, "emailVerified", image, role, banned, "banReason", "banExpires", "createdAt", "updatedAt"
            FROM better_auth."user"
            WHERE id = ${params.id}
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (rows.length === 0) {
            return yield* new NotFoundError({ error: "User not found" });
          }

          const r = rows[0];
          return {
            id: r.id,
            name: r.name,
            email: r.email,
            emailVerified: Boolean(r.emailVerified),
            image: r.image ?? null,
            role: r.role ?? null,
            banned: r.banned !== null ? Boolean(r.banned) : null,
            banReason: r.banReason ?? null,
            banExpires: toIsoString(r.banExpires),
            createdAt: toIsoString(r.createdAt) ?? "",
            updatedAt: toIsoString(r.updatedAt) ?? "",
          };
        }),
      )
      .handle("updateUserRole", ({ params, payload }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin"]);

          const userRows = yield* sql<{ role: string | null }>`
            SELECT role FROM better_auth."user" WHERE id = ${params.id}
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (userRows.length === 0) {
            return yield* new NotFoundError({ error: "User not found" });
          }

          const currentRole = userRows[0].role;
          if (currentRole === "admin" && payload.role !== "admin") {
            const adminCountRes = yield* sql<{ count: number }>`
              SELECT COUNT(*)::int AS count
              FROM better_auth."user"
              WHERE role = 'admin' AND banned = false
            `.pipe(
              Effect.mapError(
                (e) =>
                  new InternalServerError({
                    error: `Database error: ${e.message}`,
                  }),
              ),
            );

            if ((adminCountRes[0]?.count ?? 0) <= 1) {
              return yield* new BadRequestError({
                error: "No se puede remover el último administrador activo",
              });
            }
          }

          yield* sql`
            UPDATE better_auth."user"
            SET role = ${payload.role}, "updatedAt" = NOW()
            WHERE id = ${params.id}
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          return { success: true };
        }),
      )
      .handle("banUser", ({ params, payload }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin"]);

          const userRows = yield* sql<{ role: string | null }>`
            SELECT role FROM better_auth."user" WHERE id = ${params.id}
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (userRows.length === 0) {
            return yield* new NotFoundError({ error: "User not found" });
          }

          if (userRows[0].role === "admin") {
            const adminCountRes = yield* sql<{ count: number }>`
              SELECT COUNT(*)::int AS count
              FROM better_auth."user"
              WHERE role = 'admin' AND banned = false
            `.pipe(
              Effect.mapError(
                (e) =>
                  new InternalServerError({
                    error: `Database error: ${e.message}`,
                  }),
              ),
            );

            if ((adminCountRes[0]?.count ?? 0) <= 1) {
              return yield* new BadRequestError({
                error: "No se puede suspender al único administrador activo",
              });
            }
          }

          const banExpires = payload.expiresInSeconds
            ? new Date(Date.now() + payload.expiresInSeconds * 1000)
            : null;
          const reason = payload.reason ?? null;

          yield* sql
            .withTransaction(
              Effect.gen(function* () {
                yield* sql`
                UPDATE better_auth."user"
                SET banned = true, "banReason" = ${reason}, "banExpires" = ${banExpires}, "updatedAt" = NOW()
                WHERE id = ${params.id}
              `;
                yield* sql`
                DELETE FROM better_auth."session" WHERE "userId" = ${params.id}
              `;
              }),
            )
            .pipe(
              Effect.mapError(
                (e) =>
                  new InternalServerError({
                    error: `Failed to ban user: ${e.message}`,
                  }),
              ),
            );

          return { success: true };
        }),
      )
      .handle("unbanUser", ({ params }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin"]);

          const res = yield* sql<{ id: string }>`
            UPDATE better_auth."user"
            SET banned = false, "banReason" = null, "banExpires" = null, "updatedAt" = NOW()
            WHERE id = ${params.id}
            RETURNING id
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (res.length === 0) {
            return yield* new NotFoundError({ error: "User not found" });
          }

          return { success: true };
        }),
      )
      .handle("deleteUser", ({ params }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin"]);

          if (user.id === params.id) {
            const adminCountRes = yield* sql<{ count: number }>`
              SELECT COUNT(*)::int AS count
              FROM better_auth."user"
              WHERE role = 'admin' AND banned = false
            `.pipe(
              Effect.mapError(
                (e) =>
                  new InternalServerError({
                    error: `Database error: ${e.message}`,
                  }),
              ),
            );

            if ((adminCountRes[0]?.count ?? 0) <= 1) {
              return yield* new BadRequestError({
                error: "No se puede eliminar a uno mismo si es el único administrador",
              });
            }

            yield* sql`
              DELETE FROM better_auth."user" WHERE id = ${params.id}
            `.pipe(
              Effect.mapError(
                (e) =>
                  new InternalServerError({
                    error: `Database error: ${e.message}`,
                  }),
              ),
            );

            return { success: true };
          }

          const res = yield* sql<{ id: string }>`
          DELETE FROM better_auth."user" WHERE id = ${params.id} RETURNING id
        `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (res.length === 0) {
            return yield* new NotFoundError({ error: "User not found" });
          }

          return { success: true };
        }),
      );
  }),
);
