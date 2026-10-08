import { createLazyFileRoute } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

const SchedulePage = lazy(() =>
  import("./-schedule-page").then((module) => ({ default: module.SchedulePage })),
);

export const Route = createLazyFileRoute("/schedule/")({
  component: ScheduleRoute,
});

function ScheduleRoute() {
  return (
    <Suspense fallback={<div className="bg-background flex-1" />}>
      <SchedulePage />
    </Suspense>
  );
}
