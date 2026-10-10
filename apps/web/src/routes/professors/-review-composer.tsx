import { Cancel01Icon, Search01Icon, UnfoldMoreIcon } from "@hugeicons/core-free-icons";
import { Link } from "@tanstack/react-router";
import { lazy, Suspense, useEffect, useMemo, useRef, useState } from "react";

import type { ProfessorReviewCourseOption } from "@/lib/professor-reviews/types";
import type { ReviewTag } from "@/lib/professor-reviews/types";

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogPopup,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Button } from "@/components/ui/button";
import {
  Combobox,
  ComboboxChip,
  ComboboxChips,
  ComboboxChipsInput,
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
  ComboboxValue,
  useComboboxAnchor,
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
  Drawer,
  DrawerDescription,
  DrawerFooter,
  DrawerHeader,
  DrawerPopup,
  DrawerTitle,
} from "@/components/ui/drawer";
import { Field, FieldDescription, FieldLabel } from "@/components/ui/field";
import { Icon } from "@/components/ui/icon";
import { Label } from "@/components/ui/label";
import {
  NumberField,
  NumberFieldDecrement,
  NumberFieldGroup,
  NumberFieldIncrement,
  NumberFieldInput,
} from "@/components/ui/number-field";
import { Radio, RadioGroup } from "@/components/ui/radio-group";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Slider } from "@/components/ui/slider";
import { Textarea } from "@/components/ui/textarea";
import {
  formatClosedTermLabel,
  formatTermNameWithoutYear,
  groupTermsByYear,
} from "@/lib/academic-terms";
import {
  useProfessorOfferingTerms,
  useProfessorReviewCourses,
} from "@/lib/hooks/use-professor-reviews";
import { cn } from "@/lib/utils";

const TAG_GROUPS = [
  {
    label: "Sugeridas",
    tags: [
      "Tomaría su clase nuevamente",
      "Explica con claridad",
      "Brinda apoyo",
      "Da buena retroalimentación",
    ],
  },
  {
    label: "Enseñanza",
    tags: ["Inspirador", "Respetado por los estudiantes", "Clases excelentes", "Muy cómico"],
  },
  {
    label: "Evaluación",
    tags: [
      "Califica con rigor",
      "Exámenes retadores",
      "Aspectos de calificación claros",
      "Proyecto útil",
    ],
  },
  {
    label: "Carga de trabajo",
    tags: [
      "Muchas tareas",
      "Deja trabajos largos",
      "Muchos exámenes",
      "Pocos exámenes",
      "Requiere mucha lectura",
      "Clases largas",
      "Muchos proyectos grupales",
    ],
  },
  {
    label: "Asistencia y participación",
    tags: ["Asistencia obligatoria", "La participación importa"],
  },
  {
    label: "Otros",
    tags: ["Da crédito extra", "Clase fácil"],
  },
] as const;

const Turnstile = lazy(() =>
  import("@marsidev/react-turnstile").then((module) => ({
    default: module.Turnstile,
  })),
);

function ScoreNumberField({
  id,
  label,
  value,
  onChange,
  min = 0,
  max = 10,
  step = 0.1,
  placeholder = "0 a 10",
  optional = false,
}: {
  id: string;
  label: string;
  value: string;
  onChange: (nextValue: string) => void;
  min?: number;
  max?: number;
  step?: number;
  placeholder?: string;
  optional?: boolean;
}) {
  return (
    <div className="flex w-full flex-col gap-2">
      {optional ? (
        <div className="inline-flex w-full items-center justify-between gap-2">
          <Label htmlFor={id} className="text-xs font-medium whitespace-nowrap">
            {label}
          </Label>
          <Label className="text-muted-foreground font-normal" render={<span />}>
            Opcional
          </Label>
        </div>
      ) : (
        <Label htmlFor={id} className="text-xs font-medium whitespace-nowrap">
          {label}
        </Label>
      )}
      <NumberField
        id={id}
        min={min}
        max={max}
        step={step}
        value={value.trim() === "" ? null : Number(value)}
        onValueChange={(val) =>
          onChange(val !== null && val !== undefined && !Number.isNaN(val) ? String(val) : "")
        }
        className="w-full"
      >
        <NumberFieldGroup className="h-9 w-full sm:h-9">
          <NumberFieldDecrement aria-label={`Disminuir ${label.toLowerCase()}`} />
          <NumberFieldInput placeholder={placeholder} />
          <NumberFieldIncrement aria-label={`Aumentar ${label.toLowerCase()}`} />
        </NumberFieldGroup>
      </NumberField>
    </div>
  );
}

type ReviewComposerProps = {
  isMobile: boolean;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  submitMutationPending: boolean;
  turnstileSiteKey: string | null;
  professorId: string | null;
  selectedCourses: ProfessorReviewCourseOption[];
  setSelectedCourses: (value: ProfessorReviewCourseOption[]) => void;
  academicTermId: string;
  setAcademicTermId: (value: string) => void;
  gradeReceived: string;
  setGradeReceived: (value: string) => void;
  comment: string;
  setComment: (value: string) => void;
  easeScore: string;
  setEaseScore: (value: string) => void;
  qualityScore: string;
  setQualityScore: (value: string) => void;
  clarityScore: string;
  setClarityScore: (value: string) => void;
  fairnessScore: string;
  setFairnessScore: (value: string) => void;
  engagementLevel: string;
  setEngagementLevel: (value: string) => void;
  attendanceRequired: boolean;
  setAttendanceRequired: (value: boolean) => void;
  tags: ReviewTag[];
  setTags: React.Dispatch<React.SetStateAction<ReviewTag[]>>;
  turnstileToken: string | null;
  setTurnstileToken: (value: string | null) => void;
  onSubmit: () => void;
  onCloseReset: () => void;
};

export function ReviewComposer({
  isMobile,
  open,
  onOpenChange,
  submitMutationPending,
  turnstileSiteKey,
  professorId,
  selectedCourses,
  setSelectedCourses,
  academicTermId,
  setAcademicTermId,
  gradeReceived,
  setGradeReceived,
  comment,
  setComment,
  easeScore,
  setEaseScore,
  qualityScore,
  setQualityScore,
  clarityScore,
  setClarityScore,
  fairnessScore,
  setFairnessScore,
  engagementLevel,
  setEngagementLevel,
  attendanceRequired,
  setAttendanceRequired,
  tags,
  setTags,
  turnstileToken,
  setTurnstileToken,
  onSubmit,
  onCloseReset,
}: ReviewComposerProps) {
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [showReviewExample, setShowReviewExample] = useState(false);
  const comboboxPortalContainerRef = useRef<HTMLDivElement | null>(null);
  const courseAnchorRef = useComboboxAnchor();
  const termTriggerRef = useRef<HTMLButtonElement | null>(null);
  const tagAnchorRef = useComboboxAnchor();
  const parsedEngagementLevel = Number(engagementLevel);
  const clampedEngagementLevel = Number.isFinite(parsedEngagementLevel)
    ? Math.min(5, Math.max(1, Math.round(parsedEngagementLevel)))
    : 4;
  const coursesQuery = useProfessorReviewCourses(professorId);
  const termsQuery = useProfessorOfferingTerms(professorId);

  const courseOptions = useMemo(() => coursesQuery.data ?? [], [coursesQuery.data]);
  const termOptions = useMemo(() => termsQuery.data ?? [], [termsQuery.data]);
  const termGroups = useMemo(() => groupTermsByYear(termOptions), [termOptions]);
  const tagGroupItems = useMemo(
    () =>
      TAG_GROUPS.map((group) => ({
        value: group.label,
        items: group.tags,
      })),
    [],
  );

  const selectedTerm = termOptions.find((term) => String(term.id) === academicTermId) ?? null;

  useEffect(() => {
    if (academicTermId && !termOptions.some((term) => String(term.id) === academicTermId)) {
      setAcademicTermId("");
    }
  }, [academicTermId, setAcademicTermId, termOptions]);

  useEffect(() => {
    if (courseOptions.length === 0 || selectedCourses.length === 0) return;
    const validCodes = new Set(courseOptions.map((c) => c.code.toUpperCase()));
    const filtered = selectedCourses.filter((c) => validCodes.has(c.code.toUpperCase()));
    if (filtered.length !== selectedCourses.length) {
      setSelectedCourses(filtered);
    }
  }, [courseOptions, selectedCourses, setSelectedCourses]);

  const scoreDirty = (score: string) => score.trim() === "" || Number(score) !== 8;
  const isDirty =
    comment.trim() !== "" ||
    selectedCourses.length > 0 ||
    academicTermId !== "" ||
    gradeReceived.trim() !== "" ||
    tags.length > 0 ||
    scoreDirty(easeScore) ||
    scoreDirty(qualityScore) ||
    scoreDirty(clarityScore) ||
    scoreDirty(fairnessScore) ||
    engagementLevel !== "4" ||
    !attendanceRequired;

  const handleOpenChange = (nextOpen: boolean) => {
    if (!nextOpen && isDirty) {
      setConfirmOpen(true);
      return;
    }
    onOpenChange(nextOpen);
    if (!nextOpen) onCloseReset();
  };

  const requestClose = () => {
    handleOpenChange(false);
  };

  const handleDiscard = () => {
    onOpenChange(false);
    onCloseReset();
  };

  const confirmDialog = (
    <AlertDialog open={confirmOpen} onOpenChange={setConfirmOpen}>
      <AlertDialogPopup>
        <AlertDialogHeader>
          <AlertDialogTitle>¿Descartar reseña?</AlertDialogTitle>
          <AlertDialogDescription>
            Tienes cambios sin enviar. Si sales ahora, se perderán.
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel>Volver</AlertDialogCancel>
          <AlertDialogAction variant="destructive" onClick={handleDiscard}>
            Descartar
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogPopup>
    </AlertDialog>
  );

  const footerActions = (
    <>
      <Button type="button" variant="ghost" onClick={requestClose}>
        Cancelar
      </Button>
      <Button
        onClick={onSubmit}
        disabled={submitMutationPending || !turnstileSiteKey || !turnstileToken}
      >
        {submitMutationPending ? "Enviando..." : "Enviar reseña"}
      </Button>
    </>
  );

  const form = (
    <div className={`space-y-4 ${isMobile ? "px-4 pb-4" : "px-6 pb-6"}`}>
      <div className="grid gap-4 md:grid-cols-2">
        <div className="space-y-2">
          <Label htmlFor="composer-courses-trigger">Cursos</Label>
          <Combobox
            multiple
            autoHighlight
            items={courseOptions}
            value={selectedCourses}
            onValueChange={(courses) => {
              if (Array.isArray(courses)) setSelectedCourses(courses);
            }}
            itemToStringValue={(course) => `${course.code}: ${course.name}`}
          >
            <ComboboxChips ref={courseAnchorRef} className="w-full">
              <ComboboxValue>
                {(courses: ProfessorReviewCourseOption[]) => (
                  <>
                    {courses?.map((course) => (
                      <ComboboxChip
                        key={course.id}
                        aria-label={`${course.code}: ${course.name}`}
                        title={`${course.code}: ${course.name}`}
                      >
                        {course.code}
                      </ComboboxChip>
                    ))}
                    <ComboboxChipsInput
                      id="composer-courses-trigger"
                      className="min-w-0"
                      aria-label="Seleccionar cursos"
                      placeholder={
                        courses && courses.length > 0 ? undefined : "Seleccionar cursos..."
                      }
                    />
                  </>
                )}
              </ComboboxValue>
            </ComboboxChips>
            <ComboboxContent
              anchor={courseAnchorRef}
              container={comboboxPortalContainerRef}
              aria-label="Cursos"
              className="w-80"
            >
              <ComboboxEmpty>No se encontraron cursos para este profesor.</ComboboxEmpty>
              <ComboboxList className="max-h-56 scrollbar-none">
                {(course) => (
                  <ComboboxItem key={course.id} value={course}>
                    <span className="block min-w-0 flex-1 truncate">
                      {course.code}: {course.name}
                    </span>
                  </ComboboxItem>
                )}
              </ComboboxList>
            </ComboboxContent>
          </Combobox>
        </div>

        <div className="space-y-2">
          <div className="inline-flex w-full items-center justify-between gap-2">
            <Label htmlFor="composer-term-trigger">Periodo</Label>
            <Label className="text-muted-foreground font-normal" render={<span />}>
              Opcional
            </Label>
          </div>
          <Combobox
            items={termGroups}
            value={selectedTerm}
            onValueChange={(term) => setAcademicTermId(term ? String(term.id) : "")}
            itemToStringValue={(term) => formatTermNameWithoutYear(term.display_name)}
          >
            <ComboboxTrigger
              ref={termTriggerRef}
              render={
                <Button
                  id="composer-term-trigger"
                  variant="outline"
                  className="w-full min-w-0 justify-between overflow-hidden px-3 font-normal"
                  disabled={termsQuery.isLoading || termOptions.length === 0}
                />
              }
            >
              <span
                className={cn(
                  "block min-w-0 flex-1 truncate text-left",
                  !selectedTerm && "text-muted-foreground",
                )}
              >
                {selectedTerm
                  ? formatClosedTermLabel(selectedTerm)
                  : termsQuery.isLoading
                    ? "Cargando periodos..."
                    : "Seleccionar periodo"}
              </span>
              {selectedTerm ? (
                <button
                  type="button"
                  className="text-muted-foreground z-10 -mr-1 flex h-full shrink-0 items-center justify-center p-0.5 opacity-60 transition-opacity hover:opacity-100"
                  onClick={(e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    setAcademicTermId("");
                  }}
                  onKeyDown={(e) => {
                    if (e.key === "Enter" || e.key === " ") {
                      e.preventDefault();
                      e.stopPropagation();
                      setAcademicTermId("");
                    }
                  }}
                >
                  <Icon icon={Cancel01Icon} size={16} className="size-4" />
                  <span className="sr-only">Limpiar periodo seleccionado</span>
                </button>
              ) : (
                <Icon
                  icon={UnfoldMoreIcon}
                  size={14}
                  className="-me-1! size-3.5 shrink-0 opacity-60"
                />
              )}
            </ComboboxTrigger>
            <ComboboxContent
              anchor={termTriggerRef}
              container={comboboxPortalContainerRef}
              aria-label="Período"
              className="w-72"
            >
              <div className="border-b p-2">
                <ComboboxInput
                  className="rounded-md before:rounded-[calc(var(--radius-md)-1px)]"
                  placeholder="Buscar periodo..."
                  showTrigger={false}
                  startAddon={<Icon icon={Search01Icon} size={16} />}
                />
              </div>
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
                    {index < termGroups.length - 1 && <ComboboxSeparator />}
                  </ComboboxGroup>
                )}
              </ComboboxList>
            </ComboboxContent>
          </Combobox>
        </div>

        <div className="space-y-2">
          <ScoreNumberField
            id="composer-grade-received"
            label="Calificación obtenida"
            optional
            value={gradeReceived}
            onChange={setGradeReceived}
            max={100}
            step={1}
            placeholder="0 a 100"
          />
        </div>

        <div className="flex flex-col gap-2">
          <Label className="text-xs font-medium">Asistencia obligatoria</Label>
          <div className="flex h-9 items-center">
            <RadioGroup
              value={attendanceRequired ? "yes" : "no"}
              onValueChange={(value) => setAttendanceRequired(value === "yes")}
              className="flex flex-row items-center gap-4"
            >
              <Label className="cursor-pointer text-sm font-normal">
                <Radio value="yes" /> Sí
              </Label>
              <Label className="cursor-pointer text-sm font-normal">
                <Radio value="no" /> No
              </Label>
            </RadioGroup>
          </div>
        </div>
      </div>

      <Field className="w-full">
        <div className="flex w-full items-center justify-between gap-2">
          <FieldLabel htmlFor="composer-comment">Comentario</FieldLabel>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={() => setShowReviewExample((value) => !value)}
          >
            {showReviewExample ? "Ocultar ejemplo" : "Ver ejemplo"}
          </Button>
        </div>
        {showReviewExample ? (
          <div className="grid w-full gap-2">
            <div className="rounded-md border border-emerald-500/30 bg-emerald-500/10 px-3 py-2 text-sm">
              <p className="font-medium text-emerald-700 dark:text-emerald-400">
                Ejemplo de buena reseña
              </p>
              <p className="mt-1 text-emerald-900 dark:text-emerald-100">
                "Usa clase invertida, así que conviene llegar con la lectura hecha y en clase se
                enfoca en resolver problemas aplicados; además, la retroalimentación fue clara y
                rápida, por lo que pude corregir errores a tiempo y entender mejor cómo estudiar
                para los exámenes."
              </p>
            </div>
            <div className="rounded-md border border-red-500/30 bg-red-500/10 px-3 py-2 text-sm">
              <p className="font-medium text-red-700 dark:text-red-400">Ejemplo de mala reseña</p>
              <p className="mt-1 text-red-900 dark:text-red-100">
                "Ese profe es un inútil, da asco y no le crean nada de lo que dice."
              </p>
            </div>
          </div>
        ) : null}
        <Textarea
          id="composer-comment"
          maxLength={1000}
          placeholder="Describe método de enseñanza, evaluación y recomendaciones prácticas para futuros estudiantes"
          value={comment}
          onChange={(event) => setComment(event.target.value)}
          className="w-full"
        />
        <FieldDescription>
          Describe método de enseñanza y evaluación ({comment.length}/1000 caracteres).
        </FieldDescription>
      </Field>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <ScoreNumberField
          id="composer-ease-score"
          label="Facilidad"
          value={easeScore}
          onChange={setEaseScore}
        />
        <ScoreNumberField
          id="composer-quality-score"
          label="Calidad"
          value={qualityScore}
          onChange={setQualityScore}
        />
        <ScoreNumberField
          id="composer-clarity-score"
          label="Claridad"
          value={clarityScore}
          onChange={setClarityScore}
        />
        <ScoreNumberField
          id="composer-fairness-score"
          label="Justicia"
          value={fairnessScore}
          onChange={setFairnessScore}
        />
      </div>

      <div className="space-y-2">
        <div className="flex items-center justify-between gap-2">
          <Label htmlFor="composer-engagement-level">Interés en la clase</Label>
          <span
            className={`text-sm font-medium ${clampedEngagementLevel >= 4 ? "text-green-600" : clampedEngagementLevel <= 2 ? "text-red-600" : "text-amber-600"}`}
          >
            {clampedEngagementLevel <= 2 ? "Bajo" : clampedEngagementLevel >= 4 ? "Alto" : "Medio"}
          </span>
        </div>
        <div className="flex h-9 items-center">
          <Slider
            className="w-full -translate-y-px [&_[data-slot=slider-indicator]]:hidden [&_[data-slot=slider-track]::before]:inset-x-0 [&_[data-slot=slider-track]::before]:bg-gradient-to-r [&_[data-slot=slider-track]::before]:from-red-500 [&_[data-slot=slider-track]::before]:to-green-500"
            id="composer-engagement-level"
            thumbAlignment="center"
            min={1}
            max={5}
            step={1}
            value={[clampedEngagementLevel]}
            onValueChange={(value) => {
              const numericValue = typeof value === "number" ? value : (value?.[0] ?? 0);
              setEngagementLevel(String(numericValue));
            }}
          />
        </div>
      </div>

      <div className="space-y-2">
        <Label>Etiquetas</Label>
        <Combobox
          multiple
          autoHighlight
          items={tagGroupItems}
          value={tags}
          onValueChange={(value) => {
            if (Array.isArray(value)) setTags(value as ReviewTag[]);
          }}
          disabled={false}
        >
          <ComboboxChips
            ref={tagAnchorRef}
            className="min-h-[64px] w-full content-start items-start"
          >
            {tags.map((tag) => (
              <ComboboxChip key={tag}>{tag}</ComboboxChip>
            ))}
            <ComboboxChipsInput
              className="min-w-0"
              placeholder={tags.length === 0 ? "Seleccionar etiquetas..." : undefined}
            />
          </ComboboxChips>
          <ComboboxContent
            anchor={tagAnchorRef}
            container={comboboxPortalContainerRef}
            className="w-80"
          >
            <ComboboxEmpty>No se encontraron etiquetas.</ComboboxEmpty>
            <ComboboxList className="max-h-56 scrollbar-none">
              {(group, index) => (
                <ComboboxGroup key={group.value} items={group.items}>
                  <ComboboxLabel>{group.value}</ComboboxLabel>
                  <ComboboxCollection>
                    {(tag) => (
                      <ComboboxItem key={tag} value={tag}>
                        <span className="block min-w-0 flex-1 truncate">{tag}</span>
                      </ComboboxItem>
                    )}
                  </ComboboxCollection>
                  {index < tagGroupItems.length - 1 && <ComboboxSeparator />}
                </ComboboxGroup>
              )}
            </ComboboxList>
          </ComboboxContent>
        </Combobox>
      </div>

      {turnstileSiteKey ? (
        <Suspense fallback={null}>
          <Turnstile
            siteKey={turnstileSiteKey}
            options={{ language: "es", size: "flexible", appearance: "interaction-only" }}
            onSuccess={(token) => setTurnstileToken(token)}
            onError={() => setTurnstileToken(null)}
            onExpire={() => setTurnstileToken(null)}
          />
        </Suspense>
      ) : (
        <p className="text-sm text-amber-600">
          Turnstile no está configurado. Define VITE_TURNSTILE_SITE_KEY para habilitar envío.
        </p>
      )}
    </div>
  );

  if (isMobile) {
    return (
      <Drawer open={open} onOpenChange={handleOpenChange}>
        <DrawerPopup
          showBar
          className="grid max-h-[90dvh] grid-rows-[auto_minmax(0,1fr)_auto] overflow-hidden"
        >
          <div ref={comboboxPortalContainerRef} className="absolute top-0 left-0 size-0" />
          <DrawerHeader className="px-4 pt-4 pb-2">
            <DrawerTitle>Enviar reseña</DrawerTitle>
            <DrawerDescription className="space-y-2">
              <span className="block">
                Tu reseña es anónima y requiere aprobación antes de publicarse.
              </span>
              <Button
                className="h-auto p-0"
                variant="link"
                render={
                  <Link
                    to="/policies"
                    hash="politica-de-resenas-y-opiniones-sobre-docentes"
                    preload="intent"
                    target="_blank"
                    rel="noreferrer"
                  />
                }
              >
                Ver reglamento de reseñas
              </Button>
            </DrawerDescription>
          </DrawerHeader>
          <ScrollArea className="min-h-0">{form}</ScrollArea>
          <DrawerFooter>{footerActions}</DrawerFooter>
        </DrawerPopup>
        {confirmDialog}
      </Drawer>
    );
  }

  return (
    <Dialog open={open} onOpenChange={handleOpenChange}>
      <DialogContent
        className="max-h-[90vh] max-w-2xl grid-rows-[auto_minmax(0,1fr)] overflow-hidden"
        initialFocus={false}
      >
        <div ref={comboboxPortalContainerRef} className="absolute top-0 left-0 size-0" />
        <DialogHeader>
          <DialogTitle>Enviar reseña</DialogTitle>
          <DialogDescription className="space-y-2">
            <span className="block">
              Tu reseña es anónima y requiere aprobación antes de publicarse.
            </span>
            <Button
              className="h-auto p-0"
              variant="link"
              render={
                <Link
                  to="/policies"
                  hash="politica-de-resenas-y-opiniones-sobre-docentes"
                  preload="intent"
                  target="_blank"
                  rel="noreferrer"
                />
              }
            >
              Ver reglamento de reseñas
            </Button>
          </DialogDescription>
        </DialogHeader>
        <ScrollArea className="min-h-0">{form}</ScrollArea>
        <DialogFooter>{footerActions}</DialogFooter>
      </DialogContent>
      {confirmDialog}
    </Dialog>
  );
}
