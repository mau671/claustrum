import type { AppRole } from "@/lib/auth/permissions";

import { useAuthUser } from "@/lib/hooks/use-queries";

export function useUserRole(): AppRole {
  const { data: user } = useAuthUser();
  const role = (user as { role?: string } | null | undefined)?.role;
  if (role === "admin" || role === "moderator") {
    return role;
  }
  return "user";
}

export function useCanModerate(): boolean {
  const role = useUserRole();
  return role === "admin" || role === "moderator";
}

export function useIsAdmin(): boolean {
  const role = useUserRole();
  return role === "admin";
}
