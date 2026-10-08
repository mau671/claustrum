import { createFileRoute, redirect } from "@tanstack/react-router";

import {
  universitiesQueryOptions,
  campusesQueryOptions,
  academicUnitsQueryOptions,
  studyPlansQueryOptions,
  academicTermsQueryOptions,
  scheduleCoursesQueryOptions,
  appStateQueryOptions,
} from "@/lib/hooks/use-queries";
import { buildSeoMeta } from "@/lib/seo";

import {
  hasLegacyScheduleSearchParams,
  parseScheduleSearch,
  SCHEDULE_DEFAULT_UNIVERSITY_ID,
  toScheduleUrlSearch,
} from "./-schedule-search";

export const Route = createFileRoute("/schedule/")({
  head: () =>
    buildSeoMeta({
      title: "Generador de horarios para el TEC | Claustrum",
      description:
        "Creador de horarios interactivo para estudiantes del Tecnológico de Costa Rica (ITCR). Arma tu semestre, compara opciones de cursos y planifica tu matrícula.",
      breadcrumbName: "Horarios",
      urlPath: "/schedule",
      image: "/og/og-schedule.png",
    }),
  validateSearch: parseScheduleSearch,
  search: {
    middlewares: [
      ({ search, next }) => toScheduleUrlSearch(next(search)) as unknown as typeof search,
    ],
  },
  beforeLoad: ({ search, location, context: { queryClient } }) => {
    const hasLegacyParams = hasLegacyScheduleSearchParams(location.searchStr);
    if (
      hasLegacyParams ||
      (search.university !== undefined && search.university !== SCHEDULE_DEFAULT_UNIVERSITY_ID)
    ) {
      throw redirect({
        to: "/schedule",
        search: {
          ...search,
          university: undefined,
        },
        replace: true,
      });
    }

    const hasMeaningfulSearch =
      !!search.campus || !!search.career || !!search.plan || !!search.term;
    if (!hasMeaningfulSearch) {
      const appState = queryClient.getQueryData(appStateQueryOptions().queryKey);
      const profile = appState?.profileContext;

      if (profile && profile.study_plan_id) {
        throw redirect({
          to: "/schedule",
          search: {
            ...search,
            campus: profile.campus_id ?? undefined,
            career: profile.academic_unit_id ?? undefined,
            plan: profile.study_plan_id ?? undefined,
            term: profile.term_id ? Number(profile.term_id) : undefined,
          },
          replace: true,
        });
      }
    }
  },
  loaderDeps: ({ search }) => ({
    university: search.university,
    campus: search.campus,
    career: search.career,
    plan: search.plan,
    term: search.term,
    otherCampuses: search.otherCampuses,
    showAll: search.showAll,
  }),
  loader: async ({ context: { queryClient }, deps }) => {
    const promises: Promise<unknown>[] = [];
    promises.push(queryClient.ensureQueryData(universitiesQueryOptions()));

    const u = deps.university ?? SCHEDULE_DEFAULT_UNIVERSITY_ID;
    if (u) promises.push(queryClient.ensureQueryData(campusesQueryOptions(u)));
    if (deps.campus)
      promises.push(queryClient.ensureQueryData(academicUnitsQueryOptions(deps.campus)));
    if (deps.career)
      promises.push(queryClient.ensureQueryData(studyPlansQueryOptions(deps.career)));
    if (deps.campus)
      promises.push(
        queryClient.ensureQueryData(academicTermsQueryOptions(deps.campus, deps.plan ?? null)),
      );

    if (deps.campus && deps.term) {
      const appState = queryClient.getQueryData(appStateQueryOptions().queryKey);
      const userId = appState?.session?.user?.id ?? null;
      promises.push(
        queryClient.ensureQueryData(
          scheduleCoursesQueryOptions({
            termId: deps.term,
            campusId: deps.campus,
            careerId: deps.career ?? null,
            planId: deps.plan ?? null,
            includeOtherCampuses: deps.otherCampuses ?? false,
            showAllCourses: deps.showAll ?? false,
            userId,
          }),
        ),
      );
    }

    await Promise.allSettled(promises);
  },
  pendingComponent: () => <div className="bg-background flex-1" />,
});
