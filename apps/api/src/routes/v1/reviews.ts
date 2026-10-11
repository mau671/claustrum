import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb } from "../../lib/db";
import { verifyTurnstileToken } from "../../lib/security";
import { optionalAuth, requireAuth, requireRole } from "../../middleware/auth";

const app = new Hono<HonoEnv>();

const REVIEW_TAGS = [
  "Tomaría su clase nuevamente",
  "Brinda apoyo",
  "Da buena retroalimentación",
  "Explica con claridad",
  "Clases excelentes",
  "Califica con rigor",
  "Muchas tareas",
  "Deja trabajos largos",
  "Exámenes retadores",
  "Muchos exámenes",
  "Pocos exámenes",
  "Asistencia obligatoria",
  "La participación importa",
  "Clases largas",
  "Requiere mucha lectura",
  "Aspectos de calificación claros",
  "Respetado por los estudiantes",
  "Inspirador",
  "Muy cómico",
  "Da crédito extra",
  "Muchos proyectos grupales",
  "Proyecto útil",
  "Clase fácil",
] as const;

const courseCodeSchema = z
  .string()
  .trim()
  .toUpperCase()
  .regex(/^[A-Z]{2,4}\d{3,4}$/);

const professorReviewSchema = z.object({
  professorId: z.string().min(1),
  courseCodes: z.array(courseCodeSchema).min(1).max(6),
  academicTermId: z.number().int().positive().nullable().optional(),
  comment: z.string().trim().min(5).max(1000),
  easeScore: z.number().min(0).max(10),
  qualityScore: z.number().min(0).max(10),
  clarityScore: z.number().min(0).max(10),
  fairnessScore: z.number().min(0).max(10),
  attendanceRequired: z.boolean(),
  gradeReceived: z.string().trim().max(32).optional().nullable(),
  engagementLevel: z.number().int().min(1).max(5),
  tags: z.array(z.enum(REVIEW_TAGS)).max(6),
  turnstileToken: z.string().min(1),
});

const professorReviewReactionSchema = z.object({
  reaction: z.enum(["like", "dislike"]).nullable(),
});

const PROFESSOR_REVIEW_REPORT_REASONS = [
  "spam",
  "ofensivo",
  "acoso",
  "datos_personales",
  "falso_enganoso",
  "otro",
] as const;

const professorReviewReportSchema = z
  .object({
    reason: z.enum(PROFESSOR_REVIEW_REPORT_REASONS),
    description: z.string().trim().max(1000).optional(),
    turnstileToken: z.string().min(1),
  })
  .superRefine((value, context) => {
    if (value.reason === "otro" && (!value.description || value.description.trim().length === 0)) {
      context.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Description is required when reason is 'otro'",
        path: ["description"],
      });
    }
  });

function isRealProfessorName(fullName: string): boolean {
  const normalized = fullName.trim().toLowerCase();
  if (normalized.length === 0) return false;
  if (/sin\s+profesor\s+asignado/i.test(fullName)) return false;
  if (/se\s+imparte\s+en\s+idioma\s+ingles/i.test(fullName)) return false;
  return true;
}

// GET /reviews
const listReviewsQuerySchema = z.object({
  professorId: z.string(),
  limit: z.coerce.number().default(20),
  offset: z.coerce.number().default(0),
});

app.get("/reviews", optionalAuth, zValidator("query", listReviewsQuerySchema), async (c) => {
  const { professorId, limit, offset } = c.req.valid("query");
  const user = c.get("user");

  return withDb(c, async (pool) => {
    const client = await pool.connect();
    try {
      if (user?.id) {
        await client.query("SELECT set_config('request.jwt.claims', $1, true)", [
          JSON.stringify({ sub: user.id }),
        ]);
      }

      const res = await client.query(
        "SELECT * FROM public.get_professor_reviews_public($1, $2, $3)",
        [professorId, limit, offset],
      );

      const rows = res.rows.map((r) => ({
        review_id: Number(r.review_id),
        professor_id: r.professor_id,
        courses: r.courses ?? [],
        comment: r.comment,
        ease_score: Number(r.ease_score),
        quality_score: Number(r.quality_score),
        clarity_score: Number(r.clarity_score),
        fairness_score: Number(r.fairness_score),
        attendance_required: r.attendance_required,
        grade_received: r.grade_received,
        engagement_level: r.engagement_level,
        tags: r.tags ?? [],
        status: r.status,
        created_at: r.created_at,
        like_count: Number(r.like_count ?? 0),
        dislike_count: Number(r.dislike_count ?? 0),
        my_reaction: r.my_reaction ?? null,
        total_count: Number(r.total_count ?? 0),
      }));

      return c.json(rows);
    } finally {
      client.release();
    }
  });
});

// POST /reviews
app.post("/reviews", requireAuth, zValidator("json", professorReviewSchema), async (c) => {
  const data = c.req.valid("json");

  if (!c.env.TURNSTILE_SECRET_KEY) {
    return c.json({ error: "Missing Turnstile secret configuration" }, 500);
  }

  const isHuman = await verifyTurnstileToken(
    data.turnstileToken,
    c.env,
    c.req.header("cf-connecting-ip") ?? null,
  );
  if (!isHuman) {
    return c.json({ error: "Invalid anti-spam token" }, 400);
  }

  return withDb(c, async (pool) => {
    const client = await pool.connect();
    try {
      await client.query("BEGIN");

      // Verify courses exist
      const coursesRes = await client.query(
        "SELECT id, code FROM public.course WHERE code = ANY($1::text[])",
        [data.courseCodes],
      );
      if (coursesRes.rows.length !== data.courseCodes.length) {
        await client.query("ROLLBACK");
        return c.json({ error: "One or more course codes do not exist" }, 400);
      }

      // Verify professor exists
      const profRes = await client.query(
        "SELECT id, full_name FROM public.professor WHERE id::text = $1",
        [data.professorId],
      );
      if (profRes.rows.length === 0) {
        await client.query("ROLLBACK");
        return c.json({ error: "Professor does not exist" }, 400);
      }

      const professor = profRes.rows[0];
      if (!isRealProfessorName(professor.full_name)) {
        await client.query("ROLLBACK");
        return c.json({ error: "Professor is not eligible for reviews" }, 400);
      }

      // If academicTermId provided, verify professor taught during that term
      if (data.academicTermId) {
        const termCheckRes = await client.query(
          `SELECT 1
           FROM public.course_offering_group_professor cogp
           JOIN public.course_offering_group cog ON cog.id = cogp.course_offering_group_id
           JOIN public.course_offering co ON co.id = cog.course_offering_id
           WHERE cogp.professor_id::text = $1
             AND co.academic_term_id = $2
           LIMIT 1`,
          [data.professorId, data.academicTermId],
        );
        if (termCheckRes.rows.length === 0) {
          await client.query("ROLLBACK");
          return c.json({ error: "Professor has no offering records for that academic term" }, 400);
        }
      }

      // Insert review
      const insertReviewRes = await client.query(
        `INSERT INTO public.professor_review (
           professor_id, academic_term_id, comment, ease_score, quality_score,
           clarity_score, fairness_score, attendance_required, grade_received,
           engagement_level, tags, status
         ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, 'pending')
         RETURNING id, status, created_at`,
        [
          data.professorId,
          data.academicTermId ?? null,
          data.comment,
          data.easeScore,
          data.qualityScore,
          data.clarityScore,
          data.fairnessScore,
          data.attendanceRequired,
          data.gradeReceived ?? null,
          data.engagementLevel,
          data.tags,
        ],
      );

      const insertedReview = insertReviewRes.rows[0];

      // Insert review courses
      for (const course of coursesRes.rows) {
        await client.query(
          "INSERT INTO public.professor_review_course (review_id, course_id) VALUES ($1, $2)",
          [insertedReview.id, course.id],
        );
      }

      await client.query("COMMIT");
      return c.json({ success: true, review: insertedReview }, 201);
    } catch (error) {
      await client.query("ROLLBACK").catch(() => {});
      throw error;
    } finally {
      client.release();
    }
  });
});

const reviewIdParamSchema = z.object({
  id: z.coerce.number(),
});

// GET /reviews/:id
app.get("/reviews/:id", zValidator("param", reviewIdParamSchema), async (c) => {
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const res = await pool.query(
      `WITH review_courses AS (
         SELECT
           prc.review_id,
           jsonb_agg(
             jsonb_build_object('id', c.id, 'code', c.code, 'name', c.name)
             ORDER BY c.code, c.name, c.id
           ) AS courses
         FROM public.professor_review_course prc
         JOIN public.course c ON c.id = prc.course_id
         WHERE prc.review_id = $1
         GROUP BY prc.review_id
       )
       SELECT
         pr.id AS review_id,
         pr.professor_id,
         p.full_name AS professor_name,
         COALESCE(rc.courses, '[]'::jsonb) AS courses,
         pr.comment,
         pr.ease_score,
         pr.quality_score,
         pr.clarity_score,
         pr.fairness_score,
         pr.attendance_required,
         pr.grade_received,
         pr.engagement_level,
         pr.tags,
         pr.status,
         pr.created_at,
         pr.reviewed_at,
         pr.moderation_note
       FROM public.professor_review pr
       JOIN public.professor p ON p.id = pr.professor_id
       LEFT JOIN review_courses rc ON rc.review_id = pr.id
       WHERE pr.id = $1`,
      [id],
    );

    if (res.rows.length === 0) {
      return c.json({ error: "Review not found" }, 404);
    }

    const r = res.rows[0];
    return c.json({
      review_id: Number(r.review_id),
      professor_id: r.professor_id,
      professor_name: r.professor_name,
      courses: r.courses ?? [],
      comment: r.comment,
      ease_score: Number(r.ease_score),
      quality_score: Number(r.quality_score),
      clarity_score: Number(r.clarity_score),
      fairness_score: Number(r.fairness_score),
      attendance_required: r.attendance_required,
      grade_received: r.grade_received,
      engagement_level: r.engagement_level,
      tags: r.tags ?? [],
      status: r.status,
      created_at: r.created_at,
      reviewed_at: r.reviewed_at,
      moderation_note: r.moderation_note,
    });
  });
});

// PATCH /reviews/:id (admin & moderator)
const moderateReviewBodySchema = z.object({
  status: z.enum(["approved", "rejected"]),
  reason: z.string().optional().nullable(),
});

app.patch(
  "/reviews/:id",
  requireAuth,
  requireRole(["admin", "moderator"]),
  zValidator("param", reviewIdParamSchema),
  zValidator("json", moderateReviewBodySchema),
  async (c) => {
    const user = c.get("user")!;
    const { id } = c.req.valid("param");
    const { status, reason } = c.req.valid("json");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `UPDATE public.professor_review
         SET status = $1,
             moderation_note = $2,
             reviewed_by = $3,
             reviewed_at = NOW()
         WHERE id = $4
         RETURNING id, status`,
        [status, reason ?? null, user.id, id],
      );

      if (res.rowCount === 0) {
        return c.json({ error: "Review not found" }, 404);
      }

      return c.json({ success: true, review: res.rows[0] });
    });
  },
);

// DELETE /reviews/:id (admin only or author)
app.delete("/reviews/:id", requireAuth, zValidator("param", reviewIdParamSchema), async (c) => {
  const user = c.get("user")!;
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    // Admin can delete any review
    if (user.role === "admin") {
      const res = await pool.query(
        "DELETE FROM public.professor_review WHERE id = $1 RETURNING id",
        [id],
      );
      if (res.rowCount === 0) {
        return c.json({ error: "Review not found" }, 404);
      }
      return c.json({ success: true });
    }

    return c.json({ error: "No autorizado para eliminar esta reseña" }, 403);
  });
});

// POST /reviews/:id/reactions
app.post(
  "/reviews/:id/reactions",
  requireAuth,
  zValidator("param", reviewIdParamSchema),
  zValidator("json", professorReviewReactionSchema),
  async (c) => {
    const user = c.get("user")!;
    const { id } = c.req.valid("param");
    const { reaction } = c.req.valid("json");

    return withDb(c, async (pool) => {
      const reviewRes = await pool.query(
        "SELECT id FROM public.professor_review WHERE id = $1 AND status = 'approved'",
        [id],
      );

      if (reviewRes.rows.length === 0) {
        return c.json({ error: "Review not found" }, 404);
      }

      if (reaction === null) {
        await pool.query(
          "DELETE FROM public.professor_review_reaction WHERE review_id = $1 AND user_id = $2",
          [id, user.id],
        );
      } else {
        await pool.query(
          `INSERT INTO public.professor_review_reaction (review_id, user_id, reaction)
           VALUES ($1, $2, $3)
           ON CONFLICT (review_id, user_id)
           DO UPDATE SET reaction = EXCLUDED.reaction`,
          [id, user.id, reaction],
        );
      }

      const countsRes = await pool.query(
        `SELECT
           COUNT(*) FILTER (WHERE reaction = 'like')::bigint AS like_count,
           COUNT(*) FILTER (WHERE reaction = 'dislike')::bigint AS dislike_count
         FROM public.professor_review_reaction
         WHERE review_id = $1`,
        [id],
      );

      const likeCount = Number(countsRes.rows[0]?.like_count ?? 0);
      const dislikeCount = Number(countsRes.rows[0]?.dislike_count ?? 0);

      return c.json({
        success: true,
        reaction,
        likeCount,
        dislikeCount,
      });
    });
  },
);

// POST /reviews/:id/reports
app.post(
  "/reviews/:id/reports",
  requireAuth,
  zValidator("param", reviewIdParamSchema),
  zValidator("json", professorReviewReportSchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const data = c.req.valid("json");

    if (!c.env.TURNSTILE_SECRET_KEY) {
      return c.json({ error: "Missing Turnstile secret configuration" }, 500);
    }

    const isHuman = await verifyTurnstileToken(
      data.turnstileToken,
      c.env,
      c.req.header("cf-connecting-ip") ?? null,
    );
    if (!isHuman) {
      return c.json({ error: "Invalid anti-spam token" }, 400);
    }

    return withDb(c, async (pool) => {
      const reviewRes = await pool.query(
        "SELECT id FROM public.professor_review WHERE id = $1 AND status = 'approved'",
        [id],
      );

      if (reviewRes.rows.length === 0) {
        return c.json({ error: "Review not found" }, 404);
      }

      const res = await pool.query(
        `INSERT INTO public.professor_review_report (review_id, reason, description, status)
         VALUES ($1, $2, $3, 'pending')
         RETURNING id, review_id, status, created_at`,
        [id, data.reason, data.description?.trim() || null],
      );

      return c.json({ success: true, report: res.rows[0] }, 201);
    });
  },
);

export default app;
