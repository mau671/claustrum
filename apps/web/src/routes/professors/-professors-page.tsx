import { Cancel01Icon, ChevronDownIcon, ChevronUpIcon } from "@hugeicons/core-free-icons";
import { useDebouncedValue } from "@tanstack/react-pacer";
import { useQueryClient } from "@tanstack/react-query";
import { Link, getRouteApi } from "@tanstack/react-router";
import {
  columnVisibilityFeature,
  createColumnHelper,
  flexRender,
  tableFeatures,
  useTable,
} from "@tanstack/react-table";
import { useMemo, useState, useCallback } from "react";

import type { ProfessorReviewStatsRow } from "@/lib/professor-reviews/types";

import { FilterCombobox, normalizeText } from "@/components/filters/shared-filters";
import { NumberedPagination } from "@/components/numbered-pagination";
import { Button } from "@/components/ui/button";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import { Frame, FrameFooter } from "@/components/ui/frame";
import { Icon, MorphIcon } from "@/components/ui/icon";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  NumberField,
  NumberFieldDecrement,
  NumberFieldGroup,
  NumberFieldIncrement,
  NumberFieldInput,
} from "@/components/ui/number-field";
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
import { useProfessorReviewStats } from "@/lib/hooks/use-professor-reviews";
import { useAcademicUnitsWithProfessors } from "@/lib/hooks/use-queries";
import {
  getProfessorById,
  getProfessorReviewSummary,
  getProfessorReviewsPublic,
} from "@/lib/professor-reviews/api";
import { cn } from "@/lib/utils";
import { getProfessorNameTransitionName } from "@/lib/utils/view-transition";

const PAGE_SIZE = 25;

function formatScore(score: number | null): string {
  if (score === null) return "-";
  return score.toFixed(2);
}

const SKELETON_NAME_WIDTHS = ["w-44", "w-52", "w-36", "w-48", "w-40"];
const SKELETON_SCHOOL_WIDTHS = ["w-36", "w-48", "w-32", "w-44", "w-40"];

function ProfessorsTableSkeleton({ count = 25, isMobile }: { count?: number; isMobile: boolean }) {
  return (
    <>
      {Array.from({ length: count }).map((_, index) => {
        const nameWidth = SKELETON_NAME_WIDTHS[index % SKELETON_NAME_WIDTHS.length];
        const schoolWidth = SKELETON_SCHOOL_WIDTHS[index % SKELETON_SCHOOL_WIDTHS.length];

        if (isMobile) {
          return (
            <TableRow key={index} className="border-border/70 border-b">
              <TableCell className="max-w-0">
                <div className="max-w-full min-w-0">
                  <div className="flex min-w-0 flex-col">
                    <div className="py-0.5 leading-normal">
                      <Skeleton className={cn("h-5 rounded-sm", nameWidth)} />
                    </div>
                    <span className="text-[10px] leading-tight">
                      <Skeleton className="inline-block h-2.5 w-24 rounded-sm align-middle" />
                    </span>
                  </div>
                </div>
              </TableCell>
              <TableCell className="text-right">
                <div className="flex justify-end">
                  <Skeleton className="h-4 w-6 rounded-sm" />
                </div>
              </TableCell>
              <TableCell className="text-right">
                <div className="flex justify-end">
                  <Skeleton className="h-4 w-7 rounded-sm" />
                </div>
              </TableCell>
            </TableRow>
          );
        }

        return (
          <TableRow key={index} className="border-border/70 border-b">
            <TableCell className="max-w-0">
              <div className="max-w-full min-w-0">
                <div className="flex min-w-0 flex-col">
                  <div className="py-0.5 leading-normal">
                    <Skeleton className={cn("h-5 rounded-sm", nameWidth)} />
                  </div>
                </div>
              </div>
            </TableCell>
            <TableCell className="max-w-0">
              <div className="max-w-full min-w-0">
                <Skeleton className={cn("h-4 rounded-sm", schoolWidth)} />
              </div>
            </TableCell>
            <TableCell className="text-right">
              <div className="flex justify-end">
                <Skeleton className="h-4 w-8 rounded-sm" />
              </div>
            </TableCell>
            <TableCell className="text-right">
              <div className="flex justify-end">
                <Skeleton className="h-4 w-10 rounded-sm" />
              </div>
            </TableCell>
          </TableRow>
        );
      })}
    </>
  );
}

const routeApi = getRouteApi("/professors/");

const professorTableFeatures = tableFeatures({
  columnVisibilityFeature,
});

const professorColumnHelper = createColumnHelper<
  typeof professorTableFeatures,
  ProfessorReviewStatsRow
>();

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
          <Icon
            icon={ChevronUpIcon}
            size={10}
            className={cn(
              "size-[10px]",
              sortBy === colId && sortDesc === false
                ? "text-foreground"
                : "text-muted-foreground/50",
            )}
          />
          <Icon
            icon={ChevronDownIcon}
            size={10}
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
    limit: PAGE_SIZE,
    offset: page * PAGE_SIZE,
  });

  const rows = query.data ?? [];
  const totalCount = rows[0]?.total_count ?? 0;
  const totalPages = totalCount === 0 ? 1 : Math.ceil(totalCount / PAGE_SIZE);
  const hasMore = page + 1 < totalPages;

  const isMobile = useIsMobile();

  const columns = useMemo(
    () =>
      professorColumnHelper.columns([
        professorColumnHelper.accessor("professor_name", {
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
                  className="text-foreground inline-block max-w-full truncate py-0.5 leading-normal font-medium underline-offset-2 hover:underline"
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
        }),
        ...(isMobile
          ? []
          : [
              professorColumnHelper.accessor("academic_unit", {
                header: "Escuela",
                cell: ({ row }) => (
                  <span
                    className="text-muted-foreground block truncate text-xs"
                    title={row.original.academic_unit || undefined}
                  >
                    {row.original.academic_unit || "-"}
                  </span>
                ),
              }),
            ]),
        professorColumnHelper.accessor("approved_review_count", {
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
        }),
        professorColumnHelper.accessor("average_overall_score", {
          header: () => (
            <div className="flex justify-end text-right">
              {renderSortHeader("Promedio", "score")}
            </div>
          ),
          cell: ({ row }) => (
            <span className="block text-right tabular-nums">
              {formatScore(row.original.average_overall_score)}
            </span>
          ),
        }),
      ]),
    [queryClient, renderSortHeader, isMobile],
  );

  const table = useTable({
    features: professorTableFeatures,
    data: rows,
    columns,
  });
  const filterMinAverage = (
    <div className="flex w-full flex-col gap-2">
      <Label htmlFor="min-average-score">Promedio mínimo</Label>
      <NumberField
        id="min-average-score"
        min={0}
        max={10}
        step={0.1}
        value={minAverageScoreInput === "" ? null : Number(minAverageScoreInput)}
        onValueChange={(val) =>
          setMinAverageScoreInput(
            val !== null && val !== undefined && !Number.isNaN(val) ? String(val) : "",
          )
        }
        className="w-full"
      >
        <NumberFieldGroup className="h-9 w-full sm:h-9">
          <NumberFieldDecrement />
          <NumberFieldInput placeholder="0 a 10" />
          <NumberFieldIncrement />
        </NumberFieldGroup>
      </NumberField>
    </div>
  );

  const filterMinReviews = (
    <div className="flex w-full flex-col gap-2">
      <Label htmlFor="min-review-count">Mínimo de reseñas</Label>
      <NumberField
        id="min-review-count"
        min={0}
        max={100}
        step={1}
        value={minReviewCountInput === "" ? null : Number(minReviewCountInput)}
        onValueChange={(val) =>
          setMinReviewCountInput(
            val !== null && val !== undefined && !Number.isNaN(val) ? String(val) : "",
          )
        }
        className="w-full"
      >
        <NumberFieldGroup className="h-9 w-full sm:h-9">
          <NumberFieldDecrement />
          <NumberFieldInput placeholder="Mín. reseñas" />
          <NumberFieldIncrement />
        </NumberFieldGroup>
      </NumberField>
    </div>
  );

  const filterSchool = (
    <div className="flex w-full flex-col gap-2">
      <Label htmlFor="school-filter">Escuela</Label>
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
        triggerClassName="h-9 sm:h-9 w-full sm:min-w-0 sm:max-w-none text-xs"
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
            <div className="flex flex-1 flex-col gap-2">
              <Label htmlFor="professor-search">Nombre</Label>
              <Input
                id="professor-search"
                className="h-9 w-full sm:h-9"
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
            <CollapsibleTrigger
              render={
                <Button
                  type="button"
                  variant="outline"
                  className="size-9"
                  aria-label={filtersExpanded ? "Ocultar filtros" : "Mostrar filtros"}
                />
              }
              className="lg:hidden"
            >
              <MorphIcon icon={filtersExpanded ? Cancel01Icon : ChevronDownIcon} size={16} />
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

      <Frame className="w-full">
        <Table variant="card" className="table-fixed">
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
              <ProfessorsTableSkeleton count={PAGE_SIZE} isMobile={isMobile} />
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
                      {cell.column.id === "professor_name" || cell.column.id === "academic_unit" ? (
                        <div className="max-w-full min-w-0">
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
