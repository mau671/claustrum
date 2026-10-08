import { useDebouncedValue } from "@tanstack/react-pacer";
import { useQueryClient } from "@tanstack/react-query";
import { Link, getRouteApi } from "@tanstack/react-router";
import { type ColumnDef, flexRender, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { ChevronDown, ChevronRight, ChevronUp } from "lucide-react";
import { useMemo, useState, useCallback } from "react";

import type { ProfessorReviewStatsRow } from "@/lib/professor-reviews/types";

import { FilterCombobox, normalizeText } from "@/components/filters/shared-filters";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationNext,
  PaginationPrevious,
} from "@/components/ui/pagination";
import { ScoreInput } from "@/components/ui/score-input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Spinner } from "@/components/ui/spinner";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { useIsMobile } from "@/hooks/use-mobile";
import { useProfessorReviewStats } from "@/lib/hooks/use-professor-reviews";
import { useAcademicUnitsWithProfessors } from "@/lib/hooks/use-queries";
import {
  getProfessorById,
  getProfessorReviewSummary,
  getProfessorReviewsPublic,
} from "@/lib/professor-reviews/api";
import { cn } from "@/lib/utils";
import { getProfessorNameTransitionName } from "@/lib/utils/view-transition";

const DEFAULT_PAGE_SIZE = 25;

function formatScore(score: number | null): string {
  if (score === null) return "-";
  return score.toFixed(2);
}

const routeApi = getRouteApi("/professors/");

export function ProfessorsReviewsPage() {
  const queryClient = useQueryClient();
  const search = routeApi.useSearch();
  const navigate = routeApi.useNavigate();

  const searchInput = search.q ?? "";
  const [debouncedSearch] = useDebouncedValue(searchInput, { wait: 300 });

  const minAverageScoreInput = search.ms ?? "";
  const setMinAverageScoreInput = (val: string) =>
    void navigate({
      search: (prev) => ({ ...prev, ms: val || undefined, page: undefined }),
      replace: true,
    });

  const minReviewCountInput = search.mr ?? "0";
  const setMinReviewCountInput = (val: string) =>
    void navigate({
      search: (prev) => ({ ...prev, mr: val === "0" ? undefined : val, page: undefined }),
      replace: true,
    });

  const academicUnitIdInput = search.r ?? null;
  const setAcademicUnitIdInput = (val: number | null) =>
    void navigate({
      search: (prev) => ({ ...prev, r: val ?? undefined, page: undefined }),
      replace: true,
    });

  const sortBy = search.sortBy ?? "reviews";
  const sortDesc = search.sortDesc ?? true;

  const { data: allAcademicUnits = [] } = useAcademicUnitsWithProfessors();

  const handleSort = useCallback(
    (colId: string) => {
      let newSortBy: string | undefined = colId;
      let newSortDesc: boolean | undefined = true;

      if (sortBy === colId) {
        if (sortDesc === true) {
          newSortDesc = false;
        } else {
          newSortBy = "none";
          newSortDesc = undefined;
        }
      }

      void navigate({
        search: (prev) => ({
          ...prev,
          sortBy: newSortBy === "reviews" ? undefined : newSortBy,
          sortDesc: newSortDesc === true && newSortBy === "reviews" ? undefined : newSortDesc,
          page: undefined,
        }),
        replace: true,
      });
    },
    [navigate, sortBy, sortDesc],
  );

  const renderSortHeader = useCallback(
    (title: string, colId: string) => (
      <button
        type="button"
        onClick={() => handleSort(colId)}
        className="hover:text-foreground focus-visible:ring-ring flex h-8 items-center font-medium transition-colors focus-visible:ring-1 focus-visible:outline-none"
      >
        {title}
        <div className="ml-1.5 flex flex-col -space-y-[6px]">
          <ChevronUp
            className={cn(
              "size-[10px]",
              sortBy === colId && sortDesc === false
                ? "text-foreground"
                : "text-muted-foreground/50",
            )}
          />
          <ChevronDown
            className={cn(
              "size-[10px]",
              sortBy === colId && sortDesc === true
                ? "text-foreground"
                : "text-muted-foreground/50",
            )}
          />
        </div>
      </button>
    ),
    [handleSort, sortBy, sortDesc],
  );
  const [filtersExpanded, setFiltersExpanded] = useState(false);
  const [pageSize, setPageSize] = useState(DEFAULT_PAGE_SIZE);
  const page = search.page ? search.page - 1 : 0;
  const setPage = (updater: number | ((prev: number) => number)) => {
    const newPage = typeof updater === "function" ? updater(page) : updater;
    void navigate({
      search: (prev) => ({
        ...prev,
        page: newPage === 0 ? undefined : newPage + 1,
      }),
      replace: true,
    });
  };
  const minAverageScore = minAverageScoreInput.trim() === "" ? null : Number(minAverageScoreInput);
  const minReviewCount = Number.isFinite(Number(minReviewCountInput))
    ? Number(minReviewCountInput)
    : 0;

  const activeSortBy = sortBy === "none" ? null : sortBy;

  const query = useProfessorReviewStats({
    query: debouncedSearch,
    minAverageScore,
    minReviewCount,
    academicUnitId: academicUnitIdInput,
    onlyWithApprovedReviews: false,
    sortBy: activeSortBy,
    sortDesc,
    limit: pageSize,
    offset: page * pageSize,
  });

  const rows = query.data ?? [];
  const totalCount = rows[0]?.total_count ?? 0;
  const totalPages = totalCount === 0 ? 1 : Math.ceil(totalCount / pageSize);
  const hasMore = page + 1 < totalPages;
  const firstRow = rows.length === 0 ? 0 : page * pageSize + 1;
  const lastRow = page * pageSize + rows.length;

  const isMobile = useIsMobile();

  const columns = useMemo<ColumnDef<ProfessorReviewStatsRow>[]>(
    () => [
      {
        accessorKey: "professor_name",
        header: () => renderSortHeader("Nombre", "name"),
        cell: ({ row }) => {
          const professorId = row.original.professor_id;

          const prefetchProfessorDetail = () => {
            queryClient.setQueryData(["professorById", professorId], {
              id: professorId,
              full_name: row.original.professor_name,
            });
            void queryClient.prefetchQuery({
              queryKey: ["professorById", professorId],
              queryFn: () => getProfessorById(professorId),
            });
            void queryClient.prefetchQuery({
              queryKey: ["professorReviewsPublic", professorId, 0, 10],
              queryFn: () => getProfessorReviewsPublic(professorId, 10, 0),
            });
            void queryClient.prefetchQuery({
              queryKey: ["professorReviewSummary", professorId],
              queryFn: () => getProfessorReviewSummary(professorId),
            });
          };

          return (
            <div className="flex min-w-0 flex-col">
              <Link
                to="/professors/$professorId"
                params={{ professorId }}
                preload="intent"
                viewTransition={{ types: ["professor-open"] }}
                className="block truncate leading-tight font-medium underline-offset-4 hover:underline"
                style={{ viewTransitionName: getProfessorNameTransitionName(professorId) }}
                onMouseEnter={prefetchProfessorDetail}
                onPointerDown={prefetchProfessorDetail}
                onTouchStart={prefetchProfessorDetail}
                onFocus={prefetchProfessorDetail}
              >
                {row.original.professor_name}
              </Link>
              {row.original.academic_unit && (
                <span
                  className="text-muted-foreground truncate text-[10px] leading-tight sm:hidden"
                  title={row.original.academic_unit}
                >
                  {row.original.academic_unit}
                </span>
              )}
            </div>
          );
        },
      },
      ...(isMobile
        ? []
        : ([
            {
              accessorKey: "academic_unit",
              header: "Escuela",
              cell: ({ row }) => (
                <span
                  className="text-muted-foreground block truncate text-xs"
                  title={row.original.academic_unit || undefined}
                >
                  {row.original.academic_unit || "-"}
                </span>
              ),
            },
          ] as ColumnDef<ProfessorReviewStatsRow>[])),
      {
        accessorKey: "approved_review_count",
        header: () => (
          <div className="flex justify-end text-right">
            {renderSortHeader("Reseñas", "reviews")}
          </div>
        ),
        cell: ({ row }) => (
          <span className="block text-right tabular-nums">
            {row.original.approved_review_count}
          </span>
        ),
      },
      {
        accessorKey: "average_overall_score",
        header: () => (
          <div className="flex justify-end text-right">{renderSortHeader("Promedio", "score")}</div>
        ),
        cell: ({ row }) => (
          <span className="block text-right tabular-nums">
            {formatScore(row.original.average_overall_score)}
          </span>
        ),
      },
    ],
    [queryClient, renderSortHeader, isMobile],
  );

  const table = useReactTable({
    data: rows,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });
  const filterMinAverage = (
    <ScoreInput
      label="Promedio mínimo"
      value={minAverageScoreInput}
      onChange={(val) => {
        setMinAverageScoreInput(val);
      }}
      max={10}
      step={0.1}
    />
  );

  const filterMinReviews = (
    <ScoreInput
      label="Mínimo de reseñas"
      value={minReviewCountInput}
      onChange={(val) => {
        setMinReviewCountInput(val);
      }}
      max={100}
      step={1}
      regex={/^\d*$/}
    />
  );

  const filterSchool = (
    <div className="space-y-2">
      <Label>Escuela</Label>
      <FilterCombobox
        label="escuela"
        value={academicUnitIdInput?.toString() || ""}
        placeholder="Seleccionar escuela..."
        items={allAcademicUnits}
        onChange={(val) => {
          const newId = val ? parseInt(val) : null;
          setAcademicUnitIdInput(newId === academicUnitIdInput ? null : newId);
        }}
        isVisible={true}
        itemLabel={(item) =>
          item.code
            ? `${normalizeText(item.code)}: ${normalizeText(item.name)}`
            : normalizeText(item.name)
        }
        triggerClassName="h-9 sm:max-w-none"
      />
    </div>
  );

  return (
    <div className="flex flex-1 flex-col gap-6 px-4 py-6 lg:px-6">
      <header className="sr-only">
        <h1>Reseñas de profes TEC</h1>
        <p>
          Busca reseñas de profes del TEC, filtra por curso y compara experiencias academicas de
          estudiantes. Esta seccion tambien ayuda a encontrar referencias relacionadas con mis
          profes TEC, profesores TEC y opiniones de cursos.
        </p>
      </header>

      <Collapsible open={filtersExpanded} onOpenChange={setFiltersExpanded}>
        <div className="flex flex-col gap-4 lg:flex-row lg:items-end">
          <div className="flex flex-1 items-end gap-2">
            <div className="flex-1 space-y-2">
              <Label htmlFor="professor-search">Nombre</Label>
              <Input
                id="professor-search"
                className="h-9"
                placeholder="Ej: María González"
                aria-label="Buscar por nombre de profesor"
                value={searchInput}
                onChange={(event) => {
                  const newSearch = event.target.value;
                  void navigate({
                    search: (prev) => ({ ...prev, q: newSearch || undefined, page: undefined }),
                    replace: true,
                  });
                }}
              />
            </div>
            <CollapsibleTrigger asChild className="lg:hidden">
              <Button
                type="button"
                variant="outline"
                className="size-9"
                aria-label={filtersExpanded ? "Ocultar filtros" : "Mostrar filtros"}
              >
                {filtersExpanded ? (
                  <ChevronDown className="size-4" />
                ) : (
                  <ChevronRight className="size-4" />
                )}
              </Button>
            </CollapsibleTrigger>
          </div>

          <div className="hidden lg:flex lg:items-end lg:gap-4">
            <div className="w-40 shrink-0">{filterMinAverage}</div>
            <div className="w-40 shrink-0">{filterMinReviews}</div>
            <div className="w-72 shrink-0">{filterSchool}</div>
          </div>
        </div>

        <CollapsibleContent className="lg:hidden">
          <div className="grid gap-4 pt-3 md:grid-cols-2">
            {filterMinAverage}
            {filterMinReviews}
            <div className="md:col-span-2">{filterSchool}</div>
          </div>
        </CollapsibleContent>
      </Collapsible>

      <Card className="h-fit overflow-hidden p-0">
        <CardContent className="p-0">
          <div className="relative">
            <Table className="table-fixed">
              <TableHeader>
                {table.getHeaderGroups().map((headerGroup) => (
                  <TableRow key={headerGroup.id}>
                    {headerGroup.headers.map((header) => (
                      <TableHead
                        key={header.id}
                        className={cn(
                          header.column.id === "professor_name" && "w-auto sm:w-[35%]",
                          header.column.id === "academic_unit" && "w-[32%]",
                          header.column.id === "approved_review_count" && "w-[72px] sm:w-[15%]",
                          header.column.id === "average_overall_score" && "w-[80px] sm:w-[18%]",
                          (header.column.id === "approved_review_count" ||
                            header.column.id === "average_overall_score") &&
                            "text-right",
                        )}
                      >
                        {header.isPlaceholder
                          ? null
                          : flexRender(header.column.columnDef.header, header.getContext())}
                      </TableHead>
                    ))}
                  </TableRow>
                ))}
              </TableHeader>
              <TableBody>
                {query.isLoading ? (
                  <TableRow>
                    <TableCell colSpan={columns.length} className="p-0">
                      <div className="flex h-[650px] items-center justify-center">
                        <Spinner className="text-muted-foreground size-8" />
                      </div>
                    </TableCell>
                  </TableRow>
                ) : rows.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={columns.length} className="h-24 text-center">
                      <span className="text-muted-foreground text-sm">
                        No hay resultados para los filtros seleccionados.
                      </span>
                    </TableCell>
                  </TableRow>
                ) : (
                  table.getRowModel().rows.map((row) => (
                    <TableRow key={row.id}>
                      {row.getVisibleCells().map((cell) => (
                        <TableCell
                          key={cell.id}
                          className={cn(
                            (cell.column.id === "professor_name" ||
                              cell.column.id === "academic_unit") &&
                              "max-w-0",
                          )}
                        >
                          {cell.column.id === "professor_name" ||
                          cell.column.id === "academic_unit" ? (
                            <div className="max-w-full min-w-0 truncate">
                              {flexRender(cell.column.columnDef.cell, cell.getContext())}
                            </div>
                          ) : (
                            flexRender(cell.column.columnDef.cell, cell.getContext())
                          )}
                        </TableCell>
                      ))}
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>

      <div className="mt-2 flex items-center justify-between px-2">
        <span className="text-muted-foreground text-xs">
          {rows.length === 0
            ? "Sin resultados"
            : `Mostrando ${firstRow}-${lastRow} de ${totalCount}`}{" "}
          · Página {page + 1} de {totalPages}
          {query.isFetching ? <span className="ml-1 animate-pulse">(Actualizando…)</span> : null}
        </span>
        <div className="flex items-center gap-3">
          <Pagination className="w-auto">
            <PaginationContent>
              <PaginationItem>
                <PaginationPrevious
                  href="#"
                  onClick={(event) => {
                    event.preventDefault();
                    setPage((value) => Math.max(value - 1, 0));
                  }}
                  aria-disabled={page === 0 || query.isFetching}
                  className={cn(
                    page === 0 || query.isFetching ? "pointer-events-none opacity-50" : "",
                  )}
                />
              </PaginationItem>
              <PaginationItem>
                <PaginationNext
                  href="#"
                  onClick={(event) => {
                    event.preventDefault();
                    setPage((value) => value + 1);
                  }}
                  aria-disabled={!hasMore || query.isFetching}
                  className={cn(
                    !hasMore || query.isFetching ? "pointer-events-none opacity-50" : "",
                  )}
                />
              </PaginationItem>
            </PaginationContent>
          </Pagination>
          <div className="w-28">
            <Select
              value={String(pageSize)}
              onValueChange={(value) => {
                setPage(0);
                setPageSize(Number(value));
              }}
            >
              <SelectTrigger className="h-8">
                <SelectValue placeholder="Filas" />
              </SelectTrigger>
              <SelectContent position="popper" align="end" sideOffset={4}>
                <SelectItem value="25">25 filas</SelectItem>
                <SelectItem value="50">50 filas</SelectItem>
                <SelectItem value="100">100 filas</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
      </div>
    </div>
  );
}
