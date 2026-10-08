import { Link } from "@tanstack/react-router";
import { X } from "lucide-react";
import { lazy, Suspense, useEffect, useMemo, useRef, useState } from "react";

import type { ProfessorReviewCourseOption } from "@/lib/professor-reviews/types";
import type { ReviewTag } from "@/lib/professor-reviews/types";

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
  useComboboxAnchor,
} from "@/components/ui/combobox";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { ScoreInput } from "@/components/ui/score-input";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";
import { Slider } from "@/components/ui/slider";
import { Textarea } from "@/components/ui/textarea";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
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
  const [showReviewExample, setShowReviewExample] = useState(false);
  const comboboxPortalContainerRef = useRef<HTMLDivElement | null>(null);
  const termTriggerRef = useRef<HTMLButtonElement | null>(null);
  const courseAnchorRef = useComboboxAnchor();
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

  const form = (
    <div className={`space-y-4 ${isMobile ? "px-4 pb-4" : "px-1 pb-2"}`}>
      <div className="grid gap-4 md:grid-cols-2">
        <div className="space-y-2">
          <Label>Cursos</Label>
          <Combobox
            multiple
            autoHighlight
            items={courseOptions}
            value={selectedCourses}
            onValueChange={(courses) => {
              if (Array.isArray(courses)) setSelectedCourses(courses);
            }}
            itemToStringValue={(course) => `${course.code}: ${course.name}`}
            disabled={coursesQuery.isLoading || courseOptions.length === 0}
          >
            <ComboboxChips ref={courseAnchorRef} className="w-full content-start items-start">
              {selectedCourses.map((course) => (
                <Tooltip key={course.id}>
                  <TooltipTrigger asChild>
                    <ComboboxChip>{course.code}</ComboboxChip>
                  </TooltipTrigger>
                  <TooltipContent side="top" sideOffset={4}>
                    {course.code}: {course.name}
                  </TooltipContent>
                </Tooltip>
              ))}
              <ComboboxChipsInput
                className="min-w-0"
                placeholder={selectedCourses.length === 0 ? "Seleccionar cursos" : undefined}
              />
            </ComboboxChips>
            <ComboboxContent
              anchor={courseAnchorRef}
              container={comboboxPortalContainerRef}
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
          <Label>Periodo (opcional)</Label>
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
              {selectedTerm && (
                <button
                  type="button"
                  className="text-muted-foreground hover:text-foreground hover:bg-muted z-10 -mr-1.5 flex h-full items-center justify-center rounded-sm p-0.5 transition-colors"
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
                  <X className="size-4" />
                  <span className="sr-only">Limpiar periodo seleccionado</span>
                </button>
              )}
            </ComboboxTrigger>
            <ComboboxContent
              anchor={termTriggerRef}
              container={comboboxPortalContainerRef}
              className="w-72"
            >
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
                    {index < termGroups.length - 1 && <ComboboxSeparator />}
                  </ComboboxGroup>
                )}
              </ComboboxList>
            </ComboboxContent>
          </Combobox>
        </div>

        <div className="space-y-2">
          <ScoreInput
            label="Calificación obtenida (opcional)"
            value={gradeReceived}
            onChange={setGradeReceived}
            max={100}
            step={1}
            regex={/^\d{0,3}(\.\d?)?$/}
            placeholder="0 a 100"
          />
        </div>

        <div className="space-y-2">
          <Label className="block">Asistencia obligatoria</Label>
          <div className="flex h-9 items-center">
            <RadioGroup
              value={attendanceRequired ? "yes" : "no"}
              onValueChange={(value) => setAttendanceRequired(value === "yes")}
              className="flex items-center gap-4"
            >
              <label
                htmlFor="composer-attendance-yes"
                className="inline-flex items-center gap-2 text-sm"
              >
                <RadioGroupItem value="yes" id="composer-attendance-yes" />
                Sí
              </label>
              <label
                htmlFor="composer-attendance-no"
                className="inline-flex items-center gap-2 text-sm"
              >
                <RadioGroupItem value="no" id="composer-attendance-no" />
                No
              </label>
            </RadioGroup>
          </div>
        </div>
      </div>

      <div className="space-y-2">
        <div className="flex items-center justify-between gap-2">
          <Label htmlFor="composer-comment">Comentario</Label>
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
          <div className="grid gap-2">
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
        />
        <p className="text-muted-foreground text-xs">{comment.length}/1000</p>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <ScoreInput label="Facilidad" value={easeScore} onChange={setEaseScore} />
        <ScoreInput label="Calidad" value={qualityScore} onChange={setQualityScore} />
        <ScoreInput label="Claridad" value={clarityScore} onChange={setClarityScore} />
        <ScoreInput label="Justicia" value={fairnessScore} onChange={setFairnessScore} />
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
            className="w-full -translate-y-px [&_[data-slot=slider-range]]:bg-transparent [&_[data-slot=slider-track]]:bg-gradient-to-r [&_[data-slot=slider-track]]:from-red-500 [&_[data-slot=slider-track]]:to-green-500"
            id="composer-engagement-level"
            min={1}
            max={5}
            step={1}
            value={[clampedEngagementLevel]}
            onValueChange={(value) => setEngagementLevel(String(value[0] ?? 4))}
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

      <div className="flex justify-end">
        <Button
          onClick={onSubmit}
          disabled={submitMutationPending || !turnstileSiteKey || !turnstileToken}
        >
          {submitMutationPending ? "Enviando..." : "Enviar reseña"}
        </Button>
      </div>
    </div>
  );

  if (isMobile) {
    return (
      <Sheet
        open={open}
        onOpenChange={(nextOpen) => {
          onOpenChange(nextOpen);
          if (!nextOpen) onCloseReset();
        }}
      >
        <SheetContent
          side="bottom"
          className="grid max-h-[90vh] grid-rows-[auto_minmax(0,1fr)] gap-0 overflow-hidden p-0"
          onOpenAutoFocus={(e) => e.preventDefault()}
        >
          <div ref={comboboxPortalContainerRef} className="absolute top-0 left-0 size-0" />
          <SheetHeader className="px-4 pt-4 pb-2">
            <SheetTitle>Enviar reseña</SheetTitle>
            <SheetDescription className="space-y-2">
              <span className="block">
                Tu reseña es anónima y requiere aprobación antes de publicarse.
              </span>
              <Button asChild className="h-auto p-0" variant="link">
                <Link
                  to="/policies"
                  hash="politica-de-resenas-y-opiniones-sobre-docentes"
                  preload="intent"
                  target="_blank"
                  rel="noreferrer"
                >
                  Ver reglamento de reseñas
                </Link>
              </Button>
            </SheetDescription>
          </SheetHeader>
          <ScrollArea className="min-h-0">{form}</ScrollArea>
        </SheetContent>
      </Sheet>
    );
  }

  return (
    <Dialog
      open={open}
      onOpenChange={(nextOpen) => {
        onOpenChange(nextOpen);
        if (!nextOpen) onCloseReset();
      }}
    >
      <DialogContent
        className="max-h-[90vh] max-w-3xl grid-rows-[auto_minmax(0,1fr)] overflow-hidden"
        onOpenAutoFocus={(e) => e.preventDefault()}
      >
        <div ref={comboboxPortalContainerRef} className="absolute top-0 left-0 size-0" />
        <DialogHeader>
          <DialogTitle>Enviar reseña</DialogTitle>
          <DialogDescription className="space-y-2">
            <span className="block">
              Tu reseña es anónima y requiere aprobación antes de publicarse.
            </span>
            <Button asChild className="h-auto p-0" variant="link">
              <Link
                to="/policies"
                hash="politica-de-resenas-y-opiniones-sobre-docentes"
                preload="intent"
                target="_blank"
                rel="noreferrer"
              >
                Ver reglamento de reseñas
              </Link>
            </Button>
          </DialogDescription>
        </DialogHeader>
        <ScrollArea className="min-h-0">{form}</ScrollArea>
      </DialogContent>
    </Dialog>
  );
}
