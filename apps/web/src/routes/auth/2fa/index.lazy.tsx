import { createLazyFileRoute } from "@tanstack/react-router";

import { AuthTwoFactorPage } from "@/components/auth-two-factor";

export const Route = createLazyFileRoute("/auth/2fa/")({
  component: TwoFactorRoute,
});

function TwoFactorRoute() {
  return <AuthTwoFactorPage />;
}
