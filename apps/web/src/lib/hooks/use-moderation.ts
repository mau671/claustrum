import { useQuery } from "@tanstack/react-query";

import { apiClient } from "@/lib/api/client";
import { getEvaluationModerationQueue } from "@/lib/evaluations/api";
import { getUnreviewedFeedbackCount } from "@/lib/feedback/api";
import {
  getProfessorReviewReportsForModeration,
  getProfessorReviewsForModeration,
} from "@/lib/professor-reviews/api";

export type ModerationCounts = {
  pendingReviews: number;
  pendingEvaluations: number;
  pendingReviewReports: number;
  pendingFeedback: number;
};

export function useModerationRealtime(_enabled = true) {
  // Realtime updates handled automatically by periodic refetch in useModerationCounts
}

export function useModerationCounts(enabled = true) {
  return useQuery({
    queryKey: ["moderationCounts"],
    queryFn: async (): Promise<ModerationCounts> => {
      try {
        const counts = await apiClient<{
          pendingReviews: number;
          pendingEvaluations: number;
          pendingReports: number;
          pendingFeedback: number;
        }>("/moderation/counts");

        return {
          pendingReviews: counts.pendingReviews ?? 0,
          pendingEvaluations: counts.pendingEvaluations ?? 0,
          pendingReviewReports: counts.pendingReports ?? 0,
          pendingFeedback: counts.pendingFeedback ?? 0,
        };
      } catch {
        const [reviews, evaluations, reviewReports, feedback] = await Promise.all([
          getProfessorReviewsForModeration("pending", 1, 0).catch(() => []),
          getEvaluationModerationQueue("pending", 1, 0).catch(() => []),
          getProfessorReviewReportsForModeration("pending", 1, 0).catch(() => []),
          getUnreviewedFeedbackCount().catch(() => [{ total_count: 0 }]),
        ]);

        return {
          pendingReviews: reviews.length,
          pendingEvaluations: evaluations.length,
          pendingReviewReports: reviewReports.length,
          pendingFeedback: feedback[0]?.total_count ?? 0,
        };
      }
    },
    staleTime: 15_000,
    refetchInterval: enabled ? 15_000 : false,
    enabled,
  });
}
