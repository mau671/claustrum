import { createContext, use, useEffect, useMemo, type ReactNode } from "react";

import { useAuthUser } from "@/lib/hooks/use-queries";
import { resetSupabaseAuthTokenState } from "@/lib/supabase/browser-client";

export type AppAuthUser = NonNullable<ReturnType<typeof useAuthUser>["data"]>;

type AppAuthContextValue = {
  authUser: AppAuthUser;
  isAuthLoading: boolean;
};

const AppAuthContext = createContext<AppAuthContextValue | null>(null);

export function AppAuthProvider({ children }: { children: ReactNode }) {
  const { data: authUser, isLoading: isAuthLoading } = useAuthUser();

  useEffect(() => {
    if (!authUser) return;
    resetSupabaseAuthTokenState();
  }, [authUser]);

  const value = useMemo(
    () => ({ authUser: authUser ?? null, isAuthLoading }),
    [authUser, isAuthLoading],
  );

  return <AppAuthContext.Provider value={value}>{children}</AppAuthContext.Provider>;
}

export function useAppAuth() {
  const context = use(AppAuthContext);
  if (!context) {
    throw new Error("useAppAuth must be used within AppAuthProvider");
  }
  return context;
}
