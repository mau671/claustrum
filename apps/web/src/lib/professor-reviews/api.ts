import type {
  ProfessorReviewCourseOption,
  ProfessorReviewReportModerationRow,
  ProfessorReviewReportStatus,
  ProfessorReviewTermOption,
  ProfessorReviewModerationRow,
  ProfessorReviewPublicRow,
  ProfessorReviewReaction,
  ProfessorReviewSummary,
  ProfessorReviewTagCount,
  ProfessorReviewStatsRow,
  ProfessorReviewStatusFilter,
  SearchProfessorReviewStatsParams,
  SubmitProfessorReviewPayload,
  SubmitProfessorReviewReportPayload,
} from "@/lib/professor-reviews/types";

import { apiClient, ApiError } from "@/lib/api/client";

function normalizeReviewCourses<T extends { courses: unknown }>(row: T) {
  const courses = Array.isArray(row.courses)
    ? row.courses.filter(
        (course): course is { id: number; code: string; name: string } =>
          typeof course === "object" &&
          course !== null &&
          "id" in course &&
          "code" in course &&
          "name" in course &&
          typeof course.id === "number" &&
          typeof course.code === "string" &&
          typeof course.name === "string",
      )
    : [];

  return {
    ...row,
    courses,
  };
}

export async function searchProfessorReviewStats(
  params: SearchProfessorReviewStatsParams,
): Promise<ProfessorReviewStatsRow[]> {
  const q = new URLSearchParams();
  if (params.query.trim()) q.set("search", params.query.trim());
  if (params.minAverageScore !== null && params.minAverageScore !== undefined) {
    q.set("minAverageScore", String(params.minAverageScore));
  }
  if (params.minReviewCount !== undefined) {
    q.set("minReviewCount", String(params.minReviewCount));
  }
  if (params.academicUnitId) {
    q.set("academicUnitId", String(params.academicUnitId));
  }
  if (params.onlyWithApprovedReviews !== undefined) {
    q.set("onlyWithApprovedReviews", String(params.onlyWithApprovedReviews));
  }
  if (params.sortBy) {
    q.set("sortBy", params.sortBy);
  }
  if (params.sortDesc !== null && params.sortDesc !== undefined) {
    q.set("sortDesc", String(params.sortDesc));
  }
  if (params.limit !== undefined) {
    q.set("limit", String(params.limit));
  }
  if (params.offset !== undefined) {
    q.set("offset", String(params.offset));
  }

  const data = await apiClient<ProfessorReviewStatsRow[]>(`/professors?${q.toString()}`);
  return data ?? [];
}

export async function getProfessorReviewsPublic(
  professorId: string,
  limit: number,
  offset: number,
): Promise<ProfessorReviewPublicRow[]> {
  const data = await apiClient<ProfessorReviewPublicRow[]>(
    `/reviews?professorId=${encodeURIComponent(professorId)}&limit=${limit}&offset=${offset}`,
  );
  return (data ?? []).map((row) => ({
    ...normalizeReviewCourses(row),
    like_count: row.like_count ?? 0,
    dislike_count: row.dislike_count ?? 0,
    my_reaction: row.my_reaction ?? null,
  }));
}

export async function getProfessorReviewSummary(
  professorId: string,
): Promise<ProfessorReviewSummary> {
  const data = await apiClient<ProfessorReviewSummary>(
    `/professors/${encodeURIComponent(professorId)}/summary`,
  );
  const tagCounts = Array.isArray(data?.tag_counts)
    ? (data.tag_counts as ProfessorReviewTagCount[])
    : [];

  return {
    professor_id: data?.professor_id ?? professorId,
    approved_review_count: data?.approved_review_count ?? 0,
    average_overall_score: data?.average_overall_score ?? null,
    average_ease_score: data?.average_ease_score ?? null,
    average_quality_score: data?.average_quality_score ?? null,
    average_clarity_score: data?.average_clarity_score ?? null,
    average_fairness_score: data?.average_fairness_score ?? null,
    would_take_again_percentage: data?.would_take_again_percentage ?? null,
    tag_counts: tagCounts,
  };
}

export async function getProfessorById(
  professorId: string,
): Promise<{ id: number; full_name: string } | null> {
  try {
    return await apiClient<{ id: number; full_name: string }>(
      `/professors/${encodeURIComponent(professorId)}`,
    );
  } catch (error) {
    if (error instanceof ApiError && error.status === 404) {
      return null;
    }
    throw error;
  }
}

export async function searchProfessorReviewCourses(
  query: string,
): Promise<ProfessorReviewCourseOption[]> {
  const trimmed = query.trim();
  if (trimmed.length < 2) {
    return [];
  }

  const data = await apiClient<ProfessorReviewCourseOption[]>(
    `/courses?search=${encodeURIComponent(trimmed)}`,
  );
  return data ?? [];
}

export async function getProfessorReviewCourses(
  professorId: string,
): Promise<ProfessorReviewCourseOption[]> {
  const data = await apiClient<ProfessorReviewCourseOption[]>(
    `/professors/${encodeURIComponent(professorId)}/courses`,
  );
  return data ?? [];
}

export async function getProfessorOfferingTerms(
  professorId: string,
): Promise<ProfessorReviewTermOption[]> {
  const data = await apiClient<ProfessorReviewTermOption[]>(
    `/professors/${encodeURIComponent(professorId)}/terms`,
  );
  return data ?? [];
}

export async function submitProfessorReview(payload: SubmitProfessorReviewPayload): Promise<void> {
  await apiClient("/reviews", {
    method: "POST",
    body: JSON.stringify(payload),
  });
}

export async function setProfessorReviewReaction(
  reviewId: number,
  reaction: ProfessorReviewReaction | null,
): Promise<void> {
  await apiClient(`/reviews/${reviewId}/reactions`, {
    method: "POST",
    body: JSON.stringify({ reaction }),
  });
}

export async function submitProfessorReviewReport(
  payload: SubmitProfessorReviewReportPayload,
): Promise<void> {
  await apiClient(`/reviews/${payload.reviewId}/reports`, {
    method: "POST",
    body: JSON.stringify({
      reason: payload.reason,
      description: payload.description,
      turnstileToken: payload.turnstileToken,
    }),
  });
}

export async function getProfessorReviewsForModeration(
  status: ProfessorReviewStatusFilter,
  limit: number,
  offset: number,
): Promise<ProfessorReviewModerationRow[]> {
  const data = await apiClient<ProfessorReviewModerationRow[]>(
    `/moderation/reviews?status=${status}&limit=${limit}&offset=${offset}`,
  );
  return (data ?? []).map(normalizeReviewCourses);
}

export async function moderateProfessorReview(
  reviewId: number,
  status: "approved" | "rejected",
  note: string,
): Promise<void> {
  await apiClient(`/reviews/${reviewId}`, {
    method: "PATCH",
    body: JSON.stringify({ status, reason: note.trim() === "" ? null : note.trim() }),
  });
}

export async function getProfessorReviewReportsForModeration(
  status: ProfessorReviewReportStatus,
  limit: number,
  offset: number,
): Promise<ProfessorReviewReportModerationRow[]> {
  const data = await apiClient<ProfessorReviewReportModerationRow[]>(
    `/reports?status=${status}&limit=${limit}&offset=${offset}`,
  );
  return data ?? [];
}

export async function moderateProfessorReviewReport(
  reportId: number,
  status: Exclude<ProfessorReviewReportStatus, "pending">,
  note: string,
): Promise<void> {
  await apiClient(`/reports/${reportId}`, {
    method: "PATCH",
    body: JSON.stringify({ status, note: note.trim() === "" ? null : note.trim() }),
  });
}

export async function getCurrentUserIsAdmin(): Promise<boolean> {
  try {
    const user = await apiClient<{ role?: string }>("/users/me");
    return user?.role === "admin";
  } catch {
    return false;
  }
}
