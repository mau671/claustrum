import { createLazyFileRoute } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

const ProfessorDetailPage = lazy(() =>
  import("./-professor-detail-page").then((module) => ({ default: module.ProfessorDetailPage })),
);

export const Route = createLazyFileRoute("/professors/$professorId")({
  component: ProfessorDetailRoute,
});

function ProfessorDetailRoute() {
  return (
    <Suspense fallback={<div className="bg-background flex-1" />}>
      <ProfessorDetailPage />
    </Suspense>
  );
}
