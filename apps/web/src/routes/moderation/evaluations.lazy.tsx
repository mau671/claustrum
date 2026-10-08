import { createLazyFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import { toast } from "sonner";

import type { EvaluationModerationRow } from "@/lib/evaluations/types";

import { useEvaluationModerationQueue, useModerateEvaluation } from "@/lib/hooks/use-evaluations";

import { EvaluationSection } from "./-moderation-components";

const PAGE_SIZE = 20;

export const Route = createLazyFileRoute("/moderation/evaluations")({
  component: EvaluationsPage,
});

function EvaluationsPage() {
  const navigate = useNavigate();
  const search = Route.useSearch();
  const page = search.page ?? 1;
  const queryPage = Math.max(page - 1, 0);
  const selectedEvaluationId = search.evaluationId ?? null;

  const [moderationNote, setModerationNote] = useState<Record<number, string>>({});

  const evaluationsQuery = useEvaluationModerationQueue("pending", queryPage, PAGE_SIZE, true);
  const moderateEvaluationMutation = useModerateEvaluation();

  const evaluationRows = useMemo(
    () => (evaluationsQuery.data ?? []) as EvaluationModerationRow[],
    [evaluationsQuery.data],
  );
  const evaluationTotal = evaluationRows[0]?.total_count ?? 0;
  const evaluationHasMore = evaluationTotal > (queryPage + 1) * PAGE_SIZE;

  // Auto-select first if none selected
  useEffect(() => {
    if (
      evaluationRows.length > 0 &&
      selectedEvaluationId === null &&
      !evaluationsQuery.isFetching
    ) {
      const firstId = evaluationRows[0].id;
      void navigate({
        from: "/moderation/evaluations",
        search: (prev) => ({ ...prev, evaluationId: firstId }),
        replace: true,
      });
    }
  }, [evaluationRows, selectedEvaluationId, navigate, evaluationsQuery.isFetching]);

  const selectedEvaluation = useMemo(
    () => evaluationRows.find((e) => e.id === selectedEvaluationId) ?? null,
    [evaluationRows, selectedEvaluationId],
  );

  const handlePageChange = (newPage: number) => {
    void navigate({
      from: "/moderation/evaluations",
      search: (prev) => ({
        ...prev,
        page: newPage === 0 ? undefined : newPage + 1,
        evaluationId: undefined,
      }),
    });
  };

  const handleSelect = (id: number | null) => {
    void navigate({
      from: "/moderation/evaluations",
      search: (prev) => ({ ...prev, evaluationId: id ?? undefined }),
    });
  };

  const handleApproveEvaluation = async (evaluationId: number) => {
    try {
      await moderateEvaluationMutation.mutateAsync({
        evaluationId,
        status: "approved",
        note: moderationNote[evaluationId] ?? "",
      });
      toast.success("Evaluación aprobada");
      if (selectedEvaluationId === evaluationId) handleSelect(null);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo moderar la evaluación.");
    }
  };

  const handleRejectEvaluation = async (evaluationId: number) => {
    try {
      await moderateEvaluationMutation.mutateAsync({
        evaluationId,
        status: "rejected",
        note: moderationNote[evaluationId] ?? "",
      });
      toast.success("Evaluación rechazada");
      if (selectedEvaluationId === evaluationId) handleSelect(null);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo moderar la evaluación.");
    }
  };

  return (
    <EvaluationSection
      rows={evaluationRows}
      selectedEvaluation={selectedEvaluation}
      onSelect={handleSelect}
      page={queryPage}
      hasMore={evaluationHasMore}
      isLoading={evaluationsQuery.isLoading}
      isFetching={evaluationsQuery.isFetching}
      onPageChange={handlePageChange}
      moderationNote={moderationNote}
      onNoteChange={(id, value) => setModerationNote((prev) => ({ ...prev, [id]: value }))}
      onApprove={handleApproveEvaluation}
      onReject={handleRejectEvaluation}
      isPending={moderateEvaluationMutation.isPending}
    />
  );
}
