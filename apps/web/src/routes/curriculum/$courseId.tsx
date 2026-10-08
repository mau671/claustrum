import { createFileRoute, redirect } from "@tanstack/react-router";

import { parseCurriculumSearch } from "./-curriculum-search";

export const Route = createFileRoute("/curriculum/$courseId")({
  validateSearch: parseCurriculumSearch,
  beforeLoad: ({ search, params }) => {
    if (search.plan) {
      throw redirect({
        to: "/curriculum/$planId/$courseId",
        params: {
          planId: search.plan.toString(),
          courseId: params.courseId,
        },
        replace: true,
      });
    } else {
      // If no plan is specified in the old URL, fallback to curriculum home
      throw redirect({
        to: "/curriculum",
        replace: true,
      });
    }
  },
});
