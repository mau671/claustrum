import { apiClient } from "@/lib/api/client";

export interface SubmitFeedbackPayload {
  type: "bug" | "feature" | "other";
  content: string;
  turnstileToken: string;
  isAnonymous?: boolean;
}

export interface FeedbackRow {
  id: number;
  type: "bug" | "feature" | "other";
  content: string;
  is_reviewed: boolean;
  created_at: string;
  user_id?: string | null;
  admin_notes?: string | null;
}

export async function submitFeedback(payload: SubmitFeedbackPayload): Promise<void> {
  await apiClient("/feedback", {
    method: "POST",
    body: JSON.stringify(payload),
  });
}

export async function getFeedbackList(limit: number, offset: number): Promise<FeedbackRow[]> {
  const data = await apiClient<FeedbackRow[]>(`/feedback?limit=${limit}&offset=${offset}`);
  return data ?? [];
}

export async function getUnreviewedFeedbackCount(): Promise<{ total_count: number }[]> {
  try {
    const data = await apiClient<
      | {
          pendingFeedback?: number;
          feedback?: number;
          total_count?: number;
          count?: number;
        }
      | Array<{ total_count: number }>
    >("/moderation/counts");

    if (Array.isArray(data)) {
      return data;
    }
    const count = data?.pendingFeedback ?? data?.feedback ?? data?.total_count ?? data?.count ?? 0;
    return [{ total_count: count }];
  } catch {
    return [{ total_count: 0 }];
  }
}

export async function markFeedbackAsReviewed(id: number): Promise<void> {
  await apiClient(`/feedback/${id}`, {
    method: "PATCH",
    body: JSON.stringify({ isReviewed: true }),
  });
}

export async function replyToFeedback(
  feedbackId: number,
  adminNotes: string,
  replyMessage: string,
): Promise<void> {
  await apiClient(`/feedback/${feedbackId}/replies`, {
    method: "POST",
    body: JSON.stringify({
      message: replyMessage,
      notes: adminNotes,
    }),
  });
}
