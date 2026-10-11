import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb } from "../../lib/db";

const app = new Hono<HonoEnv>();

// GET /courses
const coursesQuerySchema = z.object({
  ids: z.string().optional(),
  search: z.string().optional(),
});

app.get("/courses", zValidator("query", coursesQuerySchema), async (c) => {
  const { ids, search } = c.req.valid("query");

  return withDb(c, async (pool) => {
    if (ids) {
      const parsedIds = ids
        .split(",")
        .map((s) => Number(s.trim()))
        .filter((n) => Number.isFinite(n) && n > 0);

      if (parsedIds.length === 0) {
        return c.json([]);
      }

      const res = await pool.query(
        "SELECT id, code, name FROM public.course WHERE id = ANY($1::bigint[]) ORDER BY code ASC",
        [parsedIds],
      );
      const courses = res.rows.map((row) => ({
        id: Number(row.id),
        code: row.code,
        name: row.name,
      }));
      return c.json(courses);
    }

    if (search && search.trim() !== "") {
      const term = `%${search.trim()}%`;
      const res = await pool.query(
        "SELECT id, code, name FROM public.course WHERE code ILIKE $1 OR name ILIKE $1 ORDER BY code ASC LIMIT 50",
        [term],
      );
      const courses = res.rows.map((row) => ({
        id: Number(row.id),
        code: row.code,
        name: row.name,
      }));
      return c.json(courses);
    }

    const res = await pool.query(
      "SELECT id, code, name FROM public.course ORDER BY code ASC LIMIT 50",
    );
    const courses = res.rows.map((row) => ({
      id: Number(row.id),
      code: row.code,
      name: row.name,
    }));
    return c.json(courses);
  });
});

const courseIdParamSchema = z.object({
  id: z.coerce.number(),
});

// GET /courses/:id
app.get("/courses/:id", zValidator("param", courseIdParamSchema), async (c) => {
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const res = await pool.query("SELECT * FROM public.course WHERE id = $1", [id]);
    if (res.rows.length === 0) {
      return c.json({ error: "Course not found" }, 404);
    }
    const row = res.rows[0];
    return c.json({
      id: Number(row.id),
      code: row.code,
      name: row.name,
      credits: row.credits !== null ? Number(row.credits) : null,
      weekly_hours: row.weekly_hours !== null ? Number(row.weekly_hours) : null,
      created_at: row.created_at,
      updated_at: row.updated_at,
    });
  });
});

// GET /courses/:id/terms
const courseTermsQuerySchema = z.object({
  campusId: z.coerce.number().optional(),
  academicUnitId: z.coerce.number().optional(),
  studyPlanId: z.coerce.number().optional(),
});

app.get(
  "/courses/:id/terms",
  zValidator("param", courseIdParamSchema),
  zValidator("query", courseTermsQuerySchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const { campusId, academicUnitId, studyPlanId } = c.req.valid("query");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        "SELECT * FROM public.get_course_offering_terms($1, $2, $3, $4)",
        [id, campusId ?? null, academicUnitId ?? null, studyPlanId ?? null],
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
  },
);

// GET /courses/:id/groups
const courseGroupsQuerySchema = z.object({
  campusId: z.coerce.number().optional(),
  academicUnitId: z.coerce.number().optional(),
  academicTermId: z.coerce.number().optional(),
  studyPlanId: z.coerce.number().optional(),
});

app.get(
  "/courses/:id/groups",
  zValidator("param", courseIdParamSchema),
  zValidator("query", courseGroupsQuerySchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const { campusId, academicUnitId, academicTermId, studyPlanId } = c.req.valid("query");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        "SELECT * FROM public.get_course_latest_term_groups($1, $2, $3, $4, $5)",
        [id, campusId ?? null, academicUnitId ?? null, academicTermId ?? null, studyPlanId ?? null],
      );
      const groups = res.rows.map((r) => ({
        academicTermId: Number(r.academic_term_id),
        termDisplayName: r.term_display_name,
        termYear: Number(r.term_year),
        termPeriodNumber: Number(r.term_period_number),
        sourceCourseId: Number(r.source_course_id),
        sourceCourseCode: r.source_course_code,
        sourceCourseName: r.source_course_name,
        groupId: Number(r.group_id),
        groupCode: r.group_code,
        groupType: r.group_type,
        capacity: Number(r.capacity),
        campusId: r.campus_id !== null ? Number(r.campus_id) : null,
        campusName: r.campus_name ?? null,
        professors: r.professors ?? [],
        meetings: r.meetings ?? [],
        // also keep snake_case
        academic_term_id: Number(r.academic_term_id),
        term_display_name: r.term_display_name,
        term_year: Number(r.term_year),
        term_period_number: Number(r.term_period_number),
        source_course_id: Number(r.source_course_id),
        source_course_code: r.source_course_code,
        source_course_name: r.source_course_name,
        group_id: Number(r.group_id),
        group_code: r.group_code,
        group_type: r.group_type,
        campus_id: r.campus_id !== null ? Number(r.campus_id) : null,
        campus_name: r.campus_name ?? null,
      }));
      return c.json(groups);
    });
  },
);

// GET /courses/:id/professors
const courseProfessorsQuerySchema = z.object({
  campusId: z.coerce.number().optional(),
  academicUnitId: z.coerce.number().optional(),
  yearWindow: z.coerce.number().default(2),
  academicTermId: z.coerce.number().optional(),
});

app.get(
  "/courses/:id/professors",
  zValidator("param", courseIdParamSchema),
  zValidator("query", courseProfessorsQuerySchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const { campusId, academicUnitId, yearWindow, academicTermId } = c.req.valid("query");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        "SELECT * FROM public.get_course_recent_professors($1, $2, $3, $4, $5)",
        [id, campusId ?? null, academicUnitId ?? null, yearWindow, academicTermId ?? null],
      );
      const professors = res.rows.map((r) => ({
        professorId: Number(r.professor_id),
        professorName: r.professor_name,
        lastTaughtTermId: Number(r.last_taught_term_id),
        lastTaughtTermName: r.last_taught_term_name,
        lastTaughtYear: Number(r.last_taught_year),
        lastTaughtPeriodNumber: Number(r.last_taught_period_number),
        groupsInLastTermCount: Number(r.groups_in_last_term_count),
        termsTaughtCount: Number(r.terms_taught_count),
        // also keep snake_case
        professor_id: Number(r.professor_id),
        professor_name: r.professor_name,
        last_taught_term_id: Number(r.last_taught_term_id),
        last_taught_term_name: r.last_taught_term_name,
        last_taught_year: Number(r.last_taught_year),
        last_taught_period_number: Number(r.last_taught_period_number),
        groups_in_last_term_count: Number(r.groups_in_last_term_count),
        terms_taught_count: Number(r.terms_taught_count),
      }));
      return c.json(professors);
    });
  },
);

// GET /courses/:id/equivalents
const courseEquivalentsQuerySchema = z.object({
  studyPlanId: z.coerce.number(),
  limit: z.coerce.number().default(100),
  offset: z.coerce.number().default(0),
});

app.get(
  "/courses/:id/equivalents",
  zValidator("param", courseIdParamSchema),
  zValidator("query", courseEquivalentsQuerySchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const { studyPlanId, limit, offset } = c.req.valid("query");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        "SELECT * FROM public.get_course_detail_related_courses($1, $2, $3, $4)",
        [studyPlanId, id, limit, offset],
      );
      const equivalents = res.rows.map((r) => ({
        id: Number(r.course_id),
        code: r.course_code,
        name: r.course_name,
        credits: r.course_credits !== null ? Number(r.course_credits) : null,
        weeklyHours: r.course_weekly_hours !== null ? Number(r.course_weekly_hours) : null,
        relationKind: r.relation_kind,
        isPlaceholder: Boolean(r.is_placeholder),
        hasOfferings: Boolean(r.has_offerings),
        totalEquivalents: Number(r.total_equivalents),
        // also keep snake_case
        course_id: Number(r.course_id),
        course_code: r.course_code,
        course_name: r.course_name,
        course_credits: r.course_credits !== null ? Number(r.course_credits) : null,
        course_weekly_hours: r.course_weekly_hours !== null ? Number(r.course_weekly_hours) : null,
        relation_kind: r.relation_kind,
        is_placeholder: Boolean(r.is_placeholder),
        has_offerings: Boolean(r.has_offerings),
        total_equivalents: Number(r.total_equivalents),
      }));
      return c.json(equivalents);
    });
  },
);

export default app;
