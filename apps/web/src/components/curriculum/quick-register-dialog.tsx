import { Search01Icon, UnfoldMoreIcon } from "@hugeicons/core-free-icons";
import { useQueryClient } from "@tanstack/react-query";
import { useState, useEffect, useMemo, useRef, useId } from "react";

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
import {
  Drawer,
  DrawerPopup,
  DrawerHeader,
  DrawerTitle,
  DrawerDescription,
  DrawerFooter,
} from "@/components/ui/drawer";
import { Icon } from "@/components/ui/icon";
import { Label } from "@/components/ui/label";
import {
  NumberField,
  NumberFieldDecrement,
  NumberFieldGroup,
  NumberFieldIncrement,
  NumberFieldInput,
} from "@/components/ui/number-field";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { ScrollArea } from "@/components/ui/scroll-area";
import { toast } from "@/components/ui/toast";
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
  const gradeId = useId();

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

  const requiresProgressGrade = progressStatus === "approved" || progressStatus === "failed";
  const canSaveProgress = !!selectedAttemptCourse;

  useEffect(() => {
    if (!requiresProgressGrade) setGradeInput("");
  }, [requiresProgressGrade]);

  const formatCourseLabel = (c: { id: number; code: string; name: string }) =>
    `${c.code}: ${c.name}`;

  if (!course) return null;

  const progressForm = (
    <div className="w-full max-w-full min-w-0 space-y-6">
      <div className="w-full max-w-full min-w-0">
        <Label>Curso a registrar</Label>
        <Combobox
          items={attemptCourseOptions}
          value={selectedAttemptCourse}
          onValueChange={(target) => setAttemptCourseId(target ? String(target.id) : course.id)}
          itemToStringValue={formatCourseLabel}
        >
          <ComboboxTrigger
            ref={attemptCourseTriggerRef}
            className="w-full max-w-full min-w-0"
            aria-label="Curso a registrar"
            render={
              <Button
                variant="outline"
                aria-label="Curso a registrar"
                className="mt-2 flex w-full max-w-full min-w-0 justify-between overflow-hidden font-normal"
                disabled={!isPlaceholderCourse || attemptCourseOptions.length === 0}
              />
            }
          >
            <span
              className={cn(
                "block min-w-0 flex-1 truncate text-left",
                !selectedAttemptCourse && "text-muted-foreground",
              )}
            >
              {selectedAttemptCourse
                ? formatCourseLabel(selectedAttemptCourse)
                : "Selecciona un curso"}
            </span>
            <Icon icon={UnfoldMoreIcon} className="-me-1! size-3.5 shrink-0 opacity-60" />
          </ComboboxTrigger>
          <ComboboxContent
            anchor={attemptCourseTriggerRef}
            container={comboboxPortalContainerRef}
            aria-label="Curso"
          >
            <div className="border-b p-2">
              <ComboboxInput
                className="rounded-md before:rounded-[calc(var(--radius-md)-1px)]"
                placeholder="Buscar curso..."
                showTrigger={false}
                startAddon={<Icon icon={Search01Icon} className="size-4" />}
              />
            </div>
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

      <div className="w-full max-w-full min-w-0">
        <Label>Periodo</Label>
        <Combobox
          items={academicTermGroups}
          value={selectedQuickTerm}
          onValueChange={(term) => setAcademicTermId(term ? String(term.id) : "")}
          itemToStringValue={(term) => formatTermNameWithoutYear(term.display_name)}
        >
          <ComboboxTrigger
            ref={progressTermTriggerRef}
            className="w-full max-w-full min-w-0"
            aria-label="Periodo"
            render={
              <Button
                variant="outline"
                aria-label="Periodo"
                className="mt-2 flex w-full max-w-full min-w-0 justify-between overflow-hidden font-normal"
              />
            }
          >
            <span
              className={cn(
                "block min-w-0 flex-1 truncate text-left",
                !selectedQuickTerm && "text-muted-foreground",
              )}
            >
              {selectedQuickTerm
                ? formatClosedTermLabel(selectedQuickTerm)
                : progressTermsQuery.isLoading
                  ? "Cargando..."
                  : "Selecciona un periodo"}
            </span>
            <Icon icon={UnfoldMoreIcon} className="-me-1! size-3.5 shrink-0 opacity-60" />
          </ComboboxTrigger>
          <ComboboxContent
            anchor={progressTermTriggerRef}
            container={comboboxPortalContainerRef}
            aria-label="Período"
            className="w-72"
          >
            <div className="border-b p-2">
              <ComboboxInput
                className="rounded-md before:rounded-[calc(var(--radius-md)-1px)]"
                placeholder="Buscar período..."
                showTrigger={false}
                startAddon={<Icon icon={Search01Icon} className="size-4" />}
              />
            </div>
            <ComboboxEmpty>No se encontraron períodos.</ComboboxEmpty>
            <ComboboxList className="max-h-56 scrollbar-none">
              {(group, index) => (
                <ComboboxGroup key={group.value} items={group.items}>
                  <ComboboxLabel className="text-xs font-semibold">{group.value}</ComboboxLabel>
                  <ComboboxCollection>
                    {(term) => (
                      <ComboboxItem key={term.id} value={term}>
                        <span className="block min-w-0 flex-1 truncate text-xs">
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
        <Label>Estado</Label>
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
                <span className="text-sm font-medium">{option.label}</span>
              </label>
            );
          })}
        </RadioGroup>
      </div>

      <div className="flex flex-col gap-2">
        <div className="inline-flex w-full items-center justify-between gap-2">
          <Label htmlFor={gradeId}>Nota obtenida</Label>
          {requiresProgressGrade && (
            <Label className="text-muted-foreground font-normal" render={<span />}>
              Opcional
            </Label>
          )}
        </div>
        <NumberField
          id={gradeId}
          min={0}
          max={100}
          step={1}
          value={gradeInput.trim() === "" ? null : Number(gradeInput)}
          onValueChange={(val) =>
            setGradeInput(val === null || Number.isNaN(val) ? "" : String(val))
          }
          disabled={!requiresProgressGrade}
        >
          <NumberFieldGroup className="h-9 w-full sm:h-9">
            <NumberFieldDecrement aria-label="Disminuir nota" />
            <NumberFieldInput placeholder={requiresProgressGrade ? "0 a 100" : "No aplica"} />
            <NumberFieldIncrement aria-label="Aumentar nota" />
          </NumberFieldGroup>
        </NumberField>
      </div>
    </div>
  );

  if (isMobile) {
    return (
      <Drawer open={isOpen} onOpenChange={onOpenChange}>
        <DrawerPopup
          showBar
          className="grid max-h-[90dvh] w-full max-w-full min-w-0 grid-cols-[minmax(0,1fr)] grid-rows-[auto_minmax(0,1fr)_auto] overflow-hidden"
        >
          <div ref={comboboxPortalContainerRef} className="absolute top-0 left-0 size-0" />
          <DrawerHeader className="px-4 pt-4 pb-2">
            <DrawerTitle>Registrar progreso</DrawerTitle>
            <DrawerDescription>
              Guarda el estado de este curso para el periodo seleccionado.
            </DrawerDescription>
          </DrawerHeader>
          <ScrollArea className="min-h-0 w-full max-w-full min-w-0">
            <div className="w-full max-w-full min-w-0 space-y-6 px-4 pb-4">{progressForm}</div>
          </ScrollArea>
          <DrawerFooter className="border-t px-4 pt-3 pb-4">
            <Button
              type="button"
              onClick={handleCreateAttempt}
              disabled={isSaving || !canSaveProgress}
              className="w-full"
            >
              {isSaving ? "Guardando..." : "Guardar progreso"}
            </Button>
          </DrawerFooter>
        </DrawerPopup>
      </Drawer>
    );
  }

  return (
    <Dialog open={isOpen} onOpenChange={onOpenChange}>
      <DialogContent className="max-h-[90vh] grid-rows-[auto_minmax(0,1fr)_auto] overflow-hidden sm:max-w-lg">
        <div ref={comboboxPortalContainerRef} className="absolute top-0 left-0 size-0" />
        <DialogHeader>
          <DialogTitle>Registrar progreso</DialogTitle>
          <DialogDescription>
            Guarda el estado de este curso para el periodo seleccionado.
          </DialogDescription>
        </DialogHeader>
        <ScrollArea className="min-h-0">
          <div className="space-y-6 px-1 pb-1">{progressForm}</div>
        </ScrollArea>
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
