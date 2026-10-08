import { authClient } from "@/lib/auth/client";
import { getApiBaseUrl } from "@/lib/env/public";

export interface SubmitFeedbackPayload {
  type: "bug" | "feature" | "other";
  content: string;
  turnstileToken: string;
  isAnonymous?: boolean;
}

export async function submitFeedback(payload: SubmitFeedbackPayload): Promise<void> {
  const apiBaseUrl = getApiBaseUrl();
  if (!apiBaseUrl) {
    throw new Error("API Worker URL no configurado");
  }

  const { data: tokenData } = await authClient.token();
  const accessToken = tokenData?.token;

  const headers = new Headers();
  headers.set("Content-Type", "application/json");
  if (accessToken) {
    headers.set("Authorization", `Bearer ${accessToken}`);
  }

  const response = await fetch(`${apiBaseUrl}/feedback`, {
    method: "POST",
    headers,
    body: JSON.stringify(payload),
  });

  if (!response.ok) {
    const body = await response.json().catch(() => ({ error: "Error desconocido" }));
    throw new Error(body.error ?? `Error ${response.status}`);
  }
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

export async function getFeedbackList(limit: number, offset: number): Promise<FeedbackRow[]> {
  const { getSupabaseBrowserClient } = await import("@/lib/supabase/browser-client");
  const supabase = getSupabaseBrowserClient();

  const { data, error } = await supabase
    .from("user_feedback")
    .select("*")
    .order("created_at", { ascending: false })
    .range(offset, offset + limit - 1);

  if (error) throw error;

  return data as FeedbackRow[];
}

export async function getUnreviewedFeedbackCount(): Promise<{ total_count: number }[]> {
  const { getSupabaseBrowserClient } = await import("@/lib/supabase/browser-client");
  const supabase = getSupabaseBrowserClient();

  const { count, error } = await supabase
    .from("user_feedback")
    .select("*", { count: "exact", head: true })
    .eq("is_reviewed", false);

  if (error) throw error;

  return [{ total_count: count ?? 0 }];
}

export async function markFeedbackAsReviewed(id: number): Promise<void> {
  const { getSupabaseBrowserClient } = await import("@/lib/supabase/browser-client");
  const supabase = getSupabaseBrowserClient();

  const { error } = await supabase.from("user_feedback").update({ is_reviewed: true }).eq("id", id);

  if (error) throw error;
}

export async function replyToFeedback(
  feedbackId: number,
  adminNotes: string,
  replyMessage: string,
): Promise<void> {
  const { getSupabaseBrowserClient } = await import("@/lib/supabase/browser-client");
  const supabase = getSupabaseBrowserClient();

  const { error } = await supabase.rpc("reply_to_feedback", {
    p_feedback_id: feedbackId,
    p_admin_notes: adminNotes,
    p_reply_message: replyMessage,
  });

  if (error) throw error;
}
