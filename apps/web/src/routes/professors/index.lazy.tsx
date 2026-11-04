import { createLazyFileRoute } from "@tanstack/react-router";

import { ProfessorsReviewsPage } from "./-professors-page";

export const Route = createLazyFileRoute("/professors/")({
  component: ProfessorsReviewsPage,
});
