import { createFileRoute } from "@tanstack/react-router";

import { searchEvaluations } from "@/lib/evaluations/api";
import { EVALUATION_TYPE_LABELS, type EvaluationType } from "@/lib/evaluations/types";
import { buildSeoMeta } from "@/lib/seo";

type EvaluationsSearchInput = Record<string, unknown>;

export interface EvaluationsSearch {
  q?: string;
  type?: EvaluationType;
  page?: number;
}

const PAGE_SIZE = 25;
const VALID_TYPES = Object.keys(EVALUATION_TYPE_LABELS) as EvaluationType[];

export const Route = createFileRoute("/evaluations/")({
  head: () =>
    buildSeoMeta({
      title: "Evaluaciones y exámenes del TEC | Claustrum",
      description:
        "Explora exámenes y evaluaciones subidos por estudiantes del Tecnológico de Costa Rica, organizados por curso.",
      breadcrumbName: "Evaluaciones",
      urlPath: "/evaluations",
    }),
  validateSearch: (search: EvaluationsSearchInput): EvaluationsSearch => ({
    q: typeof search.q === "string" ? search.q : undefined,
    type:
      typeof search.type === "string" && VALID_TYPES.includes(search.type as EvaluationType)
        ? (search.type as EvaluationType)
        : undefined,
    page: search.page !== undefined ? Number(search.page) : undefined,
  }),
  loaderDeps: ({ search }) => ({ q: search.q, type: search.type, page: search.page }),
  loader: async ({ context: { queryClient }, deps }) => {
    const page = deps.page ? Math.max(0, deps.page - 1) : 0;
    const params = {
      q: deps.q?.trim() || undefined,
      type: deps.type,
      limit: PAGE_SIZE,
      offset: page * PAGE_SIZE,
    };

    await queryClient.ensureQueryData({
      queryKey: ["evaluationSearch", params],
      queryFn: () => searchEvaluations(params),
    });
  },
});
