import { createFileRoute } from "@tanstack/react-router";

import { studyPlanDetailQueryOptions } from "@/lib/hooks/use-queries";
import { buildSeoMeta, NOINDEX_ROBOTS } from "@/lib/seo";

// This route uses standard path parameters, no need for complex search parsing.
type CourseDetailSearch = {
  action?: string;
  filters?: boolean;
};

export const Route = createFileRoute("/curriculum/$planId/$courseId")({
  head: () =>
    buildSeoMeta({
      title: "Detalles del Curso | Claustrum",
      robots: NOINDEX_ROBOTS,
    }),
  validateSearch: (search: Record<string, unknown>): CourseDetailSearch => {
    return {
      action: search.action as string | undefined,
      filters: search.filters === true || search.filters === "true" ? true : undefined,
    };
  },
  loader: async ({ context: { queryClient }, params }) => {
    await queryClient.ensureQueryData(studyPlanDetailQueryOptions(Number(params.planId)));
  },
  pendingComponent: () => <div className="bg-background flex-1" />,
});
