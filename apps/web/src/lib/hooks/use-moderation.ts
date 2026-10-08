import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useEffect } from "react";

import { getEvaluationModerationQueue } from "@/lib/evaluations/api";
import { getUnreviewedFeedbackCount } from "@/lib/feedback/api";
import {
  getProfessorReviewReportsForModeration,
  getProfessorReviewsForModeration,
} from "@/lib/professor-reviews/api";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser-client";

export type ModerationCounts = {
  pendingReviews: number;
  pendingEvaluations: number;
  pendingReviewReports: number;
  pendingFeedback: number;
};

export function useModerationRealtime(enabled = true) {
  const queryClient = useQueryClient();

  useEffect(() => {
    if (!enabled) return;

    const supabase = getSupabaseBrowserClient();

    // Use a unique channel name per hook instance to avoid collisions
    // if multiple components use this hook at the same time.
    const channelId = `moderation-updates-${crypto.randomUUID()}`;
    const channel = supabase
      .channel(channelId)
      .on("postgres_changes", { event: "*", schema: "public", table: "professor_review" }, () => {
        void queryClient.invalidateQueries({ queryKey: ["moderationCounts"] });
        void queryClient.invalidateQueries({ queryKey: ["professorModerationQueue"] });
      })
      .on("postgres_changes", { event: "*", schema: "public", table: "course_evaluations" }, () => {
        void queryClient.invalidateQueries({ queryKey: ["moderationCounts"] });
        void queryClient.invalidateQueries({ queryKey: ["evaluationModerationQueue"] });
      })
      .on(
        "postgres_changes",
        { event: "*", schema: "public", table: "professor_review_report" },
        () => {
          void queryClient.invalidateQueries({ queryKey: ["moderationCounts"] });
          void queryClient.invalidateQueries({
            queryKey: ["professorReviewReportModerationQueue"],
          });
        },
      )
      .on("postgres_changes", { event: "*", schema: "public", table: "user_feedback" }, () => {
        void queryClient.invalidateQueries({ queryKey: ["moderationCounts"] });
      })
      .subscribe();

    return () => {
      void supabase.removeChannel(channel);
    };
  }, [enabled, queryClient]);
}

export function useModerationCounts(enabled = true) {
  useModerationRealtime(enabled);

  return useQuery({
    queryKey: ["moderationCounts"],
    queryFn: async (): Promise<ModerationCounts> => {
      const [reviews, evaluations, reviewReports, feedback] = await Promise.all([
        getProfessorReviewsForModeration("pending", 1, 0),
        getEvaluationModerationQueue("pending", 1, 0),
        getProfessorReviewReportsForModeration("pending", 1, 0),
        getUnreviewedFeedbackCount(),
      ]);
      return {
        pendingReviews: reviews[0]?.total_count ?? 0,
        pendingEvaluations: evaluations[0]?.total_count ?? 0,
        pendingReviewReports: reviewReports[0]?.total_count ?? 0,
        pendingFeedback: feedback[0]?.total_count ?? 0,
      };
    },
    enabled,
    staleTime: 30_000,
  });
}
