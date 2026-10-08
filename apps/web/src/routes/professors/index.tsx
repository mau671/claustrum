import { createFileRoute } from "@tanstack/react-router";

import { buildSeoMeta } from "@/lib/seo";

type ProfessorsSearchInput = Record<string, unknown>;

export interface ProfessorsSearch {
  q?: string;
  ms?: string;
  mr?: string;
  r?: number;
  sortBy?: string;
  sortDesc?: boolean;
  page?: number;
}

export const Route = createFileRoute("/professors/")({
  head: () =>
    buildSeoMeta({
      title: "Reseñas y evaluaciones de profesores | Claustrum",
      description:
        "Explora, lee y comparte opiniones sobre profesores para planificar tu próximo semestre.",
      breadcrumbName: "Profesores",
      urlPath: "/professors",
      image: "/og/og-professors.png",
    }),
  validateSearch: (search: ProfessorsSearchInput): ProfessorsSearch => {
    return {
      q: typeof search.q === "string" ? search.q : undefined,
      ms: typeof search.ms === "string" ? search.ms : undefined,
      mr: typeof search.mr === "string" ? search.mr : undefined,
      r: search.r !== undefined && !isNaN(Number(search.r)) ? Number(search.r) : undefined,
      sortBy: typeof search.sortBy === "string" ? search.sortBy : undefined,
      sortDesc:
        typeof search.sortDesc === "boolean"
          ? search.sortDesc
          : search.sortDesc === "true"
            ? true
            : search.sortDesc === "false"
              ? false
              : undefined,
      page: search.page !== undefined ? Number(search.page) : undefined,
    };
  },
});
