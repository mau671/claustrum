import type {
  EvaluationRow,
  EvaluationModerationRow,
  EvaluationStatus,
  UploadEvaluationPayload,
} from "@/lib/evaluations/types";

import { apiClient, getApiV1Url } from "@/lib/api/client";

async function sha256File(file: File): Promise<string> {
  const buffer = await file.arrayBuffer();
  const hashBuffer = await crypto.subtle.digest("SHA-256", buffer);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map((b) => b.toString(16).padStart(2, "0")).join("");
}

export async function getCourseEvaluations(
  courseId: number,
  studyPlanId?: number | null,
): Promise<EvaluationRow[]> {
  const query = studyPlanId
    ? `/evaluations?courseId=${courseId}&studyPlanId=${studyPlanId}`
    : `/evaluations?courseId=${courseId}`;
  const data = await apiClient<EvaluationRow[]>(query);
  return data ?? [];
}

export async function getEvaluationModerationQueue(
  status: EvaluationStatus,
  limit: number,
  offset: number,
): Promise<EvaluationModerationRow[]> {
  const data = await apiClient<EvaluationModerationRow[]>(
    `/moderation/evaluations?status=${status}&limit=${limit}&offset=${offset}`,
  );
  return data ?? [];
}

export async function uploadEvaluation(payload: UploadEvaluationPayload): Promise<void> {
  const [fileSha256, answersFileSha256] = await Promise.all([
    sha256File(payload.evaluationFile),
    payload.answersFile ? sha256File(payload.answersFile) : Promise.resolve(""),
  ]);

  const formData = new FormData();
  formData.append("evaluationFile", payload.evaluationFile);
  if (payload.courseId) {
    formData.append("courseId", String(payload.courseId));
  }
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

  await apiClient("/evaluations", {
    method: "POST",
    body: formData,
  });
}

export async function getEvaluationDocument(
  evaluationId: number,
): Promise<{ blob: Blob; fileName: string }> {
  const url = getApiV1Url(`/evaluations/${evaluationId}/file`);
  const response = await fetch(url, { credentials: "include" });

  if (!response.ok) {
    const body = await response.json().catch(() => ({ error: "Error desconocido" }));
    throw new Error(body.error ?? body.message ?? `Error ${response.status}`);
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
  const url = getApiV1Url(`/evaluations/${evaluationId}/answers`);
  const response = await fetch(url, { credentials: "include" });

  if (!response.ok) {
    const body = await response.json().catch(() => ({ error: "Error desconocido" }));
    throw new Error(body.error ?? body.message ?? `Error ${response.status}`);
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
  await apiClient(`/evaluations/${evaluationId}`, {
    method: "PATCH",
    body: JSON.stringify({
      status,
      note: note.trim() === "" ? null : note.trim(),
    }),
  });
}
