import { createFileRoute } from "@tanstack/react-router";

import { getEvaluationCourses } from "@/lib/evaluations/api";
import { EVALUATION_TYPE_LABELS, type EvaluationType } from "@/lib/evaluations/types";
import { buildSeoMeta } from "@/lib/seo";

type EvaluationsSearchInput = Record<string, unknown>;

export interface EvaluationsSearch {
  q?: string;
  types?: EvaluationType[];
}

const VALID_TYPES = Object.keys(EVALUATION_TYPE_LABELS) as EvaluationType[];

function parseTypes(value: unknown): EvaluationType[] | undefined {
  const raw = typeof value === "string" ? value.split(",") : Array.isArray(value) ? value : [];
  const types = raw.filter(
    (item): item is EvaluationType =>
      typeof item === "string" && VALID_TYPES.includes(item as EvaluationType),
  );
  return types.length > 0 ? types : undefined;
}

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
    q: typeof search.q === "string" && search.q.trim() !== "" ? search.q : undefined,
    types: parseTypes(search.types),
  }),
  loaderDeps: ({ search }) => ({ q: search.q, types: search.types }),
  loader: async ({ context: { queryClient }, deps }) => {
    const params = {
      q: deps.q?.trim() || undefined,
      types: deps.types,
    };

    await queryClient.ensureQueryData({
      queryKey: ["evaluationCourses", params],
      queryFn: () => getEvaluationCourses(params),
    });
  },
});
