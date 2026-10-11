import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb, withUserDb } from "../../lib/db";
import { optionalAuth, requireAuth } from "../../middleware/auth";

const app = new Hono<HonoEnv>();

// GET /schedules/courses
const scheduleCoursesQuerySchema = z.object({
  termId: z.coerce.number(),
  campusId: z.coerce.number(),
  careerId: z.coerce.number().optional(),
  planId: z.coerce.number().optional(),
  otherCampuses: z.enum(["true", "false"]).optional(),
  showAll: z.enum(["true", "false"]).optional(),
});

app.get(
  "/schedules/courses",
  optionalAuth,
  zValidator("query", scheduleCoursesQuerySchema),
  async (c) => {
    const { termId, campusId, careerId, planId, otherCampuses, showAll } = c.req.valid("query");
    const user = c.get("user");
    const userId = user?.id ?? null;

    const includeOtherCampuses = otherCampuses === "true";
    const showAllCourses = userId ? showAll !== "false" : true;

    return withDb(c, async (pool) => {
      const res = await pool.query(
        "SELECT * FROM public.get_schedule_courses($1, $2, $3, $4, $5, $6, $7)",
        [
          userId,
          termId,
          campusId,
          planId ?? null,
          careerId ?? null,
          includeOtherCampuses,
          showAllCourses,
        ],
      );

      const courses = res.rows.map((r) => ({
        offering_id: Number(r.offering_id),
        course_id: Number(r.course_id),
        course_code: r.course_code,
        course_name: r.course_name,
        credits: Number(r.credits),
        weekly_hours: Number(r.weekly_hours),
        course_type: r.course_type ?? null,
        academic_unit_id: Number(r.academic_unit_id),
        academic_unit_name: r.academic_unit_name,
        campus_id: Number(r.campus_id),
        academic_term_id: Number(r.academic_term_id),
        term_display_name: r.term_display_name,
        groups: r.groups ?? [],
        level_number: r.level_number !== null ? Number(r.level_number) : null,
        level_label: r.level_label ?? null,
        sort_order: r.sort_order !== null ? Number(r.sort_order) : null,
      }));

      return c.json(courses);
    });
  },
);

// GET /schedules
app.get("/schedules", requireAuth, async (c) => {
  const user = c.get("user")!;

  return withDb(c, async (pool) => {
    const res = await pool.query(
      `SELECT id, name, academic_term_id, created_at, updated_at
       FROM public.saved_schedule
       WHERE user_id = $1
       ORDER BY updated_at DESC`,
      [user.id],
    );

    const schedules = res.rows.map((r) => ({
      id: Number(r.id),
      name: r.name,
      academic_term_id: Number(r.academic_term_id),
      created_at: r.created_at,
      updated_at: r.updated_at,
    }));

    return c.json(schedules);
  });
});

// POST /schedules
const saveScheduleBodySchema = z.object({
  name: z.string().trim().min(1).max(255),
  termId: z.number().int().positive().optional(),
  academicTermId: z.number().int().positive().optional(),
  groupLookups: z.array(
    z.object({
      courseCode: z.string(),
      campusId: z.number().nullable().optional(),
      groupCode: z.string(),
    }),
  ),
});

app.post("/schedules", requireAuth, zValidator("json", saveScheduleBodySchema), async (c) => {
  const user = c.get("user")!;
  const data = c.req.valid("json");
  const academicTermId = data.academicTermId ?? data.termId;

  if (!academicTermId) {
    return c.json({ error: "academicTermId or termId is required" }, 400);
  }

  return withUserDb(c, user.id, async (client) => {
    const res = await client.query("SELECT * FROM public.save_user_schedule($1, $2, $3::jsonb)", [
      data.name,
      academicTermId,
      JSON.stringify(data.groupLookups),
    ]);

    if (res.rows.length === 0) {
      return c.json({ error: "Failed to save schedule" }, 500);
    }

    const row = res.rows[0];
    const schedule = {
      id: Number(row.id),
      name: row.name,
      academic_term_id: Number(row.academic_term_id),
      created_at: row.created_at,
      updated_at: row.updated_at,
    };

    return c.json(schedule, 201);
  });
});

const scheduleIdParamSchema = z.object({
  id: z.coerce.number(),
});

// GET /schedules/:id
app.get("/schedules/:id", requireAuth, zValidator("param", scheduleIdParamSchema), async (c) => {
  const user = c.get("user")!;
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const res = await pool.query(
      `SELECT id, name, academic_term_id, created_at, updated_at
       FROM public.saved_schedule
       WHERE id = $1 AND user_id = $2`,
      [id, user.id],
    );

    if (res.rows.length === 0) {
      return c.json({ error: "Schedule not found" }, 404);
    }

    const row = res.rows[0];
    const schedule = {
      id: Number(row.id),
      name: row.name,
      academic_term_id: Number(row.academic_term_id),
      created_at: row.created_at,
      updated_at: row.updated_at,
    };

    return c.json(schedule);
  });
});

// GET /schedules/:id/items
app.get(
  "/schedules/:id/items",
  requireAuth,
  zValidator("param", scheduleIdParamSchema),
  async (c) => {
    const user = c.get("user")!;
    const { id } = c.req.valid("param");

    return withDb(c, async (pool) => {
      const scheduleRes = await pool.query(
        "SELECT id FROM public.saved_schedule WHERE id = $1 AND user_id = $2",
        [id, user.id],
      );

      if (scheduleRes.rows.length === 0) {
        return c.json({ error: "Schedule not found" }, 404);
      }

      const res = await pool.query(
        `SELECT
           ssi.id,
           ssi.saved_schedule_id,
           ssi.course_offering_group_id,
           c.code AS course_code,
           co.campus_id,
           cog.group_code
         FROM public.saved_schedule_item ssi
         JOIN public.course_offering_group cog ON cog.id = ssi.course_offering_group_id
         JOIN public.course_offering co ON co.id = cog.course_offering_id
         JOIN public.course c ON c.id = co.course_id
         WHERE ssi.saved_schedule_id = $1
         ORDER BY ssi.id ASC`,
        [id],
      );

      const items = res.rows.map((r) => ({
        id: Number(r.id),
        saved_schedule_id: Number(r.saved_schedule_id),
        course_offering_group_id: Number(r.course_offering_group_id),
        course_code: r.course_code,
        campus_id: r.campus_id !== null ? Number(r.campus_id) : null,
        group_code: r.group_code,
      }));

      return c.json(items);
    });
  },
);

// DELETE /schedules/:id
app.delete("/schedules/:id", requireAuth, zValidator("param", scheduleIdParamSchema), async (c) => {
  const user = c.get("user")!;
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const res = await pool.query(
      "DELETE FROM public.saved_schedule WHERE id = $1 AND user_id = $2 RETURNING id",
      [id, user.id],
    );

    if (res.rowCount === 0) {
      return c.json({ error: "Schedule not found" }, 404);
    }

    return c.json({ success: true });
  });
});

export default app;
