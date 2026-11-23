import { ViewIcon } from "@hugeicons/core-free-icons";
import { useDebouncedCallback } from "@tanstack/react-pacer";
import { getRouteApi } from "@tanstack/react-router";
import { useMemo, useState } from "react";

import { NumberedPagination } from "@/components/numbered-pagination";
import { Button } from "@/components/ui/button";
import { Frame, FrameFooter } from "@/components/ui/frame";
import { Icon } from "@/components/ui/icon";
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
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { useIsMobile } from "@/hooks/use-mobile";
import {
  EVALUATION_TYPE_LABELS,
  formatEvaluationTypeLabel,
  type EvaluationType,
} from "@/lib/evaluations/types";
import { useEvaluationSearch } from "@/lib/hooks/use-evaluations";
import { cn } from "@/lib/utils";

const routeApi = getRouteApi("/evaluations/");
const PAGE_SIZE = 25;
const TYPE_OPTIONS = (Object.keys(EVALUATION_TYPE_LABELS) as EvaluationType[]).map((value) => ({
  value,
  label: EVALUATION_TYPE_LABELS[value],
}));

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

function EvaluationsSkeleton({ isMobile }: { isMobile: boolean }) {
  return (
    <>
      {Array.from({ length: PAGE_SIZE }).map((_, index) => (
        <TableRow key={index} className="border-border/70 border-b">
          <TableCell className="max-w-0">
            <div className="flex min-w-0 flex-col gap-1">
              <Skeleton className={cn("h-3.5 rounded-sm", index % 2 === 0 ? "w-28" : "w-20")} />
              <Skeleton className="h-2.5 w-40 rounded-sm" />
            </div>
          </TableCell>
          <TableCell>
            <Skeleton className="h-3.5 w-20 rounded-sm" />
          </TableCell>
          {!isMobile && (
            <>
              <TableCell>
                <Skeleton className="h-3.5 w-24 rounded-sm" />
              </TableCell>
              <TableCell>
                <Skeleton className="h-3.5 w-28 rounded-sm" />
              </TableCell>
            </>
          )}
          <TableCell className="text-right">
            <Skeleton className="ms-auto h-3.5 w-10 rounded-sm" />
          </TableCell>
        </TableRow>
      ))}
    </>
  );
}

export function EvaluationsPage() {
  const search = routeApi.useSearch();
  const navigate = routeApi.useNavigate();
  const isMobile = useIsMobile();

  const [searchTerm, setSearchTerm] = useState(search.q ?? "");
  const [previousQuery, setPreviousQuery] = useState(search.q ?? "");
  if ((search.q ?? "") !== previousQuery) {
    setPreviousQuery(search.q ?? "");
    setSearchTerm(search.q ?? "");
  }

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
  const rows = query.data ?? [];
  const totalCount = rows[0]?.total_count ?? 0;
  const totalPages = totalCount === 0 ? 1 : Math.ceil(totalCount / PAGE_SIZE);
  const hasMore = page + 1 < totalPages;

  return (
    <div className="flex flex-1 flex-col gap-6 px-4 py-6 lg:px-6">
      <header className="sr-only">
        <h1>Evaluaciones y exámenes del TEC</h1>
        <p>
          Explora exámenes y evaluaciones subidos por estudiantes del Tecnológico de Costa Rica,
          organizados por curso.
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
        <Table variant="card" className="table-fixed">
          <TableHeader>
            <TableRow>
              <TableHead className="w-auto sm:w-[38%]">Curso</TableHead>
              <TableHead className="w-[26%] sm:w-[18%]">Evaluación</TableHead>
              {!isMobile && (
                <>
                  <TableHead className="w-[22%]">Período</TableHead>
                  <TableHead className="w-[22%]">Profesor</TableHead>
                </>
              )}
              <TableHead className="w-[64px] text-right">Archivo</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {query.isLoading ? (
              <EvaluationsSkeleton isMobile={isMobile} />
            ) : rows.length === 0 ? (
              <TableRow>
                <TableCell colSpan={isMobile ? 3 : 5} className="h-24 text-center">
                  <span className="text-muted-foreground text-sm">
                    No hay evaluaciones para los filtros seleccionados.
                  </span>
                </TableCell>
              </TableRow>
            ) : (
              rows.map((row) => (
                <TableRow key={row.id}>
                  <TableCell className="max-w-0">
                    <div className="flex min-w-0 flex-col">
                      <div className="flex min-w-0 items-center gap-2">
                        <span className="text-foreground shrink-0 font-mono text-xs font-medium">
                          {row.course_code}
                        </span>
                        <span className="text-muted-foreground truncate text-[10px] leading-tight">
                          {row.course_name}
                        </span>
                      </div>
                      {row.term_display_name && (
                        <span className="text-muted-foreground truncate text-[10px] leading-tight sm:hidden">
                          {row.term_display_name}
                        </span>
                      )}
                    </div>
                  </TableCell>
                  <TableCell className="max-w-0">
                    <span
                      className="text-foreground block truncate text-sm"
                      title={
                        formatEvaluationTypeLabel(
                          row.type,
                          row.number,
                          row.name,
                          row.extraordinary,
                          row.variant,
                        ) || undefined
                      }
                    >
                      {formatEvaluationTypeLabel(
                        row.type,
                        row.number,
                        row.name,
                        row.extraordinary,
                        row.variant,
                      )}
                    </span>
                    <span className="text-muted-foreground block text-[10px] leading-tight">
                      {formatFileSize(row.file_size)}
                      {row.answers_separate || row.answers_included ? " · con respuestas" : ""}
                    </span>
                  </TableCell>
                  {!isMobile && (
                    <>
                      <TableCell className="max-w-0">
                        <span
                          className="text-muted-foreground block truncate text-xs"
                          title={row.term_display_name ?? undefined}
                        >
                          {row.term_display_name ?? "-"}
                        </span>
                      </TableCell>
                      <TableCell className="max-w-0">
                        <span
                          className="text-muted-foreground block truncate text-xs"
                          title={row.professor_name ?? undefined}
                        >
                          {row.professor_name ?? "-"}
                        </span>
                      </TableCell>
                    </>
                  )}
                  <TableCell className="text-right">
                    <Button
                      variant="ghost"
                      size="icon"
                      className="size-8"
                      onClick={() =>
                        void navigate({
                          to: "/evaluations/view/$evaluationSlug",
                          params: { evaluationSlug: `${row.id}.pdf` },
                        })
                      }
                      aria-label={`Ver ${formatEvaluationTypeLabel(
                        row.type,
                        row.number,
                        row.name,
                        row.extraordinary,
                        row.variant,
                      )} de ${row.course_code}`}
                    >
                      <Icon icon={ViewIcon} className="size-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
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
