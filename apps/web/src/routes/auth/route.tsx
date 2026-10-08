import { createFileRoute, Outlet, redirect } from "@tanstack/react-router";

import { AuthShell } from "@/components/auth-shell";
import { appStateQueryOptions } from "@/lib/hooks/use-queries";
import { buildSeoMeta, NOINDEX_ROBOTS } from "@/lib/seo";

export const Route = createFileRoute("/auth")({
  head: () =>
    buildSeoMeta({
      title: "Autenticación | Claustrum",
      robots: NOINDEX_ROBOTS,
    }),
  beforeLoad: async ({ context: { queryClient }, location }) => {
    if (location.pathname === "/auth" || location.pathname === "/auth/") {
      throw redirect({ to: "/auth/signin", replace: true });
    }

    // Redirect authenticated users away from login/signup pages
    const isLoginRoute = ["/auth/signin", "/auth/signup", "/auth/magic-link"].includes(
      location.pathname,
    );
    if (isLoginRoute) {
      try {
        const appState = await queryClient.fetchQuery(appStateQueryOptions());
        const authData = appState?.user;
        if (authData?.id) {
          throw redirect({ to: "/overview", replace: true });
        }
      } catch (err: any) {
        if (err?.isRedirect) throw err;
      }
    }
  },
  component: AuthRoute,
});

function AuthRoute() {
  return (
    <AuthShell>
      <Outlet />
    </AuthShell>
  );
}
