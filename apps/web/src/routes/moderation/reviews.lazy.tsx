import { createLazyFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import { toast } from "sonner";

import type {
  ProfessorReviewModerationRow,
  ProfessorReviewStatusFilter,
} from "@/lib/professor-reviews/types";

import { useModerateProfessorReview, useModerationQueue } from "@/lib/hooks/use-professor-reviews";

import { ReviewSection } from "./-moderation-components";

const PAGE_SIZE = 20;

export const Route = createLazyFileRoute("/moderation/reviews")({
  component: ReviewsPage,
});

function ReviewsPage() {
  const navigate = useNavigate();
  const search = Route.useSearch();
  const page = search.page ?? 1;
  const queryPage = Math.max(page - 1, 0);
  const selectedReviewId = search.reviewId ?? null;
  const statusFilter: ProfessorReviewStatusFilter =
    (search.status as ProfessorReviewStatusFilter) ?? "all";

  const [moderationNote, setModerationNote] = useState<Record<number, string>>({});

  const reviewsQuery = useModerationQueue(statusFilter, queryPage, PAGE_SIZE, true);
  const moderateReviewMutation = useModerateProfessorReview();

  const reviewRows = useMemo(
    () => (reviewsQuery.data ?? []) as ProfessorReviewModerationRow[],
    [reviewsQuery.data],
  );
  const reviewTotal = reviewRows[0]?.total_count ?? 0;
  const reviewHasMore = reviewTotal > (queryPage + 1) * PAGE_SIZE;

  // Auto-select first if none selected
  useEffect(() => {
    if (reviewRows.length > 0 && selectedReviewId === null && !reviewsQuery.isFetching) {
      const firstId = reviewRows[0].review_id;
      void navigate({
        from: "/moderation/reviews",
        search: (prev) => ({ ...prev, reviewId: firstId }),
        replace: true,
      });
    }
  }, [reviewRows, selectedReviewId, navigate, reviewsQuery.isFetching]);

  const selectedReview = useMemo(
    () => reviewRows.find((r) => r.review_id === selectedReviewId) ?? null,
    [reviewRows, selectedReviewId],
  );

  const handlePageChange = (newPage: number) => {
    void navigate({
      from: "/moderation/reviews",
      search: (prev) => ({
        ...prev,
        page: newPage === 0 ? undefined : newPage + 1,
        reviewId: undefined,
      }),
    });
  };

  const handleStatusChange = (newStatus: ProfessorReviewStatusFilter) => {
    void navigate({
      from: "/moderation/reviews",
      search: (prev) => ({
        ...prev,
        status: newStatus === "all" ? undefined : newStatus,
        page: undefined,
        reviewId: undefined,
      }),
    });
  };

  const handleSelect = (id: number | null) => {
    void navigate({
      from: "/moderation/reviews",
      search: (prev) => ({ ...prev, reviewId: id ?? undefined }),
    });
  };

  const handleApproveReview = async (reviewId: number) => {
    try {
      await moderateReviewMutation.mutateAsync({
        reviewId,
        status: "approved",
        note: moderationNote[reviewId] ?? "",
      });
      toast.success("Reseña aprobada");
      if (selectedReviewId === reviewId) handleSelect(null);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo moderar la reseña.");
    }
  };

  const handleRejectReview = async (reviewId: number) => {
    try {
      await moderateReviewMutation.mutateAsync({
        reviewId,
        status: "rejected",
        note: moderationNote[reviewId] ?? "",
      });
      toast.success("Reseña rechazada");
      if (selectedReviewId === reviewId) handleSelect(null);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo moderar la reseña.");
    }
  };

  return (
    <ReviewSection
      rows={reviewRows}
      selectedReview={selectedReview}
      onSelect={handleSelect}
      page={queryPage}
      hasMore={reviewHasMore}
      isLoading={reviewsQuery.isLoading}
      isFetching={reviewsQuery.isFetching}
      onPageChange={handlePageChange}
      statusFilter={statusFilter}
      onStatusChange={handleStatusChange}
      moderationNote={moderationNote}
      onNoteChange={(id, value) => setModerationNote((prev) => ({ ...prev, [id]: value }))}
      onApprove={handleApproveReview}
      onReject={handleRejectReview}
      isPending={moderateReviewMutation.isPending}
    />
  );
}
