import { createLazyFileRoute } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

const ProfessorsReviewsPage = lazy(() =>
  import("./-professors-page").then((module) => ({ default: module.ProfessorsReviewsPage })),
);

export const Route = createLazyFileRoute("/professors/")({
  component: ProfessorsRoute,
});

function ProfessorsRoute() {
  return (
    <Suspense fallback={<div className="bg-background flex-1" />}>
      <ProfessorsReviewsPage />
    </Suspense>
  );
}
