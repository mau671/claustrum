import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";

import type { EvaluationStatus, UploadEvaluationPayload } from "@/lib/evaluations/types";

import {
  getCourseEvaluations,
  getEvaluationDocument,
  getEvaluationAnswersDocument,
  getEvaluationModerationQueue,
  moderateEvaluation,
  uploadEvaluation,
} from "@/lib/evaluations/api";

export function useCourseEvaluations(courseId: number | null, studyPlanId: number | null = null) {
  return useQuery({
    queryKey: ["courseEvaluations", courseId, studyPlanId],
    queryFn: () => getCourseEvaluations(courseId!, studyPlanId),
    enabled: courseId !== null,
  });
}

export function useUploadEvaluation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: UploadEvaluationPayload) => uploadEvaluation(payload),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["courseEvaluations"] });
      void queryClient.invalidateQueries({ queryKey: ["evaluationModerationQueue"] });
    },
  });
}

export function useEvaluationModerationQueue(
  status: EvaluationStatus,
  page: number,
  pageSize: number,
  enabled = true,
) {
  return useQuery({
    queryKey: ["evaluationModerationQueue", status, page, pageSize],
    queryFn: () => getEvaluationModerationQueue(status, pageSize, page * pageSize),
    enabled,
    placeholderData: (previousData) => previousData,
    staleTime: 60_000,
  });
}

export function useEvaluationDocumentQuery(evaluationId: number | null) {
  return useQuery({
    queryKey: ["evaluationDocument", evaluationId],
    queryFn: () => getEvaluationDocument(evaluationId!),
    enabled: evaluationId !== null,
    staleTime: 5 * 60 * 1000,
  });
}

export function useEvaluationAnswersDocumentQuery(evaluationId: number | null) {
  return useQuery({
    queryKey: ["evaluationAnswersDocument", evaluationId],
    queryFn: () => getEvaluationAnswersDocument(evaluationId!),
    enabled: evaluationId !== null,
    staleTime: 5 * 60 * 1000,
  });
}

export function useModerateEvaluation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (variables: {
      evaluationId: number;
      status: "approved" | "rejected";
      note: string;
    }) => moderateEvaluation(variables.evaluationId, variables.status, variables.note),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["evaluationModerationQueue"] });
      void queryClient.invalidateQueries({ queryKey: ["courseEvaluations"] });
    },
  });
}
