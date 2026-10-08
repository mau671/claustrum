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

import { authClient } from "@/lib/auth/client";
import { getApiBaseUrl } from "@/lib/env/public";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser-client";

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

function escapeIlikeQuery(value: string) {
  return value.replace(/[,%]/g, " ").trim();
}

export async function searchProfessorReviewStats(
  params: SearchProfessorReviewStatsParams,
): Promise<ProfessorReviewStatsRow[]> {
  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase.rpc("search_professor_review_stats", {
    p_query: params.query.trim() === "" ? null : params.query.trim(),
    p_min_avg_score: params.minAverageScore,
    p_min_review_count: params.minReviewCount,
    p_academic_unit_id: params.academicUnitId,
    p_only_with_approved_reviews: params.onlyWithApprovedReviews,
    p_sort_by: params.sortBy,
    p_sort_desc: params.sortDesc,
    p_limit: params.limit,
    p_offset: params.offset,
  });

  if (error) throw error;
  return (data ?? []) as ProfessorReviewStatsRow[];
}

export async function getProfessorReviewsPublic(
  professorId: string,
  limit: number,
  offset: number,
): Promise<ProfessorReviewPublicRow[]> {
  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase.rpc("get_professor_reviews_public", {
    p_professor_id: professorId,
    p_limit: limit,
    p_offset: offset,
  });

  if (error) throw error;
  return ((data ?? []) as ProfessorReviewPublicRow[]).map((row) => ({
    ...normalizeReviewCourses(row),
    like_count: row.like_count ?? 0,
    dislike_count: row.dislike_count ?? 0,
    my_reaction: row.my_reaction ?? null,
  }));
}

export async function getProfessorReviewSummary(
  professorId: string,
): Promise<ProfessorReviewSummary> {
  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase.rpc("get_professor_review_summary", {
    p_professor_id: professorId,
  });

  if (error) throw error;

  const row = (data?.[0] ?? {
    professor_id: professorId,
    approved_review_count: 0,
    average_overall_score: null,
    average_ease_score: null,
    average_quality_score: null,
    average_clarity_score: null,
    average_fairness_score: null,
    would_take_again_percentage: null,
    tag_counts: [],
  }) as {
    professor_id: string;
    approved_review_count: number;
    average_overall_score: number | null;
    average_ease_score: number | null;
    average_quality_score: number | null;
    average_clarity_score: number | null;
    average_fairness_score: number | null;
    would_take_again_percentage: number | null;
    tag_counts: unknown;
  };

  const tagCounts = Array.isArray(row.tag_counts)
    ? (row.tag_counts as ProfessorReviewTagCount[])
    : [];

  return {
    ...row,
    tag_counts: tagCounts,
  };
}

export async function getProfessorById(
  professorId: string,
): Promise<{ id: number; full_name: string } | null> {
  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase
    .from("professor")
    .select("id,full_name")
    .eq("id", professorId)
    .maybeSingle();

  if (error) throw error;
  return data;
}

export async function searchProfessorReviewCourses(
  query: string,
): Promise<ProfessorReviewCourseOption[]> {
  const normalizedQuery = escapeIlikeQuery(query);

  if (normalizedQuery.length < 2) {
    return [];
  }

  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase.rpc("search_professor_review_courses", {
    p_query: normalizedQuery,
    p_limit: 8,
  });

  if (error) throw error;

  return (data ?? []) as ProfessorReviewCourseOption[];
}

export async function getProfessorReviewCourses(
  professorId: string,
): Promise<ProfessorReviewCourseOption[]> {
  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase.rpc("get_professor_review_courses", {
    p_professor_id: professorId,
  });

  if (error) throw error;
  return (data ?? []) as ProfessorReviewCourseOption[];
}

export async function getProfessorOfferingTerms(
  professorId: string,
): Promise<ProfessorReviewTermOption[]> {
  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase
    .rpc("get_professor_offering_terms", {
      p_professor_id: professorId,
    })
    .select("*")
    .order("year", { ascending: false })
    .order("period_number", { ascending: false });

  if (error) throw error;
  return (data ?? []) as ProfessorReviewTermOption[];
}

export async function submitProfessorReview(payload: SubmitProfessorReviewPayload): Promise<void> {
  const apiBaseUrl = getApiBaseUrl();
  if (!apiBaseUrl) {
    throw new Error("API Worker URL no configurado");
  }

  const response = await fetch(`${apiBaseUrl}/professors/${payload.professorId}/reviews`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(payload),
  });

  if (!response.ok) {
    const body = await response.json().catch(() => ({ error: "Error desconocido" }));
    throw new Error(body.error ?? `Error ${response.status}`);
  }
}

export async function setProfessorReviewReaction(
  reviewId: number,
  reaction: ProfessorReviewReaction | null,
): Promise<void> {
  const apiBaseUrl = getApiBaseUrl();
  if (!apiBaseUrl) {
    throw new Error("API Worker URL no configurado");
  }

  const { data: tokenData } = await authClient.token();
  const accessToken = tokenData?.token;
  if (!accessToken) {
    throw new Error("Debes iniciar sesión para reaccionar a una reseña");
  }

  const response = await fetch(`${apiBaseUrl}/reviews/${reviewId}/reactions`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${accessToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ reaction }),
  });

  if (!response.ok) {
    const body = await response.json().catch(() => ({ error: "Error desconocido" }));
    throw new Error(body.error ?? `Error ${response.status}`);
  }
}

export async function submitProfessorReviewReport(
  payload: SubmitProfessorReviewReportPayload,
): Promise<void> {
  const apiBaseUrl = getApiBaseUrl();
  if (!apiBaseUrl) {
    throw new Error("API Worker URL no configurado");
  }

  const response = await fetch(`${apiBaseUrl}/reviews/${payload.reviewId}/reports`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      reason: payload.reason,
      description: payload.description,
      turnstileToken: payload.turnstileToken,
    }),
  });

  if (!response.ok) {
    const body = await response.json().catch(() => ({ error: "Error desconocido" }));
    throw new Error(body.error ?? `Error ${response.status}`);
  }
}

export async function getProfessorReviewsForModeration(
  status: ProfessorReviewStatusFilter,
  limit: number,
  offset: number,
): Promise<ProfessorReviewModerationRow[]> {
  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase.rpc("get_professor_reviews_for_moderation", {
    p_status: status === "all" ? null : status,
    p_limit: limit,
    p_offset: offset,
  });

  if (error) throw error;
  return ((data ?? []) as ProfessorReviewModerationRow[]).map(normalizeReviewCourses);
}

export async function moderateProfessorReview(
  reviewId: number,
  status: "approved" | "rejected",
  note: string,
): Promise<void> {
  const supabase = getSupabaseBrowserClient();
  const { error } = await supabase.rpc("moderate_professor_review", {
    p_review_id: reviewId,
    p_new_status: status,
    p_moderation_note: note.trim() === "" ? null : note.trim(),
  });

  if (error) throw error;
}

export async function getProfessorReviewReportsForModeration(
  status: ProfessorReviewReportStatus,
  limit: number,
  offset: number,
): Promise<ProfessorReviewReportModerationRow[]> {
  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase.rpc("get_professor_review_reports_for_moderation", {
    p_status: status,
    p_limit: limit,
    p_offset: offset,
  });

  if (error) throw error;
  return (data ?? []) as ProfessorReviewReportModerationRow[];
}

export async function moderateProfessorReviewReport(
  reportId: number,
  status: Exclude<ProfessorReviewReportStatus, "pending">,
  note: string,
): Promise<void> {
  const supabase = getSupabaseBrowserClient();
  const { error } = await supabase.rpc("moderate_professor_review_report", {
    p_report_id: reportId,
    p_new_status: status,
    p_resolution_note: note.trim() === "" ? null : note.trim(),
  });

  if (error) throw error;
}

export async function getCurrentUserIsAdmin(): Promise<boolean> {
  const supabase = getSupabaseBrowserClient();
  const { data, error } = await supabase.rpc("is_admin");
  if (error) throw error;
  return Boolean(data);
}
