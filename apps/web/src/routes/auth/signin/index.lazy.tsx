import { createLazyFileRoute } from "@tanstack/react-router";

import { InsetSigninPage } from "@/components/inset-auth";

export const Route = createLazyFileRoute("/auth/signin/")({
  component: SigninPage,
});

function SigninPage() {
  return <InsetSigninPage />;
}
