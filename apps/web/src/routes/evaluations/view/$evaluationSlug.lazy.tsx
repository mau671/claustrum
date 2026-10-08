import { createLazyFileRoute } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

const EvaluationViewPage = lazy(() =>
  import("./-view-page").then((module) => ({ default: module.EvaluationViewPage })),
);

export const Route = createLazyFileRoute("/evaluations/view/$evaluationSlug")({
  component: EvaluationSlugRoute,
});

function EvaluationSlugRoute() {
  return (
    <Suspense fallback={<div className="bg-background flex-1" />}>
      <EvaluationViewPage />
    </Suspense>
  );
}
