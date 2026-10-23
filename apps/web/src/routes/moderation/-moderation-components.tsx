import { Cancel01Icon, CheckIcon } from "@hugeicons/core-free-icons";
import {
  createColumnHelper,
  flexRender,
  rowPaginationFeature,
  tableFeatures,
  useTable,
} from "@tanstack/react-table";
import { Fragment, lazy, Suspense, useEffect, useMemo, useState } from "react";

import type { EvaluationModerationRow, EvaluationStatus } from "@/lib/evaluations/types";
import type {
  ProfessorReviewModerationRow,
  ProfessorReviewReportModerationRow,
  ProfessorReviewStatus,
} from "@/lib/professor-reviews/types";

import { NumberedPagination } from "@/components/numbered-pagination";
import { ReviewComment } from "@/components/review-comment";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardPanel } from "@/components/ui/card";
import { Frame, FrameFooter, FrameHeader, FrameTitle } from "@/components/ui/frame";
import { Icon } from "@/components/ui/icon";
import { Label } from "@/components/ui/label";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Spinner } from "@/components/ui/spinner";
import { Textarea } from "@/components/ui/textarea";
import { cn } from "@/lib/utils";

const PdfViewer = lazy(() =>
  import("@/components/pdf-viewer").then((mod) => ({ default: mod.PdfViewer })),
);
import { formatEvaluationFileName, formatEvaluationTypeLabel } from "@/lib/evaluations/types";
import {
  useEvaluationDocumentQuery,
  useEvaluationAnswersDocumentQuery,
} from "@/lib/hooks/use-evaluations";

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

function formatScore(value: number | null): string {
  return value === null ? "-" : value.toFixed(1);
}

function ReviewCourses({ review }: { review: ProfessorReviewModerationRow }) {
  if (!review.courses || review.courses.length === 0) return null;

  return (
    <div className="space-y-1.5">
      <h4 className="text-foreground text-sm font-medium">
        {review.courses.length > 1 ? "Cursos asociados" : "Curso asociado"}
      </h4>
      <div className="space-y-1">
        {review.courses.map((course) => (
          <div
            key={`${review.review_id}-${course.id}`}
            className="text-foreground text-sm leading-snug font-medium break-words"
          >
            <span className="text-muted-foreground mr-1.5 text-xs font-normal">{course.code}:</span>
            <span>{course.name}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

function ReviewScoreSummary({ review }: { review: ProfessorReviewModerationRow }) {
  const ratings = [
    { label: "Calidad", value: formatScore(review.quality_score) },
    { label: "Facilidad", value: formatScore(review.ease_score) },
    ...(review.clarity_score !== null
      ? [{ label: "Claridad", value: formatScore(review.clarity_score) }]
      : []),
    ...(review.fairness_score !== null
      ? [{ label: "Justicia", value: formatScore(review.fairness_score) }]
      : []),
  ];

  const hasAttendance = review.attendance_required !== null;
  const hasGrade = Boolean(review.grade_received && String(review.grade_received).trim() !== "");
  const hasEngagement = Boolean(
    review.engagement_level && String(review.engagement_level).trim() !== "",
  );

  return (
    <div className="space-y-2">
      {/* Calidad, Facilidad, Claridad, Justicia como texto simple */}
      <div className="flex flex-wrap items-center gap-x-5 gap-y-1.5 text-sm">
        {ratings.map((r) => (
          <span key={r.label} className="text-foreground">
            <span className="text-muted-foreground">{r.label}: </span>
            <span className="font-semibold tabular-nums">{r.value}</span>
          </span>
        ))}
      </div>

      {/* Asistencia, Nota obtenida, Interés como valores normales sin card */}
      {(hasAttendance || hasGrade || hasEngagement) && (
        <div className="text-muted-foreground flex flex-wrap items-center gap-x-5 gap-y-1 text-sm">
          {hasAttendance && (
            <span>
              <span>Asistencia: </span>
              <span className="text-foreground font-medium">
                {review.attendance_required ? "Obligatoria" : "Opcional"}
              </span>
            </span>
          )}
          {hasGrade && (
            <span>
              <span>Nota obtenida: </span>
              <span className="text-foreground font-medium">{review.grade_received}</span>
            </span>
          )}
          {hasEngagement && (
            <span>
              <span>Interés: </span>
              <span className="text-foreground font-medium">{review.engagement_level}</span>
            </span>
          )}
        </div>
      )}
    </div>
  );
}

export function ReviewReportSection({
  rows,
  selectedReport,
  onSelect,
  page,
  hasMore,
  isLoading,
  isFetching,
  onPageChange,
  moderationNote,
  onNoteChange,
  onResolve,
  onDismiss,
  isPending,
}: {
  rows: ProfessorReviewReportModerationRow[];
  selectedReport: ProfessorReviewReportModerationRow | null;
  onSelect: (id: number | null) => void;
  page: number;
  hasMore: boolean;
  isLoading: boolean;
  isFetching: boolean;
  onPageChange: (page: number) => void;
  moderationNote: Record<number, string>;
  onNoteChange: (id: number, value: string) => void;
  onResolve: (id: number) => Promise<void>;
  onDismiss: (id: number) => Promise<void>;
  isPending: boolean;
}) {
  return (
    <div className="flex flex-1 flex-col gap-4 lg:min-h-0 lg:flex-row">
      <Frame className="min-h-0 w-full shrink-0 flex-col lg:w-80 xl:w-96">
        <FrameHeader className="flex h-11 shrink-0 flex-row items-center px-4 py-2 sm:h-12 sm:px-5">
          <FrameTitle className="text-muted-foreground text-sm font-semibold">
            Reportes pendientes
          </FrameTitle>
        </FrameHeader>

        <Card className="bg-card flex max-h-[340px] min-h-0 flex-1 flex-col overflow-hidden rounded-xl border shadow-xs/5 lg:max-h-none">
          <div className="divide-border/60 flex min-h-0 flex-1 flex-col divide-y overflow-y-auto">
            {isLoading ? (
              <div className="text-muted-foreground flex flex-1 items-center justify-center gap-2 p-6 text-sm">
                <Spinner className="size-4" />
                <span>Cargando reportes…</span>
              </div>
            ) : rows.length === 0 ? (
              <p className="text-muted-foreground p-6 text-center text-sm">
                No hay reportes pendientes.
              </p>
            ) : (
              rows.map((report) => (
                <CardPanel
                  key={report.report_id}
                  render={
                    <button
                      type="button"
                      aria-label={`Ver reporte de ${report.course_code}: ${report.professor_name}`}
                    />
                  }
                  onClick={() => onSelect(report.report_id)}
                  className={cn(
                    "focus-visible:bg-accent flex w-full flex-none cursor-pointer flex-col p-3.5 text-left transition-colors outline-none",
                    selectedReport?.report_id === report.report_id
                      ? "bg-accent/80 text-accent-foreground"
                      : "hover:bg-muted/50 text-foreground",
                  )}
                >
                  <span className="truncate font-medium">
                    {report.course_code}: {report.course_name}
                  </span>
                  <div className="mt-1 flex w-full items-end justify-between gap-2">
                    <span className="text-muted-foreground truncate text-sm">
                      {report.professor_name}
                    </span>
                  </div>
                  <span className="text-muted-foreground mt-0.5 line-clamp-2 text-xs">
                    {report.reason}
                  </span>
                </CardPanel>
              ))
            )}
          </div>
        </Card>

        <FrameFooter className="flex h-12 shrink-0 items-center justify-center p-1.5 sm:h-13">
          <ModerationPagination
            page={page}
            totalPages={hasMore ? page + 2 : page + 1}
            hasMore={hasMore}
            isFetching={isFetching}
            onPageChange={onPageChange}
          />
        </FrameFooter>
      </Frame>

      {selectedReport && (
        <Frame className="min-w-0 flex-1 flex-col lg:max-h-full lg:min-h-0">
          <FrameHeader className="flex h-11 shrink-0 flex-row items-center px-4 py-2 sm:h-12 sm:px-5">
            <FrameTitle className="min-w-0 flex-1 truncate text-base font-semibold sm:text-lg">
              {selectedReport.course_code}: {selectedReport.course_name}
            </FrameTitle>
          </FrameHeader>

          <Card className="bg-card min-h-0 flex-1 overflow-hidden rounded-xl border shadow-xs/5">
            <CardPanel className="flex min-h-0 flex-1 flex-col gap-3.5 overflow-y-auto p-4 sm:p-5">
              <div className="text-muted-foreground flex flex-wrap items-center gap-x-4 gap-y-1.5 text-xs">
                <span>
                  <strong className="text-foreground font-medium">Profesor:</strong>{" "}
                  {selectedReport.professor_name}
                </span>
                <span>
                  <strong className="text-foreground font-medium">Motivo:</strong>{" "}
                  {selectedReport.reason}
                </span>
                {selectedReport.description && (
                  <span>
                    <strong className="text-foreground font-medium">Detalles:</strong>{" "}
                    {selectedReport.description}
                  </span>
                )}
              </div>

              <div className="space-y-1.5">
                <h4 className="text-foreground text-sm font-medium">Comentario reportado</h4>
                <blockquote className="border-primary/50 bg-muted/20 text-foreground rounded-r-lg border-l-2 py-2.5 pr-4 pl-3.5 text-sm leading-relaxed break-words whitespace-pre-wrap">
                  <ReviewComment comment={selectedReport.comment} />
                </blockquote>
              </div>

              <div className="flex flex-col gap-1.5 pt-1">
                <div className="inline-flex w-full items-center justify-between gap-2">
                  <Label
                    htmlFor={`note-report-${selectedReport.report_id}`}
                    className="text-sm font-medium"
                  >
                    Nota de resolución
                  </Label>
                  <Label className="text-muted-foreground text-sm font-normal" render={<span />}>
                    Opcional
                  </Label>
                </div>
                <Textarea
                  id={`note-report-${selectedReport.report_id}`}
                  value={moderationNote[selectedReport.report_id] ?? ""}
                  onChange={(e) => onNoteChange(selectedReport.report_id, e.target.value)}
                  className="bg-background h-20 min-h-0 resize-none text-xs shadow-none sm:text-sm"
                  placeholder="Escribe una nota opcional para explicar el contexto de la decisión"
                />
              </div>
            </CardPanel>
          </Card>

          <FrameFooter className="flex h-12 shrink-0 items-center p-2 sm:h-13 sm:p-2.5">
            <div className="flex w-full gap-2.5">
              <Button
                className="flex-1"
                onClick={() => void onResolve(selectedReport.report_id)}
                disabled={isPending}
              >
                <Icon icon={CheckIcon} size={16} className="mr-1.5 size-4" /> Resolver
              </Button>
              <Button
                variant="destructive"
                className="flex-1"
                onClick={() => void onDismiss(selectedReport.report_id)}
                disabled={isPending}
              >
                <Icon icon={Cancel01Icon} size={16} className="mr-1.5 size-4" /> Descartar
              </Button>
            </div>
          </FrameFooter>
        </Frame>
      )}
    </div>
  );
}

const reviewQueueFeatures = tableFeatures({
  rowPaginationFeature,
});

const reviewQueueColumnHelper = createColumnHelper<
  typeof reviewQueueFeatures,
  ProfessorReviewModerationRow
>();

export function ModerationStatusTabs<T extends string>({
  statusFilter,
  onStatusChange,
}: {
  statusFilter: T;
  onStatusChange: (status: T) => void;
}) {
  const tabs: { value: T; label: string }[] = [
    { value: "pending" as T, label: "Pendientes" },
    { value: "approved" as T, label: "Aprobadas" },
    { value: "rejected" as T, label: "Rechazadas" },
  ];

  return (
    <ScrollArea scrollFade className="w-full [&_[data-slot=scroll-area-scrollbar]]:hidden">
      <div className="flex w-max min-w-full items-center gap-1 px-0.5 text-xs">
        {tabs.map((tab) => {
          const isSelected = statusFilter === tab.value;
          return (
            <button
              key={tab.value}
              type="button"
              onClick={() => onStatusChange(tab.value)}
              className={cn(
                "flex-1 rounded-lg border px-3 py-1.5 text-center text-xs font-medium whitespace-nowrap transition-colors",
                isSelected
                  ? "border-border/80 bg-background text-foreground shadow-xs"
                  : "text-muted-foreground hover:bg-background/50 hover:text-foreground border-transparent",
              )}
            >
              {tab.label}
            </button>
          );
        })}
      </div>
    </ScrollArea>
  );
}

export function ModerationPagination({
  page,
  totalPages,
  hasMore,
  isFetching,
  onPageChange,
}: {
  page: number;
  totalPages: number;
  hasMore: boolean;
  isFetching: boolean;
  onPageChange: (newPage: number) => void;
}) {
  return (
    <NumberedPagination
      page={page}
      totalPages={totalPages}
      hasMore={hasMore}
      isFetching={isFetching}
      onPageChange={onPageChange}
    />
  );
}

export function ReviewSection({
  rows,
  selectedReview,
  onSelect,
  page,
  pageSize = 20,
  totalCount,
  totalPages,
  hasMore,
  isLoading,
  isFetching,
  onPageChange,
  statusFilter = "pending",
  onStatusChange,
  moderationNote,
  onNoteChange,
  onApprove,
  onReject,
  isPending,
}: {
  rows: ProfessorReviewModerationRow[];
  selectedReview: ProfessorReviewModerationRow | null;
  onSelect: (id: number | null) => void;
  page: number;
  pageSize?: number;
  totalCount?: number;
  totalPages?: number;
  hasMore: boolean;
  isLoading: boolean;
  isFetching: boolean;
  onPageChange: (page: number) => void;
  statusFilter?: ProfessorReviewStatus;
  onStatusChange?: (status: ProfessorReviewStatus) => void;
  moderationNote: Record<number, string>;
  onNoteChange: (id: number, value: string) => void;
  onApprove: (id: number) => Promise<void>;
  onReject: (id: number) => Promise<void>;
  isPending: boolean;
}) {
  const columns = useMemo(
    () => [
      reviewQueueColumnHelper.display({
        id: "reviewItem",
        cell: ({ row }) => (
          <CardPanel
            render={
              <button type="button" aria-label={`Ver reseña de ${row.original.professor_name}`} />
            }
            onClick={() => onSelect(row.original.review_id)}
            className={cn(
              "focus-visible:bg-accent flex w-full flex-none cursor-pointer flex-col p-3.5 text-left transition-colors outline-none",
              selectedReview?.review_id === row.original.review_id
                ? "bg-accent/80 text-accent-foreground"
                : "hover:bg-muted/50 text-foreground",
            )}
          >
            <div className="flex items-center justify-between gap-2">
              <span className="truncate font-medium">{row.original.professor_name}</span>
            </div>
            <div className="text-muted-foreground mt-1 flex flex-col text-xs">
              {row.original.courses.map((course) => (
                <span key={course.id} className="truncate">
                  {course.code}: {course.name}
                </span>
              ))}
            </div>
            <span className="text-muted-foreground mt-1 line-clamp-2 text-xs break-words">
              {row.original.comment}
            </span>
          </CardPanel>
        ),
      }),
    ],
    // oxlint-disable-next-line react-hooks/exhaustive-deps
    [onSelect, selectedReview?.review_id],
  );

  const table = useTable({
    features: reviewQueueFeatures,
    data: rows,
    columns,
    manualPagination: true,
    pageCount: totalPages ?? (hasMore ? page + 2 : page + 1),
    rowCount: totalCount ?? rows.length,
    state: {
      pagination: {
        pageIndex: page,
        pageSize,
      },
    },
  });

  const calculatedTotalPages = totalPages ?? Math.max(1, hasMore ? page + 2 : page + 1);

  return (
    <div className="flex flex-1 flex-col gap-4 lg:min-h-0 lg:flex-row">
      <Frame className="min-h-0 w-full shrink-0 flex-col lg:w-80 xl:w-96">
        {onStatusChange && (
          <FrameHeader className="flex h-11 shrink-0 flex-row items-center p-1 sm:h-12">
            <ModerationStatusTabs statusFilter={statusFilter} onStatusChange={onStatusChange} />
          </FrameHeader>
        )}

        <Card className="bg-card flex max-h-[340px] min-h-0 flex-1 flex-col overflow-hidden rounded-xl border shadow-xs/5 lg:max-h-none">
          <div className="divide-border/60 flex min-h-0 flex-1 flex-col divide-y overflow-y-auto">
            {isLoading ? (
              <div className="text-muted-foreground flex items-center justify-center gap-2 p-6 text-sm">
                <Spinner className="size-4" />
                <span>Cargando reseñas…</span>
              </div>
            ) : table.getRowModel().rows.length === 0 ? (
              <p className="text-muted-foreground p-6 text-center text-sm">
                {statusFilter === "pending"
                  ? "No hay reseñas pendientes."
                  : statusFilter === "approved"
                    ? "No hay reseñas aprobadas."
                    : statusFilter === "rejected"
                      ? "No hay reseñas rechazadas."
                      : "No hay reseñas en el historial."}
              </p>
            ) : (
              table.getRowModel().rows.map((row) => (
                <Fragment key={row.id}>
                  {row.getAllCells().map((cell) => (
                    <Fragment key={cell.id}>
                      {flexRender(cell.column.columnDef.cell, cell.getContext())}
                    </Fragment>
                  ))}
                </Fragment>
              ))
            )}
          </div>
        </Card>

        <FrameFooter className="flex h-12 shrink-0 items-center justify-center p-1.5 sm:h-13">
          <ModerationPagination
            page={page}
            totalPages={calculatedTotalPages}
            hasMore={hasMore}
            isFetching={isFetching}
            onPageChange={onPageChange}
          />
        </FrameFooter>
      </Frame>

      {selectedReview && (
        <Frame className="min-w-0 flex-1 flex-col lg:max-h-full lg:min-h-0">
          <FrameHeader className="flex h-11 shrink-0 flex-row items-center px-4 py-2 sm:h-12 sm:px-5">
            <FrameTitle className="min-w-0 flex-1 truncate text-base font-semibold sm:text-lg">
              {selectedReview.professor_name}
            </FrameTitle>
          </FrameHeader>

          <Card className="bg-card min-h-0 flex-1 overflow-hidden rounded-xl border shadow-xs/5">
            <CardPanel className="flex min-h-0 flex-1 flex-col gap-4 overflow-y-auto p-4 sm:p-5">
              {/* Cursos asociados */}
              <ReviewCourses review={selectedReview} />

              {/* Comentario del estudiante */}
              <div className="space-y-1.5">
                <h4 className="text-foreground text-sm font-medium">Comentario</h4>
                <blockquote className="border-primary/50 bg-muted/20 text-foreground rounded-r-lg border-l-2 py-2.5 pr-4 pl-3.5 text-sm leading-relaxed break-words whitespace-pre-wrap">
                  <ReviewComment comment={selectedReview.comment} />
                </blockquote>
              </div>

              {/* Métricas y contexto académico */}
              <ReviewScoreSummary review={selectedReview} />

              {/* Etiquetas */}
              {selectedReview.tags && selectedReview.tags.length > 0 && (
                <div className="space-y-1.5">
                  <h4 className="text-foreground text-sm font-medium">Etiquetas</h4>
                  <div className="flex flex-wrap gap-1.5">
                    {selectedReview.tags.map((tag) => (
                      <Badge
                        key={tag}
                        variant="secondary"
                        className="rounded-md px-2 py-0.5 text-xs font-normal"
                      >
                        {tag}
                      </Badge>
                    ))}
                  </div>
                </div>
              )}

              {/* Nota previa de moderación */}
              {selectedReview.moderation_note && (
                <div className="rounded-lg border border-amber-500/30 bg-amber-500/10 p-2.5 text-xs text-amber-900 dark:text-amber-200">
                  <strong>Nota previa de moderación:</strong> {selectedReview.moderation_note}
                </div>
              )}

              <div className="flex flex-col gap-1.5 pt-1">
                <div className="inline-flex w-full items-center justify-between gap-2">
                  <Label
                    htmlFor={`note-review-${selectedReview.review_id}`}
                    className="text-sm font-medium"
                  >
                    Nota de moderación
                  </Label>
                  <Label className="text-muted-foreground text-sm font-normal" render={<span />}>
                    Opcional
                  </Label>
                </div>
                <Textarea
                  id={`note-review-${selectedReview.review_id}`}
                  value={moderationNote[selectedReview.review_id] ?? ""}
                  onChange={(e) => onNoteChange(selectedReview.review_id, e.target.value)}
                  className="bg-background h-20 min-h-0 resize-none text-xs shadow-none sm:text-sm"
                  placeholder="Escribe una nota opcional para explicar el motivo del rechazo o aprobación"
                />
              </div>
            </CardPanel>
          </Card>

          <FrameFooter className="flex h-12 shrink-0 items-center p-2 sm:h-13 sm:p-2.5">
            <div className="flex w-full gap-2.5">
              <Button
                className="flex-1"
                onClick={() => void onApprove(selectedReview.review_id)}
                disabled={isPending}
              >
                <Icon icon={CheckIcon} size={16} className="mr-1.5 size-4" /> Aprobar
              </Button>
              <Button
                variant="destructive"
                className="flex-1"
                onClick={() => void onReject(selectedReview.review_id)}
                disabled={isPending}
              >
                <Icon icon={Cancel01Icon} size={16} className="mr-1.5 size-4" /> Rechazar
              </Button>
            </div>
          </FrameFooter>
        </Frame>
      )}
    </div>
  );
}

function EvaluationPdfViewer({
  selectedEvaluation,
}: {
  selectedEvaluation: EvaluationModerationRow;
}) {
  const [blobUrl, setBlobUrl] = useState<string | null>(null);
  const [answersBlobUrl, setAnswersBlobUrl] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<"evaluation" | "answers">("evaluation");
  const {
    data: evalDoc,
    isLoading: isEvalLoading,
    error: evalError,
  } = useEvaluationDocumentQuery(selectedEvaluation.id);
  const {
    data: answersDoc,
    isLoading: isAnswersLoading,
    error: answersError,
  } = useEvaluationAnswersDocumentQuery(
    selectedEvaluation.has_separate_answers ? selectedEvaluation.id : null,
  );

  const fileLoading = isEvalLoading || isAnswersLoading;
  const fileError = evalError
    ? (evalError as Error).message
    : answersError
      ? (answersError as Error).message
      : null;

  useEffect(() => {
    let evalUrl: string | null = null;
    let answersUrl: string | null = null;

    if (evalDoc?.blob) {
      evalUrl = URL.createObjectURL(evalDoc.blob);
      setBlobUrl(evalUrl);
    }

    if (answersDoc?.blob) {
      answersUrl = URL.createObjectURL(answersDoc.blob);
      setAnswersBlobUrl(answersUrl);
    }

    return () => {
      if (evalUrl) URL.revokeObjectURL(evalUrl);
      if (answersUrl) URL.revokeObjectURL(answersUrl);
    };
  }, [evalDoc, answersDoc]);

  const baseFileName = formatEvaluationFileName(
    selectedEvaluation.course_code,
    selectedEvaluation.evaluation_type,
    selectedEvaluation.evaluation_number,
    selectedEvaluation.custom_name,
  );
  const answersFileName = baseFileName.replace(".pdf", "-respuestas.pdf");

  return (
    <div className="bg-card text-card-foreground flex min-h-0 min-w-0 flex-1 flex-col overflow-hidden rounded-xl border shadow-xs">
      {selectedEvaluation.has_separate_answers && (
        <div className="border-border/50 flex border-b">
          <button
            onClick={() => setActiveTab("evaluation")}
            className={cn(
              "hover:bg-muted/50 flex-1 px-4 py-2 text-sm font-medium transition-colors",
              activeTab === "evaluation" ? "bg-muted text-foreground" : "text-muted-foreground",
            )}
          >
            Evaluación
          </button>
          <button
            onClick={() => setActiveTab("answers")}
            className={cn(
              "border-border/50 hover:bg-muted/50 flex-1 border-l px-4 py-2 text-sm font-medium transition-colors",
              activeTab === "answers" ? "bg-muted text-foreground" : "text-muted-foreground",
            )}
          >
            Respuestas
          </button>
        </div>
      )}

      {fileLoading && (
        <div className="flex flex-1 flex-col items-center justify-center gap-4">
          <Spinner className="text-muted-foreground size-8" />
          <p className="text-muted-foreground text-sm">Cargando documento…</p>
        </div>
      )}

      {!fileLoading && fileError && (
        <div className="flex flex-1 flex-col items-center justify-center gap-4 px-4 text-center">
          <p className="text-destructive text-sm">{fileError}</p>
        </div>
      )}

      {!fileLoading && !fileError && (
        <Suspense
          fallback={
            <div className="flex flex-1 flex-col items-center justify-center gap-4">
              <Spinner className="text-muted-foreground size-8" />
              <p className="text-muted-foreground text-sm">Cargando visor…</p>
            </div>
          }
        >
          {activeTab === "evaluation" && blobUrl && (
            <PdfViewer blobUrl={blobUrl} fileName={baseFileName} className="h-full rounded-b-xl" />
          )}
          {activeTab === "answers" && answersBlobUrl && (
            <PdfViewer
              blobUrl={answersBlobUrl}
              fileName={answersFileName}
              className="h-full rounded-b-xl"
            />
          )}
        </Suspense>
      )}
    </div>
  );
}

export function EvaluationSection({
  rows,
  selectedEvaluation,
  onSelect,
  page,
  pageSize: _pageSize = 20,
  totalCount: _totalCount,
  totalPages,
  hasMore,
  isLoading,
  isFetching,
  onPageChange,
  statusFilter = "pending",
  onStatusChange,
  moderationNote,
  onNoteChange,
  onApprove,
  onReject,
  isPending,
}: {
  rows: EvaluationModerationRow[];
  selectedEvaluation: EvaluationModerationRow | null;
  onSelect: (id: number | null) => void;
  page: number;
  pageSize?: number;
  totalCount?: number;
  totalPages?: number;
  hasMore: boolean;
  isLoading: boolean;
  isFetching: boolean;
  onPageChange: (page: number) => void;
  statusFilter?: EvaluationStatus;
  onStatusChange?: (status: EvaluationStatus) => void;
  moderationNote: Record<number, string>;
  onNoteChange: (id: number, value: string) => void;
  onApprove: (id: number) => Promise<void>;
  onReject: (id: number) => Promise<void>;
  isPending: boolean;
}) {
  const calculatedTotalPages = totalPages ?? Math.max(1, hasMore ? page + 2 : page + 1);

  return (
    <div className="flex flex-1 flex-col gap-4 lg:min-h-0 lg:flex-row">
      <Frame className="min-h-0 w-full shrink-0 flex-col lg:w-80 xl:w-96">
        {onStatusChange && (
          <FrameHeader className="flex h-11 shrink-0 flex-row items-center p-1 sm:h-12">
            <ModerationStatusTabs statusFilter={statusFilter} onStatusChange={onStatusChange} />
          </FrameHeader>
        )}

        <Card className="bg-card flex max-h-[340px] min-h-0 flex-1 flex-col overflow-hidden rounded-xl border shadow-xs/5 lg:max-h-none">
          <div className="divide-border/60 flex min-h-0 flex-1 flex-col divide-y overflow-y-auto">
            {isLoading ? (
              <div className="text-muted-foreground flex items-center justify-center gap-2 p-6 text-sm">
                <Spinner className="size-4" />
                <span>Cargando evaluaciones…</span>
              </div>
            ) : rows.length === 0 ? (
              <p className="text-muted-foreground p-6 text-center text-sm">
                {statusFilter === "pending"
                  ? "No hay evaluaciones pendientes."
                  : statusFilter === "approved"
                    ? "No hay evaluaciones aprobadas."
                    : "No hay evaluaciones rechazadas."}
              </p>
            ) : (
              rows.map((evaluation) => (
                <CardPanel
                  key={evaluation.id}
                  render={
                    <button
                      type="button"
                      aria-label={`Ver evaluación de ${evaluation.course_code}`}
                    />
                  }
                  onClick={() => onSelect(evaluation.id)}
                  className={cn(
                    "focus-visible:bg-accent flex w-full flex-none cursor-pointer flex-col p-3.5 text-left transition-colors outline-none",
                    selectedEvaluation?.id === evaluation.id
                      ? "bg-accent/80 text-accent-foreground"
                      : "hover:bg-muted/50 text-foreground",
                  )}
                >
                  <span className="truncate font-medium">
                    {evaluation.course_code}: {evaluation.course_name}
                  </span>
                  <div className="mt-1 flex w-full items-end justify-between gap-2">
                    <div className="flex min-w-0 flex-col gap-0.5">
                      <span className="text-muted-foreground truncate text-sm">
                        {formatEvaluationFileName(
                          evaluation.course_code,
                          evaluation.evaluation_type,
                          evaluation.evaluation_number,
                          evaluation.custom_name,
                        )}
                      </span>
                      <span className="text-muted-foreground truncate text-xs">
                        {evaluation.professor_name ?? "—"}
                      </span>
                    </div>
                    <div className="flex flex-col items-end gap-0.5 text-xs whitespace-nowrap">
                      <span className="text-muted-foreground">
                        {evaluation.term_display_name
                          ? evaluation.term_display_name.replace(" - ", ": ")
                          : "—"}
                      </span>
                      <span className="text-muted-foreground font-mono">
                        {formatFileSize(evaluation.file_size)}
                      </span>
                    </div>
                  </div>
                </CardPanel>
              ))
            )}
          </div>
        </Card>

        <FrameFooter className="flex h-12 shrink-0 items-center justify-center p-1.5 sm:h-13">
          <ModerationPagination
            page={page}
            totalPages={calculatedTotalPages}
            hasMore={hasMore}
            isFetching={isFetching}
            onPageChange={onPageChange}
          />
        </FrameFooter>
      </Frame>

      {selectedEvaluation && (
        <div className="flex min-w-0 flex-1 flex-col gap-4 lg:min-h-0 lg:flex-row">
          <Frame className="min-w-0 shrink-0 flex-col lg:w-80">
            <FrameHeader className="flex h-11 shrink-0 flex-row items-center px-4 py-2 sm:h-12 sm:px-5">
              <FrameTitle className="min-w-0 flex-1 truncate text-base font-semibold sm:text-lg">
                {selectedEvaluation.course_code}: {selectedEvaluation.course_name}
              </FrameTitle>
            </FrameHeader>

            <Card className="bg-card min-h-0 flex-1 overflow-hidden rounded-xl border shadow-xs/5">
              <CardPanel className="flex min-h-0 flex-1 flex-col gap-3.5 overflow-y-auto p-4 sm:p-5">
                <div className="text-muted-foreground grid grid-cols-2 gap-2 text-xs">
                  <span className="col-span-2">
                    <strong className="text-foreground font-medium">Tipo:</strong>{" "}
                    {formatEvaluationTypeLabel(
                      selectedEvaluation.evaluation_type,
                      selectedEvaluation.evaluation_number,
                      selectedEvaluation.custom_name,
                    )}
                  </span>
                  <span>
                    <strong className="text-foreground font-medium">Profesor:</strong>{" "}
                    {selectedEvaluation.professor_name ?? "—"}
                  </span>
                  <span>
                    <strong className="text-foreground font-medium">Período:</strong>{" "}
                    {selectedEvaluation.term_display_name
                      ? selectedEvaluation.term_display_name.replace(" - ", ": ")
                      : "—"}
                  </span>
                  <span>
                    <strong className="text-foreground font-medium">Tamaño:</strong>{" "}
                    {formatFileSize(selectedEvaluation.file_size)}
                  </span>
                  <span>
                    <strong className="text-foreground font-medium">Cátedra:</strong>{" "}
                    {selectedEvaluation.is_catedra ? "Sí" : "No"}
                  </span>
                  <span className="col-span-2">
                    <strong className="text-foreground font-medium">Respuestas:</strong>{" "}
                    {selectedEvaluation.has_separate_answers
                      ? "Archivo aparte"
                      : selectedEvaluation.includes_answers
                        ? "Incluidas"
                        : "No"}
                  </span>
                </div>

                {selectedEvaluation.moderation_note && (
                  <div className="rounded-lg border border-amber-500/30 bg-amber-500/10 p-2.5 text-xs text-amber-900 dark:text-amber-200">
                    <strong>Nota previa de moderación:</strong> {selectedEvaluation.moderation_note}
                  </div>
                )}

                <div className="flex flex-col gap-1.5 pt-1">
                  <div className="inline-flex w-full items-center justify-between gap-2">
                    <Label
                      htmlFor={`note-eval-${selectedEvaluation.id}`}
                      className="text-sm font-medium"
                    >
                      Nota de moderación
                    </Label>
                    <Label className="text-muted-foreground text-sm font-normal" render={<span />}>
                      Opcional
                    </Label>
                  </div>
                  <Textarea
                    id={`note-eval-${selectedEvaluation.id}`}
                    value={moderationNote[selectedEvaluation.id] ?? ""}
                    onChange={(e) => onNoteChange(selectedEvaluation.id, e.target.value)}
                    className="bg-background h-20 min-h-0 resize-none text-xs shadow-none sm:text-sm"
                    placeholder="Escribe una nota opcional para explicar el motivo del rechazo o aprobación"
                  />
                </div>
              </CardPanel>
            </Card>

            <FrameFooter className="flex h-12 shrink-0 items-center p-2 sm:h-13 sm:p-2.5">
              <div className="flex w-full gap-2.5">
                <Button
                  className="flex-1"
                  onClick={() => void onApprove(selectedEvaluation.id)}
                  disabled={isPending}
                >
                  <Icon icon={CheckIcon} size={16} className="mr-1.5 size-4" /> Aprobar
                </Button>
                <Button
                  variant="destructive"
                  className="flex-1"
                  onClick={() => void onReject(selectedEvaluation.id)}
                  disabled={isPending}
                >
                  <Icon icon={Cancel01Icon} size={16} className="mr-1.5 size-4" /> Rechazar
                </Button>
              </div>
            </FrameFooter>
          </Frame>

          <EvaluationPdfViewer
            key={selectedEvaluation.id}
            selectedEvaluation={selectedEvaluation}
          />
        </div>
      )}
    </div>
  );
}
