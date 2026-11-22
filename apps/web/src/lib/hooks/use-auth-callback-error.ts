import { useSearch } from "@tanstack/react-router";

import { type AuthCallbackError, getAuthCallbackError } from "@/lib/auth/auth-error-messages";

export function useAuthCallbackError(): AuthCallbackError | null {
  const search = useSearch({
    strict: false,
    structuralSharing: false,
  }) as Record<string, unknown>;

  return getAuthCallbackError(search);
}
