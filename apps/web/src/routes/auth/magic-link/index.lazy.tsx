import { createLazyFileRoute } from "@tanstack/react-router";

import { AuthMagicLinkSentPage } from "@/components/auth-magic-link-sent";

export const Route = createLazyFileRoute("/auth/magic-link/")({
  component: MagicLinkSentRoute,
});

function MagicLinkSentRoute() {
  return <AuthMagicLinkSentPage />;
}
