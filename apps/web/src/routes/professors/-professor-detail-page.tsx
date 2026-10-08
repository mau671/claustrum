import { useQueryClient } from "@tanstack/react-query";
import { useNavigate, useParams, useRouter, getRouteApi } from "@tanstack/react-router";
const routeApi = getRouteApi("/professors/$professorId");
import { ArrowLeft, PenLine, Plus } from "lucide-react";
import { lazy, Suspense, useState } from "react";
import { toast } from "sonner";
import { z } from "zod";

import type { ProfessorReviewCourseOption } from "@/lib/professor-reviews/types";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { useIsMobile } from "@/hooks/use-mobile";
import { getTurnstileSiteKey } from "@/lib/env/public";
import {
  useProfessorById,
  useProfessorReviewsPublic,
  useProfessorReviewSummary,
  useSubmitProfessorReview,
} from "@/lib/hooks/use-professor-reviews";
import { REVIEW_TAG_OPTIONS, type ReviewTag } from "@/lib/professor-reviews/types";
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
  gradeReceived: z.string().trim().max(32).optional(),
  engagementLevel: z.number().int().min(1).max(5),
  tags: z.array(z.enum(REVIEW_TAG_OPTIONS)).max(6),
  turnstileToken: z.string().min(1),
});

const DEFAULT_PAGE_SIZE = 10;

function metricLabel(value: number | null, suffix = "") {
  if (value === null) return "-";
  return `${value.toFixed(2)}${suffix}`;
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
  const [pageSize, setPageSize] = useState(DEFAULT_PAGE_SIZE);
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
  const reviewsQuery = useProfessorReviewsPublic(professorIdText, page, pageSize);
  const submitMutation = useSubmitProfessorReview();
  const headingProfessorName =
    professorQuery.data?.full_name ?? cachedProfessor?.full_name ?? "Profesor";

  const reviewRows = reviewsQuery.data ?? [];
  const totalCount = reviewRows[0]?.total_count ?? 0;
  const totalPages = totalCount === 0 ? 1 : Math.ceil(totalCount / pageSize);
  const hasMore = page + 1 < totalPages;
  const firstRow = reviewRows.length === 0 ? 0 : page * pageSize + 1;
  const lastRow = page * pageSize + reviewRows.length;

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
              <ArrowLeft className="size-4" />
            </Button>
            <h1
              className="min-w-0 text-xl font-semibold break-words md:text-2xl md:leading-tight"
              style={{ viewTransitionName: getProfessorNameTransitionName(params.professorId) }}
            >
              {headingProfessorName}
            </h1>
          </div>
          <Button type="button" className="shrink-0" onClick={() => setIsComposerOpen(true)}>
            <PenLine className="mr-2 hidden size-4 md:inline-block" />
            <Plus className="mr-1 size-4 md:hidden" />
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
                    <Badge key={tag.tag} variant="secondary">
                      {tag.tag} ({tag.count})
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

      <Suspense fallback={<div className="bg-muted/20 h-[260px] w-full rounded-lg border" />}>
        <ProfessorReviewsList
          reviewRows={reviewRows}
          isLoading={reviewsQuery.isLoading}
          isFetching={reviewsQuery.isFetching}
          page={page}
          pageSize={pageSize}
          totalCount={totalCount}
          totalPages={totalPages}
          hasMore={hasMore}
          firstRow={firstRow}
          lastRow={lastRow}
          onPageChange={setPage}
          onPageSizeChange={setPageSize}
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
