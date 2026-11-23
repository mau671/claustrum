import {
  ChevronDownIcon,
  ChevronRightIcon,
  File01Icon,
  File02Icon,
} from "@hugeicons/core-free-icons";
import { useDebouncedCallback } from "@tanstack/react-pacer";
import { getRouteApi, Link } from "@tanstack/react-router";
import { useMemo, useState } from "react";

import { NumberedPagination } from "@/components/numbered-pagination";
import { Frame, FrameFooter, FramePanel } from "@/components/ui/frame";
import { Icon, MorphIcon } from "@/components/ui/icon";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Skeleton } from "@/components/ui/skeleton";
import {
  EVALUATION_TYPE_LABELS,
  formatEvaluationTypeLabel,
  type EvaluationSearchRow,
  type EvaluationType,
} from "@/lib/evaluations/types";
import { useEvaluationSearch } from "@/lib/hooks/use-evaluations";
import { cn } from "@/lib/utils";

const routeApi = getRouteApi("/evaluations/");
const labelCollator = new Intl.Collator("es", { numeric: true, sensitivity: "base" });
const PAGE_SIZE = 25;
const TYPE_OPTIONS = (Object.keys(EVALUATION_TYPE_LABELS) as EvaluationType[]).map((value) => ({
  value,
  label: EVALUATION_TYPE_LABELS[value],
}));

type DocumentNode = {
  kind: "enunciado" | "solucion";
  slug: string;
  size: number | null;
  includesAnswers: boolean;
};

type EvaluationNode = {
  key: string;
  label: string;
  professor: string | null;
  documents: DocumentNode[];
};

type TermNode = {
  key: string;
  label: string;
  evaluations: EvaluationNode[];
};

type YearNode = {
  key: string;
  label: string;
  terms: TermNode[];
};

type CourseNode = {
  key: string;
  code: string;
  name: string;
  years: YearNode[];
};

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

function splitTerm(displayName: string | null): { year: string; term: string } {
  if (!displayName) return { year: "Sin año", term: "Sin período" };
  const [year, ...rest] = displayName.split(" - ");
  return { year: year.trim(), term: rest.join(" - ").trim() || "Sin período" };
}

function termRank(label: string): number {
  if (label.includes("SEMESTRE 1")) return 1;
  if (label.includes("SEMESTRE 2")) return 2;
  if (label.includes("VERANO")) return 3;
  return 4;
}

function buildTree(rows: EvaluationSearchRow[]): CourseNode[] {
  const courses = new Map<string, CourseNode>();

  for (const row of rows) {
    const courseKey = String(row.course_id);
    let course = courses.get(courseKey);
    if (!course) {
      course = {
        key: courseKey,
        code: row.course_code,
        name: row.course_name,
        years: [],
      };
      courses.set(courseKey, course);
    }

    const { year: yearLabel, term: termLabel } = splitTerm(row.term_display_name);
    let year = course.years.find((item) => item.label === yearLabel);
    if (!year) {
      year = { key: `${courseKey}/${yearLabel}`, label: yearLabel, terms: [] };
      course.years.push(year);
    }
    let term = year.terms.find((item) => item.label === termLabel);
    if (!term) {
      term = { key: `${year.key}/${termLabel}`, label: termLabel, evaluations: [] };
      year.terms.push(term);
    }

    term.evaluations.push({
      key: String(row.id),
      label: formatEvaluationTypeLabel(
        row.type,
        row.number,
        row.name,
        row.extraordinary,
        row.variant,
      ),
      professor: row.professor_name,
      documents: [
        {
          kind: "enunciado",
          slug: `${row.id}.pdf`,
          size: row.file_size,
          includesAnswers: row.answers_included,
        },
        ...(row.answers_separate
          ? [
              {
                kind: "solucion" as const,
                slug: `${row.id}_answers.pdf`,
                size: null,
                includesAnswers: false,
              },
            ]
          : []),
      ],
    });
  }

  return [...courses.values()]
    .sort((a, b) => a.code.localeCompare(b.code))
    .map((course) => ({
      ...course,
      years: course.years
        .sort((a, b) => b.label.localeCompare(a.label))
        .map((year) => ({
          ...year,
          terms: year.terms
            .sort((a, b) => termRank(a.label) - termRank(b.label))
            .map((term) => ({
              ...term,
              evaluations: term.evaluations.sort((a, b) => labelCollator.compare(a.label, b.label)),
            })),
        })),
    }));
}

function GroupToggle({
  label,
  expanded,
  onToggle,
  className,
}: {
  label: string;
  expanded: boolean;
  onToggle: () => void;
  className?: string;
}) {
  return (
    <button
      type="button"
      onClick={onToggle}
      aria-expanded={expanded}
      className={cn(
        "group/toggle hover:bg-muted/40 flex w-full items-center gap-2 rounded-md px-2 py-1.5 text-left transition-colors",
        className,
      )}
    >
      <MorphIcon
        icon={expanded ? ChevronDownIcon : ChevronRightIcon}
        size={14}
        className="text-muted-foreground size-3.5 shrink-0"
      />
      <span className="text-foreground min-w-0 truncate">{label}</span>
    </button>
  );
}

function DocumentLink({ document, courseCode }: { document: DocumentNode; courseCode: string }) {
  const isSolution = document.kind === "solucion";
  return (
    <Link
      to="/evaluations/view/$evaluationSlug"
      params={{ evaluationSlug: document.slug }}
      className="text-muted-foreground hover:text-foreground hover:bg-muted/50 -mx-1 flex items-start gap-2 rounded-md px-1 py-1 text-xs transition-colors"
      aria-label={`${isSolution ? "Solución" : "Enunciado"} de ${courseCode}`}
    >
      <Icon
        icon={isSolution ? File02Icon : File01Icon}
        size={14}
        className="text-muted-foreground/70 mt-0.5 size-3.5 shrink-0"
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

function TreeSkeleton() {
  return (
    <div className="space-y-6 p-4">
      {Array.from({ length: 4 }).map((_, index) => (
        <div key={index} className="space-y-3">
          <Skeleton className="h-5 w-48 rounded-sm" />
          <div className="ml-6 space-y-2 border-l pl-4">
            <Skeleton className="h-4 w-20 rounded-sm" />
            <Skeleton className="h-4 w-28 rounded-sm" />
            <Skeleton className="h-4 w-24 rounded-sm" />
          </div>
        </div>
      ))}
    </div>
  );
}

export function EvaluationsPage() {
  const search = routeApi.useSearch();
  const navigate = routeApi.useNavigate();

  const [searchTerm, setSearchTerm] = useState(search.q ?? "");
  const [previousQuery, setPreviousQuery] = useState(search.q ?? "");
  if ((search.q ?? "") !== previousQuery) {
    setPreviousQuery(search.q ?? "");
    setSearchTerm(search.q ?? "");
  }

  const [collapsed, setCollapsed] = useState<Set<string>>(() => new Set());

  const updateSearchUrl = useDebouncedCallback(
    (query: string) => {
      void navigate({
        search: (prev) => ({ ...prev, q: query.trim() || undefined, page: undefined }),
        replace: true,
      });
    },
    { wait: 300 },
  );

  const page = search.page ? Math.max(0, search.page - 1) : 0;
  const setPage = (newPage: number) => {
    void navigate({
      search: (prev) => ({
        ...prev,
        page: newPage === 0 ? undefined : newPage + 1,
      }),
      replace: true,
    });
  };

  const params = useMemo(
    () => ({
      q: search.q?.trim() || undefined,
      type: search.type,
      limit: PAGE_SIZE,
      offset: page * PAGE_SIZE,
    }),
    [search.q, search.type, page],
  );

  const query = useEvaluationSearch(params);
  const rows = useMemo(() => query.data ?? [], [query.data]);
  const tree = useMemo(() => buildTree(rows), [rows]);
  const totalCount = rows[0]?.total_count ?? 0;
  const totalPages = totalCount === 0 ? 1 : Math.ceil(totalCount / PAGE_SIZE);
  const hasMore = page + 1 < totalPages;

  const toggle = (key: string) => {
    setCollapsed((previous) => {
      const next = new Set(previous);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };

  return (
    <div className="flex flex-1 flex-col gap-6 px-4 py-6 lg:px-6">
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
              const next = event.target.value;
              setSearchTerm(next);
              updateSearchUrl(next);
            }}
          />
        </div>
        <div className="flex w-full flex-col gap-2 sm:w-52">
          <Label htmlFor="evaluation-type">Tipo de evaluación</Label>
          <Select
            items={TYPE_OPTIONS}
            value={search.type ?? null}
            onValueChange={(value) => {
              void navigate({
                search: (prev) => ({
                  ...prev,
                  type: (value as EvaluationType | null) ?? undefined,
                  page: undefined,
                }),
                replace: true,
              });
            }}
          >
            <SelectTrigger id="evaluation-type">
              <SelectValue placeholder="Todos los tipos" />
            </SelectTrigger>
            <SelectContent>
              {TYPE_OPTIONS.map((option) => (
                <SelectItem key={option.value} value={option.value}>
                  {option.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </div>

      <Frame className="w-full">
        <FramePanel className="p-2">
          {query.isLoading ? (
            <TreeSkeleton />
          ) : tree.length === 0 ? (
            <div className="flex h-24 items-center justify-center">
              <span className="text-muted-foreground text-sm">
                No hay evaluaciones para los filtros seleccionados.
              </span>
            </div>
          ) : (
            <div className="divide-border/60 divide-y">
              {tree.map((course) => {
                const courseExpanded = !collapsed.has(course.key);
                return (
                  <div key={course.key} className="px-2 py-1.5">
                    <GroupToggle
                      label={`${course.code}: ${course.name}`}
                      expanded={courseExpanded}
                      onToggle={() => toggle(course.key)}
                      className="py-2"
                    />

                    {courseExpanded && (
                      <div className="border-border/60 ml-4 space-y-1 border-l pt-1 pl-3 sm:ml-5">
                        {course.years.map((year) => {
                          const yearExpanded = !collapsed.has(year.key);
                          return (
                            <div key={year.key}>
                              <GroupToggle
                                label={year.label}
                                expanded={yearExpanded}
                                onToggle={() => toggle(year.key)}
                                className="font-mono text-xs tracking-wide"
                              />

                              {yearExpanded && (
                                <div className="border-border/60 ml-4 space-y-1 border-l pl-3 sm:ml-5">
                                  {year.terms.map((term) => (
                                    <div key={term.key} className="py-1">
                                      <div className="text-muted-foreground px-2 text-[11px] font-medium tracking-wide uppercase">
                                        {term.label}
                                      </div>
                                      <div className="border-border/60 mt-1 ml-4 space-y-1 border-l pl-3 sm:ml-5">
                                        {term.evaluations.map((evaluation) => (
                                          <div key={evaluation.key} className="py-1">
                                            <div className="px-2">
                                              <span className="text-foreground block text-sm font-medium">
                                                {evaluation.label}
                                              </span>
                                              {evaluation.professor && (
                                                <span className="text-muted-foreground block truncate text-xs">
                                                  {evaluation.professor}
                                                </span>
                                              )}
                                            </div>
                                            <div className="mt-0.5 ml-4 flex flex-col gap-0.5 sm:ml-5">
                                              {evaluation.documents.map((document) => (
                                                <DocumentLink
                                                  key={document.kind}
                                                  document={document}
                                                  courseCode={course.code}
                                                />
                                              ))}
                                            </div>
                                          </div>
                                        ))}
                                      </div>
                                    </div>
                                  ))}
                                </div>
                              )}
                            </div>
                          );
                        })}
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          )}
        </FramePanel>
        <FrameFooter className="p-1.5 pt-2">
          <NumberedPagination
            page={page}
            totalPages={totalPages}
            hasMore={hasMore}
            isFetching={query.isFetching}
            onPageChange={setPage}
          />
        </FrameFooter>
      </Frame>
    </div>
  );
}
