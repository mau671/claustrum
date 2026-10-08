import { useQueryClient } from "@tanstack/react-query";
import { Plus, Minus } from "lucide-react";
import { useState, useEffect, useMemo, useRef } from "react";
import { toast } from "sonner";

import type { Course, CourseStatus } from "@/lib/types";

import { Button } from "@/components/ui/button";
import {
  Combobox,
  ComboboxTrigger,
  ComboboxContent,
  ComboboxInput,
  ComboboxEmpty,
  ComboboxList,
  ComboboxItem,
  ComboboxGroup,
  ComboboxLabel,
  ComboboxCollection,
  ComboboxSeparator,
} from "@/components/ui/combobox";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetDescription,
  SheetFooter,
} from "@/components/ui/sheet";
import { useIsMobile } from "@/hooks/use-mobile";
import {
  formatTermNameWithoutYear,
  formatClosedTermLabel,
  groupTermsByYear,
} from "@/lib/academic-terms";
import {
  useCourseOfferingTerms,
  useCourseDetailRelatedCourses,
  useCreateCourseAttempt,
} from "@/lib/hooks/use-queries";
import { cn } from "@/lib/utils";
import { saveLocalCourseStatus } from "@/lib/utils/local-storage-utils";

const statusConfig: Record<CourseStatus, { color: string; bg: string; ring: string; dot: string }> =
  {
    approved: {
      color: "text-emerald-700 dark:text-emerald-400",
      bg: "bg-emerald-50 dark:bg-emerald-950/40",
      ring: "ring-emerald-200 dark:ring-emerald-800",
      dot: "bg-emerald-500",
    },
    failed: {
      color: "text-destructive dark:text-destructive",
      bg: "bg-destructive/10 dark:bg-destructive/20",
      ring: "ring-destructive/20 dark:ring-destructive/30",
      dot: "bg-destructive",
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

interface QuickRegisterDialogProps {
  course: Course | null;
  userId?: string;
  studyPlanId?: number;
  isOpen: boolean;
  onOpenChange: (open: boolean) => void;
}

export function QuickRegisterDialog({
  course,
  userId,
  studyPlanId,
  isOpen,
  onOpenChange,
}: QuickRegisterDialogProps) {
  const isMobile = useIsMobile();
  const queryClient = useQueryClient();
  const comboboxPortalContainerRef = useRef<HTMLDivElement>(null);
  const attemptCourseTriggerRef = useRef<HTMLButtonElement>(null);
  const progressTermTriggerRef = useRef<HTMLButtonElement>(null);

  const [gradeInput, setGradeInput] = useState("");
  const [academicTermId, setAcademicTermId] = useState<string>("");
  const [attemptCourseId, setAttemptCourseId] = useState<string>("");
  const [progressStatus, setProgressStatus] =
    useState<Exclude<CourseStatus, "not_taken">>("approved");
  const [isSaving, setIsSaving] = useState(false);

  const createCourseAttempt = useCreateCourseAttempt();

  useEffect(() => {
    if (isOpen && course) {
      setAttemptCourseId(course.id);
      setGradeInput("");
      setAcademicTermId("");
      setProgressStatus("approved");
    }
  }, [isOpen, course]);

  const courseIdNum = course ? parseInt(course.id) : 0;

  const allRelatedCoursesQuery = useCourseDetailRelatedCourses(
    studyPlanId ?? null,
    courseIdNum,
    0,
    10000,
  );

  const isPlaceholderCourse = allRelatedCoursesQuery.data?.isPlaceholder ?? false;
  const totalEquivalents = allRelatedCoursesQuery.data?.totalCount ?? 0;

  const baseCourseOption = useMemo(
    () =>
      course
        ? {
            id: Number.parseInt(course.id, 10),
            code: course.code,
            name: course.name,
            credits: course.credits,
            weeklyHours: course.hours,
            relationKind: "base" as const,
            isPlaceholder: isPlaceholderCourse,
            hasOfferings: false,
            totalEquivalents,
          }
        : null,
    [course, isPlaceholderCourse, totalEquivalents],
  );

  const attemptCourseOptions = useMemo(() => {
    if (!baseCourseOption) return [];
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
    if (!course) return;
    if (!isPlaceholderCourse) {
      if (attemptCourseId !== course.id) setAttemptCourseId(course.id);
      return;
    }
    if (attemptCourseOptions.length === 0) return;
    if (!attemptCourseOptions.some((option) => String(option.id) === attemptCourseId)) {
      setAttemptCourseId(String(attemptCourseOptions[0].id));
    }
  }, [attemptCourseId, attemptCourseOptions, course, isPlaceholderCourse]);

  const attemptCourseNumericId = Number.parseInt(attemptCourseId, 10);
  const progressCourseId = Number.isNaN(attemptCourseNumericId)
    ? courseIdNum
    : attemptCourseNumericId;

  const progressTermsQuery = useCourseOfferingTerms(progressCourseId, null, null);
  const academicTerms = useMemo(
    () => (progressTermsQuery.isPlaceholderData ? [] : (progressTermsQuery.data ?? [])),
    [progressTermsQuery.data, progressTermsQuery.isPlaceholderData],
  );

  const academicTermGroups = useMemo(() => groupTermsByYear(academicTerms), [academicTerms]);

  useEffect(() => {
    if (!academicTermId && academicTerms.length > 0) {
      setAcademicTermId(String(academicTerms[0].id));
      return;
    }
    if (academicTermId && !academicTerms.some((term) => String(term.id) === academicTermId)) {
      setAcademicTermId(academicTerms.length > 0 ? String(academicTerms[0].id) : "");
    }
  }, [academicTermId, academicTerms]);

  const selectedQuickTerm =
    academicTerms.find((term) => String(term.id) === academicTermId) ?? null;

  const parseSelectedTermId = () => {
    if (!academicTermId) return null;
    const parsed = Number(academicTermId);
    if (!Number.isInteger(parsed) || parsed <= 0) {
      toast.error("El periodo seleccionado no es válido");
      return undefined;
    }
    return parsed;
  };

  const handleCreateAttempt = async () => {
    if (!course) return;
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
      const equivalentId = isPlaceholderCourse ? parseInt(attemptCourseId) : null;
      if (!userId || !studyPlanId) {
        saveLocalCourseStatus(parseInt(course.id), studyPlanId ?? null, progressStatus);
        void queryClient.invalidateQueries({ queryKey: ["studentCourseStatuses"] });
        void queryClient.invalidateQueries({ queryKey: ["scheduleCourses"] });
        toast.success("Progreso guardado localmente", {
          description: "Inicia sesión para guardar el historial de intentos permanentemente",
          duration: 5000,
        });
      } else {
        await createCourseAttempt.mutateAsync({
          userId,
          studyPlanId,
          courseId: parseInt(course.id),
          status: progressStatus,
          grade: requiresGrade ? parsedGrade : null,
          academicTermId: parsedAcademicTermId,
          equivalentCourseId: equivalentId,
        });
        toast.success("Progreso registrado correctamente");
      }

      onOpenChange(false);
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

  const requiresProgressGrade = progressStatus === "approved" || progressStatus === "failed";
  const canSaveProgress = !!selectedAttemptCourse;

  useEffect(() => {
    if (!requiresProgressGrade) setGradeInput("");
  }, [requiresProgressGrade]);

  const formatCourseLabel = (c: { id: number; code: string; name: string }) =>
    `${c.code}: ${c.name}`;

  if (!course) return null;

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
                htmlFor={`quick-status-${option.value}`}
                className={cn(
                  "flex cursor-pointer items-center gap-2 rounded-lg border p-3 transition-colors",
                  isSelected ? `${cfg.bg} ${cfg.ring} ring-1` : "border-border hover:bg-accent/50",
                )}
              >
                <RadioGroupItem id={`quick-status-${option.value}`} value={option.value} />
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

  if (isMobile) {
    return (
      <Sheet open={isOpen} onOpenChange={onOpenChange}>
        <SheetContent
          side="bottom"
          className="grid max-h-[86vh] grid-rows-[auto_minmax(0,1fr)_auto] gap-0 overflow-hidden p-0"
        >
          <div ref={comboboxPortalContainerRef} className="absolute top-0 left-0 size-0" />
          <SheetHeader className="px-4 pt-4 pb-2">
            <SheetTitle>Registrar progreso: {course.name}</SheetTitle>
            <SheetDescription>
              Guarda el estado de este curso para el periodo seleccionado.
            </SheetDescription>
          </SheetHeader>
          <div className="min-h-0 overflow-y-auto px-4 pb-4">{progressForm}</div>
          <SheetFooter className="border-t px-4 pt-3 pb-4">
            <Button
              type="button"
              onClick={handleCreateAttempt}
              disabled={isSaving || !canSaveProgress}
              className="w-full"
            >
              {isSaving ? "Guardando..." : "Guardar progreso"}
            </Button>
          </SheetFooter>
        </SheetContent>
      </Sheet>
    );
  }

  return (
    <Dialog open={isOpen} onOpenChange={onOpenChange}>
      <DialogContent className="max-h-[90vh] overflow-hidden sm:max-w-lg">
        <div ref={comboboxPortalContainerRef} className="absolute top-0 left-0 size-0" />
        <DialogHeader>
          <DialogTitle>Registrar progreso: {course.name}</DialogTitle>
          <DialogDescription>
            Guarda el estado de este curso para el periodo seleccionado.
          </DialogDescription>
        </DialogHeader>
        <div className="space-y-6 px-1 pb-1">{progressForm}</div>
        <DialogFooter>
          <Button
            type="button"
            onClick={handleCreateAttempt}
            disabled={isSaving || !canSaveProgress}
          >
            {isSaving ? "Guardando..." : "Guardar progreso"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
