import { createFileRoute } from "@tanstack/react-router";

import {
  getProfessorById,
  getProfessorReviewsPublic,
  getProfessorReviewSummary,
  getProfessorTeachingHistory,
} from "@/lib/professor-reviews/api";
import { buildSeoMeta, INDEXABLE_ROBOTS, NOINDEX_ROBOTS } from "@/lib/seo";

type ProfessorDetailSearchInput = Record<string, unknown>;

export interface ProfessorDetailSearch {
  page?: number;
}

export const Route = createFileRoute("/professors/$professorId")({
  validateSearch: (search: ProfessorDetailSearchInput): ProfessorDetailSearch => {
    return {
      page: search.page !== undefined ? Number(search.page) : undefined,
    };
  },
  loaderDeps: ({ search }) => ({
    page: search.page,
  }),
  loader: async ({ context: { queryClient }, params: { professorId }, deps }) => {
    if (!/^\d+$/.test(professorId)) return null;
    const pageIndex = deps.page ? Math.max(0, deps.page - 1) : 0;

    const [professor, summary, reviews, history] = await Promise.all([
      queryClient
        .ensureQueryData({
          queryKey: ["professorById", professorId],
          queryFn: () => getProfessorById(professorId),
        })
        .catch(() => null),
      queryClient
        .ensureQueryData({
          queryKey: ["professorReviewSummary", professorId],
          queryFn: () => getProfessorReviewSummary(professorId),
        })
        .catch(() => null),
      queryClient
        .ensureQueryData({
          queryKey: ["professorReviewsPublic", professorId, pageIndex, 10],
          queryFn: () => getProfessorReviewsPublic(professorId, 10, pageIndex * 10),
        })
        .catch(() => null),
      queryClient
        .ensureQueryData({
          queryKey: ["professorTeachingHistory", professorId],
          queryFn: () => getProfessorTeachingHistory(professorId),
        })
        .catch(() => null),
    ]);

    return {
      professor,
      summary,
      reviews,
      history,
    };
  },
  head: (ctx) => {
    const data = ctx.loaderData;
    const professor = data?.professor;
    const summary = data?.summary;
    const reviews = data?.reviews;
    const history = data?.history;

    const rawName = professor?.full_name ?? "Profesor";
    const name = rawName.replace(
      /\w\S*/g,
      (txt) => txt.charAt(0).toUpperCase() + txt.slice(1).toLowerCase(),
    );

    const reviewCount = summary?.approved_review_count ?? 0;
    const avgScore =
      summary?.average_overall_score !== null && summary?.average_overall_score !== undefined
        ? summary.average_overall_score.toFixed(1)
        : null;

    let description: string;
    if (reviewCount > 0 && avgScore !== null) {
      const reviewWord = reviewCount === 1 ? "reseña" : "reseñas";
      description = `Opiniones y calificaciones de ${name}, docente del TEC (ITCR). Calificación promedio de ${avgScore}/10 basada en ${reviewCount} ${reviewWord}. Resumen de la comunidad y materias impartidas.`;
    } else {
      description = `Opiniones, calificaciones y materias impartidas de ${name}, docente del Tecnológico de Costa Rica (TEC, ITCR). Consulta su historial docente en Claustrum.`;
    }

    const hasReviews = reviewCount > 0;
    const hasHistory = Array.isArray(history) && history.length > 0;
    const isIndexable = !!professor && (hasReviews || hasHistory);
    const robots = isIndexable ? INDEXABLE_ROBOTS : NOINDEX_ROBOTS;

    const jsonLd: Record<string, unknown>[] = [];

    const personSchema: Record<string, unknown> = {
      "@context": "https://schema.org",
      "@type": "Person",
      name,
      jobTitle: "Docente universitario",
      worksFor: {
        "@type": "EducationalOrganization",
        name: "Instituto Tecnológico de Costa Rica",
        alternateName: ["TEC", "ITCR"],
        url: "https://www.tec.ac.cr",
      },
    };

    if (reviewCount > 0 && avgScore !== null) {
      personSchema.aggregateRating = {
        "@type": "AggregateRating",
        ratingValue: avgScore,
        bestRating: "10",
        worstRating: "0",
        ratingCount: reviewCount,
      };

      if (reviews && reviews.length > 0) {
        personSchema.review = reviews.slice(0, 5).map((r) => ({
          "@type": "Review",
          reviewBody: r.comment,
          datePublished: r.created_at,
          author: {
            "@type": "Person",
            name: "Estudiante anónimo",
          },
          ...(r.quality_score !== null
            ? {
                reviewRating: {
                  "@type": "Rating",
                  ratingValue: r.quality_score.toFixed(1),
                  bestRating: "10",
                  worstRating: "0",
                },
              }
            : {}),
        }));
      }
    }

    jsonLd.push(personSchema);

    return buildSeoMeta({
      title: `Opiniones y calificaciones de ${name} - TEC | Claustrum`,
      description,
      breadcrumbName: name,
      urlPath: `/professors/${ctx.params.professorId}`,
      image: "/og/og-professors.png",
      ogType: "profile",
      robots,
      jsonLd,
    });
  },
});
