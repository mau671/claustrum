import { keepPreviousData, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";

import type {
  ProfessorReviewReportStatus,
  ProfessorReviewPublicRow,
  ProfessorReviewReaction,
  ProfessorReviewStatusFilter,
  SearchProfessorReviewStatsParams,
  SubmitProfessorReviewPayload,
  SubmitProfessorReviewReportPayload,
} from "@/lib/professor-reviews/types";

import {
  getCurrentUserIsAdmin,
  getProfessorOfferingTerms,
  getProfessorReviewCourses,
  getProfessorById,
  getProfessorReviewReportsForModeration,
  getProfessorReviewSummary,
  getProfessorReviewsForModeration,
  getProfessorReviewsPublic,
  moderateProfessorReviewReport,
  moderateProfessorReview,
  searchProfessorReviewCourses,
  searchProfessorReviewStats,
  setProfessorReviewReaction,
  submitProfessorReviewReport,
  submitProfessorReview,
} from "@/lib/professor-reviews/api";

export function useProfessorReviewStats(params: SearchProfessorReviewStatsParams) {
  return useQuery({
    queryKey: ["professorReviewStats", params],
    queryFn: () => searchProfessorReviewStats(params),
    placeholderData: keepPreviousData,
  });
}

export function useProfessorReviewsPublic(
  professorId: string | null,
  page: number,
  pageSize: number,
) {
  return useQuery({
    queryKey: ["professorReviewsPublic", professorId, page, pageSize],
    queryFn: () => getProfessorReviewsPublic(professorId!, pageSize, page * pageSize),
    enabled: professorId !== null,
    placeholderData: (previousData) => previousData,
  });
}

export function useProfessorReviewSummary(professorId: string | null) {
  return useQuery({
    queryKey: ["professorReviewSummary", professorId],
    queryFn: () => getProfessorReviewSummary(professorId!),
    enabled: professorId !== null,
  });
}

export function useProfessorById(professorId: string | null) {
  return useQuery({
    queryKey: ["professorById", professorId],
    queryFn: () => getProfessorById(professorId!),
    enabled: professorId !== null,
  });
}

export function useProfessorReviewCourseSearch(query: string) {
  return useQuery({
    queryKey: ["professorReviewCourses", query],
    queryFn: () => searchProfessorReviewCourses(query),
    enabled: query.trim().length >= 2,
    placeholderData: keepPreviousData,
    staleTime: 60_000,
  });
}

export function useSubmitProfessorReview() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: SubmitProfessorReviewPayload) => submitProfessorReview(payload),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["professorReviewStats"] });
    },
  });
}

export function useSetProfessorReviewReaction() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (variables: { reviewId: number; reaction: ProfessorReviewReaction | null }) =>
      setProfessorReviewReaction(variables.reviewId, variables.reaction),
    onMutate: async (variables) => {
      await queryClient.cancelQueries({ queryKey: ["professorReviewsPublic"] });

      const previousRows = queryClient.getQueriesData<ProfessorReviewPublicRow[]>({
        queryKey: ["professorReviewsPublic"],
      });

      queryClient.setQueriesData<ProfessorReviewPublicRow[]>(
        { queryKey: ["professorReviewsPublic"] },
        (currentRows) =>
          currentRows?.map((row) => {
            if (row.review_id !== variables.reviewId) return row;

            const likeCount =
              row.like_count -
              (row.my_reaction === "like" ? 1 : 0) +
              (variables.reaction === "like" ? 1 : 0);
            const dislikeCount =
              row.dislike_count -
              (row.my_reaction === "dislike" ? 1 : 0) +
              (variables.reaction === "dislike" ? 1 : 0);

            return {
              ...row,
              like_count: Math.max(likeCount, 0),
              dislike_count: Math.max(dislikeCount, 0),
              my_reaction: variables.reaction,
            };
          }),
      );

      return { previousRows };
    },
    onError: (_error, _variables, context) => {
      context?.previousRows.forEach(([queryKey, rows]) => {
        queryClient.setQueryData(queryKey, rows);
      });
    },
    onSettled: () => {
      void queryClient.invalidateQueries({ queryKey: ["professorReviewsPublic"] });
    },
  });
}

export function useSubmitProfessorReviewReport() {
  return useMutation({
    mutationFn: (payload: SubmitProfessorReviewReportPayload) =>
      submitProfessorReviewReport(payload),
  });
}

export function useProfessorReviewCourses(professorId: string | null) {
  return useQuery({
    queryKey: ["professorReviewCoursesByProfessor", professorId],
    queryFn: () => getProfessorReviewCourses(professorId!),
    enabled: professorId !== null,
    placeholderData: keepPreviousData,
    staleTime: 60_000,
  });
}

export function useProfessorOfferingTerms(professorId: string | null) {
  return useQuery({
    queryKey: ["professorOfferingTerms", professorId],
    queryFn: () => getProfessorOfferingTerms(professorId!),
    enabled: professorId !== null,
    placeholderData: keepPreviousData,
    staleTime: 60_000,
  });
}

export function useIsAdmin(userId: string | null) {
  return useQuery({
    queryKey: ["isAdmin", userId],
    queryFn: getCurrentUserIsAdmin,
    enabled: !!userId,
    staleTime: 60_000,
  });
}

export function useModerationQueue(
  status: ProfessorReviewStatusFilter,
  page: number,
  pageSize: number,
  enabled = true,
) {
  return useQuery({
    queryKey: ["professorModerationQueue", status, page, pageSize],
    queryFn: () => getProfessorReviewsForModeration(status, pageSize, page * pageSize),
    enabled,
    placeholderData: (previousData) => previousData,
    staleTime: 60_000,
  });
}

export function useModerateProfessorReview() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (variables: { reviewId: number; status: "approved" | "rejected"; note: string }) =>
      moderateProfessorReview(variables.reviewId, variables.status, variables.note),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["professorModerationQueue"] });
      void queryClient.invalidateQueries({ queryKey: ["professorReviewStats"] });
      void queryClient.invalidateQueries({ queryKey: ["professorReviewsPublic"] });
    },
  });
}

export function useReportModerationQueue(
  status: ProfessorReviewReportStatus,
  page: number,
  pageSize: number,
  enabled = true,
) {
  return useQuery({
    queryKey: ["professorReviewReportModerationQueue", status, page, pageSize],
    queryFn: () => getProfessorReviewReportsForModeration(status, pageSize, page * pageSize),
    enabled,
    placeholderData: (previousData) => previousData,
    staleTime: 60_000,
  });
}

export function useModerateProfessorReviewReport() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (variables: { reportId: number; status: "resolved" | "dismissed"; note: string }) =>
      moderateProfessorReviewReport(variables.reportId, variables.status, variables.note),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["professorReviewReportModerationQueue"] });
      void queryClient.invalidateQueries({ queryKey: ["moderationCounts"] });
    },
  });
}
