import { createLazyFileRoute } from "@tanstack/react-router";

import { EvaluationsPage } from "./-evaluations-page";

export const Route = createLazyFileRoute("/evaluations/")({
  component: EvaluationsPage,
});
