import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb } from "../../lib/db";

const app = new Hono<HonoEnv>();

const booleanQueryParam = (defaultValue: boolean) =>
  z
    .union([z.boolean(), z.string()])
    .optional()
    .transform((val) => {
      if (val === undefined || val === "") return defaultValue;
      if (typeof val === "boolean") return val;
      return val.toLowerCase() === "true" || val === "1";
    });

// GET /professors
const searchProfessorsQuerySchema = z.object({
  query: z.string().optional(),
  search: z.string().optional(),
  minAverageScore: z.coerce.number().optional(),
  minReviewCount: z.coerce.number().default(0),
  academicUnitId: z.coerce.number().optional(),
  onlyWithApprovedReviews: booleanQueryParam(false),
  sortBy: z
    .enum(["reviews", "score", "ease", "quality", "clarity", "name", "date"])
    .default("reviews"),
  sortDesc: booleanQueryParam(true),
  limit: z.coerce.number().default(25),
  offset: z.coerce.number().default(0),
});

app.get("/professors", zValidator("query", searchProfessorsQuerySchema), async (c) => {
  const queryData = c.req.valid("query");
  const searchQuery = (queryData.query ?? queryData.search)?.trim() || null;

  return withDb(c, async (pool) => {
    const res = await pool.query(
      `SELECT * FROM public.search_professor_review_stats(
         $1, $2, $3, $4, $5, $6, $7, $8, $9
       )`,
      [
        searchQuery,
        queryData.minAverageScore ?? null,
        queryData.minReviewCount,
        queryData.academicUnitId ?? null,
        queryData.onlyWithApprovedReviews,
        queryData.sortBy,
        queryData.sortDesc,
        queryData.limit,
        queryData.offset,
      ],
    );

    const rows = res.rows.map((r) => ({
      professor_id: r.professor_id,
      professor_name: r.professor_name,
      approved_review_count: Number(r.approved_review_count),
      average_overall_score:
        r.average_overall_score !== null ? Number(r.average_overall_score) : null,
      average_ease_score: r.average_ease_score !== null ? Number(r.average_ease_score) : null,
      average_quality_score:
        r.average_quality_score !== null ? Number(r.average_quality_score) : null,
      average_clarity_score:
        r.average_clarity_score !== null ? Number(r.average_clarity_score) : null,
      courses_reviewed_count: Number(r.courses_reviewed_count),
      last_approved_review_at: r.last_approved_review_at,
      search_rank: r.search_rank !== null ? Number(r.search_rank) : null,
      academic_unit: r.academic_unit ?? null,
      total_count: Number(r.total_count),
    }));

    return c.json(rows);
  });
});

const professorIdParamSchema = z.object({
  id: z.string(),
});

// GET /professors/:id
app.get("/professors/:id", zValidator("param", professorIdParamSchema), async (c) => {
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const res = await pool.query("SELECT id, full_name FROM public.professor WHERE id::text = $1", [
      id,
    ]);

    if (res.rows.length === 0) {
      return c.json({ error: "Professor not found" }, 404);
    }

    const row = res.rows[0];
    return c.json({
      id: Number(row.id),
      full_name: row.full_name,
    });
  });
});

// GET /professors/:id/summary
app.get("/professors/:id/summary", zValidator("param", professorIdParamSchema), async (c) => {
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const res = await pool.query("SELECT * FROM public.get_professor_review_summary($1)", [id]);

    if (res.rows.length === 0) {
      return c.json({
        professor_id: id,
        approved_review_count: 0,
        average_overall_score: null,
        average_ease_score: null,
        average_quality_score: null,
        average_clarity_score: null,
        average_fairness_score: null,
        would_take_again_percentage: null,
        tag_counts: [],
      });
    }

    const r = res.rows[0];
    return c.json({
      professor_id: r.professor_id ?? id,
      approved_review_count: Number(r.approved_review_count ?? 0),
      average_overall_score:
        r.average_overall_score !== null ? Number(r.average_overall_score) : null,
      average_ease_score: r.average_ease_score !== null ? Number(r.average_ease_score) : null,
      average_quality_score:
        r.average_quality_score !== null ? Number(r.average_quality_score) : null,
      average_clarity_score:
        r.average_clarity_score !== null ? Number(r.average_clarity_score) : null,
      average_fairness_score:
        r.average_fairness_score !== null ? Number(r.average_fairness_score) : null,
      would_take_again_percentage:
        r.would_take_again_percentage !== null ? Number(r.would_take_again_percentage) : null,
      tag_counts: r.tag_counts ?? [],
    });
  });
});

// GET /professors/:id/courses
app.get("/professors/:id/courses", zValidator("param", professorIdParamSchema), async (c) => {
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const res = await pool.query("SELECT * FROM public.get_professor_review_courses($1)", [id]);
    const courses = res.rows.map((r) => ({
      id: Number(r.id),
      code: r.code,
      name: r.name,
    }));
    return c.json(courses);
  });
});

// GET /professors/:id/terms
app.get("/professors/:id/terms", zValidator("param", professorIdParamSchema), async (c) => {
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const res = await pool.query("SELECT * FROM public.get_professor_offering_terms($1)", [id]);
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

// GET /professors/:id/history
app.get("/professors/:id/history", zValidator("param", professorIdParamSchema), async (c) => {
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const res = await pool.query(
      `SELECT
         at.id AS term_id,
         at.year,
         at.period_number,
         at.display_name AS term_display_name,
         am.name AS modality_name,
         c.id AS course_id,
         c.code AS course_code,
         c.name AS course_name,
         cog.id AS group_id,
         cog.group_code
       FROM public.course_offering_group_professor cogp
       JOIN public.course_offering_group cog ON cog.id = cogp.course_offering_group_id
       JOIN public.course_offering co ON co.id = cog.course_offering_id
       JOIN public.course c ON c.id = co.course_id
       JOIN public.academic_term at ON at.id = co.academic_term_id
       LEFT JOIN public.academic_modality am ON am.id = at.academic_modality_id
       WHERE cogp.professor_id::text = $1
         AND co.is_active = TRUE
         AND (cog.is_active IS NULL OR cog.is_active = TRUE)
       ORDER BY at.year DESC, at.period_number DESC, at.id DESC, c.code ASC, cog.group_code ASC`,
      [id],
    );

    const termMap = new Map<
      number,
      {
        term_id: number;
        year: number;
        period_number: number;
        term_display_name: string;
        modality_name: string | null;
        courses: Map<
          number,
          {
            id: number;
            code: string;
            name: string;
            groups: string[];
          }
        >;
      }
    >();

    for (const r of res.rows) {
      const termId = Number(r.term_id);
      let termEntry = termMap.get(termId);
      if (!termEntry) {
        termEntry = {
          term_id: termId,
          year: Number(r.year),
          period_number: Number(r.period_number),
          term_display_name: r.term_display_name,
          modality_name: r.modality_name ?? null,
          courses: new Map(),
        };
        termMap.set(termId, termEntry);
      }

      const courseId = Number(r.course_id);
      let courseEntry = termEntry.courses.get(courseId);
      if (!courseEntry) {
        courseEntry = {
          id: courseId,
          code: r.course_code,
          name: r.course_name,
          groups: [],
        };
        termEntry.courses.set(courseId, courseEntry);
      }

      if (r.group_code && !courseEntry.groups.includes(r.group_code)) {
        courseEntry.groups.push(r.group_code);
      }
    }

    const result = Array.from(termMap.values()).map((term) => ({
      term_id: term.term_id,
      year: term.year,
      period_number: term.period_number,
      term_display_name: term.term_display_name,
      modality_name: term.modality_name,
      courses: Array.from(term.courses.values()),
    }));

    return c.json(result);
  });
});

export default app;
