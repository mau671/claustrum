import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb } from "../../lib/db";
import { verifyTurnstileToken } from "../../lib/security";
import { optionalAuth, requireAuth, requireRole } from "../../middleware/auth";

const app = new Hono<HonoEnv>();

const uploadPayloadSchema = z
  .object({
    courseId: z.number().int().positive(),
    academicTermId: z.number().int().positive().nullable(),
    professorId: z.number().int().positive().nullable(),
    evaluationType: z.enum(["parcial", "quiz", "final", "reposicion", "tarea", "proyecto", "otro"]),
    evaluationNumber: z.number().int().positive().nullable(),
    customName: z.string().trim().max(128).nullable(),
    isCatedra: z.boolean(),
    includesAnswers: z.boolean(),
    hasSeparateAnswers: z.boolean(),
    turnstileToken: z.string().trim().min(1),
  })
  .superRefine((payload, ctx) => {
    const requiresNumber = ["parcial", "quiz", "reposicion", "tarea", "proyecto"] as const;

    if (payload.evaluationType === "otro") {
      if (!payload.customName || payload.customName.trim() === "") {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["customName"],
          message: "customName es requerido cuando evaluationType es 'otro'",
        });
      }
    } else if (payload.customName !== null) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["customName"],
        message: "customName solo se permite cuando evaluationType es 'otro'",
      });
    }

    if (requiresNumber.includes(payload.evaluationType) && payload.evaluationNumber === null) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["evaluationNumber"],
        message: "evaluationNumber es requerido para este tipo de evaluacion",
      });
    }

    if (!requiresNumber.includes(payload.evaluationType) && payload.evaluationNumber !== null) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["evaluationNumber"],
        message: "evaluationNumber no aplica para este tipo de evaluacion",
      });
    }
  });

function formatFileName(
  courseCode: string | null,
  evaluationType: string | null,
  evaluationNumber: number | null,
  customName: string | null,
): string {
  if (evaluationType === "otro" && customName && customName.trim() !== "") {
    return `${courseCode ?? "evaluacion"}-${customName.trim()}.pdf`;
  }

  if (!evaluationType) return `${courseCode ?? "evaluacion"}.pdf`;

  const base = `${courseCode ?? "evaluacion"}-${evaluationType.toUpperCase()}`;
  if (evaluationNumber && evaluationNumber > 0) {
    return `${base}-${evaluationNumber}.pdf`;
  }
  return `${base}.pdf`;
}

function parseNullableNumber(value: FormDataEntryValue | null): number | null {
  if (typeof value !== "string" || value.trim() === "") return null;
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : Number.NaN;
}

function parseBooleanField(value: FormDataEntryValue | null): boolean {
  return value === "true";
}

// GET /evaluations
const getEvaluationsQuerySchema = z.object({
  courseId: z.coerce.number(),
  studyPlanId: z.coerce.number().optional(),
});

app.get("/evaluations", zValidator("query", getEvaluationsQuerySchema), async (c) => {
  const { courseId, studyPlanId } = c.req.valid("query");

  return withDb(c, async (pool) => {
    const res = await pool.query(
      `WITH target_courses AS (
         SELECT $1::bigint AS course_id
         UNION
         SELECT rel.course_id
         FROM public.get_course_detail_related_courses($2::bigint, $1::bigint) rel
         WHERE $2::bigint IS NOT NULL
       )
       SELECT
         e.id,
         e.course_id,
         c.code AS course_code,
         c.name AS course_name,
         e.academic_term_id,
         e.professor_id,
         e.evaluation_type::TEXT,
         e.evaluation_number,
         e.custom_name,
         e.is_catedra,
         e.includes_answers,
         e.has_separate_answers,
         e.file_key,
         e.file_size,
         e.answers_file_key,
         e.status::TEXT,
         e.created_at,
         at.display_name AS term_display_name,
         p.full_name AS professor_name
       FROM public.course_evaluations e
       JOIN public.course c ON c.id = e.course_id
       LEFT JOIN public.academic_term at ON at.id = e.academic_term_id
       LEFT JOIN public.professor p ON p.id = e.professor_id
       WHERE e.course_id IN (SELECT course_id FROM target_courses)
         AND e.status = 'approved'
       ORDER BY e.evaluation_type, e.evaluation_number NULLS LAST`,
      [courseId, studyPlanId ?? null],
    );

    const rows = res.rows.map((r) => ({
      id: Number(r.id),
      course_id: Number(r.course_id),
      course_code: r.course_code,
      course_name: r.course_name,
      academic_term_id: r.academic_term_id !== null ? Number(r.academic_term_id) : null,
      professor_id: r.professor_id !== null ? Number(r.professor_id) : null,
      evaluation_type: r.evaluation_type,
      evaluation_number: r.evaluation_number !== null ? Number(r.evaluation_number) : null,
      custom_name: r.custom_name ?? null,
      is_catedra: Boolean(r.is_catedra),
      includes_answers: Boolean(r.includes_answers),
      has_separate_answers: Boolean(r.has_separate_answers),
      file_key: r.file_key,
      file_size: Number(r.file_size),
      answers_file_key: r.answers_file_key ?? null,
      status: r.status,
      created_at: r.created_at,
      term_display_name: r.term_display_name ?? null,
      professor_name: r.professor_name ?? null,
    }));

    return c.json(rows);
  });
});

// POST /evaluations
app.post("/evaluations", requireAuth, async (c) => {
  const request = c.req.raw;
  let formData: FormData;
  try {
    formData = await request.formData();
  } catch {
    return c.json({ error: "Invalid form data" }, 400);
  }

  const evaluationFile = formData.get("evaluationFile");
  const answersFile = formData.get("answersFile");

  if (!(evaluationFile instanceof File) || evaluationFile.type !== "application/pdf") {
    return c.json({ error: "Se requiere un archivo PDF valido" }, 400);
  }

  if (evaluationFile.size > 10 * 1024 * 1024) {
    return c.json({ error: "El archivo excede el limite de 10 MB" }, 400);
  }

  const parsed = uploadPayloadSchema.safeParse({
    courseId: parseNullableNumber(formData.get("courseId")),
    academicTermId: parseNullableNumber(formData.get("academicTermId")),
    professorId: parseNullableNumber(formData.get("professorId")),
    evaluationType: formData.get("evaluationType"),
    evaluationNumber: parseNullableNumber(formData.get("evaluationNumber")),
    customName: typeof formData.get("customName") === "string" ? formData.get("customName") : null,
    isCatedra: parseBooleanField(formData.get("isCatedra")),
    includesAnswers: parseBooleanField(formData.get("includesAnswers")),
    hasSeparateAnswers: parseBooleanField(formData.get("hasSeparateAnswers")),
    turnstileToken: formData.get("turnstileToken"),
  });

  if (!parsed.success) {
    return c.json({ error: "Payload de evaluacion invalido", details: parsed.error.issues }, 400);
  }

  const payload = parsed.data;

  if (!c.env.TURNSTILE_SECRET_KEY) {
    return c.json({ error: "Turnstile no esta configurado en el servidor" }, 500);
  }

  const remoteIp = request.headers.get("CF-Connecting-IP");
  const isHuman = await verifyTurnstileToken(payload.turnstileToken, c.env, remoteIp);
  if (!isHuman) {
    return c.json({ error: "No se pudo verificar el captcha" }, 400);
  }

  if (payload.hasSeparateAnswers && !(answersFile instanceof File)) {
    return c.json({ error: "Debes adjuntar el archivo de respuestas" }, 400);
  }

  if (answersFile instanceof File) {
    if (answersFile.type !== "application/pdf") {
      return c.json({ error: "El archivo de respuestas debe ser PDF" }, 400);
    }
    if (answersFile.size > 10 * 1024 * 1024) {
      return c.json({ error: "El archivo de respuestas excede el limite de 10 MB" }, 400);
    }
  }

  const fileSha256 = formData.get("fileSha256");
  const answersFileSha256 = formData.get("answersFileSha256");

  const fileKey = `evaluations/${payload.courseId}/${crypto.randomUUID()}.pdf`;
  let answersKey: string | null = null;

  try {
    await c.env.EVALUATIONS_BUCKET.put(fileKey, evaluationFile.stream(), {
      httpMetadata: { contentType: "application/pdf" },
    });

    if (payload.hasSeparateAnswers && answersFile instanceof File) {
      answersKey = `evaluations/${payload.courseId}/${crypto.randomUUID()}_answers.pdf`;
      await c.env.EVALUATIONS_BUCKET.put(answersKey, answersFile.stream(), {
        httpMetadata: { contentType: "application/pdf" },
      });
    }

    return await withDb(c, async (pool) => {
      await pool.query(
        `INSERT INTO public.course_evaluations (
           course_id, academic_term_id, professor_id, evaluation_type, evaluation_number,
           custom_name, is_catedra, includes_answers, has_separate_answers,
           file_key, file_size, file_sha256, answers_file_key, answers_file_size, answers_file_sha256,
           status
         ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, 'pending')`,
        [
          payload.courseId,
          payload.academicTermId,
          payload.professorId,
          payload.evaluationType,
          payload.evaluationNumber,
          payload.customName,
          payload.isCatedra,
          payload.includesAnswers,
          payload.hasSeparateAnswers,
          fileKey,
          evaluationFile.size,
          typeof fileSha256 === "string" ? fileSha256 : "",
          answersKey,
          answersFile instanceof File ? answersFile.size : null,
          typeof answersFileSha256 === "string" ? answersFileSha256 : null,
        ],
      );

      return c.json({ success: true, message: "Evaluacion subida correctamente" }, 201);
    });
  } catch (error) {
    await c.env.EVALUATIONS_BUCKET.delete(fileKey).catch(() => {});
    if (answersKey) {
      await c.env.EVALUATIONS_BUCKET.delete(answersKey).catch(() => {});
    }
    throw error;
  }
});

const evaluationIdParamSchema = z.object({
  id: z.coerce.number(),
});

// GET /evaluations/:id
app.get("/evaluations/:id", zValidator("param", evaluationIdParamSchema), async (c) => {
  const { id } = c.req.valid("param");

  return withDb(c, async (pool) => {
    const res = await pool.query(
      `SELECT
         e.id,
         e.course_id,
         c.code AS course_code,
         c.name AS course_name,
         e.academic_term_id,
         at.display_name AS term_display_name,
         e.professor_id,
         p.full_name AS professor_name,
         e.evaluation_type::TEXT,
         e.evaluation_number,
         e.custom_name,
         e.is_catedra,
         e.includes_answers,
         e.has_separate_answers,
         e.file_key,
         e.file_size,
         e.answers_file_key,
         e.status::TEXT,
         e.moderation_note,
         e.created_at
       FROM public.course_evaluations e
       JOIN public.course c ON c.id = e.course_id
       LEFT JOIN public.academic_term at ON at.id = e.academic_term_id
       LEFT JOIN public.professor p ON p.id = e.professor_id
       WHERE e.id = $1`,
      [id],
    );

    if (res.rows.length === 0) {
      return c.json({ error: "Evaluacion no encontrada" }, 404);
    }

    const r = res.rows[0];
    return c.json({
      id: Number(r.id),
      course_id: Number(r.course_id),
      course_code: r.course_code,
      course_name: r.course_name,
      academic_term_id: r.academic_term_id !== null ? Number(r.academic_term_id) : null,
      term_display_name: r.term_display_name ?? null,
      professor_id: r.professor_id !== null ? Number(r.professor_id) : null,
      professor_name: r.professor_name ?? null,
      evaluation_type: r.evaluation_type,
      evaluation_number: r.evaluation_number !== null ? Number(r.evaluation_number) : null,
      custom_name: r.custom_name ?? null,
      is_catedra: Boolean(r.is_catedra),
      includes_answers: Boolean(r.includes_answers),
      has_separate_answers: Boolean(r.has_separate_answers),
      file_key: r.file_key,
      file_size: Number(r.file_size),
      answers_file_key: r.answers_file_key ?? null,
      status: r.status,
      moderation_note: r.moderation_note ?? null,
      created_at: r.created_at,
    });
  });
});

// GET /evaluations/:id/file
app.get(
  "/evaluations/:id/file",
  optionalAuth,
  zValidator("param", evaluationIdParamSchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const user = c.get("user");

    const evaluation = await withDb(c, async (pool) => {
      const res = await pool.query(
        `SELECT e.id, e.status, e.file_key, e.evaluation_type, e.evaluation_number, e.custom_name, c.code AS course_code
         FROM public.course_evaluations e
         JOIN public.course c ON c.id = e.course_id
         WHERE e.id = $1`,
        [id],
      );
      return res.rows[0] || null;
    });

    if (!evaluation) {
      return c.json({ error: "Evaluacion no encontrada" }, 404);
    }

    if (evaluation.status !== "approved") {
      if (!user) {
        return c.json({ error: "No autorizado" }, 401);
      }
      const userRole = user.role ?? "user";
      if (!["admin", "moderator"].includes(userRole)) {
        return c.json({ error: "Acceso denegado" }, 403);
      }
    }

    const object = await c.env.EVALUATIONS_BUCKET.get(evaluation.file_key);
    if (!object) {
      return c.json({ error: "Archivo no encontrado" }, 404);
    }

    const fileName = formatFileName(
      evaluation.course_code,
      evaluation.evaluation_type,
      evaluation.evaluation_number !== null ? Number(evaluation.evaluation_number) : null,
      evaluation.custom_name,
    );

    return new Response(object.body, {
      status: 200,
      headers: {
        "Content-Type": "application/pdf",
        "Content-Length": String(object.size),
        "Content-Disposition": `inline; filename="${fileName}"`,
        "Cache-Control": "private, max-age=3600",
      },
    });
  },
);

// GET /evaluations/:id/answers
app.get(
  "/evaluations/:id/answers",
  optionalAuth,
  zValidator("param", evaluationIdParamSchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const user = c.get("user");

    const evaluation = await withDb(c, async (pool) => {
      const res = await pool.query(
        `SELECT e.id, e.status, e.answers_file_key, e.evaluation_type, e.evaluation_number, e.custom_name, c.code AS course_code
         FROM public.course_evaluations e
         JOIN public.course c ON c.id = e.course_id
         WHERE e.id = $1`,
        [id],
      );
      return res.rows[0] || null;
    });

    if (!evaluation) {
      return c.json({ error: "Evaluacion no encontrada" }, 404);
    }

    if (!evaluation.answers_file_key) {
      return c.json({ error: "Esta evaluación no tiene archivo de respuestas" }, 404);
    }

    if (evaluation.status !== "approved") {
      if (!user) {
        return c.json({ error: "No autorizado" }, 401);
      }
      const userRole = user.role ?? "user";
      if (!["admin", "moderator"].includes(userRole)) {
        return c.json({ error: "Acceso denegado" }, 403);
      }
    }

    const object = await c.env.EVALUATIONS_BUCKET.get(evaluation.answers_file_key);
    if (!object) {
      return c.json({ error: "Archivo de respuestas no encontrado" }, 404);
    }

    const baseName = formatFileName(
      evaluation.course_code,
      evaluation.evaluation_type,
      evaluation.evaluation_number !== null ? Number(evaluation.evaluation_number) : null,
      evaluation.custom_name,
    );
    const fileName = baseName.replace(".pdf", "-respuestas.pdf");

    return new Response(object.body, {
      status: 200,
      headers: {
        "Content-Type": "application/pdf",
        "Content-Length": String(object.size),
        "Content-Disposition": `inline; filename="${fileName}"`,
        "Cache-Control": "private, max-age=3600",
      },
    });
  },
);

// PATCH /evaluations/:id (admin & moderator)
const moderateEvaluationSchema = z.object({
  status: z.enum(["approved", "rejected"]),
  note: z.string().optional().nullable(),
});

app.patch(
  "/evaluations/:id",
  requireAuth,
  requireRole(["admin", "moderator"]),
  zValidator("param", evaluationIdParamSchema),
  zValidator("json", moderateEvaluationSchema),
  async (c) => {
    const user = c.get("user")!;
    const { id } = c.req.valid("param");
    const { status, note } = c.req.valid("json");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `UPDATE public.course_evaluations
         SET status = $1,
             moderation_note = $2,
             moderated_by = $3,
             moderated_at = NOW(),
             updated_at = NOW()
         WHERE id = $4
         RETURNING id, status`,
        [status, note ?? null, user.id, id],
      );

      if (res.rowCount === 0) {
        return c.json({ error: "Evaluacion no encontrada" }, 404);
      }

      return c.json({ success: true, evaluation: res.rows[0] });
    });
  },
);

// DELETE /evaluations/:id (admin only)
app.delete(
  "/evaluations/:id",
  requireAuth,
  requireRole("admin"),
  zValidator("param", evaluationIdParamSchema),
  async (c) => {
    const { id } = c.req.valid("param");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        "SELECT file_key, answers_file_key FROM public.course_evaluations WHERE id = $1",
        [id],
      );

      if (res.rows.length === 0) {
        return c.json({ error: "Evaluacion no encontrada" }, 404);
      }

      const { file_key, answers_file_key } = res.rows[0];

      if (file_key) {
        await c.env.EVALUATIONS_BUCKET.delete(file_key).catch(() => {});
      }
      if (answers_file_key) {
        await c.env.EVALUATIONS_BUCKET.delete(answers_file_key).catch(() => {});
      }

      await pool.query("DELETE FROM public.course_evaluations WHERE id = $1", [id]);
      return c.json({ success: true });
    });
  },
);

export default app;
