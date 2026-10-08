import type {
  EvaluationRow,
  EvaluationModerationRow,
  EvaluationStatus,
  UploadEvaluationPayload,
} from "@/lib/evaluations/types";

import { authClient } from "@/lib/auth/client";
import { getApiBaseUrl } from "@/lib/env/public";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser-client";

async function sha256File(file: File): Promise<string> {
  const buffer = await file.arrayBuffer();
  const hashBuffer = await crypto.subtle.digest("SHA-256", buffer);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map((b) => b.toString(16).padStart(2, "0")).join("");
}

export async function getCourseEvaluations(
  courseId: number,
  studyPlanId: number | null,
): Promise<EvaluationRow[]> {
  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase.rpc("get_course_evaluations", {
    p_course_id: courseId,
    p_study_plan_id: studyPlanId,
  });
  if (error) throw error;
  return (data ?? []) as EvaluationRow[];
}

export async function getEvaluationModerationQueue(
  status: EvaluationStatus,
  limit: number,
  offset: number,
): Promise<EvaluationModerationRow[]> {
  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase.rpc("get_evaluation_moderation_queue", {
    p_status: status,
    p_limit: limit,
    p_offset: offset,
  });
  if (error) throw error;
  return (data ?? []) as EvaluationModerationRow[];
}

export async function uploadEvaluation(payload: UploadEvaluationPayload): Promise<void> {
  const apiBaseUrl = getApiBaseUrl();
  if (!apiBaseUrl) {
    throw new Error("API Worker URL no configurado");
  }

  const [fileSha256, answersFileSha256] = await Promise.all([
    sha256File(payload.evaluationFile),
    payload.answersFile ? sha256File(payload.answersFile) : Promise.resolve(""),
  ]);

  const formData = new FormData();
  formData.append("evaluationFile", payload.evaluationFile);
  if (payload.answersFile) {
    formData.append("answersFile", payload.answersFile);
  }
  if (payload.academicTermId) {
    formData.append("academicTermId", String(payload.academicTermId));
  }
  if (payload.professorId) {
    formData.append("professorId", String(payload.professorId));
  }
  formData.append("evaluationType", payload.evaluationType);
  if (payload.evaluationNumber) {
    formData.append("evaluationNumber", String(payload.evaluationNumber));
  }
  if (payload.customName) {
    formData.append("customName", payload.customName);
  }
  formData.append("isCatedra", String(payload.isCatedra));
  formData.append("includesAnswers", String(payload.includesAnswers));
  formData.append("hasSeparateAnswers", String(payload.hasSeparateAnswers));
  formData.append("turnstileToken", payload.turnstileToken);
  formData.append("fileSha256", fileSha256);
  if (payload.answersFile) {
    formData.append("answersFileSha256", answersFileSha256);
  }

  const response = await fetch(`${apiBaseUrl}/courses/${payload.courseId}/evaluations`, {
    method: "POST",
    body: formData,
  });

  if (!response.ok) {
    const body = await response.json().catch(() => ({ error: "Error desconocido" }));
    throw new Error(body.error ?? `Error ${response.status}`);
  }
}

export async function getEvaluationDocument(
  evaluationId: number,
): Promise<{ blob: Blob; fileName: string }> {
  const apiBaseUrl = getApiBaseUrl();
  if (!apiBaseUrl) {
    throw new Error("API Worker URL no configurado");
  }

  const { data: tokenData } = await authClient.token();
  const accessToken = tokenData?.token;

  const headers = new Headers();
  if (accessToken) {
    headers.set("Authorization", `Bearer ${accessToken}`);
  }

  const response = await fetch(`${apiBaseUrl}/evaluations/${evaluationId}/file`, {
    headers,
  });

  if (!response.ok) {
    const body = await response.json().catch(() => ({ error: "Error desconocido" }));
    throw new Error(body.error ?? `Error ${response.status}`);
  }

  const blob = await response.blob();

  const disposition = response.headers.get("Content-Disposition");
  let fileName = `evaluacion-${evaluationId}.pdf`;
  if (disposition) {
    const nameMatch = disposition.match(/filename="?(.+?)"?$/);
    if (nameMatch) fileName = nameMatch[1];
  }

  return { blob, fileName };
}

export async function getEvaluationAnswersDocument(
  evaluationId: number,
): Promise<{ blob: Blob; fileName: string }> {
  const apiBaseUrl = getApiBaseUrl();
  if (!apiBaseUrl) {
    throw new Error("API Worker URL no configurado");
  }

  const { data: tokenData } = await authClient.token();
  const accessToken = tokenData?.token;

  const headers = new Headers();
  if (accessToken) {
    headers.set("Authorization", `Bearer ${accessToken}`);
  }

  const response = await fetch(`${apiBaseUrl}/evaluations/${evaluationId}/answers-file`, {
    headers,
  });

  if (!response.ok) {
    const body = await response.json().catch(() => ({ error: "Error desconocido" }));
    throw new Error(body.error ?? `Error ${response.status}`);
  }

  const blob = await response.blob();

  const disposition = response.headers.get("Content-Disposition");
  let fileName = `evaluacion-${evaluationId}-respuestas.pdf`;
  if (disposition) {
    const nameMatch = disposition.match(/filename="?(.+?)"?$/);
    if (nameMatch) fileName = nameMatch[1];
  }

  return { blob, fileName };
}

export async function moderateEvaluation(
  evaluationId: number,
  status: "approved" | "rejected",
  note: string,
): Promise<void> {
  const supabase = getSupabaseBrowserClient();
  const { error } = await supabase.rpc("moderate_evaluation", {
    p_evaluation_id: evaluationId,
    p_new_status: status,
    p_moderation_note: note.trim() === "" ? null : note.trim(),
  });

  if (error) throw error;
}
