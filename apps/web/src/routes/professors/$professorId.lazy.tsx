import { createLazyFileRoute } from "@tanstack/react-router";

import { ProfessorDetailPage } from "./-professor-detail-page";

export const Route = createLazyFileRoute("/professors/$professorId")({
  component: ProfessorDetailPage,
});
