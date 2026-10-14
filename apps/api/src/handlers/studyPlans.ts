import { Effect } from "effect";
import { HttpApi, HttpApiBuilder } from "effect/http-api";

import { StudyPlansApiGroup } from "../api/StudyPlansApi";
import {
  type CoursePrerequisitesResponse,
  type CourseRelation,
  type StudyPlan,
  type StudyPlanCourse,
  type StudyPlanDetail,
  type StudyPlanIdParams,
  StudyPlanNotFound,
  type StudyPlanRelationsQuery,
  type StudyPlansQuery,
} from "../domain/StudyPlans";
import { Database, type SqlClient } from "../services/Database";

const studyPlansApi = HttpApi.make("claustrum-study-plans").add(StudyPlansApiGroup);

export const studyPlansHandlers = HttpApiBuilder.group(
  studyPlansApi,
  "studyPlans",
  Effect.fn(function* (handlers) {
    const db = yield* Database;
    const sql = db as unknown as SqlClient;

    return handlers.handleAll({
      list: ({ query }: { query: StudyPlansQuery }) =>
        Effect.gen(function* () {
          if (query.academicUnitId && query.campusId) {
            const res = yield* sql
              .unsafe<{
                id: string | number;
                academic_unit_id: string | number;
                external_plan_id: string | number;
                name: string;
                academic_degree: string;
              }>("SELECT * FROM public.get_study_plans_for_campus_and_academic_unit($1, $2)", [
                query.academicUnitId,
                query.campusId,
              ])
              .pipe(Effect.orDie);

            return res.map((row): StudyPlan => ({
              id: Number(row.id),
              academic_unit_id: Number(row.academic_unit_id),
              external_plan_id: Number(row.external_plan_id),
              name: row.name,
              academic_degree: row.academic_degree,
              modality_name: undefined,
            }));
          }

          if (query.academicUnitId) {
            const res = yield* sql
              .unsafe<{
                id: string | number;
                academic_unit_id: string | number;
                external_plan_id: string | number;
                name: string;
                academic_degree: string;
                modality_name?: string | null;
              }>("SELECT * FROM public.get_study_plans_for_academic_unit($1)", [
                query.academicUnitId,
              ])
              .pipe(Effect.orDie);

            return res.map((row): StudyPlan => ({
              id: Number(row.id),
              academic_unit_id: Number(row.academic_unit_id),
              external_plan_id: Number(row.external_plan_id),
              name: row.name,
              academic_degree: row.academic_degree,
              modality_name: row.modality_name ?? undefined,
            }));
          }

          const res = yield* sql
            .unsafe<{
              id: string | number;
              academic_unit_id: string | number;
              external_plan_id: string | number;
              name: string;
              academic_degree: string;
              modality_name?: string | null;
            }>(
              `SELECT sp.id, sp.academic_unit_id, sp.external_plan_id,
                      sp.external_plan_id::TEXT || ' - ' || sp.name AS name,
                      sp.academic_degree,
                      am.name AS modality_name
               FROM public.study_plan sp
               LEFT JOIN public.academic_modality am ON am.id = sp.academic_modality_id
               WHERE sp.is_active = true
                 AND (am.id IS NULL OR am.is_active = true)
               ORDER BY sp.external_plan_id DESC`,
            )
            .pipe(Effect.orDie);

          return res.map((row): StudyPlan => ({
            id: Number(row.id),
            academic_unit_id: Number(row.academic_unit_id),
            external_plan_id: Number(row.external_plan_id),
            name: row.name,
            academic_degree: row.academic_degree,
            modality_name: row.modality_name ?? undefined,
          }));
        }),

      getById: ({ params }: { params: StudyPlanIdParams }) =>
        Effect.gen(function* () {
          const planRes = yield* sql
            .unsafe<{
              id: string | number;
              academic_unit_id: string | number;
              external_plan_id: string | number;
              name: string;
              academic_degree: string;
              modality_name?: string | null;
            }>(
              `SELECT sp.id, sp.academic_unit_id, sp.external_plan_id, sp.name, sp.academic_degree,
                      am.name AS modality_name
               FROM public.study_plan sp
               LEFT JOIN public.academic_modality am ON am.id = sp.academic_modality_id
               WHERE sp.id = $1`,
              [params.id],
            )
            .pipe(Effect.orDie);

          if (planRes.length === 0) {
            return yield* Effect.fail(new StudyPlanNotFound({ error: "Study plan not found" }));
          }

          const coursesRes = yield* sql
            .unsafe<{
              course_id: string | number;
              level_number: string | number | null;
              credits: string | number;
              weekly_hours: string | number;
              sort_order: string | number;
              course_code: string;
              course_name: string;
              default_credits?: string | number | null;
              course_default_credits?: string | number | null;
              default_weekly_hours?: string | number | null;
              course_default_weekly_hours?: string | number | null;
              level_label?: string | null;
            }>("SELECT * FROM public.get_study_plan_courses_details($1)", [params.id])
            .pipe(Effect.orDie);

          const relationsRes = yield* sql
            .unsafe<{
              from_course_id: string | number;
              to_course_id: string | number;
              relation_type: string;
            }>(
              "SELECT from_course_id, to_course_id, relation_type FROM public.course_relation WHERE study_plan_id = $1",
              [params.id],
            )
            .pipe(Effect.orDie);

          const row = planRes[0];
          const plan: StudyPlan = {
            id: Number(row.id),
            academic_unit_id: Number(row.academic_unit_id),
            external_plan_id: Number(row.external_plan_id),
            name: row.name,
            academic_degree: row.academic_degree,
            modality_name: row.modality_name ?? undefined,
          };

          const courses = coursesRes.map((r): StudyPlanCourse => ({
            courseId: Number(r.course_id),
            levelNumber: r.level_number !== null ? Number(r.level_number) : null,
            credits: Number(r.credits),
            weeklyHours: Number(r.weekly_hours),
            sortOrder: Number(r.sort_order),
            courseCode: r.course_code,
            courseName: r.course_name,
            courseDefaultCredits: Number(r.default_credits ?? r.course_default_credits ?? 0),
            courseDefaultWeeklyHours: Number(
              r.default_weekly_hours ?? r.course_default_weekly_hours ?? 0,
            ),
            default_credits: Number(r.default_credits ?? r.course_default_credits ?? 0),
            default_weekly_hours: Number(
              r.default_weekly_hours ?? r.course_default_weekly_hours ?? 0,
            ),
            levelLabel: r.level_label ?? undefined,
            course_id: Number(r.course_id),
            level_number: r.level_number !== null ? Number(r.level_number) : null,
            weekly_hours: Number(r.weekly_hours),
            sort_order: Number(r.sort_order),
            course_code: r.course_code,
            course_name: r.course_name,
          }));

          const relations = relationsRes.map((r): CourseRelation => ({
            fromCourseId: Number(r.from_course_id),
            toCourseId: Number(r.to_course_id),
            relationType: r.relation_type,
            from_course_id: Number(r.from_course_id),
            to_course_id: Number(r.to_course_id),
            relation_type: r.relation_type,
          }));

          return { ...plan, plan, courses, relations } satisfies StudyPlanDetail;
        }),

      getCourses: ({ params }: { params: StudyPlanIdParams }) =>
        Effect.gen(function* () {
          const res = yield* sql
            .unsafe<{
              course_id: string | number;
              level_number: string | number | null;
              credits: string | number;
              weekly_hours: string | number;
              sort_order: string | number;
              course_code: string;
              course_name: string;
              default_credits?: string | number | null;
              course_default_credits?: string | number | null;
              default_weekly_hours?: string | number | null;
              course_default_weekly_hours?: string | number | null;
              level_label?: string | null;
            }>("SELECT * FROM public.get_study_plan_courses_details($1)", [params.id])
            .pipe(Effect.orDie);

          return res.map((r): StudyPlanCourse => ({
            courseId: Number(r.course_id),
            levelNumber: r.level_number !== null ? Number(r.level_number) : null,
            credits: Number(r.credits),
            weeklyHours: Number(r.weekly_hours),
            sortOrder: Number(r.sort_order),
            courseCode: r.course_code,
            courseName: r.course_name,
            courseDefaultCredits: Number(r.default_credits ?? r.course_default_credits ?? 0),
            courseDefaultWeeklyHours: Number(
              r.default_weekly_hours ?? r.course_default_weekly_hours ?? 0,
            ),
            default_credits: Number(r.default_credits ?? r.course_default_credits ?? 0),
            default_weekly_hours: Number(
              r.default_weekly_hours ?? r.course_default_weekly_hours ?? 0,
            ),
            levelLabel: r.level_label ?? undefined,
            course_id: Number(r.course_id),
            level_number: r.level_number !== null ? Number(r.level_number) : null,
            weekly_hours: Number(r.weekly_hours),
            sort_order: Number(r.sort_order),
            course_code: r.course_code,
            course_name: r.course_name,
          }));
        }),

      getRelations: ({
        params,
        query,
      }: {
        params: StudyPlanIdParams;
        query: StudyPlanRelationsQuery;
      }) =>
        Effect.gen(function* () {
          if (query.courseId) {
            const res = yield* sql
              .unsafe<{
                from_course_id: string | number;
                relation_type: string;
              }>(
                `SELECT from_course_id, relation_type
                 FROM public.course_relation
                 WHERE study_plan_id = $1 AND to_course_id = $2`,
                [params.id, query.courseId],
              )
              .pipe(Effect.orDie);

            const prerequisites: number[] = [];
            const corequisites: number[] = [];

            for (const row of res) {
              if (row.relation_type === "PREREQUISITE") {
                prerequisites.push(Number(row.from_course_id));
              } else if (row.relation_type === "COREQUISITE") {
                corequisites.push(Number(row.from_course_id));
              }
            }

            return { prerequisites, corequisites } satisfies CoursePrerequisitesResponse;
          }

          const res = yield* sql
            .unsafe<{
              from_course_id: string | number;
              to_course_id: string | number;
              relation_type: string;
            }>(
              "SELECT from_course_id, to_course_id, relation_type FROM public.course_relation WHERE study_plan_id = $1",
              [params.id],
            )
            .pipe(Effect.orDie);

          return res.map((r): CourseRelation => ({
            fromCourseId: Number(r.from_course_id),
            toCourseId: Number(r.to_course_id),
            relationType: r.relation_type,
            from_course_id: Number(r.from_course_id),
            to_course_id: Number(r.to_course_id),
            relation_type: r.relation_type,
          }));
        }),
    });
  }),
);
