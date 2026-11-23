import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";

import { apiClient } from "@/lib/api/client";
import { authClient } from "@/lib/auth/client";

export const ADMIN_USER_ROLES = ["admin", "moderator", "user"] as const;
export type AdminUserRole = (typeof ADMIN_USER_ROLES)[number];

export const ADMIN_USER_SORT_FIELDS = [
  "name",
  "email",
  "role",
  "banned",
  "createdAt",
  "updatedAt",
] as const;
export type AdminUserSortBy = (typeof ADMIN_USER_SORT_FIELDS)[number];

export interface AdminUser {
  id: string;
  name: string;
  email: string;
  emailVerified: boolean;
  image: string | null;
  role: string | null;
  banned: boolean | null;
  banReason: string | null;
  banExpires: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface AdminUsersResponse {
  users: AdminUser[];
  total: number;
}

export interface UserAcademicProfile {
  user_id: string;
  carnet: string | null;
  university_id: number | null;
  university_name: string | null;
  campus_id: number | null;
  campus_name: string | null;
  academic_unit_id: number | null;
  academic_unit_name: string | null;
  study_plan_id: number | null;
  study_plan_name: string | null;
  user_study_plan_id: number | null;
  entry_year: number | null;
  term_id: number | null;
  onboarding_completed_at: string | null;
  onboarding_dismissed_at: string | null;
}

export interface UserFeedbackItem {
  id: number;
  type: "bug" | "feature" | "other";
  content: string;
  is_reviewed: boolean;
  created_at: string;
  user_id: string | null;
  admin_notes: string | null;
}

export interface UserNotificationItem {
  id: string;
  user_id: string | null;
  title: string;
  message: string;
  link: string | null;
  is_read: boolean;
  created_at: string;
}

export interface UserSessionItem {
  id: string;
  token: string;
  userId: string;
  expiresAt: Date | string;
  createdAt: Date | string;
  updatedAt: Date | string;
  ipAddress?: string | null;
  userAgent?: string | null;
  impersonatedBy?: string | null;
}

export interface AdminUsersFilters {
  /** 1-based page number. */
  page: number;
  pageSize: number;
  search?: string;
  role?: AdminUserRole | "all";
  banned?: "all" | "true" | "false";
  sortBy?: AdminUserSortBy;
  sortDesc?: boolean;
}

function buildUsersQuery(filters: AdminUsersFilters): string {
  const params = new URLSearchParams();
  params.set("limit", String(filters.pageSize));
  params.set("offset", String(Math.max(filters.page - 1, 0) * filters.pageSize));

  const search = filters.search?.trim();
  if (search) params.set("search", search);
  if (filters.role && filters.role !== "all") params.set("role", filters.role);
  if (filters.banned && filters.banned !== "all") params.set("banned", filters.banned);
  if (filters.sortBy) params.set("sortBy", filters.sortBy);
  if (filters.sortDesc !== undefined) params.set("sortDesc", String(filters.sortDesc));

  return params.toString();
}

function adminUsersQueryKey(filters: AdminUsersFilters) {
  return [
    "adminUsers",
    filters.page,
    filters.pageSize,
    filters.search?.trim() ?? "",
    filters.role ?? "all",
    filters.banned ?? "all",
    filters.sortBy ?? "",
    filters.sortDesc ?? "",
  ] as const;
}

export function useAdminUsers(filters: AdminUsersFilters, enabled = true) {
  return useQuery({
    queryKey: adminUsersQueryKey(filters),
    queryFn: () => apiClient<AdminUsersResponse>(`/users?${buildUsersQuery(filters)}`),
    enabled,
    placeholderData: (previousData) => previousData,
    staleTime: 30_000,
  });
}

export function adminUserQueryOptions(id: string, initialData?: AdminUser | null) {
  return {
    queryKey: ["adminUser", id] as const,
    queryFn: () => apiClient<AdminUser>(`/users/${encodeURIComponent(id)}`),
    staleTime: 30_000,
    ...(initialData ? { initialData } : {}),
  };
}

export function useAdminUser(id: string | null, enabled = true, initialData?: AdminUser | null) {
  return useQuery({
    ...adminUserQueryOptions(id ?? "", initialData),
    enabled: enabled && Boolean(id),
  });
}

function useInvalidateAdminUsers() {
  const queryClient = useQueryClient();
  return () => {
    void queryClient.invalidateQueries({ queryKey: ["adminUsers"] });
    void queryClient.invalidateQueries({ queryKey: ["adminUser"] });
    void queryClient.invalidateQueries({ queryKey: ["appState"] });
    void queryClient.invalidateQueries({ queryKey: ["moderationCounts"] });
  };
}

export function useUpdateAdminUserRole() {
  const invalidate = useInvalidateAdminUsers();
  return useMutation({
    mutationFn: ({ id, role }: { id: string; role: AdminUserRole }) =>
      apiClient<{ success: boolean }>(`/users/${encodeURIComponent(id)}/role`, {
        method: "PATCH",
        body: JSON.stringify({ role }),
      }),
    onSuccess: invalidate,
  });
}

export function useBanAdminUser() {
  const invalidate = useInvalidateAdminUsers();
  return useMutation({
    mutationFn: ({
      id,
      reason,
      expiresInSeconds,
    }: {
      id: string;
      reason?: string;
      expiresInSeconds?: number;
    }) =>
      apiClient<{ success: boolean }>(`/users/${encodeURIComponent(id)}/ban`, {
        method: "POST",
        body: JSON.stringify({ reason: reason?.trim() || undefined, expiresInSeconds }),
      }),
    onSuccess: invalidate,
  });
}

export function useUnbanAdminUser() {
  const invalidate = useInvalidateAdminUsers();
  return useMutation({
    mutationFn: (id: string) =>
      apiClient<{ success: boolean }>(`/users/${encodeURIComponent(id)}/ban`, {
        method: "DELETE",
      }),
    onSuccess: invalidate,
  });
}

export function useDeleteAdminUser() {
  const invalidate = useInvalidateAdminUsers();
  return useMutation({
    mutationFn: (id: string) =>
      apiClient<{ success: boolean }>(`/users/${encodeURIComponent(id)}`, {
        method: "DELETE",
      }),
    onSuccess: invalidate,
  });
}

export function useUpdateAdminUserIdentity() {
  const invalidate = useInvalidateAdminUsers();
  return useMutation({
    mutationFn: async ({ id, name, email }: { id: string; name?: string; email?: string }) => {
      const data: Record<string, string> = {};
      if (name !== undefined) data.name = name;
      if (email !== undefined) data.email = email;
      const result = await authClient.admin.updateUser({ userId: id, data });
      if (result.error) {
        throw new Error(result.error.message ?? "No se pudo actualizar el usuario.");
      }
      return result.data;
    },
    onSuccess: invalidate,
  });
}

export function useUpdateAdminUserVerification() {
  const invalidate = useInvalidateAdminUsers();
  return useMutation({
    mutationFn: ({ id, verified }: { id: string; verified: boolean }) =>
      apiClient<{ success: boolean }>(`/users/${encodeURIComponent(id)}/verification`, {
        method: "PATCH",
        body: JSON.stringify({ verified }),
      }),
    onSuccess: invalidate,
  });
}

export function adminUserAcademicProfileQueryOptions(id: string) {
  return {
    queryKey: ["adminUserAcademicProfile", id] as const,
    queryFn: () =>
      apiClient<UserAcademicProfile>(`/users/${encodeURIComponent(id)}/academic-profile`),
    staleTime: 60_000,
  };
}

export function useAdminUserAcademicProfile(id: string | null, enabled = true) {
  return useQuery({
    ...adminUserAcademicProfileQueryOptions(id ?? ""),
    enabled: enabled && Boolean(id),
  });
}

export function useUpdateAdminUserAcademicProfile() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({
      id,
      carnet,
      campusId,
      studyPlanId,
      entryYear,
    }: {
      id: string;
      carnet?: string | null;
      campusId?: number;
      studyPlanId?: number;
      entryYear?: number;
    }) =>
      apiClient<{ success: boolean }>(`/users/${encodeURIComponent(id)}/academic-profile`, {
        method: "PATCH",
        body: JSON.stringify({ carnet, campusId, studyPlanId, entryYear }),
      }),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["adminUserAcademicProfile"] });
      void queryClient.invalidateQueries({ queryKey: ["adminUsers"] });
      void queryClient.invalidateQueries({ queryKey: ["adminUser"] });
    },
  });
}

export function adminUserFeedbackQueryOptions(id: string) {
  return {
    queryKey: ["adminUserFeedback", id] as const,
    queryFn: () => apiClient<UserFeedbackItem[]>(`/users/${encodeURIComponent(id)}/feedback`),
    staleTime: 60_000,
  };
}

export function useAdminUserFeedback(id: string | null, enabled = true) {
  return useQuery({
    ...adminUserFeedbackQueryOptions(id ?? ""),
    enabled: enabled && Boolean(id),
  });
}

export function adminUserNotificationsQueryOptions(id: string) {
  return {
    queryKey: ["adminUserNotifications", id] as const,
    queryFn: () =>
      apiClient<UserNotificationItem[]>(`/users/${encodeURIComponent(id)}/notifications`),
    staleTime: 30_000,
  };
}

export function useAdminUserNotifications(id: string | null, enabled = true) {
  return useQuery({
    ...adminUserNotificationsQueryOptions(id ?? ""),
    enabled: enabled && Boolean(id),
  });
}

export function useSendAdminNotification() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({
      id,
      title,
      message,
      link,
    }: {
      id: string;
      title: string;
      message: string;
      link?: string;
    }) =>
      apiClient<{ success: boolean }>(`/users/${encodeURIComponent(id)}/notifications`, {
        method: "POST",
        body: JSON.stringify({ title, message, link: link?.trim() || undefined }),
      }),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["adminUserNotifications"] });
    },
  });
}

export function adminUserSessionsQueryOptions(id: string) {
  return {
    queryKey: ["adminUserSessions", id] as const,
    queryFn: async (): Promise<UserSessionItem[]> => {
      const result = await authClient.admin.listUserSessions({ userId: id });
      if (result.error) {
        throw new Error(result.error.message ?? "No se pudieron cargar las sesiones.");
      }
      return (result.data?.sessions ?? []) as UserSessionItem[];
    },
    staleTime: 30_000,
  };
}

export function useAdminUserSessions(id: string | null, enabled = true) {
  return useQuery({
    ...adminUserSessionsQueryOptions(id ?? ""),
    enabled: enabled && Boolean(id),
  });
}

export function usePrefetchAdminUserDetails() {
  const queryClient = useQueryClient();
  return (id: string, user: AdminUser) => {
    queryClient.setQueryData(adminUserQueryOptions(id).queryKey, user);
    void queryClient.prefetchQuery(adminUserAcademicProfileQueryOptions(id));
    void queryClient.prefetchQuery(adminUserFeedbackQueryOptions(id));
    void queryClient.prefetchQuery(adminUserNotificationsQueryOptions(id));
    void queryClient.prefetchQuery(adminUserSessionsQueryOptions(id));
  };
}

export function useRevokeAdminUserSession() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (sessionToken: string) => {
      const result = await authClient.admin.revokeUserSession({ sessionToken });
      if (result.error) {
        throw new Error(result.error.message ?? "No se pudo revocar la sesión.");
      }
      return result.data;
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["adminUserSessions"] });
    },
  });
}

export function useRevokeAllAdminUserSessions() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (userId: string) => {
      const result = await authClient.admin.revokeUserSessions({ userId });
      if (result.error) {
        throw new Error(result.error.message ?? "No se pudieron revocar las sesiones.");
      }
      return result.data;
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["adminUserSessions"] });
    },
  });
}
