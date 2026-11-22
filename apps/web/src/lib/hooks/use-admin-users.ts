import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";

import { apiClient } from "@/lib/api/client";

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

export function useAdminUser(id: string | null, enabled = true) {
  return useQuery({
    queryKey: ["adminUser", id],
    queryFn: () => apiClient<AdminUser>(`/users/${encodeURIComponent(id ?? "")}`),
    enabled: enabled && Boolean(id),
    staleTime: 30_000,
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
