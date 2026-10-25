import { useQueryClient } from "@tanstack/react-query";
import { useNavigate, useParams, useRouter, getRouteApi } from "@tanstack/react-router";
const routeApi = getRouteApi("/professors/$professorId");
import {
  Add01Icon,
  ArrowLeft02Icon,
  ChevronDownIcon,
  ChevronUpIcon,
  PencilLineIcon,
} from "@hugeicons/core-free-icons";
import { lazy, Suspense, useMemo, useState } from "react";
import { z } from "zod";

import type { ProfessorReviewCourseOption } from "@/lib/professor-reviews/types";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Collapsible, CollapsiblePanel, CollapsibleTrigger } from "@/components/ui/collapsible";
import { Icon, MorphIcon } from "@/components/ui/icon";
import { Separator } from "@/components/ui/separator";
import { toast } from "@/components/ui/toast";
import { useIsMobile } from "@/hooks/use-mobile";
import { formatTermNameWithoutYear } from "@/lib/academic-terms";
import { getTurnstileSiteKey } from "@/lib/env/public";
import {
  useProfessorById,
  useProfessorReviewsPublic,
  useProfessorReviewSummary,
  useProfessorTeachingHistory,
  useSubmitProfessorReview,
} from "@/lib/hooks/use-professor-reviews";
import { REVIEW_TAG_OPTIONS, type ReviewTag } from "@/lib/professor-reviews/types";
import { cn } from "@/lib/utils";
import { getProfessorNameTransitionName } from "@/lib/utils/view-transition";

const ReviewComposer = lazy(() =>
  import("./-review-composer").then((module) => ({ default: module.ReviewComposer })),
);

const ProfessorReviewsList = lazy(() =>
  import("./-professor-reviews-list").then((module) => ({ default: module.ProfessorReviewsList })),
);

const courseCodeSchema = z
  .string()
  .trim()
  .toUpperCase()
  .regex(/^[A-Z]{2,4}\d{3,4}$/);

const reviewFormSchema = z.object({
  courseCodes: z.array(courseCodeSchema).min(1).max(6),
  academicTermId: z.number().int().positive().nullable().optional(),
  comment: z.string().trim().min(5).max(1000),
  easeScore: z.number().min(0).max(10),
  qualityScore: z.number().min(0).max(10),
  clarityScore: z.number().min(0).max(10),
  fairnessScore: z.number().min(0).max(10),
  attendanceRequired: z.boolean(),
  gradeReceived: z
    .union([z.string(), z.number()])
    .optional()
    .nullable()
    .transform((value) => {
      if (value === "" || value === null || value === undefined) return null;
      const num = Number(value);
      return Number.isNaN(num) ? null : num;
    })
    .refine((value) => value === null || (value >= 0 && value <= 100), {
      message: "La nota debe ser un número entre 0 y 100",
    }),
  engagementLevel: z.number().int().min(1).max(5),
  tags: z.array(z.enum(REVIEW_TAG_OPTIONS)).max(6),
  turnstileToken: z.string().min(1),
});

const PAGE_SIZE = 10;

function metricLabel(value: number | null, suffix = "") {
  if (value === null) return "-";
  return `${value.toFixed(2)}${suffix}`;
}

function formatGroupCode(group: string): string {
  return `GR ${group.trim()}`;
}

function sortTermsAlphabetical<T extends { term_display_name: string }>(terms: T[]): T[] {
  return [...terms].sort((a, b) => {
    const nameA = formatTermNameWithoutYear(a.term_display_name).toUpperCase();
    const nameB = formatTermNameWithoutYear(b.term_display_name).toUpperCase();
    return nameA.localeCompare(nameB, "es", { numeric: true, sensitivity: "base" });
  });
}

function ProfessorTeachingHistoryCard({ professorId }: { professorId: string | null }) {
  const historyQuery = useProfessorTeachingHistory(professorId);
  const history = useMemo(() => historyQuery.data ?? [], [historyQuery.data]);
  const [isOpen, setIsOpen] = useState(false);

  const years = useMemo(() => {
    const set = new Set<number>();
    for (const t of history) {
      set.add(t.year);
    }
    return Array.from(set).sort((a, b) => b - a);
  }, [history]);

  const [selectedYear, setSelectedYear] = useState<number | null>(null);
  const activeYear = selectedYear ?? years[0] ?? null;

  const termsForActiveYear = useMemo(() => {
    if (activeYear === null) return [];
    return sortTermsAlphabetical(history.filter((t) => t.year === activeYear));
  }, [history, activeYear]);

  const [selectedTermId, setSelectedTermId] = useState<number | null>(null);

  const activeTerm = useMemo(() => {
    if (termsForActiveYear.length === 0) return null;
    if (selectedTermId !== null) {
      const found = termsForActiveYear.find((t) => t.term_id === selectedTermId);
      if (found) return found;
    }
    return termsForActiveYear[0] ?? null;
  }, [termsForActiveYear, selectedTermId]);

  if (historyQuery.isLoading) {
    return (
      <Card className="overflow-hidden">
        <div className="border-border/60 flex items-center justify-between px-5 py-3">
          <h3 className="text-foreground text-base leading-none font-semibold">
            Cursos impartidos
          </h3>
        </div>
        <div className="text-muted-foreground p-5 text-sm">Cargando historial de cursos…</div>
      </Card>
    );
  }

  if (history.length === 0) {
    return (
      <Card className="overflow-hidden">
        <div className="border-border/60 flex items-center justify-between px-5 py-3">
          <h3 className="text-foreground text-base leading-none font-semibold">
            Cursos impartidos
          </h3>
        </div>
        <div className="text-muted-foreground p-5 text-sm">
          No hay registros de cursos o grupos impartidos para este profesor.
        </div>
      </Card>
    );
  }

  return (
    <Collapsible open={isOpen} onOpenChange={setIsOpen}>
      <Card className="overflow-hidden">
        <CollapsibleTrigger
          className={cn(
            "border-border/60 hover:bg-muted/20 flex w-full cursor-pointer items-center justify-between px-5 py-3 text-left transition-colors",
            isOpen && "border-b",
          )}
        >
          <h3 className="text-foreground text-base leading-none font-semibold">
            Cursos impartidos
          </h3>
          <span className="text-muted-foreground flex size-6 items-center justify-center">
            <MorphIcon icon={isOpen ? ChevronUpIcon : ChevronDownIcon} size={16} />
          </span>
        </CollapsibleTrigger>

        <CollapsiblePanel>
          {/* Barra horizontal de Años */}
          <div className="border-border/50 flex [scrollbar-width:none] items-center gap-1.5 overflow-x-auto border-b px-3.5 py-2 sm:px-5 [&::-webkit-scrollbar]:hidden">
            {years.map((year) => {
              const isSelected = year === activeYear;
              return (
                <button
                  key={year}
                  type="button"
                  onClick={() => {
                    setSelectedYear(year);
                    const termsInYear = sortTermsAlphabetical(
                      history.filter((t) => t.year === year),
                    );
                    setSelectedTermId(termsInYear[0]?.term_id ?? null);
                  }}
                  className={cn(
                    "shrink-0 rounded-lg px-3 py-1.5 text-xs font-medium tabular-nums transition-colors sm:text-sm",
                    isSelected
                      ? "bg-muted text-foreground shadow-2xs"
                      : "text-muted-foreground hover:bg-muted/50 hover:text-foreground",
                  )}
                >
                  {year}
                </button>
              );
            })}
          </div>

          {/* Barra horizontal de Periodos del año seleccionado */}
          <div className="border-border/50 flex [scrollbar-width:none] items-center gap-1.5 overflow-x-auto border-b px-3.5 py-2 sm:px-5 [&::-webkit-scrollbar]:hidden">
            {termsForActiveYear.map((term) => {
              const isSelected = term.term_id === activeTerm?.term_id;
              const periodName = formatTermNameWithoutYear(term.term_display_name).toUpperCase();

              return (
                <button
                  key={term.term_id}
                  type="button"
                  onClick={() => setSelectedTermId(term.term_id)}
                  className={cn(
                    "shrink-0 rounded-lg px-3 py-1.5 text-xs font-medium transition-colors sm:text-sm",
                    isSelected
                      ? "bg-muted text-foreground shadow-2xs"
                      : "text-muted-foreground hover:bg-muted/50 hover:text-foreground",
                  )}
                >
                  {periodName}
                </button>
              );
            })}
          </div>

          {/* Cursos y Grupos del periodo activo */}
          <div className="max-h-80 overflow-y-auto px-3.5 py-2 sm:max-h-96 sm:px-5">
            {activeTerm && activeTerm.courses.length > 0 ? (
              <div className="flex flex-col gap-2">
                {activeTerm.courses.map((course) => (
                  <div
                    key={course.id}
                    className="flex flex-col justify-between gap-1.5 sm:flex-row sm:items-center"
                  >
                    <div className="min-w-0 flex-1 leading-snug break-words">
                      <span className="text-muted-foreground mr-1.5 text-xs font-normal">
                        {course.code}:
                      </span>
                      <span className="text-foreground text-sm font-medium">{course.name}</span>
                    </div>
                    <div className="flex shrink-0 flex-wrap items-center gap-1.5">
                      {course.groups.map((group) => (
                        <Badge
                          key={group}
                          variant="secondary"
                          className="px-1.5 py-0.5 text-xs font-normal tabular-nums"
                        >
                          {formatGroupCode(group)}
                        </Badge>
                      ))}
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-muted-foreground py-4 text-center text-sm">
                No hay cursos registrados para este periodo.
              </div>
            )}
          </div>
        </CollapsiblePanel>
      </Card>
    </Collapsible>
  );
}

export function ProfessorDetailPage() {
  const navigate = useNavigate({ from: "/professors/$professorId" });
  const params = useParams({ from: "/professors/$professorId" });
  const router = useRouter();
  const queryClient = useQueryClient();
  const isMobile = useIsMobile();
  const professorId = Number(params.professorId);

  const search = routeApi.useSearch();
  const page = search.page ? search.page - 1 : 0;
  const setPage = (updater: number | ((prev: number) => number)) => {
    const newPage = typeof updater === "function" ? updater(page) : updater;
    void navigate({
      search: (prev) => ({
        ...prev,
        page: newPage === 0 ? undefined : newPage + 1,
      }),
      replace: true,
    });
  };
  const [isComposerOpen, setIsComposerOpen] = useState(false);

  const [selectedCourses, setSelectedCourses] = useState<ProfessorReviewCourseOption[]>([]);
  const [academicTermId, setAcademicTermId] = useState("");
  const [comment, setComment] = useState("");
  const [easeScore, setEaseScore] = useState("8.0");
  const [qualityScore, setQualityScore] = useState("8.0");
  const [clarityScore, setClarityScore] = useState("8.0");
  const [fairnessScore, setFairnessScore] = useState("8.0");
  const [attendanceRequired, setAttendanceRequired] = useState(true);
  const [gradeReceived, setGradeReceived] = useState("");
  const [engagementLevel, setEngagementLevel] = useState("4");
  const [tags, setTags] = useState<ReviewTag[]>([]);
  const [turnstileToken, setTurnstileToken] = useState<string | null>(null);

  const turnstileSiteKey = getTurnstileSiteKey();
  const parsedProfessorId = Number.isFinite(professorId) && professorId > 0 ? professorId : null;
  const professorIdText = /^\d+$/.test(params.professorId) ? params.professorId : null;
  const cachedProfessor = professorIdText
    ? queryClient.getQueryData<{ id: number; full_name: string }>([
        "professorById",
        professorIdText,
      ])
    : null;

  const professorQuery = useProfessorById(professorIdText);
  const summaryQuery = useProfessorReviewSummary(professorIdText);
  const reviewsQuery = useProfessorReviewsPublic(professorIdText, page, PAGE_SIZE);
  const submitMutation = useSubmitProfessorReview();
  const headingProfessorName =
    professorQuery.data?.full_name ?? cachedProfessor?.full_name ?? "Profesor";

  const reviewRows = reviewsQuery.data ?? [];
  const totalCount = reviewRows[0]?.total_count ?? 0;
  const totalPages = totalCount === 0 ? 1 : Math.ceil(totalCount / PAGE_SIZE);
  const hasMore = page + 1 < totalPages;

  const summary = summaryQuery.data;
  const isInvalidProfessorId = parsedProfessorId === null;

  const handleBack = () => {
    if (typeof window !== "undefined" && window.history.length > 1) {
      router.history.back();
      return;
    }
    void navigate({ to: "/professors" });
  };

  const resetComposer = () => {
    setSelectedCourses([]);
    setAcademicTermId("");
    setComment("");
    setEaseScore("8.0");
    setQualityScore("8.0");
    setClarityScore("8.0");
    setFairnessScore("8.0");
    setAttendanceRequired(true);
    setGradeReceived("");
    setEngagementLevel("4");
    setTags([]);
    setTurnstileToken(null);
  };

  const handleSubmit = async () => {
    if (parsedProfessorId === null || professorIdText === null) return;

    const parsed = reviewFormSchema.safeParse({
      courseCodes: selectedCourses.map((c) => c.code),
      academicTermId: academicTermId ? Number(academicTermId) : null,
      comment,
      easeScore: Number(easeScore),
      qualityScore: Number(qualityScore),
      clarityScore: Number(clarityScore),
      fairnessScore: Number(fairnessScore),
      attendanceRequired,
      gradeReceived,
      engagementLevel: Number(engagementLevel),
      tags,
      turnstileToken: turnstileToken ?? "",
    });

    if (!parsed.success) {
      toast.error("Revisa los datos del formulario y vuelve a intentar.");
      return;
    }

    try {
      await submitMutation.mutateAsync({
        professorId: professorIdText,
        ...parsed.data,
      });
      toast.success("Reseña enviada", {
        description: "Estará visible tras ser revisada por nuestro equipo",
      });
      setIsComposerOpen(false);
      resetComposer();
      await reviewsQuery.refetch();
      await summaryQuery.refetch();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo enviar la reseña.");
    }
  };

  if (isInvalidProfessorId) {
    return <div className="text-muted-foreground p-6 text-sm">ID de profesor inválido.</div>;
  }

  return (
    <div className="flex flex-1 flex-col gap-6 px-4 py-6 lg:px-6">
      <div className="flex flex-col gap-3">
        <div className="flex min-w-0 items-center justify-between gap-3">
          <div className="flex min-w-0 items-center gap-3">
            <Button
              type="button"
              variant="outline"
              size="icon"
              className="shrink-0"
              onClick={handleBack}
              aria-label="Atrás"
              title="Atrás"
            >
              <Icon icon={ArrowLeft02Icon} size={16} className="size-4" />
            </Button>
            <h1
              className="min-w-0 text-xl font-semibold break-words md:text-2xl md:leading-tight"
              style={{ viewTransitionName: getProfessorNameTransitionName(params.professorId) }}
            >
              {headingProfessorName}
            </h1>
          </div>
          <Button type="button" className="shrink-0" onClick={() => setIsComposerOpen(true)}>
            <Icon icon={PencilLineIcon} size={16} className="mr-2 hidden size-4 md:inline-block" />
            <Icon icon={Add01Icon} size={16} className="mr-1 size-4 md:hidden" />
            <span className="hidden md:inline">Escribir reseña</span>
            <span className="md:hidden">Agregar</span>
          </Button>
        </div>
      </div>

      <Card className="overflow-hidden py-0">
        <CardContent className="p-0">
          <div className="grid grid-cols-[2fr_1fr] md:grid-cols-[25%_auto_15%_auto_1fr]">
            <div className="flex min-h-36 flex-col items-center justify-center p-5 text-center md:min-h-52 md:p-6">
              <span className="text-muted-foreground text-sm font-semibold tracking-wide uppercase md:text-base">
                Calidad general
              </span>
              <span className="mt-1 text-5xl leading-none font-bold tracking-tight tabular-nums md:text-6xl">
                {metricLabel(summary?.average_overall_score ?? null)}
              </span>
            </div>

            <Separator orientation="vertical" className="hidden md:block" />

            <div className="grid min-h-36 gap-4 border-l p-5 md:min-h-52 md:items-center md:gap-5 md:border-l-0 md:p-6">
              <SummaryMetric
                label="Facilidad"
                value={metricLabel(summary?.average_ease_score ?? null)}
              />
              <SummaryMetric
                label="Calidad"
                value={metricLabel(summary?.average_quality_score ?? null)}
              />
              <SummaryMetric
                label="Lo llevarían otra vez"
                value={
                  !summary || summary.would_take_again_percentage === null
                    ? "-"
                    : `${summary.would_take_again_percentage.toFixed(2)}%`
                }
              />
            </div>

            <Separator className="col-span-2 md:hidden" />
            <Separator orientation="vertical" className="hidden md:block" />

            <div className="col-span-2 flex min-h-32 flex-col justify-start p-5 md:col-auto md:min-h-52 md:p-6">
              <p className="mb-3 text-base font-semibold">Etiquetas destacadas</p>
              {summaryQuery.isLoading ? (
                <p className="text-muted-foreground text-sm">Cargando etiquetas…</p>
              ) : summary?.tag_counts?.length ? (
                <div className="flex flex-wrap gap-2">
                  {summary.tag_counts.slice(0, 10).map((tag) => (
                    <Badge key={tag.tag} variant="secondary" className="gap-1.5 px-1.5">
                      <span>{tag.tag}</span>
                      <Separator orientation="vertical" className="h-3" />
                      <span className="text-muted-foreground tabular-nums">{tag.count}</span>
                    </Badge>
                  ))}
                </div>
              ) : (
                <p className="text-muted-foreground text-sm">
                  Aún no hay etiquetas aprobadas para mostrar.
                </p>
              )}
            </div>
          </div>
        </CardContent>
      </Card>

      <ProfessorTeachingHistoryCard professorId={professorIdText} />

      <Suspense fallback={<div className="bg-muted/20 h-[260px] w-full rounded-lg border" />}>
        <ProfessorReviewsList
          reviewRows={reviewRows}
          isLoading={reviewsQuery.isLoading}
          isFetching={reviewsQuery.isFetching}
          page={page}
          totalCount={totalCount}
          totalPages={totalPages}
          hasMore={hasMore}
          onPageChange={setPage}
        />
      </Suspense>

      {isComposerOpen ? (
        <Suspense fallback={null}>
          <ReviewComposer
            isMobile={isMobile}
            open={isComposerOpen}
            onOpenChange={(open) => {
              setIsComposerOpen(open);
              if (!open) setTurnstileToken(null);
            }}
            submitMutationPending={submitMutation.isPending}
            turnstileSiteKey={turnstileSiteKey}
            professorId={professorIdText}
            selectedCourses={selectedCourses}
            setSelectedCourses={setSelectedCourses}
            academicTermId={academicTermId}
            setAcademicTermId={setAcademicTermId}
            gradeReceived={gradeReceived}
            setGradeReceived={setGradeReceived}
            comment={comment}
            setComment={setComment}
            easeScore={easeScore}
            setEaseScore={setEaseScore}
            qualityScore={qualityScore}
            setQualityScore={setQualityScore}
            clarityScore={clarityScore}
            setClarityScore={setClarityScore}
            fairnessScore={fairnessScore}
            setFairnessScore={setFairnessScore}
            engagementLevel={engagementLevel}
            setEngagementLevel={setEngagementLevel}
            attendanceRequired={attendanceRequired}
            setAttendanceRequired={setAttendanceRequired}
            tags={tags}
            setTags={setTags}
            turnstileToken={turnstileToken}
            setTurnstileToken={setTurnstileToken}
            onSubmit={() => void handleSubmit()}
            onCloseReset={resetComposer}
          />
        </Suspense>
      ) : null}
    </div>
  );
}

function SummaryMetric({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex flex-col items-center justify-center text-center">
      <span className="text-muted-foreground text-[11px] font-semibold tracking-wide uppercase md:text-xs">
        {label}
      </span>
      <span className="mt-1 text-2xl leading-none font-bold tracking-tight tabular-nums md:text-3xl">
        {value}
      </span>
    </div>
  );
}
