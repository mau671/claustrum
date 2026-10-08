import { createLazyFileRoute } from "@tanstack/react-router";

import { InsetOnboardingPage } from "@/components/inset-onboarding";

export const Route = createLazyFileRoute("/onboarding/")({
  component: OnboardingPage,
});

function OnboardingPage() {
  return <InsetOnboardingPage />;
}
