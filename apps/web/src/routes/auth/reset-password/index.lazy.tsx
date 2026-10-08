import { createLazyFileRoute } from "@tanstack/react-router";

import { AuthResetPasswordPage } from "@/components/auth-reset-password";

export const Route = createLazyFileRoute("/auth/reset-password/")({
  component: ResetPasswordRoute,
});

function ResetPasswordRoute() {
  return <AuthResetPasswordPage />;
}
