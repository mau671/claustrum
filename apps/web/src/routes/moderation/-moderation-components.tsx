import {
  Calendar03Icon,
  Cancel01Icon,
  CheckIcon,
  ChevronLeftIcon,
  ChevronRightIcon,
  Clock01Icon,
} from "@hugeicons/core-free-icons";
import {
  createColumnHelper,
  flexRender,
  rowPaginationFeature,
  tableFeatures,
  useTable,
} from "@tanstack/react-table";
import { Fragment, lazy, Suspense, useEffect, useMemo, useRef, useState } from "react";

import type { EvaluationModerationRow } from "@/lib/evaluations/types";
import type {
  ProfessorReviewModerationRow,
  ProfessorReviewReportModerationRow,
  ProfessorReviewStatusFilter,
} from "@/lib/professor-reviews/types";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardPanel } from "@/components/ui/card";
import { Frame, FrameFooter, FrameHeader } from "@/components/ui/frame";
import { Icon } from "@/components/ui/icon";
import { Label } from "@/components/ui/label";
import {
  Pagination,
  PaginationContent,
  PaginationEllipsis,
  PaginationItem,
} from "@/components/ui/pagination";
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

function formatDateTime(dateString: string | null | undefined): string {
  if (!dateString) return "—";
  const date = new Date(dateString);
  if (isNaN(date.getTime())) return "—";
  return new Intl.DateTimeFormat(undefined, {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(date);
}

function ReviewCourses({ review }: { review: ProfessorReviewModerationRow }) {
  return (
    <div className="space-y-1">
      {review.courses.map((course) => (
        <p
          key={`${review.review_id}-${course.id}`}
          className="text-muted-foreground text-sm break-words"
        >
          {course.code}: {course.name}
        </p>
      ))}
    </div>
  );
}

function ReviewScoreSummary({ review }: { review: ProfessorReviewModerationRow }) {
  const scores = [
    { label: "Facilidad", value: formatScore(review.ease_score) },
    { label: "Calidad", value: formatScore(review.quality_score) },
    ...(review.clarity_score !== null
      ? [{ label: "Claridad", value: formatScore(review.clarity_score) }]
      : []),
    ...(review.fairness_score !== null
      ? [{ label: "Justicia", value: formatScore(review.fairness_score) }]
      : []),
    ...(review.attendance_required !== null
      ? [
          {
            label: "Asistencia",
            value: review.attendance_required ? "Obligatoria" : "No obligatoria",
          },
        ]
      : []),
    ...(review.grade_received !== null ? [{ label: "Nota", value: review.grade_received }] : []),
    ...(review.engagement_level !== null
      ? [{ label: "Interés", value: review.engagement_level }]
      : []),
  ];

  return (
    <div className="flex flex-wrap gap-2">
      {scores.map((s, i) => (
        <div
          key={i}
          className="bg-muted text-muted-foreground flex items-center gap-1.5 rounded-md px-2.5 py-1 text-xs"
        >
          <span className="font-medium">{s.label}:</span>
          <span>{s.value}</span>
        </div>
      ))}
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
    <div className="flex min-h-0 flex-1 flex-col gap-4 lg:flex-row">
      <Frame
        className={cn(
          "min-h-0 w-full shrink-0 flex-col lg:w-80 xl:w-96",
          selectedReport && "hidden lg:flex",
        )}
      >
        <Card className="bg-card flex min-h-0 flex-1 flex-col overflow-hidden rounded-xl border shadow-xs/5">
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
                  render={<button type="button" />}
                  onClick={() => onSelect(report.report_id)}
                  className={cn(
                    "focus-visible:bg-accent flex w-full cursor-pointer flex-col p-3.5 text-left transition-colors outline-none",
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

        <FrameFooter className="p-1.5 pt-2">
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
        <div className="flex min-h-0 min-w-0 flex-1 flex-col gap-4 lg:max-h-full lg:overflow-y-auto">
          <div className="flex flex-col gap-2 sm:hidden">
            <h2 className="text-sm font-semibold">Reporte</h2>
            <Button variant="ghost" size="sm" onClick={() => onSelect(null)} className="w-fit">
              Volver
            </Button>
          </div>

          <div className="bg-card text-card-foreground flex flex-col overflow-hidden rounded-xl border shadow-xs">
            <div className="flex flex-col gap-3 p-5 md:p-6">
              <div className="space-y-1">
                <h3 className="text-xl leading-none font-semibold tracking-tight">
                  {selectedReport.course_code}: {selectedReport.course_name}
                </h3>
              </div>

              <div className="relative mt-2">
                <div className="absolute inset-0 flex items-center" aria-hidden="true">
                  <div className="border-border/50 w-full border-t" />
                </div>
              </div>

              <div className="text-muted-foreground flex flex-col gap-1.5 text-xs">
                <span>
                  <strong>Profesor:</strong> {selectedReport.professor_name}
                </span>
                <span>
                  <strong>Motivo:</strong> {selectedReport.reason}
                </span>
                {selectedReport.description && (
                  <span>
                    <strong>Detalles adicionales:</strong> {selectedReport.description}
                  </span>
                )}
              </div>

              <div className="mt-2 space-y-1.5">
                <h4 className="text-sm font-medium">Comentario reportado</h4>
                <div className="bg-muted/50 rounded-md border p-3 text-sm">
                  {selectedReport.comment}
                </div>
              </div>
            </div>

            <div className="bg-muted/30 flex flex-col gap-3 border-t p-4 md:p-5">
              <div className="flex flex-col gap-1.5">
                <Label
                  htmlFor={`note-report-${selectedReport.report_id}`}
                  className="text-sm font-medium"
                >
                  Nota de resolución
                </Label>
                <Textarea
                  id={`note-report-${selectedReport.report_id}`}
                  value={moderationNote[selectedReport.report_id] ?? ""}
                  onChange={(e) => onNoteChange(selectedReport.report_id, e.target.value)}
                  className="bg-background h-20 min-h-0 resize-none text-sm shadow-none"
                  placeholder="Escribe una nota opcional para explicar el contexto de la decisión"
                />
              </div>

              <div className="flex gap-3">
                <Button
                  className="flex-1"
                  onClick={() => void onResolve(selectedReport.report_id)}
                  disabled={isPending}
                >
                  <Icon icon={CheckIcon} size={16} className="mr-2 size-4" /> Resolver
                </Button>
                <Button
                  variant="destructive"
                  className="flex-1"
                  onClick={() => void onDismiss(selectedReport.report_id)}
                  disabled={isPending}
                >
                  <Icon icon={Cancel01Icon} size={16} className="mr-2 size-4" /> Descartar
                </Button>
              </div>
            </div>
          </div>
        </div>
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

function ReviewStatusTabs({
  statusFilter,
  onStatusChange,
}: {
  statusFilter: ProfessorReviewStatusFilter;
  onStatusChange: (status: ProfessorReviewStatusFilter) => void;
}) {
  const tabs: { value: ProfessorReviewStatusFilter; label: string }[] = [
    { value: "pending", label: "Pendientes" },
    { value: "approved", label: "Aprobadas" },
    { value: "rejected", label: "Rechazadas" },
    { value: "all", label: "Todas" },
  ];

  const tabRefs = useRef<Record<string, HTMLButtonElement | null>>({});

  useEffect(() => {
    const activeEl = tabRefs.current[statusFilter];
    if (activeEl) {
      activeEl.scrollIntoView({ behavior: "smooth", block: "nearest", inline: "nearest" });
    }
  }, [statusFilter]);

  return (
    <ScrollArea scrollFade className="w-full">
      <div className="flex w-max min-w-full items-center gap-1 px-0.5 text-xs">
        {tabs.map((tab) => {
          const isSelected = statusFilter === tab.value;
          return (
            <button
              key={tab.value}
              ref={(node) => {
                tabRefs.current[tab.value] = node;
              }}
              type="button"
              onClick={() => onStatusChange(tab.value)}
              className={cn(
                "flex-1 rounded-lg px-3 py-1.5 text-center text-xs font-medium whitespace-nowrap transition-colors",
                isSelected
                  ? "border-border/80 bg-background text-foreground border shadow-xs"
                  : "text-muted-foreground hover:bg-background/50 hover:text-foreground",
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
  const currentPage = page + 1;
  const paginationItems = useMemo(() => {
    if (totalPages <= 5) {
      return Array.from({ length: totalPages }, (_, i) => i + 1);
    }
    if (currentPage <= 3) {
      return [1, 2, 3, "ellipsis", totalPages] as const;
    }
    if (currentPage >= totalPages - 2) {
      return [1, "ellipsis", totalPages - 2, totalPages - 1, totalPages] as const;
    }
    return [1, "ellipsis", currentPage, "ellipsis", totalPages] as const;
  }, [currentPage, totalPages]);

  return (
    <Pagination className="mx-auto w-full justify-center">
      <PaginationContent className="flex flex-row items-center justify-center gap-1">
        <PaginationItem>
          <Button
            variant="ghost"
            size="icon"
            className="text-foreground size-8"
            disabled={page === 0 || isFetching}
            onClick={() => onPageChange(Math.max(page - 1, 0))}
            aria-label="Página anterior"
          >
            <Icon icon={ChevronLeftIcon} size={16} className="size-4" />
          </Button>
        </PaginationItem>

        {paginationItems.map((item, index) => {
          if (item === "ellipsis") {
            return (
              <PaginationItem key={`ellipsis-${index}`}>
                <PaginationEllipsis className="text-muted-foreground flex size-8 items-center justify-center" />
              </PaginationItem>
            );
          }

          const pageNumber = item as number;
          const isCurrent = currentPage === pageNumber;

          return (
            <PaginationItem key={pageNumber}>
              <Button
                variant={isCurrent ? "outline" : "ghost"}
                size="icon"
                className={cn(
                  "size-8 text-xs font-medium tabular-nums",
                  isCurrent &&
                    "border-border/80 bg-background text-foreground font-semibold shadow-xs",
                )}
                onClick={() => onPageChange(pageNumber - 1)}
                aria-label={`Página ${pageNumber}`}
                aria-current={isCurrent ? "page" : undefined}
              >
                {pageNumber}
              </Button>
            </PaginationItem>
          );
        })}

        <PaginationItem>
          <Button
            variant="ghost"
            size="icon"
            className="text-foreground size-8"
            disabled={!hasMore || isFetching}
            onClick={() => onPageChange(page + 1)}
            aria-label="Página siguiente"
          >
            <Icon icon={ChevronRightIcon} size={16} className="size-4" />
          </Button>
        </PaginationItem>
      </PaginationContent>
    </Pagination>
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
  statusFilter?: ProfessorReviewStatusFilter;
  onStatusChange?: (status: ProfessorReviewStatusFilter) => void;
  moderationNote: Record<number, string>;
  onNoteChange: (id: number, value: string) => void;
  onApprove: (id: number) => Promise<void>;
  onReject: (id: number) => Promise<void>;
  isPending: boolean;
}) {
  const getStatusBadge = (status: "pending" | "approved" | "rejected") => {
    switch (status) {
      case "approved":
        return (
          <Badge
            variant="outline"
            className="shrink-0 border-emerald-500/50 bg-emerald-500/10 px-1.5 py-0 text-[10px] font-medium text-emerald-700 dark:text-emerald-400"
          >
            Aprobada
          </Badge>
        );
      case "rejected":
        return (
          <Badge variant="destructive" className="shrink-0 px-1.5 py-0 text-[10px] font-medium">
            Rechazada
          </Badge>
        );
      case "pending":
      default:
        return (
          <Badge
            variant="secondary"
            className="shrink-0 border-amber-500/50 bg-amber-500/10 px-1.5 py-0 text-[10px] font-medium text-amber-700 dark:text-amber-400"
          >
            Pendiente
          </Badge>
        );
    }
  };

  const columns = useMemo(
    () => [
      reviewQueueColumnHelper.display({
        id: "reviewItem",
        cell: ({ row }) => (
          <CardPanel
            render={<button type="button" />}
            onClick={() => onSelect(row.original.review_id)}
            className={cn(
              "focus-visible:bg-accent flex w-full cursor-pointer flex-col p-3.5 text-left transition-colors outline-none",
              selectedReview?.review_id === row.original.review_id
                ? "bg-accent/80 text-accent-foreground"
                : "hover:bg-muted/50 text-foreground",
            )}
          >
            <div className="flex items-center justify-between gap-2">
              <span className="truncate font-medium">{row.original.professor_name}</span>
              {getStatusBadge(row.original.status)}
            </div>
            <div className="text-muted-foreground mt-1 flex flex-col text-xs">
              {row.original.courses.map((course) => (
                <span key={course.id} className="truncate">
                  {course.code}: {course.name}
                </span>
              ))}
            </div>
            <span className="text-muted-foreground mt-1 line-clamp-2 text-xs">
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
    <div className="flex min-h-0 flex-1 flex-col gap-4 lg:flex-row">
      <Frame
        className={cn(
          "min-h-0 w-full shrink-0 flex-col lg:w-80 xl:w-96",
          selectedReview && "hidden lg:flex",
        )}
      >
        {onStatusChange && (
          <FrameHeader className="p-1 pb-1.5">
            <ReviewStatusTabs statusFilter={statusFilter} onStatusChange={onStatusChange} />
          </FrameHeader>
        )}

        <Card className="bg-card flex min-h-0 flex-1 flex-col overflow-hidden rounded-xl border shadow-xs/5">
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

        <FrameFooter className="p-1.5 pt-2">
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
        <div className="flex min-h-0 min-w-0 flex-1 flex-col gap-4 lg:max-h-full lg:overflow-y-auto">
          <div className="flex items-start justify-between gap-2 sm:hidden">
            <h2 className="text-sm font-semibold">Revisión</h2>
            <Button variant="ghost" size="sm" onClick={() => onSelect(null)}>
              Volver
            </Button>
          </div>

          <div className="bg-card text-card-foreground flex flex-col overflow-hidden rounded-xl border shadow-xs">
            <div className="flex flex-col gap-3 p-5 md:p-6">
              <div className="flex items-start justify-between gap-3">
                <div className="space-y-1">
                  <h3 className="text-xl leading-none font-semibold tracking-tight">
                    {selectedReview.professor_name}
                  </h3>
                  <div className="pt-2">
                    <ReviewCourses review={selectedReview} />
                  </div>
                </div>
                {getStatusBadge(selectedReview.status)}
              </div>

              {/* Date and time details adapted to user's browser timezone */}
              <div className="bg-muted/40 border-border/60 text-muted-foreground flex flex-wrap items-center gap-x-4 gap-y-1.5 rounded-lg border px-3 py-2 text-xs">
                <div className="flex items-center gap-1.5">
                  <Icon icon={Calendar03Icon} size={14} className="size-3.5" />
                  <span>
                    Enviada:{" "}
                    <strong className="text-foreground font-medium">
                      {formatDateTime(selectedReview.created_at)}
                    </strong>
                  </span>
                </div>
                {selectedReview.reviewed_at && (
                  <div className="flex items-center gap-1.5">
                    <Icon icon={Clock01Icon} size={14} className="size-3.5" />
                    <span>
                      Moderada:{" "}
                      <strong className="text-foreground font-medium">
                        {formatDateTime(selectedReview.reviewed_at)}
                      </strong>
                    </span>
                  </div>
                )}
              </div>

              <div className="relative mt-1">
                <div className="absolute inset-0 flex items-center" aria-hidden="true">
                  <div className="border-border/50 w-full border-t" />
                </div>
              </div>

              <blockquote className="border-primary/50 text-muted-foreground my-2 border-l-2 pl-4 italic">
                "{selectedReview.comment}"
              </blockquote>

              <ReviewScoreSummary review={selectedReview} />

              {selectedReview.tags && selectedReview.tags.length > 0 && (
                <div className="mt-1 flex flex-wrap gap-1.5">
                  {selectedReview.tags.map((tag) => (
                    <Badge key={tag} variant="secondary" className="font-normal">
                      {tag}
                    </Badge>
                  ))}
                </div>
              )}

              {selectedReview.moderation_note && (
                <div className="text-muted-foreground bg-muted/60 mt-2 rounded-md border p-2.5 text-xs">
                  <strong className="text-foreground">Nota previa:</strong>{" "}
                  {selectedReview.moderation_note}
                </div>
              )}
            </div>

            <div className="bg-muted/30 flex flex-col gap-3 border-t p-4 md:p-5">
              <div className="flex flex-col gap-1.5">
                <Label
                  htmlFor={`note-review-${selectedReview.review_id}`}
                  className="text-sm font-medium"
                >
                  Nota de moderación
                </Label>
                <Textarea
                  id={`note-review-${selectedReview.review_id}`}
                  value={moderationNote[selectedReview.review_id] ?? ""}
                  onChange={(e) => onNoteChange(selectedReview.review_id, e.target.value)}
                  className="bg-background h-20 min-h-0 resize-none text-sm shadow-none"
                  placeholder="Escribe una nota opcional para explicar el motivo del rechazo o aprobación"
                />
              </div>

              <div className="flex gap-3">
                <Button
                  className="flex-1"
                  onClick={() => void onApprove(selectedReview.review_id)}
                  disabled={isPending}
                >
                  <Icon icon={CheckIcon} size={16} className="mr-2 size-4" /> Aprobar
                </Button>
                <Button
                  variant="destructive"
                  className="flex-1"
                  onClick={() => void onReject(selectedReview.review_id)}
                  disabled={isPending}
                >
                  <Icon icon={Cancel01Icon} size={16} className="mr-2 size-4" /> Rechazar
                </Button>
              </div>
            </div>
          </div>
        </div>
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
  hasMore,
  isLoading,
  isFetching,
  onPageChange,
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
  hasMore: boolean;
  isLoading: boolean;
  isFetching: boolean;
  onPageChange: (page: number) => void;
  moderationNote: Record<number, string>;
  onNoteChange: (id: number, value: string) => void;
  onApprove: (id: number) => Promise<void>;
  onReject: (id: number) => Promise<void>;
  isPending: boolean;
}) {
  return (
    <div className="flex min-h-0 flex-1 flex-col gap-4 lg:flex-row">
      <Frame
        className={cn(
          "min-h-0 w-full shrink-0 flex-col lg:w-80 xl:w-96",
          selectedEvaluation && "hidden lg:flex",
        )}
      >
        <Card className="bg-card flex min-h-0 flex-1 flex-col overflow-hidden rounded-xl border shadow-xs/5">
          <div className="divide-border/60 flex min-h-0 flex-1 flex-col divide-y overflow-y-auto">
            {isLoading ? (
              <div className="text-muted-foreground flex items-center justify-center gap-2 p-6 text-sm">
                <Spinner className="size-4" />
                <span>Cargando evaluaciones…</span>
              </div>
            ) : rows.length === 0 ? (
              <p className="text-muted-foreground p-6 text-center text-sm">
                No hay evaluaciones pendientes.
              </p>
            ) : (
              rows.map((evaluation) => (
                <CardPanel
                  key={evaluation.id}
                  render={<button type="button" />}
                  onClick={() => onSelect(evaluation.id)}
                  className={cn(
                    "focus-visible:bg-accent flex w-full cursor-pointer flex-col p-3.5 text-left transition-colors outline-none",
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

        <FrameFooter className="p-1.5 pt-2">
          <ModerationPagination
            page={page}
            totalPages={hasMore ? page + 2 : page + 1}
            hasMore={hasMore}
            isFetching={isFetching}
            onPageChange={onPageChange}
          />
        </FrameFooter>
      </Frame>

      {selectedEvaluation && (
        <div className="flex min-h-0 min-w-0 flex-1 flex-col gap-4 lg:flex-row">
          <div className="flex flex-col gap-2 sm:hidden">
            <h2 className="text-sm font-semibold">Revisión</h2>
            <Button variant="ghost" size="sm" onClick={() => onSelect(null)} className="w-fit">
              Volver
            </Button>
          </div>

          <div className="bg-card text-card-foreground flex min-h-0 shrink-0 flex-col overflow-x-hidden overflow-y-auto rounded-xl border shadow-xs lg:w-80">
            <div className="flex flex-col gap-3 p-5 md:p-6">
              <div className="space-y-1">
                <h3 className="text-xl leading-none font-semibold tracking-tight">
                  {selectedEvaluation.course_code}: {selectedEvaluation.course_name}
                </h3>
              </div>

              <div className="relative mt-2">
                <div className="absolute inset-0 flex items-center" aria-hidden="true">
                  <div className="border-border/50 w-full border-t" />
                </div>
              </div>

              <div className="text-muted-foreground flex flex-col gap-1.5 text-xs">
                <span>
                  <strong>Tipo:</strong>{" "}
                  {formatEvaluationTypeLabel(
                    selectedEvaluation.evaluation_type,
                    selectedEvaluation.evaluation_number,
                    selectedEvaluation.custom_name,
                  )}
                </span>
                <span>
                  <strong>Período:</strong>{" "}
                  {selectedEvaluation.term_display_name
                    ? selectedEvaluation.term_display_name.replace(" - ", ": ")
                    : "—"}
                </span>
                <span>
                  <strong>Profesor:</strong> {selectedEvaluation.professor_name ?? "—"}
                </span>
                <span>
                  <strong>Tamaño:</strong> {formatFileSize(selectedEvaluation.file_size)}
                </span>
                <span>
                  <strong>Cátedra:</strong> {selectedEvaluation.is_catedra ? "Sí" : "No"}
                </span>
                <span>
                  <strong>Respuestas:</strong>{" "}
                  {selectedEvaluation.has_separate_answers
                    ? "Archivo aparte"
                    : selectedEvaluation.includes_answers
                      ? "Incluidas"
                      : "No"}
                </span>
              </div>
            </div>

            <div className="bg-muted/30 mt-auto flex flex-col gap-3 border-t p-4 md:p-5">
              <div className="flex flex-col gap-1.5">
                <Label
                  htmlFor={`note-eval-${selectedEvaluation.id}`}
                  className="text-sm font-medium"
                >
                  Nota de moderación
                </Label>
                <Textarea
                  id={`note-eval-${selectedEvaluation.id}`}
                  value={moderationNote[selectedEvaluation.id] ?? ""}
                  onChange={(e) => onNoteChange(selectedEvaluation.id, e.target.value)}
                  className="bg-background h-20 min-h-0 resize-none text-sm shadow-none"
                  placeholder="Escribe una nota opcional para explicar el motivo del rechazo"
                />
              </div>

              <div className="flex flex-col gap-2">
                <Button
                  className="w-full"
                  onClick={() => void onApprove(selectedEvaluation.id)}
                  disabled={isPending}
                >
                  <Icon icon={CheckIcon} size={16} className="mr-2 size-4" /> Aprobar
                </Button>
                <Button
                  variant="destructive"
                  className="w-full"
                  onClick={() => void onReject(selectedEvaluation.id)}
                  disabled={isPending}
                >
                  <Icon icon={Cancel01Icon} size={16} className="mr-2 size-4" /> Rechazar
                </Button>
              </div>
            </div>
          </div>

          <EvaluationPdfViewer
            key={selectedEvaluation.id}
            selectedEvaluation={selectedEvaluation}
          />
        </div>
      )}
    </div>
  );
}
