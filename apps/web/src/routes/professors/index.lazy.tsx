import { createLazyFileRoute, ClientOnly } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

const ProfessorsReviewsPage = lazy(() =>
  import("./-professors-page").then((module) => ({ default: module.ProfessorsReviewsPage })),
);

export const Route = createLazyFileRoute("/professors/")({
  component: ProfessorsRoute,
});

function ProfessorsRoute() {
  return (
    <ClientOnly fallback={<div className="bg-background min-h-[50vh] flex-1" />}>
      <Suspense fallback={<div className="bg-background min-h-[50vh] flex-1" />}>
        <ProfessorsReviewsPage />
      </Suspense>
    </ClientOnly>
  );
}
