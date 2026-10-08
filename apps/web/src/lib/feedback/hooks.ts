import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";

import {
  submitFeedback,
  getFeedbackList,
  markFeedbackAsReviewed,
  replyToFeedback,
  type SubmitFeedbackPayload,
} from "./api";

export function useSubmitFeedback() {
  return useMutation({
    mutationFn: (payload: SubmitFeedbackPayload) => submitFeedback(payload),
  });
}

export function useFeedbackList(limit: number, offset: number) {
  return useQuery({
    queryKey: ["feedback", limit, offset],
    queryFn: () => getFeedbackList(limit, offset),
  });
}

export function useMarkFeedbackAsReviewed() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => markFeedbackAsReviewed(id),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["feedback"] });
      void queryClient.invalidateQueries({ queryKey: ["moderationCounts"] });
      toast.success("Marcado como revisado");
    },
    onError: () => {
      toast.error("Error al marcar como revisado");
    },
  });
}

export function useReplyToFeedback() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({
      id,
      adminNotes,
      replyMessage,
    }: {
      id: number;
      adminNotes: string;
      replyMessage: string;
    }) => replyToFeedback(id, adminNotes, replyMessage),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["feedback"] });
      void queryClient.invalidateQueries({ queryKey: ["moderationCounts"] });
      toast.success("Feedback actualizado y resuelto");
    },
    onError: (error) => {
      toast.error(error instanceof Error ? error.message : "Error al procesar el feedback");
    },
  });
}
