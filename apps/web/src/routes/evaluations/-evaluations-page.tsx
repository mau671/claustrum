import {
  ChevronDownIcon,
  ChevronRightIcon,
  File01Icon,
  File02Icon,
  FileUpIcon,
} from "@hugeicons/core-free-icons";
import { useDebouncedValue } from "@tanstack/react-pacer";
import { getRouteApi, Link } from "@tanstack/react-router";
import { Fragment, useEffect, useMemo, useRef, useState } from "react";

import type { BrowseEvaluationsParams } from "@/lib/evaluations/api";

import { EvaluationUploadDialog } from "@/components/evaluations/evaluation-upload-dialog";
import { Button } from "@/components/ui/button";
import { Icon, MorphIcon } from "@/components/ui/icon";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { SearchableCombobox } from "@/components/ui/searchable-combobox";
import { Skeleton } from "@/components/ui/skeleton";
import {
  EVALUATION_TYPE_LABELS,
  formatEvaluationLevelLabel,
  formatEvaluationTypeLabel,
  type EvaluationCourseItem,
  type EvaluationRow,
  type EvaluationTermItem,
  type EvaluationType,
} from "@/lib/evaluations/types";
import {
  useCourseTermEvaluations,
  useEvaluationCourses,
  useEvaluationTerms,
} from "@/lib/hooks/use-evaluations";
import { cn } from "@/lib/utils";

const routeApi = getRouteApi("/evaluations/");
const TYPE_OPTIONS = (Object.keys(EVALUATION_TYPE_LABELS) as EvaluationType[]).map((value) => ({
  value,
  label: EVALUATION_TYPE_LABELS[value],
}));

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

function termsSkeleton() {
  return (
    <div className="space-y-2 py-2" aria-hidden="true">
      {Array.from({ length: 3 }).map((_, index) => (
        <div key={index} className="flex items-center gap-2 px-2">
          <Skeleton className="size-3.5 shrink-0 rounded-sm" />
          <Skeleton className={cn("h-4 rounded-sm", index === 0 ? "w-28" : "w-20")} />
        </div>
      ))}
    </div>
  );
}

function evaluationsSkeleton() {
  return (
    <div className="space-y-3 py-2" aria-hidden="true">
      {Array.from({ length: 3 }).map((_, index) => (
        <div key={index} className="px-2">
          <Skeleton className={cn("h-4 rounded-sm", index === 0 ? "w-32" : "w-24")} />
          {index === 0 && <Skeleton className="mt-1.5 h-3 w-40 rounded-sm" />}
          <div className="mt-2 ml-4 space-y-1.5">
            <Skeleton className="h-3 w-28 rounded-sm" />
            {index === 0 && <Skeleton className="h-3 w-24 rounded-sm" />}
          </div>
        </div>
      ))}
    </div>
  );
}

function GroupToggle({
  label,
  expanded,
  onToggle,
  className,
  meta,
}: {
  label: string;
  expanded: boolean;
  onToggle: () => void;
  className?: string;
  meta?: string;
}) {
  return (
    <button
      type="button"
      onClick={onToggle}
      aria-expanded={expanded}
      className={cn(
        "hover:bg-muted/40 flex w-full items-center gap-2 rounded-md px-2 py-1.5 text-left transition-colors",
        className,
      )}
    >
      <MorphIcon
        icon={expanded ? ChevronDownIcon : ChevronRightIcon}
        size={14}
        className="text-muted-foreground size-3.5 shrink-0"
      />
      <span className="text-foreground min-w-0 truncate">{label}</span>
      {meta && (
        <span className="text-muted-foreground/80 ml-auto min-w-0 shrink-0 truncate text-[11px] font-normal">
          {meta}
        </span>
      )}
    </button>
  );
}

function DocumentLink({
  document,
  courseCode,
}: {
  document: {
    kind: "enunciado" | "solucion";
    slug: string;
    size: number | null;
    includesAnswers: boolean;
  };
  courseCode: string;
}) {
  const isSolution = document.kind === "solucion";
  return (
    <Link
      to="/evaluations/view/$evaluationSlug"
      params={{ evaluationSlug: document.slug }}
      className="text-muted-foreground hover:text-foreground hover:bg-muted/50 -mx-1 flex items-center gap-2 rounded-md px-1 py-1 text-xs transition-colors"
      aria-label={`${isSolution ? "Solución" : "Enunciado"} de ${courseCode}`}
    >
      <Icon
        icon={isSolution ? File02Icon : File01Icon}
        size={14}
        className="text-muted-foreground/70 size-3.5 shrink-0"
      />
      <span className="flex min-w-0 flex-1 flex-col">
        <span className="flex items-baseline justify-between gap-2">
          <span>{isSolution ? "Solución" : "Enunciado"}</span>
          {document.size !== null && (
            <span className="text-muted-foreground/70 font-mono text-[11px] tabular-nums">
              {formatFileSize(document.size)}
            </span>
          )}
        </span>
        {document.includesAnswers && (
          <span className="text-muted-foreground/80 text-[11px]">Incluye respuestas</span>
        )}
      </span>
    </Link>
  );
}

type LevelGroup = {
  key: string;
  extraordinary: boolean;
  variant: number | null;
  label: string;
  rows: EvaluationRow[];
};

type ExamGroup = {
  key: string;
  label: string;
  typeOrder: number;
  numberOrder: number;
  levels: LevelGroup[];
  showLevels: boolean;
};

const TYPE_ORDER: Record<EvaluationType, number> = {
  parcial: 0,
  quiz: 1,
  final: 2,
  reposicion: 3,
  tarea: 4,
  proyecto: 5,
  otro: 6,
};

function groupEvaluationsByExam(rows: EvaluationRow[]): ExamGroup[] {
  const exams = new Map<string, ExamGroup>();

  for (const row of rows) {
    const examKey = `${row.type}:${row.number ?? 0}:${row.name ?? ""}`;
    let exam = exams.get(examKey);
    if (!exam) {
      exam = {
        key: examKey,
        label: formatEvaluationTypeLabel(row.type, row.number, row.name),
        typeOrder: TYPE_ORDER[row.type] ?? 99,
        numberOrder: row.number ?? 0,
        levels: [],
        showLevels: false,
      };
      exams.set(examKey, exam);
    }

    const levelKey = `${row.extraordinary}:${row.variant ?? ""}`;
    let level = exam.levels.find((item) => item.key === levelKey);
    if (!level) {
      level = {
        key: levelKey,
        extraordinary: row.extraordinary,
        variant: row.variant,
        label: formatEvaluationLevelLabel(row.extraordinary, row.variant),
        rows: [],
      };
      exam.levels.push(level);
    }
    level.rows.push(row);
  }

  return [...exams.values()]
    .sort(
      (a, b) =>
        a.typeOrder - b.typeOrder ||
        a.numberOrder - b.numberOrder ||
        a.label.localeCompare(b.label),
    )
    .map((exam) => {
      const levels = [...exam.levels].sort((a, b) => {
        if (a.extraordinary !== b.extraordinary) return a.extraordinary ? 1 : -1;
        return (a.variant ?? 0) - (b.variant ?? 0);
      });
      return {
        ...exam,
        levels,
        // A single ordinary version needs no extra heading: show its documents directly.
        showLevels:
          levels.length > 1 ||
          levels.some((level) => level.extraordinary || level.variant !== null),
      };
    });
}

function DocumentList({ rows, courseCode }: { rows: EvaluationRow[]; courseCode: string }) {
  return (
    <>
      {rows.map((row) => (
        <Fragment key={row.id}>
          <DocumentLink
            document={{
              kind: "enunciado",
              slug: `${row.id}.pdf`,
              size: row.file_size,
              includesAnswers: row.answers_included,
            }}
            courseCode={courseCode}
          />
          {row.answers_separate && (
            <DocumentLink
              document={{
                kind: "solucion",
                slug: `${row.id}_answers.pdf`,
                size: null,
                includesAnswers: false,
              }}
              courseCode={courseCode}
            />
          )}
        </Fragment>
      ))}
    </>
  );
}

function LevelGroupView({ level, courseCode }: { level: LevelGroup; courseCode: string }) {
  const professorName = level.rows.find((row) => row.professor_name)?.professor_name ?? null;

  return (
    <div className="py-0.5">
      <div className="flex items-baseline justify-between gap-2 px-2">
        <span className="text-muted-foreground text-xs font-medium">{level.label}</span>
        {professorName && (
          <span className="text-muted-foreground/80 min-w-0 truncate text-[11px]">
            {professorName}
          </span>
        )}
      </div>
      <div className="mt-0.5 ml-4 flex flex-col gap-0.5 sm:ml-5">
        <DocumentList rows={level.rows} courseCode={courseCode} />
      </div>
    </div>
  );
}

function ExamGroupView({ exam, courseCode }: { exam: ExamGroup; courseCode: string }) {
  const [expanded, setExpanded] = useState(true);
  const professorName =
    exam.levels.flatMap((level) => level.rows).find((row) => row.professor_name)?.professor_name ??
    null;

  return (
    <div className="py-1">
      <GroupToggle
        label={exam.label}
        expanded={expanded}
        onToggle={() => setExpanded((value) => !value)}
        className="text-foreground text-sm font-medium"
        meta={exam.showLevels ? undefined : (professorName ?? undefined)}
      />
      {expanded && (
        <div className="border-border/60 mt-0.5 ml-4 space-y-1 border-l pl-3 sm:ml-5">
          {exam.showLevels ? (
            exam.levels.map((level) => (
              <LevelGroupView key={level.key} level={level} courseCode={courseCode} />
            ))
          ) : (
            <div className="flex flex-col gap-0.5 py-0.5">
              <DocumentList rows={exam.levels[0]?.rows ?? []} courseCode={courseCode} />
            </div>
          )}
        </div>
      )}
    </div>
  );
}

function TermGroup({
  course,
  term,
  params,
}: {
  course: EvaluationCourseItem;
  term: EvaluationTermItem;
  params: BrowseEvaluationsParams;
}) {
  const [expanded, setExpanded] = useState(false);
  const termKey = term.term_id === null ? "none" : String(term.term_id);
  const evaluationsQuery = useCourseTermEvaluations(
    expanded ? course.course_id : null,
    expanded ? termKey : null,
    params,
  );
  const examGroups = useMemo(
    () => groupEvaluationsByExam(evaluationsQuery.data ?? []),
    [evaluationsQuery.data],
  );

  return (
    <div className="py-0.5">
      <GroupToggle
        label={term.label}
        expanded={expanded}
        onToggle={() => setExpanded((value) => !value)}
        className="text-muted-foreground text-xs tracking-wide uppercase"
      />
      {expanded && (
        <div className="border-border/60 mt-1 ml-4 space-y-1 border-l pl-3 sm:ml-5">
          {evaluationsQuery.isLoading ? (
            evaluationsSkeleton()
          ) : examGroups.length === 0 ? (
            <p className="text-muted-foreground px-2 py-2 text-xs">Sin evaluaciones.</p>
          ) : (
            examGroups.map((exam) => (
              <ExamGroupView key={exam.key} exam={exam} courseCode={course.code} />
            ))
          )}
        </div>
      )}
    </div>
  );
}

function groupByYear(terms: EvaluationTermItem[]): { year: string; terms: EvaluationTermItem[] }[] {
  const groups = new Map<string, EvaluationTermItem[]>();
  for (const term of terms) {
    const year = term.year === null ? "Sin año" : String(term.year);
    const bucket = groups.get(year) ?? [];
    bucket.push(term);
    groups.set(year, bucket);
  }
  return [...groups.entries()]
    .sort(([a], [b]) => b.localeCompare(a))
    .map(([year, items]) => ({ year, terms: items }));
}

function CourseGroup({
  course,
  params,
  onUpload,
}: {
  course: EvaluationCourseItem;
  params: BrowseEvaluationsParams;
  onUpload: (course: EvaluationCourseItem) => void;
}) {
  const [expanded, setExpanded] = useState(false);
  const termsQuery = useEvaluationTerms(expanded ? course.course_id : null, params);
  const years = useMemo(() => groupByYear(termsQuery.data ?? []), [termsQuery.data]);

  return (
    <div className="py-2">
      <div className="flex items-center gap-2">
        <GroupToggle
          label={`${course.code}: ${course.name}`}
          expanded={expanded}
          onToggle={() => setExpanded((value) => !value)}
          className="min-w-0 flex-1 py-2 text-sm"
        />
        <Button
          type="button"
          variant="ghost"
          size="icon"
          className="text-muted-foreground size-8 shrink-0"
          onClick={() => onUpload(course)}
          aria-label={`Subir evaluación para ${course.code}`}
          title="Subir evaluación"
        >
          <Icon icon={FileUpIcon} size={16} className="size-4" />
        </Button>
      </div>
      {expanded && (
        <div className="border-border/60 mt-1 ml-4 space-y-2 border-l pl-3 sm:ml-5">
          {termsQuery.isLoading ? (
            termsSkeleton()
          ) : years.length === 0 ? (
            <p className="text-muted-foreground px-2 py-2 text-xs">Sin períodos registrados.</p>
          ) : (
            years.map((group) => (
              <div key={group.year}>
                <div className="text-muted-foreground px-2 font-mono text-xs tracking-wide">
                  {group.year}
                </div>
                <div className="border-border/60 mt-1 ml-4 space-y-0.5 border-l pl-3 sm:ml-5">
                  {group.terms.map((term) => (
                    <TermGroup
                      key={term.term_id ?? "none"}
                      course={course}
                      term={term}
                      params={params}
                    />
                  ))}
                </div>
              </div>
            ))
          )}
        </div>
      )}
    </div>
  );
}

export function EvaluationsPage() {
  const search = routeApi.useSearch();
  const navigate = routeApi.useNavigate();

  const [uploadCourse, setUploadCourse] = useState<EvaluationCourseItem | null>(null);
  const [searchTerm, setSearchTerm] = useState(search.q ?? "");
  const urlQuery = search.q ?? "";
  const lastPushedQuery = useRef(urlQuery);

  // The URL only drives the input when it changes outside this search box
  // (back/forward or a link). Our own debounced navigation must not rewrite
  // the input, otherwise in-flight navigations restore old text.
  useEffect(() => {
    if (urlQuery === lastPushedQuery.current) return;
    lastPushedQuery.current = urlQuery;
    setSearchTerm(urlQuery);
  }, [urlQuery]);

  const [debouncedSearch] = useDebouncedValue(searchTerm, { wait: 300 });

  useEffect(() => {
    const next = debouncedSearch.trim();
    if (next === lastPushedQuery.current) return;
    lastPushedQuery.current = next;
    void navigate({
      search: (prev) => ({ ...prev, q: next || undefined }),
      replace: true,
    });
  }, [debouncedSearch, navigate]);

  const params = useMemo<BrowseEvaluationsParams>(
    () => ({ q: debouncedSearch.trim() || undefined, types: search.types }),
    [debouncedSearch, search.types],
  );
  const coursesQuery = useEvaluationCourses(params);
  const courses = useMemo(() => coursesQuery.data ?? [], [coursesQuery.data]);

  const selectedTypes = useMemo(
    () => TYPE_OPTIONS.filter((option) => (search.types ?? []).includes(option.value)),
    [search.types],
  );

  return (
    <div className="flex flex-1 flex-col gap-5 px-4 py-6 lg:px-6">
      <header className="sr-only">
        <h1>Evaluaciones y exámenes del TEC</h1>
        <p>
          Explora exámenes y evaluaciones subidos por estudiantes del Tecnológico de Costa Rica,
          organizados por curso, año y período.
        </p>
      </header>

      <div className="flex flex-col gap-4 sm:flex-row sm:items-end">
        <div className="flex flex-1 flex-col gap-2">
          <Label htmlFor="evaluation-search">Curso o profesor</Label>
          <Input
            id="evaluation-search"
            className="h-9 w-full sm:h-9"
            placeholder="Ej: MA1101 o María González"
            aria-label="Buscar evaluaciones por curso o profesor"
            value={searchTerm}
            onChange={(event) => {
              setSearchTerm(event.target.value);
            }}
          />
        </div>
        <div className="flex w-full flex-col gap-2 sm:w-72">
          <Label>Tipo de evaluación</Label>
          <SearchableCombobox
            label="Tipo de evaluación"
            placeholder="Todos los tipos"
            items={TYPE_OPTIONS}
            value={selectedTypes}
            onValueChange={(options) => {
              const types = options.map((option) => option.value);
              void navigate({
                search: (prev) => ({ ...prev, types: types.length > 0 ? types : undefined }),
                replace: true,
              });
            }}
            itemToString={(option) => option.label}
            multiple
            chipsClassName="min-h-9 sm:min-h-9"
            listClassName="max-h-48 scrollbar-none"
          />
        </div>
      </div>

      {coursesQuery.isLoading ? (
        <div className="space-y-2" aria-hidden="true">
          {Array.from({ length: 6 }).map((_, index) => (
            <div key={index} className="flex items-center gap-2 px-2 py-2">
              <Skeleton className="size-3.5 shrink-0 rounded-sm" />
              <Skeleton className={cn("h-4 rounded-sm", index % 2 === 0 ? "w-56" : "w-44")} />
            </div>
          ))}
        </div>
      ) : courses.length === 0 ? (
        <div className="flex h-24 items-center justify-center">
          <span className="text-muted-foreground text-sm">
            No hay evaluaciones para los filtros seleccionados.
          </span>
        </div>
      ) : (
        <div className="divide-border/60 divide-y">
          {courses.map((course) => (
            <CourseGroup
              key={course.course_id}
              course={course}
              params={params}
              onUpload={setUploadCourse}
            />
          ))}
        </div>
      )}

      {uploadCourse && (
        <EvaluationUploadDialog
          courseId={uploadCourse.course_id}
          courseCode={uploadCourse.code}
          courseName={uploadCourse.name}
          studyPlanId={null}
          open
          onOpenChange={(open) => {
            if (!open) setUploadCourse(null);
          }}
        />
      )}
    </div>
  );
}
