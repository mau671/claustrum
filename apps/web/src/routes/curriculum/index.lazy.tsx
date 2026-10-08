import { createLazyFileRoute } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

const CurriculumPage = lazy(() =>
  import("./-curriculum-page").then((module) => ({ default: module.CurriculumPage })),
);

export const Route = createLazyFileRoute("/curriculum/")({
  component: CurriculumRoute,
});

function CurriculumRoute() {
  return (
    <Suspense fallback={<div className="bg-background flex-1" />}>
      <CurriculumPage />
    </Suspense>
  );
}
