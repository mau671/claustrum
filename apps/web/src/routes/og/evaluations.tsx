import { createFileRoute } from "@tanstack/react-router";

import { OgEvaluationsCard } from "./-evaluations-card";

export const Route = createFileRoute("/og/evaluations")({
  component: OgEvaluationsRoute,
});

function OgEvaluationsRoute() {
  return <OgEvaluationsCard />;
}
