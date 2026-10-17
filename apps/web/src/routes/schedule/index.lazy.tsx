import { createLazyFileRoute } from "@tanstack/react-router";

import { SchedulePage } from "./-schedule-page";

export const Route = createLazyFileRoute("/schedule/")({
  component: ScheduleRoute,
});

function ScheduleRoute() {
  return <SchedulePage />;
}
