import { createFileRoute } from "@tanstack/react-router";

import { searchProfessorReviewStats } from "@/lib/professor-reviews/api";
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

const PAGE_SIZE = 25;

export const Route = createFileRoute("/professors/")({
  head: () =>
    buildSeoMeta({
      title: "Reseñas y opiniones de profesores - TEC | Claustrum",
      description:
        "Explora calificaciones, opiniones y evaluaciones de profesores del Tecnológico de Costa Rica (ITCR) para planificar tu matrícula y horario.",
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
  loaderDeps: ({ search }) => ({
    q: search.q,
    ms: search.ms,
    mr: search.mr,
    r: search.r,
    sortBy: search.sortBy,
    sortDesc: search.sortDesc,
    page: search.page,
  }),
  loader: async ({ context: { queryClient }, deps }) => {
    const page = deps.page ? Math.max(0, deps.page - 1) : 0;
    const minAverageScore = deps.ms !== undefined && deps.ms.trim() !== "" ? Number(deps.ms) : null;
    const minReviewCount =
      deps.mr !== undefined && Number.isFinite(Number(deps.mr)) ? Number(deps.mr) : 0;
    const sortBy = deps.sortBy ?? "reviews";
    const activeSortBy = sortBy === "none" ? null : sortBy;
    const sortDesc = deps.sortDesc ?? true;

    const params = {
      query: (deps.q ?? "").trim(),
      minAverageScore,
      minReviewCount,
      academicUnitId: deps.r ?? null,
      onlyWithApprovedReviews: false,
      sortBy: activeSortBy,
      sortDesc,
      limit: PAGE_SIZE,
      offset: page * PAGE_SIZE,
    };

    await queryClient.ensureQueryData({
      queryKey: ["professorReviewStats", params],
      queryFn: () => searchProfessorReviewStats(params),
    });
  },
});
