import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";

import { getSupabaseBrowserClient } from "@/lib/supabase/browser-client";

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
};

export function useSavedSchedules(userId: string | null) {
  return useQuery({
    queryKey: ["savedSchedules", userId],
    queryFn: async () => {
      const sb = getSupabaseBrowserClient();
      const { data, error } = await sb
        .from("saved_schedule")
        .select("*")
        .order("updated_at", { ascending: false });
      if (error) throw error;
      return data as SavedSchedule[];
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
      const sb = getSupabaseBrowserClient();

      const { data, error } = await sb
        .rpc("save_user_schedule", {
          p_name: payload.name,
          p_academic_term_id: payload.academicTermId,
          p_group_lookups: payload.groupLookups,
        })
        .single();

      if (error) throw error;

      return data as SavedSchedule;
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
      const sb = getSupabaseBrowserClient();
      const { error } = await sb.from("saved_schedule").delete().eq("id", scheduleId);
      if (error) throw error;
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
      const sb = getSupabaseBrowserClient();
      const { data, error } = await sb
        .from("saved_schedule_item")
        .select("*")
        .eq("saved_schedule_id", scheduleId);
      if (error) throw error;
      return data as SavedScheduleItem[];
    },
    enabled: !!scheduleId,
  });
}
