import { Hono } from "hono";
import { z } from "zod";

import type { Env } from "../types";

import { fail, ok } from "../lib/http";
import { isAdmin, verifyAuth, verifyTurnstileToken } from "../lib/security";
import { getSupabaseAdmin } from "../lib/supabase";

const evaluationsRoutes = new Hono<{ Bindings: Env }>();

const uploadPayloadSchema = z
  .object({
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

evaluationsRoutes.post("/courses/:courseId/evaluations", async (c) => {
  const courseIdParam = c.req.param("courseId");
  const courseId = Number(courseIdParam);
  if (!courseId || Number.isNaN(courseId)) {
    return fail(400, "courseId invalido", c.req.raw, c.env);
  }

  const request = c.req.raw;
  const formData = await request.formData();

  const evaluationFile = formData.get("evaluationFile");
  const answersFile = formData.get("answersFile");

  if (!(evaluationFile instanceof File) || evaluationFile.type !== "application/pdf") {
    return fail(400, "Se requiere un archivo PDF valido", request, c.env);
  }

  if (evaluationFile.size > 10 * 1024 * 1024) {
    return fail(400, "El archivo excede el limite de 10 MB", request, c.env);
  }

  const payloadResult = uploadPayloadSchema.safeParse({
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

  if (!payloadResult.success) {
    return fail(400, "Payload de evaluacion invalido", request, c.env);
  }

  const payload = payloadResult.data;

  if (!c.env.TURNSTILE_SECRET_KEY) {
    return fail(500, "Turnstile no esta configurado en el servidor", request, c.env);
  }

  const remoteIp = request.headers.get("CF-Connecting-IP");
  const isHuman = await verifyTurnstileToken(payload.turnstileToken, c.env, remoteIp);
  if (!isHuman) {
    return fail(400, "No se pudo verificar el captcha", request, c.env);
  }

  if (payload.hasSeparateAnswers && !(answersFile instanceof File)) {
    return fail(400, "Debes adjuntar el archivo de respuestas", request, c.env);
  }

  if (answersFile instanceof File) {
    if (answersFile.type !== "application/pdf") {
      return fail(400, "El archivo de respuestas debe ser PDF", request, c.env);
    }
    if (answersFile.size > 10 * 1024 * 1024) {
      return fail(400, "El archivo de respuestas excede el limite de 10 MB", request, c.env);
    }
  }

  const fileSha256 = formData.get("fileSha256");
  const answersFileSha256 = formData.get("answersFileSha256");

  const fileKey = `evaluations/${courseId}/${crypto.randomUUID()}.pdf`;
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

    const supabase = getSupabaseAdmin(c.env);
    const { error: dbError } = await supabase.from("course_evaluations").insert({
      course_id: courseId,
      academic_term_id: payload.academicTermId,
      professor_id: payload.professorId,
      evaluation_type: payload.evaluationType,
      evaluation_number: payload.evaluationNumber,
      custom_name: payload.customName,
      is_catedra: payload.isCatedra,
      includes_answers: payload.includesAnswers,
      has_separate_answers: payload.hasSeparateAnswers,
      file_key: fileKey,
      file_size: evaluationFile.size,
      file_sha256: typeof fileSha256 === "string" && fileSha256 !== "" ? fileSha256 : "",
      answers_file_key: answersKey,
      answers_file_size: answersFile instanceof File ? answersFile.size : null,
      answers_file_sha256:
        typeof answersFileSha256 === "string" && answersFileSha256 !== ""
          ? answersFileSha256
          : null,
      status: "pending",
    });

    if (dbError) throw dbError;
  } catch (error) {
    await c.env.EVALUATIONS_BUCKET.delete(fileKey).catch(() => {});
    if (answersKey) {
      await c.env.EVALUATIONS_BUCKET.delete(answersKey).catch(() => {});
    }
    throw error;
  }

  return ok({ success: true, message: "Evaluacion subida correctamente" }, request, c.env);
});

evaluationsRoutes.get("/evaluations/:evaluationId/file", async (c) => {
  const request = c.req.raw;
  const evaluationId = c.req.param("evaluationId");
  if (!/^\d+$/.test(evaluationId)) {
    return fail(400, "ID de evaluacion invalido", request, c.env);
  }

  const supabase = getSupabaseAdmin(c.env);
  const { data: evaluation, error } = await supabase
    .from("course_evaluations")
    .select(
      "id, status, file_key, evaluation_type, evaluation_number, custom_name, course:course_id!inner(code)",
    )
    .eq("id", Number(evaluationId))
    .single();

  if (error || !evaluation) return fail(404, "Evaluacion no encontrada", request, c.env);

  if (evaluation.status !== "approved") {
    const authResult = await verifyAuth(request, c.env);
    if (!authResult) {
      return fail(401, "Unauthorized", request, c.env);
    }
    const { userId } = authResult;

    const admin = await isAdmin(userId, c.env);
    if (!admin) return fail(403, "No tienes acceso a esta evaluacion", request, c.env);
  }

  const object = await c.env.EVALUATIONS_BUCKET.get(evaluation.file_key);
  if (!object) return fail(404, "Archivo no encontrado", request, c.env);

  const courseCode = (evaluation.course as { code: string } | null)?.code ?? null;
  const fileName = formatFileName(
    courseCode,
    evaluation.evaluation_type,
    evaluation.evaluation_number,
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
});

evaluationsRoutes.get("/evaluations/:evaluationId/answers-file", async (c) => {
  const request = c.req.raw;
  const evaluationId = c.req.param("evaluationId");
  if (!/^\d+$/.test(evaluationId)) {
    return fail(400, "ID de evaluacion invalido", request, c.env);
  }

  const supabase = getSupabaseAdmin(c.env);
  const { data: evaluation, error } = await supabase
    .from("course_evaluations")
    .select(
      "id, status, answers_file_key, evaluation_type, evaluation_number, custom_name, course:course_id!inner(code)",
    )
    .eq("id", Number(evaluationId))
    .single();

  if (error || !evaluation) return fail(404, "Evaluacion no encontrada", request, c.env);
  if (!evaluation.answers_file_key)
    return fail(404, "Esta evaluación no tiene archivo de respuestas", request, c.env);

  if (evaluation.status !== "approved") {
    const authResult = await verifyAuth(request, c.env);
    if (!authResult) {
      return fail(401, "Unauthorized", request, c.env);
    }
    const { userId } = authResult;

    const admin = await isAdmin(userId, c.env);
    if (!admin) return fail(403, "No tienes acceso a esta evaluacion", request, c.env);
  }

  const object = await c.env.EVALUATIONS_BUCKET.get(evaluation.answers_file_key);
  if (!object) return fail(404, "Archivo de respuestas no encontrado", request, c.env);

  const courseCode = (evaluation.course as { code: string } | null)?.code ?? null;
  const baseName = formatFileName(
    courseCode,
    evaluation.evaluation_type,
    evaluation.evaluation_number,
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
});
export default evaluationsRoutes;
