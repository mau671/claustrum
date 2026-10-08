"use client";

import { useQueryClient } from "@tanstack/react-query";
import { useNavigate } from "@tanstack/react-router";
import {
  ArrowLeft,
  ChevronLeft,
  ChevronRight,
  Clock,
  FileText,
  GraduationCap,
  MapPin,
  Minus,
  Pencil,
  Plus,
  Trash2,
  MoreVertical,
  User,
  Users,
} from "lucide-react";
import { useEffect, useMemo, useRef, useState } from "react";
import { toast } from "sonner";

import type {
  AcademicTerm,
  Course,
  CourseAttempt,
  CourseLatestTermGroup,
  CourseStatus,
} from "@/lib/types";

import { CourseRelationFlow } from "@/components/course-relation-flow";
import { EvaluationUploadDialog } from "@/components/evaluations/evaluation-upload-dialog";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Combobox,
  ComboboxCollection,
  ComboboxContent,
  ComboboxEmpty,
  ComboboxGroup,
  ComboboxInput,
  ComboboxItem,
  ComboboxLabel,
  ComboboxList,
  ComboboxSeparator,
  ComboboxTrigger,
} from "@/components/ui/combobox";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Separator } from "@/components/ui/separator";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { useIsMobile } from "@/hooks/use-mobile";
import {
  formatClosedTermLabel,
  formatTermNameWithoutYear,
  groupTermsByYear,
  sortTermsLogical,
} from "@/lib/academic-terms";
import { formatEvaluationFileName, type EvaluationType } from "@/lib/evaluations/types";
import { useCourseEvaluations } from "@/lib/hooks/use-evaluations";
import {
  useCourseAttempts,
  useDeleteCourseAttempt,
  useCourseDetailRelatedCourses,
  useCourseLatestTermGroups,
  useCourseOfferingTerms,
  useUpdateCourseAttempt,
} from "@/lib/hooks/use-queries";
import { cn, getCampusCodeFromName } from "@/lib/utils";

/* ------------------------------------------------------------------ */
/*  Types & constants                                                  */
/* ------------------------------------------------------------------ */

interface CourseDetailsProps {
  course: Course;
  courseById: Map<string, Course>;
  userId?: string;
  studyPlanId?: number;
  modalityName?: string;
  transitionName?: string;
  onCreateAttempt: (
    targetCourseId: string,
    attempt: {
      status: Exclude<CourseStatus, "not_taken">;
      grade: number | null;
      academicTermId: number | null;
      equivalentCourseId?: number | null;
    },
  ) => Promise<"success" | "local">;
  onBack?: () => void;
  initialOpenProgressSheet?: boolean;
}

function getOrdinalSuffix(num: number): string {
  switch (num) {
    case 1:
    case 3:
      return "er";
    case 2:
      return "do";
    case 4:
    case 5:
    case 6:
      return "to";
    case 7:
    case 10:
      return "mo";
    case 8:
      return "vo";
    case 9:
      return "no";
    default:
      return "º";
  }
}

const statusLabels: Record<CourseStatus, string> = {
  approved: "Aprobado",
  failed: "Reprobado",
  not_taken: "No cursado",
  withdrawn: "Retirado",
  in_progress: "En curso",
};

const statusConfig: Record<CourseStatus, { color: string; bg: string; ring: string; dot: string }> =
  {
    approved: {
      color: "text-emerald-700 dark:text-emerald-400",
      bg: "bg-emerald-50 dark:bg-emerald-950/40",
      ring: "ring-emerald-200 dark:ring-emerald-800",
      dot: "bg-emerald-500",
    },
    failed: {
      color: "text-red-700 dark:text-red-400",
      bg: "bg-red-50 dark:bg-red-950/40",
      ring: "ring-red-200 dark:ring-red-800",
      dot: "bg-red-500",
    },
    not_taken: {
      color: "text-muted-foreground",
      bg: "bg-muted/60",
      ring: "ring-border",
      dot: "bg-muted-foreground",
    },
    withdrawn: {
      color: "text-amber-700 dark:text-amber-400",
      bg: "bg-amber-50 dark:bg-amber-950/40",
      ring: "ring-amber-200 dark:ring-amber-800",
      dot: "bg-amber-500",
    },
    in_progress: {
      color: "text-sky-700 dark:text-sky-400",
      bg: "bg-sky-50 dark:bg-sky-950/40",
      ring: "ring-sky-200 dark:ring-sky-800",
      dot: "bg-sky-500",
    },
  };

const WEEKDAYS = ["", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado", "Domingo"];

/* ------------------------------------------------------------------ */
/*  Helpers                                                            */
/* ------------------------------------------------------------------ */

function formatTime(value: string) {
  return value.slice(0, 5);
}

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

/* ------------------------------------------------------------------ */
/*  Sub-components                                                     */
/* ------------------------------------------------------------------ */

function StatusBadge({ status }: { status: CourseStatus }) {
  const cfg = statusConfig[status];
  return (
    <span
      className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-0.5 text-xs font-medium ring-1 ${cfg.bg} ${cfg.color} ${cfg.ring}`}
    >
      <span className={`size-1.5 rounded-full ${cfg.dot}`} />
      {statusLabels[status]}
    </span>
  );
}

function SectionHeader({ title, action }: { title: string; action?: React.ReactNode }) {
  return (
    <div className="mb-4 flex items-center justify-between gap-3">
      <h2 className="text-lg font-semibold tracking-tight">{title}</h2>
      {action ? <div className="flex items-center gap-2">{action}</div> : null}
    </div>
  );
}

function TimelineItem({
  attempt,
  termLabel,
  onEdit,
  onDelete,
}: {
  attempt: CourseAttempt;
  termLabel: string;
  onEdit: (attempt: CourseAttempt) => void;
  onDelete: (attempt: CourseAttempt) => void;
}) {
  const cfg = statusConfig[attempt.status];
  const date = new Date(attempt.recordedAt);
  const gradeText = attempt.grade === null ? null : `${Math.round(attempt.grade)}`;

  return (
    <div className="relative flex gap-4">
      {/* line */}
      <div className="flex flex-col items-center">
        <div
          className={`flex size-8 shrink-0 items-center justify-center rounded-full ring-2 ${cfg.bg} ${cfg.ring}`}
        >
          <span className={`text-xs font-bold ${cfg.color}`}>#{attempt.attemptNumber}</span>
        </div>
        <div className="bg-border mt-1 w-px flex-1" />
      </div>

      {/* content */}
      <div className="min-w-0 flex-1 pb-6">
        <div className="flex items-start justify-between gap-2">
          <div className="flex flex-wrap items-center gap-2">
            <span className="text-foreground text-sm font-semibold">
              {statusLabels[attempt.status]}
            </span>
            <span className="text-muted-foreground text-xs">{date.toLocaleDateString()}</span>
          </div>
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button
                type="button"
                variant="ghost"
                size="icon"
                className="-my-1 size-7 shrink-0"
                aria-label="Opciones de intento"
              >
                <MoreVertical className="size-3.5" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onClick={() => onEdit(attempt)}>
                <Pencil className="text-muted-foreground mr-2 size-4" />
                Editar
              </DropdownMenuItem>
              <DropdownMenuItem
                className="text-destructive focus:bg-destructive/10 focus:text-destructive"
                onClick={() => onDelete(attempt)}
              >
                <Trash2 className="mr-2 size-4" />
                Eliminar
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
        <div className="text-muted-foreground flex flex-col gap-0.5 text-sm">
          {gradeText ? (
            <span className="inline-flex items-center gap-1.5">
              <GraduationCap className="size-3.5 shrink-0" />
              Nota: {gradeText}
            </span>
          ) : null}
          {termLabel ? (
            <span className="inline-flex items-center gap-1.5">
              <Clock className="size-3.5 shrink-0" />
              {termLabel}
            </span>
          ) : null}
        </div>
        {attempt.equivalentCourseId ? (
          <p className="text-muted-foreground mt-2 text-xs italic">
            Nota: Tomado como {attempt.equivalentCourseCode}
            {attempt.equivalentCourseName ? `: ${attempt.equivalentCourseName}` : ""}
          </p>
        ) : null}
      </div>
    </div>
  );
}

function TimelineOriginItem({ course }: { course: Course }) {
  const cfg = statusConfig[course.status];
  const date = course.statusOriginRecordedAt ? new Date(course.statusOriginRecordedAt) : null;
  const gradeText =
    course.statusOriginGrade === null || course.statusOriginGrade === undefined
      ? null
      : `${Math.round(course.statusOriginGrade)}`;
  const statusLabel = statusLabels[course.status];
  const originLabel =
    course.statusOriginType === "same_course_global"
      ? `${statusLabel} en otro plan como ${course.statusOriginCourseCode ?? "este mismo curso"}`
      : `${statusLabel} por equivalencia con ${course.statusOriginCourseCode ?? "otro curso"}`;
  const originDetail = course.statusOriginCourseName
    ? `${originLabel}: ${course.statusOriginCourseName}`
    : originLabel;
  const attemptNumberText = course.statusOriginAttemptNumber
    ? `#${course.statusOriginAttemptNumber}`
    : "#";

  return (
    <div className="relative flex gap-4">
      <div className="flex flex-col items-center">
        <div
          className={`flex size-8 shrink-0 items-center justify-center rounded-full ring-2 ${cfg.bg} ${cfg.ring}`}
        >
          <span className={`text-xs font-bold ${cfg.color}`}>{attemptNumberText}</span>
        </div>
        <div className="bg-border mt-1 w-px flex-1" />
      </div>

      <div className="min-w-0 flex-1 pb-6">
        <div className="mb-1 flex items-start justify-between gap-2">
          <div className="flex flex-wrap items-center gap-2">
            <span className="text-foreground text-sm font-semibold">{statusLabel}</span>
            {date ? (
              <span className="text-muted-foreground text-xs">{date.toLocaleDateString()}</span>
            ) : null}
          </div>
        </div>
        <div className="text-muted-foreground flex flex-wrap items-center gap-x-4 gap-y-1 text-sm">
          {gradeText ? (
            <span className="inline-flex items-center gap-1">
              <GraduationCap className="size-3.5" />
              Nota {gradeText}
            </span>
          ) : null}
          {course.statusOriginAcademicTermName ? (
            <span className="inline-flex items-center gap-1">
              <Clock className="size-3.5" />
              {course.statusOriginAcademicTermName}
            </span>
          ) : null}
        </div>
        <p className="text-muted-foreground mt-2 text-xs italic">Nota: {originDetail}</p>
      </div>
    </div>
  );
}

function formatCourseLabel<T extends { code: string; name: string }>(course: T) {
  return `${course.code}: ${course.name}`;
}

function ScheduleGroupCard({
  group,
  currentCourseId,
}: {
  group: CourseLatestTermGroup;
  currentCourseId: number;
  onPrepareTransition: (key: string, id: number, name: string) => void;
}) {
  const professors = group.professors ?? [];
  const meetings = group.meetings ?? [];
  const isFromEquivalentCourse = group.sourceCourseId !== currentCourseId;

  const classrooms = meetings.map((meeting) => meeting.classroom);
  const sharedClassroom =
    meetings.length > 1 &&
    classrooms.every((classroom): classroom is string => classroom !== null) &&
    classrooms.every((classroom) => classroom === classrooms[0])
      ? classrooms[0]
      : null;

  return (
    <div className="border-border bg-card space-y-3 rounded-xl border p-4">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Badge variant="secondary" className="text-xs font-semibold">
            <span className="hidden sm:inline">Grupo </span>
            <span className="sm:hidden">GR </span>
            {group.groupCode}
          </Badge>
          <span className="text-muted-foreground text-xs">{group.groupType}</span>
        </div>

        {group.campusName && (
          <Tooltip delayDuration={300}>
            <TooltipTrigger asChild>
              <Badge
                variant="outline"
                className="bg-muted text-muted-foreground h-5 cursor-help px-1.5 text-[10px]"
              >
                {getCampusCodeFromName(group.campusName) || group.campusName}
              </Badge>
            </TooltipTrigger>
            <TooltipContent>{group.campusName}</TooltipContent>
          </Tooltip>
        )}
      </div>

      {isFromEquivalentCourse ? (
        <div className="bg-muted/40 border-border rounded-md border px-2 py-1.5 text-xs">
          <span className="text-muted-foreground">Oferta de: </span>
          <span className="text-foreground font-medium">
            {formatCourseLabel({ code: group.sourceCourseCode, name: group.sourceCourseName })}
          </span>
        </div>
      ) : null}

      <Separator />

      <div className="space-y-2">
        <div className="flex items-center gap-2">
          <User className="text-muted-foreground size-3.5 shrink-0 self-center" />
          <div className="flex flex-col justify-center gap-1">
            {professors.length === 0 ? (
              <span className="text-muted-foreground text-xs">Sin asignar</span>
            ) : (
              professors.map((professor) => {
                const transitionKey = `group-${group.groupId}-${professor.id}`;
                return (
                  <span key={transitionKey} className="text-xs">
                    {professor.name}
                  </span>
                );
              })
            )}
          </div>
        </div>

        <div className={cn("relative", sharedClassroom && "pr-16")}>
          <div className="flex items-start gap-2">
            <Clock className="text-muted-foreground size-3.5 shrink-0 self-center" />
            <div className="flex min-w-0 flex-1 flex-col justify-center gap-1">
              {meetings.length === 0 ? (
                <span className="text-muted-foreground text-xs">Sin horario registrado</span>
              ) : (
                meetings.map((meeting) => (
                  <div
                    key={`${meeting.weekday}-${meeting.starts_at}`}
                    className="grid min-w-0 grid-cols-[minmax(0,1fr)_auto] items-center gap-2"
                  >
                    <span className="text-foreground min-w-0 text-xs leading-tight whitespace-nowrap">
                      {WEEKDAYS[meeting.weekday] ?? `Dia ${meeting.weekday}`}{" "}
                      {formatTime(meeting.starts_at)}-{formatTime(meeting.ends_at)}
                    </span>
                    {!sharedClassroom && meeting.classroom && (
                      <span className="text-muted-foreground flex items-center gap-1 justify-self-end text-xs whitespace-nowrap">
                        <MapPin className="size-3.5 shrink-0" />
                        <span>{meeting.classroom}</span>
                      </span>
                    )}
                  </div>
                ))
              )}
            </div>
          </div>
          {sharedClassroom && (
            <div className="text-muted-foreground absolute top-1/2 right-0 flex -translate-y-1/2 items-center gap-1 text-xs whitespace-nowrap">
              <MapPin className="size-3.5 shrink-0" />
              <span>{sharedClassroom}</span>
            </div>
          )}
        </div>

        <div className="text-muted-foreground flex items-center gap-1.5 text-xs">
          <Users className="size-3.5 shrink-0" />
          {group.capacity} cupos
        </div>
      </div>
    </div>
  );
}

function EvaluationDocument({
  courseCode,
  evaluation,
  onPreview,
}: {
  courseCode: string;
  evaluation: {
    id: number;
    course_code?: string;
    course_name?: string;
    file_key: string;
    evaluation_type: EvaluationType;
    evaluation_number: number | null;
    custom_name: string | null;
    term_display_name: string | null;
    professor_name: string | null;
    is_catedra: boolean;
    includes_answers: boolean;
    has_separate_answers: boolean;
    file_size: number;
    status: string;
  };
  onPreview: (payload: { id: number }) => void;
}) {
  const fileName = formatEvaluationFileName(
    evaluation.course_code ?? courseCode,
    evaluation.evaluation_type,
    evaluation.evaluation_number,
    evaluation.custom_name,
  );

  return (
    <div className="group border-border bg-card hover:bg-accent/30 flex items-start gap-3 rounded-xl border p-3 transition-colors">
      <div className="bg-primary/5 text-primary flex size-10 shrink-0 items-center justify-center rounded-lg">
        <FileText className="size-5" />
      </div>

      <div className="min-w-0 flex-1">
        <div className="flex items-start justify-between gap-2">
          <button
            type="button"
            onClick={() =>
              onPreview({
                id: evaluation.id,
              })
            }
            className="min-w-0 cursor-pointer truncate text-left text-sm font-medium underline-offset-4 hover:underline"
          >
            {fileName}
          </button>
          <div className="text-muted-foreground shrink-0 text-right text-xs">
            {evaluation.term_display_name ? (
              <div>{evaluation.term_display_name.replace(" - ", ": ")}</div>
            ) : null}
          </div>
        </div>

        <div className="text-muted-foreground mt-0.5 flex items-center justify-between gap-3 text-xs">
          <div className="flex min-w-0 flex-wrap items-center gap-x-3 gap-y-0.5">
            {evaluation.is_catedra ? <span>Cátedra</span> : null}
            {evaluation.professor_name ? (
              <span className="truncate">{evaluation.professor_name}</span>
            ) : null}
          </div>
          <span className="shrink-0 font-mono">{formatFileSize(evaluation.file_size)}</span>
        </div>
      </div>
    </div>
  );
}

/* ------------------------------------------------------------------ */
/*  Main component                                                     */
/* ------------------------------------------------------------------ */

export function CourseDetails({
  course,
  courseById,
  userId,
  studyPlanId,
  modalityName,
  transitionName,
  onCreateAttempt,
  onBack,
  initialOpenProgressSheet,
}: CourseDetailsProps) {
  const isMobile = useIsMobile();
  const queryClient = useQueryClient();
  const [gradeInput, setGradeInput] = useState("");
  const [academicTermId, setAcademicTermId] = useState<string>("");
  const [isProgressSheetOpen, setIsProgressSheetOpen] = useState(initialOpenProgressSheet ?? false);
  const [progressStatus, setProgressStatus] =
    useState<Exclude<CourseStatus, "not_taken">>("approved");
  const [isSaving, setIsSaving] = useState(false);
  const [equivalentsPage, setEquivalentsPage] = useState(0);
  const [isExamUploadOpen, setIsExamUploadOpen] = useState(false);
  const [editingAttempt, setEditingAttempt] = useState<CourseAttempt | null>(null);
  const [editAcademicTermId, setEditAcademicTermId] = useState<string>("");
  const [editGradeInput, setEditGradeInput] = useState("");
  const [editStatus, setEditStatus] = useState<Exclude<CourseStatus, "not_taken">>("approved");
  const [editAttemptCourseId, setEditAttemptCourseId] = useState(course.id);
  const [deletingAttempt, setDeletingAttempt] = useState<CourseAttempt | null>(null);
  const [offeringTermId, setOfferingTermId] = useState<string>("");
  const [attemptCourseId, setAttemptCourseId] = useState(course.id);
  const comboboxPortalContainerRef = useRef<HTMLDivElement | null>(null);
  const attemptCourseTriggerRef = useRef<HTMLButtonElement | null>(null);
  const progressTermTriggerRef = useRef<HTMLButtonElement | null>(null);
  const editTermTriggerRef = useRef<HTMLButtonElement | null>(null);
  const editAttemptCourseTriggerRef = useRef<HTMLButtonElement | null>(null);
  const navigate = useNavigate();
  const updateCourseAttempt = useUpdateCourseAttempt();
  const deleteCourseAttempt = useDeleteCourseAttempt();

  const EQUIVALENTS_PER_PAGE = 10;

  useEffect(() => {
    setGradeInput("");
    setProgressStatus("approved");
    setIsProgressSheetOpen(false);
    setEquivalentsPage(0);
    setAttemptCourseId(course.id);
  }, [course.id]);

  const attemptCourseNumericId = Number.parseInt(attemptCourseId, 10);
  const progressCourseId = Number.isNaN(attemptCourseNumericId)
    ? Number.parseInt(course.id, 10)
    : attemptCourseNumericId;

  const progressTermsQuery = useCourseOfferingTerms(progressCourseId, null, null);
  const academicTerms = useMemo(
    () =>
      sortTermsLogical(progressTermsQuery.isPlaceholderData ? [] : (progressTermsQuery.data ?? [])),
    [progressTermsQuery.data, progressTermsQuery.isPlaceholderData],
  );

  const relatedCoursesQuery = useCourseDetailRelatedCourses(
    studyPlanId ?? null,
    parseInt(course.id),
    equivalentsPage,
    EQUIVALENTS_PER_PAGE,
  );
  const allRelatedCoursesQuery = useCourseDetailRelatedCourses(
    studyPlanId ?? null,
    parseInt(course.id),
    0,
    10000,
  );

  const attemptsQuery = useCourseAttempts(userId ?? null, studyPlanId ?? null, parseInt(course.id));

  const offeringTermsQuery = useCourseOfferingTerms(
    parseInt(course.id),
    null,
    null,
    studyPlanId ?? null,
  );
  const selectedOfferingTermNumericId =
    offeringTermId.trim() === "" ? null : Number.parseInt(offeringTermId, 10);
  const normalizedOfferingTermId = Number.isNaN(selectedOfferingTermNumericId ?? Number.NaN)
    ? null
    : selectedOfferingTermNumericId;

  const latestGroupsQuery = useCourseLatestTermGroups(
    parseInt(course.id),
    null,
    null,
    normalizedOfferingTermId,
    studyPlanId ?? null,
  );
  const evaluationsQuery = useCourseEvaluations(parseInt(course.id), studyPlanId ?? null);

  const totalEquivalents = relatedCoursesQuery.data?.totalCount ?? 0;
  const equivalents = (relatedCoursesQuery.data?.data ?? []).filter(
    (item) => item.relationKind === "equivalent",
  );
  const totalPages = Math.ceil(totalEquivalents / EQUIVALENTS_PER_PAGE);
  const isPlaceholderCourse = allRelatedCoursesQuery.data?.isPlaceholder ?? false;
  const baseCourseOption = useMemo(
    () => ({
      id: Number.parseInt(course.id, 10),
      code: course.code,
      name: course.name,
      credits: course.credits,
      weeklyHours: course.hours,
      relationKind: "base" as const,
      isPlaceholder: isPlaceholderCourse,
      hasOfferings: false,
      totalEquivalents,
    }),
    [
      course.code,
      course.credits,
      course.hours,
      course.id,
      course.name,
      isPlaceholderCourse,
      totalEquivalents,
    ],
  );
  const attemptCourseOptions = useMemo(() => {
    if (!isPlaceholderCourse) return [baseCourseOption];
    const equivalents = (allRelatedCoursesQuery.data?.data ?? [])
      .filter((option) => option.relationKind === "equivalent")
      .filter((option) => option.hasOfferings)
      .sort((a, b) => a.code.localeCompare(b.code));
    return equivalents;
  }, [allRelatedCoursesQuery.data?.data, baseCourseOption, isPlaceholderCourse]);
  const selectedAttemptCourse =
    attemptCourseOptions.find((option) => String(option.id) === attemptCourseId) ?? null;

  useEffect(() => {
    if (!isPlaceholderCourse) {
      if (attemptCourseId !== course.id) setAttemptCourseId(course.id);
      return;
    }

    if (attemptCourseOptions.length === 0) return;
    if (!attemptCourseOptions.some((option) => String(option.id) === attemptCourseId)) {
      setAttemptCourseId(String(attemptCourseOptions[0].id));
    }
  }, [attemptCourseId, attemptCourseOptions, course.id, isPlaceholderCourse]);

  useEffect(() => {
    if (!academicTermId && academicTerms.length > 0) {
      setAcademicTermId(String(academicTerms[0].id));
      return;
    }

    if (academicTermId && !academicTerms.some((term) => String(term.id) === academicTermId)) {
      setAcademicTermId(academicTerms.length > 0 ? String(academicTerms[0].id) : "");
    }
  }, [academicTermId, academicTerms]);

  const latestTermGroups = latestGroupsQuery.data ?? [];
  const offeringTerms = useMemo(
    () => sortTermsLogical(offeringTermsQuery.data ?? []),
    [offeringTermsQuery.data],
  );
  const selectedOfferingTerm =
    offeringTerms.find((term) => String(term.id) === offeringTermId) ?? null;
  const academicTermGroups = useMemo(() => groupTermsByYear(academicTerms), [academicTerms]);
  const offeringTermGroups = useMemo(() => groupTermsByYear(offeringTerms), [offeringTerms]);
  const evaluations = evaluationsQuery.data ?? [];

  useEffect(() => {
    if (!offeringTermId && offeringTerms.length > 0) {
      setOfferingTermId(String(offeringTerms[0].id));
      return;
    }

    if (offeringTermId && !offeringTerms.some((term) => String(term.id) === offeringTermId)) {
      setOfferingTermId(offeringTerms.length > 0 ? String(offeringTerms[0].id) : "");
    }
  }, [offeringTermId, offeringTerms]);

  const prerequisites = (course.prerequisites || []).flatMap((id) => {
    const item = courseById.get(id);
    return item ? [item] : [];
  });

  const corequisites = (course.corequisites || []).flatMap((id) => {
    const item = courseById.get(id);
    return item ? [item] : [];
  });

  const isPrerequisiteFor = Array.from(courseById.values()).filter((item) =>
    item.prerequisites?.includes(course.id),
  );

  const attempts: CourseAttempt[] = attemptsQuery.data ?? [];
  const termLabelById = new Map<number, string>(
    academicTerms.map((term: AcademicTerm) => [term.id, formatClosedTermLabel(term)]),
  );
  const selectedQuickTerm =
    academicTerms.find((term) => String(term.id) === academicTermId) ?? null;
  const selectedEditTerm =
    academicTerms.find((term) => String(term.id) === editAcademicTermId) ?? null;

  /* --- handlers (preserved) --- */

  const handleOpenProgressSheet = () => {
    const inProgressAttempts = attempts.filter((a) => a.status === "in_progress");
    if (inProgressAttempts.length > 0) {
      const latest = [...inProgressAttempts].sort((a, b) => b.attemptNumber - a.attemptNumber)[0];
      if (latest.academicTermId) {
        setAcademicTermId(String(latest.academicTermId));
      }
      if (isPlaceholderCourse && latest.equivalentCourseId) {
        setAttemptCourseId(String(latest.equivalentCourseId));
      }
    }
    setIsProgressSheetOpen(true);
  };

  const parseSelectedTermId = () => {
    if (!academicTermId) return null;
    const parsed = Number(academicTermId);
    if (!Number.isInteger(parsed) || parsed <= 0) {
      toast.error("El periodo seleccionado no es válido");
      return undefined;
    }
    return parsed;
  };

  const handleSaveProgress = async () => {
    const parsedAcademicTermId = parseSelectedTermId();
    if (parsedAcademicTermId === undefined) return;

    const requiresGrade = progressStatus === "approved" || progressStatus === "failed";
    const parsedGrade = gradeInput.trim() === "" ? null : Number(gradeInput);

    if (parsedGrade !== null && !Number.isNaN(parsedGrade)) {
      if (parsedGrade < 0 || parsedGrade > 100) {
        toast.error("La nota debe estar entre 0 y 100");
        return;
      }
    }

    setIsSaving(true);
    try {
      const result = await onCreateAttempt(course.id, {
        status: progressStatus,
        grade: requiresGrade ? parsedGrade : null,
        academicTermId: parsedAcademicTermId,
        equivalentCourseId: isPlaceholderCourse ? parseInt(attemptCourseId) : null,
      });

      if (result === "local") {
        toast.success("Progreso guardado localmente", {
          description: "Inicia sesión para guardar el historial de intentos permanentemente",
          duration: 5000,
        });
      } else {
        toast.success("Progreso registrado correctamente");
      }

      setGradeInput("");
      setProgressStatus("approved");
      setIsProgressSheetOpen(false);
      void attemptsQuery.refetch();
    } catch {
      toast.error("Error al registrar el progreso");
    } finally {
      setIsSaving(false);
    }
  };

  const handleGradeInputChange = (value: string) => {
    if (value === "") {
      setGradeInput("");
      return;
    }
    if (!/^\d{0,3}(\.\d{0,2})?$/.test(value)) return;
    const parsed = Number(value);
    if (Number.isNaN(parsed)) return;
    setGradeInput(String(Math.min(100, Math.max(0, parsed))));
  };

  const handleGradeStep = (delta: number) => {
    const current = gradeInput.trim() === "" ? 0 : Number(gradeInput);
    if (Number.isNaN(current)) {
      setGradeInput("0");
      return;
    }
    const next = Math.min(100, Math.max(0, Math.round((current + delta) * 100) / 100));
    setGradeInput(String(next));
  };

  const handleEditGradeInputChange = (value: string) => {
    if (value === "") {
      setEditGradeInput("");
      return;
    }
    if (!/^\d{0,3}(\.\d{0,2})?$/.test(value)) return;
    const parsed = Number(value);
    if (Number.isNaN(parsed)) return;
    setEditGradeInput(String(Math.min(100, Math.max(0, parsed))));
  };

  const handleEditGradeStep = (delta: number) => {
    const current = editGradeInput.trim() === "" ? 0 : Number(editGradeInput);
    if (Number.isNaN(current)) {
      setEditGradeInput("0");
      return;
    }
    const next = Math.min(100, Math.max(0, Math.round((current + delta) * 100) / 100));
    setEditGradeInput(String(next));
  };

  const openEditAttempt = (attempt: CourseAttempt) => {
    setEditingAttempt(attempt);
    setEditAcademicTermId(attempt.academicTermId ? String(attempt.academicTermId) : "");
    setEditGradeInput(attempt.grade === null ? "" : String(attempt.grade));
    setEditStatus(attempt.status);
    setEditAttemptCourseId(
      attempt.equivalentCourseId ? String(attempt.equivalentCourseId) : String(course.id),
    );
  };

  const handleSaveAttemptEdit = async () => {
    if (!editingAttempt) return;
    if (!userId || !studyPlanId) {
      toast.error("Debes iniciar sesión para editar intentos");
      return;
    }

    const parsedAcademicTermId = editAcademicTermId ? Number(editAcademicTermId) : null;
    if (
      editAcademicTermId &&
      (!Number.isInteger(parsedAcademicTermId) || (parsedAcademicTermId as number) <= 0)
    ) {
      toast.error("El periodo seleccionado no es válido");
      return;
    }

    const requiresGrade = editStatus === "approved" || editStatus === "failed";
    const parsedGrade = editGradeInput.trim() === "" ? null : Number(editGradeInput);

    if (parsedGrade !== null && !Number.isNaN(parsedGrade)) {
      if (parsedGrade < 0 || parsedGrade > 100) {
        toast.error("La nota debe estar entre 0 y 100");
        return;
      }
    }

    try {
      await updateCourseAttempt.mutateAsync({
        userId,
        studyPlanId,
        courseId: Number(course.id),
        attemptId: editingAttempt.id,
        academicTermId: parsedAcademicTermId,
        grade: requiresGrade ? parsedGrade : null,
        status: editStatus,
        equivalentCourseId: isPlaceholderCourse ? Number(editAttemptCourseId) : null,
      });

      toast.success("Intento actualizado correctamente");
      setEditingAttempt(null);
      void attemptsQuery.refetch();
    } catch {
      toast.error("Error al actualizar el intento");
    }
  };

  const handleDeleteAttempt = async () => {
    if (!deletingAttempt) return;
    if (!userId || !studyPlanId) {
      toast.error("Debes iniciar sesión para eliminar intentos");
      return;
    }

    try {
      await deleteCourseAttempt.mutateAsync({
        userId,
        studyPlanId,
        attemptId: deletingAttempt.id,
      });
      toast.success("Intento eliminado correctamente");
      setDeletingAttempt(null);
      void attemptsQuery.refetch();
    } catch {
      toast.error("Error al eliminar el intento");
    }
  };

  const seedProfessorNameInCache = (professorId: number, professorName: string) => {
    queryClient.setQueryData(["professorById", professorId], {
      id: professorId,
      full_name: professorName,
    });
  };

  const prepareProfessorTransition = (
    _transitionKey: string,
    professorId: number,
    professorName: string,
  ) => {
    seedProfessorNameInCache(professorId, professorName);
  };

  /* --- derived state for hero --- */
  const currentStatus = course.status;
  const requiresProgressGrade = progressStatus === "approved" || progressStatus === "failed";
  const canSaveProgress = !!selectedAttemptCourse;
  const isStatusFromAnotherSource =
    (currentStatus === "approved" || currentStatus === "in_progress") &&
    (course.statusOriginType === "same_course_global" || course.statusOriginType === "equivalent");
  const hasOriginInHistory = attempts.some((a) => a.id === Number(course.statusOriginAttemptId));
  const showOriginItem = isStatusFromAnotherSource && !hasOriginInHistory;

  useEffect(() => {
    if (!requiresProgressGrade) setGradeInput("");
  }, [requiresProgressGrade]);

  const progressForm = (
    <div className="space-y-6">
      <div>
        <Label className="text-sm">Curso a registrar</Label>
        <Combobox
          items={attemptCourseOptions}
          value={selectedAttemptCourse}
          onValueChange={(target) => setAttemptCourseId(target ? String(target.id) : course.id)}
          itemToStringValue={formatCourseLabel}
        >
          <ComboboxTrigger
            ref={attemptCourseTriggerRef}
            render={
              <Button
                variant="outline"
                className="mt-2 w-full justify-between font-normal"
                disabled={!isPlaceholderCourse || attemptCourseOptions.length === 0}
              />
            }
          >
            <span
              className={`block min-w-0 flex-1 truncate text-left ${!selectedAttemptCourse ? "text-muted-foreground" : ""}`}
            >
              {selectedAttemptCourse
                ? formatCourseLabel(selectedAttemptCourse)
                : "Selecciona un curso"}
            </span>
          </ComboboxTrigger>
          <ComboboxContent anchor={attemptCourseTriggerRef} container={comboboxPortalContainerRef}>
            <ComboboxInput showTrigger={false} placeholder="Buscar curso..." />
            <ComboboxEmpty>No se encontraron cursos.</ComboboxEmpty>
            <ComboboxList className="max-h-56 scrollbar-none">
              {(target) => (
                <ComboboxItem key={target.id} value={target}>
                  <span className="block min-w-0 flex-1 truncate">{formatCourseLabel(target)}</span>
                </ComboboxItem>
              )}
            </ComboboxList>
          </ComboboxContent>
        </Combobox>
      </div>

      <div>
        <Label className="text-sm">Periodo</Label>
        <Combobox
          items={academicTermGroups}
          value={selectedQuickTerm}
          onValueChange={(term) => setAcademicTermId(term ? String(term.id) : "")}
          itemToStringValue={(term) => formatTermNameWithoutYear(term.display_name)}
        >
          <ComboboxTrigger
            ref={progressTermTriggerRef}
            render={
              <Button variant="outline" className="mt-2 w-full justify-between font-normal" />
            }
          >
            <span
              className={`block min-w-0 flex-1 truncate text-left ${!selectedQuickTerm ? "text-muted-foreground" : ""}`}
            >
              {selectedQuickTerm
                ? formatClosedTermLabel(selectedQuickTerm)
                : progressTermsQuery.isLoading
                  ? "Cargando..."
                  : "Selecciona un periodo"}
            </span>
          </ComboboxTrigger>
          <ComboboxContent
            anchor={progressTermTriggerRef}
            container={comboboxPortalContainerRef}
            className="w-72"
          >
            <ComboboxInput showTrigger={false} placeholder="Buscar período..." />
            <ComboboxEmpty>No se encontraron períodos.</ComboboxEmpty>
            <ComboboxList className="max-h-56 scrollbar-none">
              {(group, index) => (
                <ComboboxGroup key={group.value} items={group.items}>
                  <ComboboxLabel>{group.value}</ComboboxLabel>
                  <ComboboxCollection>
                    {(term) => (
                      <ComboboxItem key={term.id} value={term}>
                        <span className="block min-w-0 flex-1 truncate">
                          {formatTermNameWithoutYear(term.display_name)}
                        </span>
                      </ComboboxItem>
                    )}
                  </ComboboxCollection>
                  {index < academicTermGroups.length - 1 && <ComboboxSeparator />}
                </ComboboxGroup>
              )}
            </ComboboxList>
          </ComboboxContent>
        </Combobox>
      </div>

      <div>
        <Label className="text-sm">Estado</Label>
        <RadioGroup
          className="mt-3 grid grid-cols-2 gap-2"
          value={progressStatus}
          onValueChange={(value) => setProgressStatus(value as Exclude<CourseStatus, "not_taken">)}
        >
          {(
            [
              { value: "approved", label: "Aprobado" },
              { value: "failed", label: "Reprobado" },
              { value: "in_progress", label: "En curso" },
              { value: "withdrawn", label: "Retirado" },
            ] as const
          ).map((option) => {
            const cfg = statusConfig[option.value];
            const isSelected = progressStatus === option.value;
            return (
              <label
                key={option.value}
                htmlFor={`progress-status-${option.value}`}
                className={cn(
                  "flex cursor-pointer items-center gap-2 rounded-lg border p-3 transition-colors",
                  isSelected ? `${cfg.bg} ${cfg.ring} ring-1` : "border-border hover:bg-accent/50",
                )}
              >
                <RadioGroupItem id={`progress-status-${option.value}`} value={option.value} />
                <div className="flex items-center gap-1.5">
                  <span className={`size-2 rounded-full ${cfg.dot}`} />
                  <span className="text-sm font-medium">{option.label}</span>
                </div>
              </label>
            );
          })}
        </RadioGroup>
      </div>

      <div>
        <Label className="text-sm">Nota</Label>
        <div className="mt-2 flex items-center gap-2">
          <Button
            type="button"
            variant="outline"
            size="icon"
            onClick={() => handleGradeStep(-1)}
            aria-label="Disminuir nota"
            disabled={!requiresProgressGrade}
          >
            <Minus className="size-4" />
          </Button>
          <Input
            className="text-center"
            type="text"
            inputMode="decimal"
            value={gradeInput}
            onChange={(event) => handleGradeInputChange(event.target.value)}
            placeholder={requiresProgressGrade ? "0-100 (Opcional)" : "No aplica"}
            disabled={!requiresProgressGrade}
          />
          <Button
            type="button"
            variant="outline"
            size="icon"
            onClick={() => handleGradeStep(1)}
            aria-label="Aumentar nota"
            disabled={!requiresProgressGrade}
          >
            <Plus className="size-4" />
          </Button>
        </div>
      </div>
    </div>
  );

  return (
    <div className="flex min-w-0 flex-col gap-10">
      {/* ========== HERO HEADER ========== */}
      <div className="space-y-4">
        <div className="flex items-start gap-3">
          <div className="min-w-0 flex-1">
            <div className="flex items-center gap-3">
              {onBack && (
                <Button
                  variant="ghost"
                  size="icon"
                  className="size-8 shrink-0 rounded-full"
                  onClick={onBack}
                  aria-label="Volver"
                >
                  <ArrowLeft className="size-4" />
                </Button>
              )}
              <h1
                className="text-2xl font-semibold tracking-tight md:text-3xl"
                style={transitionName ? { viewTransitionName: transitionName } : undefined}
              >
                <span className="text-muted-foreground mr-2 text-xl md:text-2xl">
                  {course.code}:
                </span>
                <span className="mr-2">{course.name}</span>
                <span className="inline-flex pb-1 align-middle">
                  <StatusBadge status={currentStatus} />
                </span>
              </h1>
            </div>
          </div>
        </div>

        {/* Stats strip */}
        <div className="border-border text-muted-foreground flex flex-wrap items-center justify-center gap-3 border-y py-3 text-base sm:justify-start">
          <div>
            <span className="text-foreground text-lg font-semibold">{course.credits}</span>{" "}
            {course.credits === 1 ? "crédito" : "créditos"}
          </div>
          <span className="text-border">|</span>
          <div>
            <span className="text-foreground text-lg font-semibold">{course.hours}</span>{" "}
            {course.hours === 1 ? "hora" : "horas"}
          </div>
          <span className="text-border">|</span>
          <div>
            <span className="text-foreground text-lg font-semibold">
              {course.semester}
              <sup className="text-xs">{getOrdinalSuffix(course.semester)}</sup>
            </span>{" "}
            {modalityName?.toLowerCase() || "nivel"}
          </div>
        </div>
      </div>

      {/* ========== ATTEMPTS TIMELINE ========== */}
      {userId ? (
        <section>
          <SectionHeader
            title="Historial de intentos"
            action={
              !attemptsQuery.isLoading && (attempts.length > 0 || isStatusFromAnotherSource) ? (
                <Button type="button" size="sm" variant="outline" onClick={handleOpenProgressSheet}>
                  Registrar progreso
                </Button>
              ) : null
            }
          />
          {attemptsQuery.isLoading ? (
            <div className="space-y-4">
              {Array.from({ length: 3 }).map((_, i) => (
                <div key={i} className="flex gap-4">
                  <div className="bg-muted size-8 shrink-0 animate-pulse rounded-full" />
                  <div className="flex-1 space-y-2 py-1">
                    <div className="bg-muted h-4 w-32 animate-pulse rounded" />
                    <div className="bg-muted h-3 w-48 animate-pulse rounded" />
                  </div>
                </div>
              ))}
            </div>
          ) : attempts.length === 0 && !isStatusFromAnotherSource ? (
            <div className="border-border flex flex-col items-center justify-center rounded-2xl border border-dashed py-12 text-center">
              <GraduationCap className="text-muted-foreground/50 mb-3 size-8" />
              <p className="text-foreground text-sm font-medium">Aún no hay intentos registrados</p>
              <p className="text-muted-foreground mt-1 text-xs">
                Registra tu primera nota para iniciar el historial
              </p>
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="mt-4"
                onClick={handleOpenProgressSheet}
              >
                Registrar progreso
              </Button>
            </div>
          ) : (
            <div className="pl-1">
              {showOriginItem ? <TimelineOriginItem course={course} /> : null}
              {attempts.map((attempt: CourseAttempt) => (
                <TimelineItem
                  key={attempt.id}
                  attempt={attempt}
                  onEdit={openEditAttempt}
                  onDelete={setDeletingAttempt}
                  termLabel={
                    attempt.academicTermId
                      ? (termLabelById.get(attempt.academicTermId) ?? `#${attempt.academicTermId}`)
                      : "Sin periodo"
                  }
                />
              ))}
            </div>
          )}
        </section>
      ) : null}

      {isMobile ? (
        <Sheet open={isProgressSheetOpen} onOpenChange={setIsProgressSheetOpen}>
          <SheetContent
            side="bottom"
            className="grid max-h-[86vh] grid-rows-[auto_minmax(0,1fr)_auto] gap-0 overflow-hidden p-0"
          >
            <div ref={comboboxPortalContainerRef} className="absolute top-0 left-0 size-0" />
            <SheetHeader className="px-4 pt-4 pb-2">
              <SheetTitle>Registrar progreso</SheetTitle>
              <SheetDescription>
                Guarda el estado de este curso para el periodo seleccionado.
              </SheetDescription>
            </SheetHeader>
            <div className="min-h-0 overflow-y-auto px-4 pb-4">{progressForm}</div>
            <SheetFooter className="border-t px-4 pt-3 pb-4">
              <Button
                type="button"
                onClick={handleSaveProgress}
                disabled={isSaving || !canSaveProgress}
                className="w-full"
              >
                {isSaving ? "Guardando..." : "Guardar progreso"}
              </Button>
            </SheetFooter>
          </SheetContent>
        </Sheet>
      ) : (
        <Dialog open={isProgressSheetOpen} onOpenChange={setIsProgressSheetOpen}>
          <DialogContent className="max-h-[90vh] overflow-hidden sm:max-w-lg">
            <div ref={comboboxPortalContainerRef} className="absolute top-0 left-0 size-0" />
            <DialogHeader>
              <DialogTitle>Registrar progreso</DialogTitle>
              <DialogDescription>
                Guarda el estado de este curso para el periodo seleccionado.
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-6 px-1 pb-1">{progressForm}</div>
            <DialogFooter>
              <Button
                type="button"
                onClick={handleSaveProgress}
                disabled={isSaving || !canSaveProgress}
              >
                {isSaving ? "Guardando..." : "Guardar progreso"}
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}

      {/* ========== COURSE RELATIONS ========== */}
      {(prerequisites.length > 0 || corequisites.length > 0 || isPrerequisiteFor.length > 0) && (
        <section>
          <SectionHeader title="Relaciones del curso" />
          <CourseRelationFlow
            course={course}
            prerequisites={prerequisites}
            corequisites={corequisites}
            dependents={isPrerequisiteFor}
          />
        </section>
      )}

      {/* ========== EVALUATIONS ========== */}
      <section>
        <SectionHeader
          title="Evaluaciones"
          action={
            !evaluationsQuery.isLoading && evaluations.length > 0 ? (
              <Button variant="outline" size="sm" onClick={() => setIsExamUploadOpen(true)}>
                Subir evaluación
              </Button>
            ) : null
          }
        />

        {evaluationsQuery.isLoading ? (
          <div className="space-y-3">
            {Array.from({ length: 3 }).map((_, i) => (
              <div key={i} className="bg-muted h-16 animate-pulse rounded-xl" />
            ))}
          </div>
        ) : evaluations.length === 0 ? (
          <div className="border-border flex flex-col items-center justify-center rounded-2xl border border-dashed py-12 text-center">
            <FileText className="text-muted-foreground/50 mb-3 size-8" />
            <p className="text-foreground text-sm font-medium">
              Aún no hay evaluaciones publicadas
            </p>
            <p className="text-muted-foreground mt-1 text-xs">
              Sé el primero en subir material de estudio
            </p>
            <Button
              variant="outline"
              size="sm"
              className="mt-4"
              onClick={() => setIsExamUploadOpen(true)}
            >
              Subir evaluación
            </Button>
          </div>
        ) : (
          <div className="space-y-2">
            {evaluations.map((evaluation) => (
              <EvaluationDocument
                key={evaluation.id}
                courseCode={course.code}
                evaluation={evaluation}
                onPreview={({ id }) =>
                  void navigate({
                    to: "/evaluations/view/$evaluationSlug",
                    params: { evaluationSlug: `${id}.pdf` },
                  })
                }
              />
            ))}
          </div>
        )}

        <EvaluationUploadDialog
          courseId={parseInt(course.id)}
          courseCode={course.code}
          courseName={course.name}
          studyPlanId={studyPlanId ?? null}
          open={isExamUploadOpen}
          onOpenChange={setIsExamUploadOpen}
        />
      </section>

      {/* ========== SCHEDULES ========== */}
      <section>
        <SectionHeader
          title="Horarios"
          action={
            <Combobox
              items={offeringTermGroups}
              value={selectedOfferingTerm}
              onValueChange={(term) => setOfferingTermId(term ? String(term.id) : "")}
              itemToStringValue={(term) => formatTermNameWithoutYear(term.display_name)}
            >
              <ComboboxTrigger
                render={<Button variant="outline" className="w-[200px] justify-between sm:w-64" />}
              >
                <span
                  className={`block min-w-0 flex-1 truncate text-left ${!selectedOfferingTerm ? "text-muted-foreground" : ""}`}
                >
                  {selectedOfferingTerm
                    ? formatClosedTermLabel(selectedOfferingTerm)
                    : offeringTermsQuery.isLoading
                      ? "Cargando periodos..."
                      : "Selecciona un periodo"}
                </span>
              </ComboboxTrigger>
              <ComboboxContent className="w-(--anchor-width) min-w-(--anchor-width)">
                <ComboboxInput showTrigger={false} placeholder="Buscar periodo..." />
                <ComboboxEmpty>No se encontraron periodos.</ComboboxEmpty>
                <ComboboxList className="max-h-56 scrollbar-none">
                  {(group, index) => (
                    <ComboboxGroup key={group.value} items={group.items}>
                      <ComboboxLabel>{group.value}</ComboboxLabel>
                      <ComboboxCollection>
                        {(term) => (
                          <ComboboxItem key={term.id} value={term}>
                            <span className="block min-w-0 flex-1 truncate">
                              {formatTermNameWithoutYear(term.display_name)}
                            </span>
                          </ComboboxItem>
                        )}
                      </ComboboxCollection>
                      {index < offeringTermGroups.length - 1 && <ComboboxSeparator />}
                    </ComboboxGroup>
                  )}
                </ComboboxList>
              </ComboboxContent>
            </Combobox>
          }
        />
        {latestGroupsQuery.isLoading ? (
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 2xl:grid-cols-4">
            {Array.from({ length: 4 }).map((_, i) => (
              <div key={i} className="bg-muted h-48 animate-pulse rounded-xl" />
            ))}
          </div>
        ) : latestTermGroups.length === 0 ? (
          <div className="border-border flex flex-col items-center justify-center rounded-2xl border border-dashed py-12 text-center">
            <Clock className="text-muted-foreground/50 mb-3 size-8" />
            <p className="text-foreground text-sm font-medium">No hay grupos registrados</p>
            <p className="text-muted-foreground mt-1 text-xs">
              No se encontraron horarios para este curso en el periodo actual
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 2xl:grid-cols-4">
            {latestTermGroups.map((group: CourseLatestTermGroup) => (
              <div key={group.groupId}>
                <ScheduleGroupCard
                  group={group}
                  currentCourseId={parseInt(course.id, 10)}
                  onPrepareTransition={prepareProfessorTransition}
                />
              </div>
            ))}
          </div>
        )}
      </section>

      {/* ========== EQUIVALENCES ========== */}
      {equivalents.length > 0 && (
        <section>
          <div className="mb-4 flex items-center justify-between">
            <h2 className="text-lg font-semibold tracking-tight">Equivalencias</h2>
            {totalPages > 1 && (
              <div className="flex items-center gap-1">
                <Button
                  variant="ghost"
                  size="icon"
                  className="size-7"
                  onClick={() => setEquivalentsPage(Math.max(0, equivalentsPage - 1))}
                  disabled={equivalentsPage === 0}
                >
                  <ChevronLeft className="size-4" />
                </Button>
                <span className="text-muted-foreground text-xs tabular-nums">
                  {equivalentsPage + 1} / {totalPages}
                </span>
                <Button
                  variant="ghost"
                  size="icon"
                  className="size-7"
                  onClick={() => setEquivalentsPage(Math.min(totalPages - 1, equivalentsPage + 1))}
                  disabled={equivalentsPage >= totalPages - 1}
                >
                  <ChevronRight className="size-4" />
                </Button>
              </div>
            )}
          </div>
          <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-5">
            {equivalents.map(
              (eq: {
                id: number;
                code: string | null;
                name: string | null;
                credits: number | null;
                weeklyHours: number | null;
              }) => (
                <div
                  key={eq.id}
                  className="border-border bg-card hover:border-primary/40 overflow-hidden rounded-lg border-2 shadow-sm transition-all duration-200"
                >
                  <div className="border-border bg-card border-b px-3 py-2">
                    <div className="text-muted-foreground flex items-center justify-between font-mono text-xs">
                      <span className="min-w-[3ch] text-right">{eq.credits ?? 0} cr</span>
                      <span className="flex-1 px-2 text-center font-semibold">
                        {eq.code || "SIN-CODIGO"}
                      </span>
                      <span className="min-w-[4ch] text-left">{eq.weeklyHours ?? 0} h</span>
                    </div>
                  </div>
                  <div className="bg-muted flex min-h-16 items-center justify-center px-3 py-2 text-center">
                    <p className="text-foreground line-clamp-2 text-xs leading-tight font-semibold">
                      {eq.name || "Sin nombre"}
                    </p>
                  </div>
                </div>
              ),
            )}
          </div>
        </section>
      )}

      <Dialog
        open={!!editingAttempt}
        onOpenChange={(open) => {
          if (!open) setEditingAttempt(null);
        }}
      >
        <DialogContent>
          <div ref={comboboxPortalContainerRef} className="absolute top-0 left-0 size-0" />
          <DialogHeader>
            <DialogTitle>Editar intento</DialogTitle>
            <DialogDescription>Actualiza los detalles del intento seleccionado.</DialogDescription>
          </DialogHeader>

          <div className="space-y-4">
            <div>
              <Label className="text-sm">Estado</Label>
              <RadioGroup
                value={editStatus}
                onValueChange={(value) =>
                  setEditStatus(value as Exclude<CourseStatus, "not_taken">)
                }
                className="mt-2 grid grid-cols-2 gap-2 sm:grid-cols-4"
              >
                {[
                  { value: "approved", label: "Aprobado" },
                  { value: "failed", label: "Reprobado" },
                  { value: "in_progress", label: "En curso" },
                  { value: "withdrawn", label: "Retirado" },
                ].map((option) => (
                  <div key={option.value}>
                    <RadioGroupItem
                      value={option.value}
                      id={`edit-status-${option.value}`}
                      className="peer sr-only"
                    />
                    <Label
                      htmlFor={`edit-status-${option.value}`}
                      className="border-border hover:bg-accent hover:text-accent-foreground peer-data-[state=checked]:border-primary peer-data-[state=checked]:bg-primary/10 peer-data-[state=checked]:text-primary flex cursor-pointer items-center justify-center rounded-md border px-3 py-2 text-center text-xs font-medium transition-all"
                    >
                      {option.label}
                    </Label>
                  </div>
                ))}
              </RadioGroup>
            </div>

            {isPlaceholderCourse && (
              <div>
                <Label htmlFor="edit-attempt-course" className="text-sm">
                  Curso a registrar
                </Label>
                <Combobox
                  items={attemptCourseOptions}
                  value={
                    attemptCourseOptions.find(
                      (option) => String(option.id) === editAttemptCourseId,
                    ) ?? null
                  }
                  onValueChange={(course) =>
                    setEditAttemptCourseId(course ? String(course.id) : "")
                  }
                  itemToStringValue={(course) => course.code}
                >
                  <ComboboxTrigger
                    ref={editAttemptCourseTriggerRef}
                    render={
                      <Button
                        id="edit-attempt-course"
                        variant="outline"
                        className="mt-2 w-full justify-between font-normal"
                      />
                    }
                  >
                    <span
                      className={`block min-w-0 flex-1 truncate text-left ${!editAttemptCourseId ? "text-muted-foreground" : ""}`}
                    >
                      {attemptCourseOptions.find(
                        (option) => String(option.id) === editAttemptCourseId,
                      )?.name ?? "Selecciona el curso equivalente"}
                    </span>
                  </ComboboxTrigger>
                  <ComboboxContent
                    anchor={editAttemptCourseTriggerRef}
                    container={comboboxPortalContainerRef}
                    className="w-72"
                  >
                    <ComboboxInput placeholder="Buscar curso..." />
                    <ComboboxEmpty>No se encontraron cursos.</ComboboxEmpty>
                    <ComboboxList className="max-h-56 scrollbar-none">
                      <ComboboxCollection>
                        {(course) => (
                          <ComboboxItem key={course.id} value={course}>
                            <span className="block min-w-0 flex-1 truncate">
                              {course.code} - {course.name}
                            </span>
                          </ComboboxItem>
                        )}
                      </ComboboxCollection>
                    </ComboboxList>
                  </ComboboxContent>
                </Combobox>
              </div>
            )}

            <div>
              <Label htmlFor="edit-attempt-term" className="text-sm">
                Periodo
              </Label>
              <Combobox
                items={academicTermGroups}
                value={selectedEditTerm}
                onValueChange={(term) => setEditAcademicTermId(term ? String(term.id) : "")}
                itemToStringValue={(term) => formatTermNameWithoutYear(term.display_name)}
              >
                <ComboboxTrigger
                  ref={editTermTriggerRef}
                  render={
                    <Button
                      id="edit-attempt-term"
                      variant="outline"
                      className="mt-2 w-full justify-between font-normal"
                    />
                  }
                >
                  <span
                    className={`block min-w-0 flex-1 truncate text-left ${!selectedEditTerm ? "text-muted-foreground" : ""}`}
                  >
                    {selectedEditTerm
                      ? formatClosedTermLabel(selectedEditTerm)
                      : progressTermsQuery.isLoading
                        ? "Cargando..."
                        : "Selecciona un periodo"}
                  </span>
                </ComboboxTrigger>
                <ComboboxContent
                  anchor={editTermTriggerRef}
                  container={comboboxPortalContainerRef}
                  className="w-72"
                >
                  <ComboboxInput showTrigger={false} placeholder="Buscar período..." />
                  <ComboboxEmpty>No se encontraron períodos.</ComboboxEmpty>
                  <ComboboxList className="max-h-56 scrollbar-none">
                    {(group, index) => (
                      <ComboboxGroup key={group.value} items={group.items}>
                        <ComboboxLabel>{group.value}</ComboboxLabel>
                        <ComboboxCollection>
                          {(term) => (
                            <ComboboxItem key={term.id} value={term}>
                              <span className="block min-w-0 flex-1 truncate">
                                {formatTermNameWithoutYear(term.display_name)}
                              </span>
                            </ComboboxItem>
                          )}
                        </ComboboxCollection>
                        {index < academicTermGroups.length - 1 && <ComboboxSeparator />}
                      </ComboboxGroup>
                    )}
                  </ComboboxList>
                </ComboboxContent>
              </Combobox>
            </div>

            {(editStatus === "approved" || editStatus === "failed") && (
              <div>
                <Label htmlFor="edit-attempt-grade" className="text-sm">
                  Nota
                </Label>
                <div className="mt-2 flex items-center gap-2">
                  <Button
                    type="button"
                    variant="outline"
                    size="icon"
                    onClick={() => handleEditGradeStep(-1)}
                    aria-label="Disminuir nota"
                    disabled={updateCourseAttempt.isPending}
                  >
                    <Minus className="size-4" />
                  </Button>
                  <Input
                    id="edit-attempt-grade"
                    className="text-center"
                    type="text"
                    inputMode="decimal"
                    value={editGradeInput}
                    onChange={(event) => handleEditGradeInputChange(event.target.value)}
                    placeholder="0-100 (Opcional)"
                    disabled={updateCourseAttempt.isPending}
                  />
                  <Button
                    type="button"
                    variant="outline"
                    size="icon"
                    onClick={() => handleEditGradeStep(1)}
                    aria-label="Aumentar nota"
                    disabled={updateCourseAttempt.isPending}
                  >
                    <Plus className="size-4" />
                  </Button>
                </div>
              </div>
            )}
          </div>

          <DialogFooter>
            <Button
              type="button"
              onClick={handleSaveAttemptEdit}
              disabled={updateCourseAttempt.isPending}
            >
              {updateCourseAttempt.isPending ? "Guardando..." : "Guardar cambios"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <AlertDialog
        open={!!deletingAttempt}
        onOpenChange={(open) => {
          if (!open) setDeletingAttempt(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Eliminar intento?</AlertDialogTitle>
            <AlertDialogDescription>
              Esta acción no se puede deshacer. Se eliminará el intento del historial
              permanentemente.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deleteCourseAttempt.isPending}>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              onClick={(e) => {
                e.preventDefault();
                void handleDeleteAttempt();
              }}
              disabled={deleteCourseAttempt.isPending}
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
            >
              {deleteCourseAttempt.isPending ? "Eliminando..." : "Eliminar"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
