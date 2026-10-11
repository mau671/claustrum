import { CheckIcon } from "@hugeicons/core-free-icons";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useEffect } from "react";

import { Icon } from "@/components/ui/icon";
import { toast } from "@/components/ui/toast";
import { apiClient, getApiV1Url } from "@/lib/api/client";

export interface NotificationRow {
  id: string;
  user_id: string;
  title: string;
  message: string;
  link: string | null;
  is_read: boolean;
  created_at: string;
}

export function useNotifications(userId?: string | null) {
  const queryClient = useQueryClient();

  useEffect(() => {
    if (!userId || typeof window === "undefined") return;

    let eventSource: EventSource | null = null;
    try {
      const streamUrl = getApiV1Url("/notifications/stream");
      eventSource = new EventSource(streamUrl, { withCredentials: true });

      eventSource.onmessage = (event) => {
        try {
          const data = JSON.parse(event.data);
          if (data && typeof data === "object" && "title" in data && "message" in data) {
            void queryClient.invalidateQueries({ queryKey: ["notifications", userId] });
            const notif = data as NotificationRow;

            toast.info(notif.title, {
              description: notif.message,
              action: {
                label: (
                  <div className="flex items-center gap-1.5">
                    <Icon icon={CheckIcon} size={14} className="size-3.5" />
                    <span>Visto</span>
                  </div>
                ),
                onClick: () => {
                  void apiClient(`/notifications/${notif.id}`, {
                    method: "PATCH",
                    body: JSON.stringify({ isRead: true }),
                  }).then(() => {
                    void queryClient.invalidateQueries({ queryKey: ["notifications", userId] });
                  });
                },
              },
            });
          } else {
            void queryClient.invalidateQueries({ queryKey: ["notifications", userId] });
          }
        } catch {
          // ignore non-json messages / heartbeat
        }
      };

      eventSource.onerror = () => {
        // Fallback handled by browser EventSource reconnecting
      };
    } catch {
      // EventSource instantiation fallback
    }

    return () => {
      if (eventSource) {
        eventSource.close();
      }
    };
  }, [userId, queryClient]);

  return useQuery({
    queryKey: ["notifications", userId ?? "anonymous"],
    queryFn: async () => {
      const data = await apiClient<NotificationRow[]>("/notifications");
      return data ?? [];
    },
    staleTime: 10_000,
  });
}

export function useMarkNotificationAsRead() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (id: string) => {
      await apiClient(`/notifications/${id}`, {
        method: "PATCH",
        body: JSON.stringify({ isRead: true }),
      });
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["notifications"] });
    },
  });
}

export function useMarkAllNotificationsAsRead() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (_userId?: string) => {
      await apiClient("/notifications/read", {
        method: "POST",
      });
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["notifications"] });
    },
  });
}
