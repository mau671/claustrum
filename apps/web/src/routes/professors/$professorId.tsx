import { createFileRoute } from "@tanstack/react-router";

import { getProfessorById } from "@/lib/professor-reviews/api";
import { buildSeoMeta } from "@/lib/seo";

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
  loader: async ({ context: { queryClient }, params: { professorId } }) => {
    if (!/^\d+$/.test(professorId)) return null;
    return queryClient
      .ensureQueryData({
        queryKey: ["professorById", professorId],
        queryFn: () => getProfessorById(professorId),
      })
      .catch(() => null);
  },
  head: (ctx) => {
    const professor = ctx.loaderData;
    const rawName = professor?.full_name ?? "Profesor";
    const name = rawName.replace(
      /\w\S*/g,
      (txt) => txt.charAt(0).toUpperCase() + txt.slice(1).toLowerCase(),
    );

    return buildSeoMeta({
      title: `Reseñas y calificaciones de ${name} - TEC | Claustrum`,
      description: `Lee opiniones y evaluaciones sobre ${name}, docente del Tecnológico de Costa Rica (ITCR). Descubre las experiencias de otros estudiantes con sus cursos.`,
      breadcrumbName: name,
      urlPath: `/professors/${ctx.params.professorId}`,
      image: "/og/og-professors.png",
      ogType: "profile",
      jsonLd: [
        {
          "@context": "https://schema.org",
          "@type": "Person",
          name: name,
          jobTitle: "Profesor",
          worksFor: {
            "@type": "EducationalOrganization",
            name: "Instituto Tecnológico de Costa Rica",
          },
        },
      ],
    });
  },
});
