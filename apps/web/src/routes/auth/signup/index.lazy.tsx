import { createLazyFileRoute } from "@tanstack/react-router";

import { InsetSignupPage } from "@/components/inset-auth";

export const Route = createLazyFileRoute("/auth/signup/")({
  component: SignupPage,
});

function SignupPage() {
  return <InsetSignupPage />;
}
