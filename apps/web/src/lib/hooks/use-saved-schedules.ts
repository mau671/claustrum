import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";

import { apiClient } from "@/lib/api/client";

export type SavedSchedule = {
  id: number;
  name: string;
  academic_term_id: number;
  created_at: string;
  updated_at: string;
};

export type SavedScheduleItem = {
  id: number;
  saved_schedule_id: number;
  course_offering_group_id: number;
  course_code?: string;
  campus_id?: number | null;
  group_code?: string;
};

export function useSavedSchedules(userId: string | null) {
  return useQuery({
    queryKey: ["savedSchedules", userId],
    queryFn: async () => {
      const data = await apiClient<SavedSchedule[]>("/schedules");
      return data ?? [];
    },
    staleTime: 5 * 60 * 1000,
    enabled: !!userId,
  });
}

export function useSaveSchedule() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (payload: {
      name: string;
      academicTermId: number;
      groupLookups: Array<{
        courseCode: string;
        campusId: number | null;
        groupCode: string;
      }>;
    }) => {
      return apiClient<SavedSchedule>("/schedules", {
        method: "POST",
        body: JSON.stringify(payload),
      });
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["savedSchedules"] });
    },
  });
}

export function useDeleteSchedule() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (scheduleId: number) => {
      await apiClient(`/schedules/${scheduleId}`, {
        method: "DELETE",
      });
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["savedSchedules"] });
    },
  });
}

export function useScheduleItems(scheduleId: number | null) {
  return useQuery({
    queryKey: ["savedScheduleItems", scheduleId],
    queryFn: async () => {
      if (!scheduleId) return [];
      const data = await apiClient<SavedScheduleItem[]>(`/schedules/${scheduleId}/items`);
      return data ?? [];
    },
    enabled: !!scheduleId,
  });
}
