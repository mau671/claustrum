import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb } from "../../lib/db";

const app = new Hono<HonoEnv>();

// GET /universities
app.get("/universities", async (c) => {
  return withDb(c, async (pool) => {
    const res = await pool.query(
      "SELECT id, name, short_name FROM public.university ORDER BY name ASC",
    );
    const universities = res.rows.map((row) => ({
      id: Number(row.id),
      name: row.name,
      short_name: row.short_name,
    }));
    return c.json(universities);
  });
});

// GET /campuses
const campusesQuerySchema = z.object({
  universityId: z.coerce.number().optional(),
  all: z.enum(["true", "false"]).optional(),
});

app.get("/campuses", zValidator("query", campusesQuerySchema), async (c) => {
  const { universityId, all } = c.req.valid("query");
  const includeAll = all === "true";

  return withDb(c, async (pool) => {
    if (!includeAll && universityId) {
      const res = await pool.query(
        "SELECT id, university_id, code, name FROM public.get_campuses_for_university($1) ORDER BY name ASC",
        [universityId],
      );
      const campuses = res.rows.map((row) => ({
        id: Number(row.id),
        university_id: Number(row.university_id),
        code: row.code,
        name: row.name,
      }));
      return c.json(campuses);
    }

    const res = await pool.query(
      `SELECT id, university_id, code, name
       FROM public.campus
       WHERE is_active = true
         AND ($1::bigint IS NULL OR university_id = $1)
         AND ($2::boolean IS TRUE OR code = ANY(ARRAY['AL', 'CA', 'LM', 'SC', 'SJ']::TEXT[]))
       ORDER BY name ASC`,
      [universityId ?? null, includeAll],
    );
    const campuses = res.rows.map((row) => ({
      id: Number(row.id),
      university_id: Number(row.university_id),
      code: row.code,
      name: row.name,
    }));
    return c.json(campuses);
  });
});

// GET /academicunits
const academicUnitsQuerySchema = z.object({
  campusId: z.coerce.number().optional(),
  withProfessors: z.enum(["true", "false"]).optional(),
});

app.get("/academicunits", zValidator("query", academicUnitsQuerySchema), async (c) => {
  const { campusId, withProfessors } = c.req.valid("query");

  return withDb(c, async (pool) => {
    if (withProfessors === "true") {
      const res = await pool.query("SELECT * FROM public.get_academic_units_with_professors()");
      const units = res.rows.map((row) => ({
        id: Number(row.id),
        code: row.code,
        name: row.name,
      }));
      return c.json(units);
    }

    if (campusId) {
      const res = await pool.query("SELECT * FROM public.get_academic_units_for_campus($1)", [
        campusId,
      ]);
      const units = res.rows.map((row) => ({
        id: Number(row.id),
        code: row.code,
        name: row.name,
        university_id: row.university_id ? Number(row.university_id) : undefined,
      }));
      return c.json(units);
    }

    const res = await pool.query(
      "SELECT id, university_id, code, name FROM public.v_academic_units_with_plans ORDER BY name ASC",
    );
    const units = res.rows.map((row) => ({
      id: Number(row.id),
      code: row.code,
      name: row.name,
      university_id: Number(row.university_id),
    }));
    return c.json(units);
  });
});

// GET /studyplans
const studyPlansQuerySchema = z.object({
  academicUnitId: z.coerce.number().optional(),
  campusId: z.coerce.number().optional(),
});

app.get("/studyplans", zValidator("query", studyPlansQuerySchema), async (c) => {
  const { academicUnitId, campusId } = c.req.valid("query");

  return withDb(c, async (pool) => {
    if (academicUnitId && campusId) {
      const res = await pool.query(
        "SELECT * FROM public.get_study_plans_for_campus_and_academic_unit($1, $2)",
        [academicUnitId, campusId],
      );
      const studyPlans = res.rows.map((row) => ({
        id: Number(row.id),
        academic_unit_id: Number(row.academic_unit_id),
        external_plan_id: Number(row.external_plan_id),
        name: row.name,
        academic_degree: row.academic_degree,
        modality_name: undefined,
      }));
      return c.json(studyPlans);
    }

    if (academicUnitId) {
      const res = await pool.query("SELECT * FROM public.get_study_plans_for_academic_unit($1)", [
        academicUnitId,
      ]);
      const studyPlans = res.rows.map((row) => ({
        id: Number(row.id),
        academic_unit_id: Number(row.academic_unit_id),
        external_plan_id: Number(row.external_plan_id),
        name: row.name,
        academic_degree: row.academic_degree,
        modality_name: row.modality_name ?? undefined,
      }));
      return c.json(studyPlans);
    }

    const res = await pool.query(
      `SELECT sp.id, sp.academic_unit_id, sp.external_plan_id,
              sp.external_plan_id::TEXT || ' - ' || sp.name AS name,
              sp.academic_degree,
              am.name AS modality_name
       FROM public.study_plan sp
       LEFT JOIN public.academic_modality am ON am.id = sp.academic_modality_id
       WHERE sp.is_active = true
         AND (am.id IS NULL OR am.is_active = true)
       ORDER BY sp.external_plan_id DESC`,
    );
    const studyPlans = res.rows.map((row) => ({
      id: Number(row.id),
      academic_unit_id: Number(row.academic_unit_id),
      external_plan_id: Number(row.external_plan_id),
      name: row.name,
      academic_degree: row.academic_degree,
      modality_name: row.modality_name ?? undefined,
    }));
    return c.json(studyPlans);
  });
});

// GET /studyplans/:id
const studyPlanIdParamSchema = z.object({
  id: z.coerce.number(),
});

app.get("/studyplans/:id", zValidator("param", studyPlanIdParamSchema), async (c) => {
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const [planRes, coursesRes, relationsRes] = await Promise.all([
      pool.query(
        `SELECT sp.id, sp.academic_unit_id, sp.external_plan_id, sp.name, sp.academic_degree,
                am.name AS modality_name
         FROM public.study_plan sp
         LEFT JOIN public.academic_modality am ON am.id = sp.academic_modality_id
         WHERE sp.id = $1`,
        [id],
      ),
      pool.query("SELECT * FROM public.get_study_plan_courses_details($1)", [id]),
      pool.query(
        "SELECT from_course_id, to_course_id, relation_type FROM public.course_relation WHERE study_plan_id = $1",
        [id],
      ),
    ]);

    if (planRes.rows.length === 0) {
      return c.json({ error: "Study plan not found" }, 404);
    }

    const row = planRes.rows[0];
    const plan = {
      id: Number(row.id),
      academic_unit_id: Number(row.academic_unit_id),
      external_plan_id: Number(row.external_plan_id),
      name: row.name,
      academic_degree: row.academic_degree,
      modality_name: row.modality_name ?? undefined,
    };

    const courses = coursesRes.rows.map((r) => ({
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
      default_weekly_hours: Number(r.default_weekly_hours ?? r.course_default_weekly_hours ?? 0),
      levelLabel: r.level_label ?? undefined,
      course_id: Number(r.course_id),
      level_number: r.level_number !== null ? Number(r.level_number) : null,
      weekly_hours: Number(r.weekly_hours),
      sort_order: Number(r.sort_order),
      course_code: r.course_code,
      course_name: r.course_name,
    }));

    const relations = relationsRes.rows.map((r) => ({
      fromCourseId: Number(r.from_course_id),
      toCourseId: Number(r.to_course_id),
      relationType: r.relation_type,
      from_course_id: Number(r.from_course_id),
      to_course_id: Number(r.to_course_id),
      relation_type: r.relation_type,
    }));

    return c.json({ ...plan, plan, courses, relations });
  });
});

// GET /studyplans/:id/courses
app.get("/studyplans/:id/courses", zValidator("param", studyPlanIdParamSchema), async (c) => {
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const res = await pool.query("SELECT * FROM public.get_study_plan_courses_details($1)", [id]);
    const courses = res.rows.map((r) => ({
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
      default_weekly_hours: Number(r.default_weekly_hours ?? r.course_default_weekly_hours ?? 0),
      levelLabel: r.level_label ?? undefined,
      course_id: Number(r.course_id),
      level_number: r.level_number !== null ? Number(r.level_number) : null,
      weekly_hours: Number(r.weekly_hours),
      sort_order: Number(r.sort_order),
      course_code: r.course_code,
      course_name: r.course_name,
    }));
    return c.json(courses);
  });
});

// GET /studyplans/:id/relations
const relationsQuerySchema = z.object({
  courseId: z.coerce.number().optional(),
});

app.get(
  "/studyplans/:id/relations",
  zValidator("param", studyPlanIdParamSchema),
  zValidator("query", relationsQuerySchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const { courseId } = c.req.valid("query");

    return withDb(c, async (pool) => {
      if (courseId) {
        const res = await pool.query(
          `SELECT from_course_id, relation_type
           FROM public.course_relation
           WHERE study_plan_id = $1 AND to_course_id = $2`,
          [id, courseId],
        );
        const prerequisites: number[] = [];
        const corequisites: number[] = [];
        for (const row of res.rows) {
          if (row.relation_type === "PREREQUISITE") {
            prerequisites.push(Number(row.from_course_id));
          } else if (row.relation_type === "COREQUISITE") {
            corequisites.push(Number(row.from_course_id));
          }
        }
        return c.json({ prerequisites, corequisites });
      }

      const res = await pool.query(
        "SELECT from_course_id, to_course_id, relation_type FROM public.course_relation WHERE study_plan_id = $1",
        [id],
      );
      const relations = res.rows.map((r) => ({
        fromCourseId: Number(r.from_course_id),
        toCourseId: Number(r.to_course_id),
        relationType: r.relation_type,
        from_course_id: Number(r.from_course_id),
        to_course_id: Number(r.to_course_id),
        relation_type: r.relation_type,
      }));
      return c.json(relations);
    });
  },
);

// GET /terms/active
app.get("/terms/active", async (c) => {
  return withDb(c, async (pool) => {
    const res = await pool.query("SELECT * FROM public.get_active_academic_terms()");
    const terms = res.rows.map((r) => ({
      id: Number(r.id),
      academic_modality_id: Number(r.academic_modality_id),
      year: Number(r.year),
      period_number: Number(r.period_number),
      external_key: r.external_key,
      display_name: r.display_name,
      starts_on: r.starts_on,
      ends_on: r.ends_on,
    }));
    return c.json(terms);
  });
});

// GET /terms/suggested
const suggestedTermQuerySchema = z.object({
  studyPlanId: z.coerce.number().optional(),
});

app.get("/terms/suggested", zValidator("query", suggestedTermQuerySchema), async (c) => {
  const { studyPlanId } = c.req.valid("query");

  return withDb(c, async (pool) => {
    const res = await pool.query(
      "SELECT public.get_suggested_academic_term($1) AS suggested_term_id",
      [studyPlanId ?? null],
    );
    const suggestedId = res.rows[0]?.suggested_term_id
      ? Number(res.rows[0].suggested_term_id)
      : null;
    return c.json(suggestedId);
  });
});

// GET /terms
const termsQuerySchema = z.object({
  campusId: z.coerce.number().optional(),
  studyPlanId: z.coerce.number().optional(),
});

app.get("/terms", zValidator("query", termsQuerySchema), async (c) => {
  const { campusId, studyPlanId } = c.req.valid("query");

  return withDb(c, async (pool) => {
    if (studyPlanId && campusId) {
      const res = await pool.query("SELECT * FROM public.get_academic_terms_by_plan($1, $2)", [
        studyPlanId,
        campusId,
      ]);
      const terms = res.rows.map((r) => ({
        id: Number(r.id),
        academic_modality_id: Number(r.academic_modality_id),
        year: Number(r.year),
        period_number: Number(r.period_number),
        external_key: r.external_key,
        display_name: r.display_name,
        starts_on: r.starts_on,
        ends_on: r.ends_on,
      }));
      return c.json(terms);
    }

    if (studyPlanId) {
      const res = await pool.query("SELECT * FROM public.get_academic_terms_by_plan($1, NULL)", [
        studyPlanId,
      ]);
      const terms = res.rows.map((r) => ({
        id: Number(r.id),
        academic_modality_id: Number(r.academic_modality_id),
        year: Number(r.year),
        period_number: Number(r.period_number),
        external_key: r.external_key,
        display_name: r.display_name,
        starts_on: r.starts_on,
        ends_on: r.ends_on,
      }));
      return c.json(terms);
    }

    const res = await pool.query(
      `SELECT at.id, at.academic_modality_id, at.year, at.period_number,
              at.external_key, at.display_name, at.starts_on, at.ends_on
       FROM public.academic_term at
       ORDER BY at.year DESC, at.period_number DESC`,
    );
    const terms = res.rows.map((r) => ({
      id: Number(r.id),
      academic_modality_id: Number(r.academic_modality_id),
      year: Number(r.year),
      period_number: Number(r.period_number),
      external_key: r.external_key,
      display_name: r.display_name,
      starts_on: r.starts_on,
      ends_on: r.ends_on,
    }));
    return c.json(terms);
  });
});

export default app;
