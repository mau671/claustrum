import { createLazyFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import { toast } from "sonner";

import type { ProfessorReviewReportModerationRow } from "@/lib/professor-reviews/types";

import {
  useModerateProfessorReviewReport,
  useReportModerationQueue,
} from "@/lib/hooks/use-professor-reviews";

import { ReviewReportSection } from "./-moderation-components";

const PAGE_SIZE = 20;

export const Route = createLazyFileRoute("/moderation/reports")({
  component: ReportsPage,
});

function ReportsPage() {
  const navigate = useNavigate();
  const search = Route.useSearch();
  const page = search.page ?? 1;
  const queryPage = Math.max(page - 1, 0);
  const selectedReviewReportId = search.reportId ?? null;

  const [moderationNote, setModerationNote] = useState<Record<number, string>>({});

  const reviewReportsQuery = useReportModerationQueue("pending", queryPage, PAGE_SIZE, true);
  const moderateReviewReportMutation = useModerateProfessorReviewReport();

  const reviewReportRows = useMemo(
    () => (reviewReportsQuery.data ?? []) as ProfessorReviewReportModerationRow[],
    [reviewReportsQuery.data],
  );
  const reviewReportTotal = reviewReportRows[0]?.total_count ?? 0;
  const reviewReportHasMore = reviewReportTotal > (queryPage + 1) * PAGE_SIZE;

  // Auto-select first if none selected
  useEffect(() => {
    if (
      reviewReportRows.length > 0 &&
      selectedReviewReportId === null &&
      !reviewReportsQuery.isFetching
    ) {
      const firstId = reviewReportRows[0].report_id;
      void navigate({
        from: "/moderation/reports",
        search: (prev) => ({ ...prev, reportId: firstId }),
        replace: true,
      });
    }
  }, [reviewReportRows, selectedReviewReportId, navigate, reviewReportsQuery.isFetching]);

  const selectedReviewReport = useMemo(
    () => reviewReportRows.find((r) => r.report_id === selectedReviewReportId) ?? null,
    [reviewReportRows, selectedReviewReportId],
  );

  const handlePageChange = (newPage: number) => {
    void navigate({
      from: "/moderation/reports",
      search: (prev) => ({
        ...prev,
        page: newPage === 0 ? undefined : newPage + 1,
        reportId: undefined,
      }),
    });
  };

  const handleSelect = (id: number | null) => {
    void navigate({
      from: "/moderation/reports",
      search: (prev) => ({ ...prev, reportId: id ?? undefined }),
    });
  };

  const handleResolveReviewReport = async (reportId: number) => {
    try {
      await moderateReviewReportMutation.mutateAsync({
        reportId,
        status: "resolved",
        note: moderationNote[reportId] ?? "",
      });
      toast.success("Reporte resuelto");
      if (selectedReviewReportId === reportId) handleSelect(null);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo resolver el reporte.");
    }
  };

  const handleDismissReviewReport = async (reportId: number) => {
    try {
      await moderateReviewReportMutation.mutateAsync({
        reportId,
        status: "dismissed",
        note: moderationNote[reportId] ?? "",
      });
      toast.success("Reporte descartado");
      if (selectedReviewReportId === reportId) handleSelect(null);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo descartar el reporte.");
    }
  };

  return (
    <ReviewReportSection
      rows={reviewReportRows}
      selectedReport={selectedReviewReport}
      onSelect={handleSelect}
      page={queryPage}
      hasMore={reviewReportHasMore}
      isLoading={reviewReportsQuery.isLoading}
      isFetching={reviewReportsQuery.isFetching}
      onPageChange={handlePageChange}
      moderationNote={moderationNote}
      onNoteChange={(id, value) => setModerationNote((prev) => ({ ...prev, [id]: value }))}
      onResolve={handleResolveReviewReport}
      onDismiss={handleDismissReviewReport}
      isPending={moderateReviewReportMutation.isPending}
    />
  );
}
