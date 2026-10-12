import { ChevronLeftIcon, ChevronRightIcon } from "@hugeicons/core-free-icons";
import { useMemo } from "react";

import { Button } from "@/components/ui/button";
import { Icon } from "@/components/ui/icon";
import {
  Pagination,
  PaginationContent,
  PaginationEllipsis,
  PaginationItem,
} from "@/components/ui/pagination";
import { cn } from "@/lib/utils";

export interface NumberedPaginationProps {
  page: number; // 0-based index
  totalPages: number;
  hasMore?: boolean;
  isFetching?: boolean;
  onPageChange: (newPage: number) => void;
  className?: string;
}

export function NumberedPagination({
  page,
  totalPages,
  hasMore = page + 1 < totalPages,
  isFetching = false,
  onPageChange,
  className,
}: NumberedPaginationProps) {
  const currentPage = page + 1;
  const paginationItems = useMemo(() => {
    if (totalPages <= 5) {
      return Array.from({ length: Math.max(totalPages, 1) }, (_, i) => i + 1);
    }
    if (currentPage <= 3) {
      return [1, 2, 3, "ellipsis", totalPages] as const;
    }
    if (currentPage >= totalPages - 2) {
      return [1, "ellipsis", totalPages - 2, totalPages - 1, totalPages] as const;
    }
    return [1, "ellipsis", currentPage, "ellipsis", totalPages] as const;
  }, [currentPage, totalPages]);

  return (
    <Pagination className={cn("mx-auto w-full justify-center", className)}>
      <PaginationContent className="flex flex-row items-center justify-center gap-1">
        <PaginationItem>
          <Button
            variant="ghost"
            size="icon"
            className="text-foreground size-8"
            disabled={page === 0 || isFetching}
            onClick={() => onPageChange(Math.max(page - 1, 0))}
            aria-label="Página anterior"
          >
            <Icon icon={ChevronLeftIcon} size={16} className="size-4" />
          </Button>
        </PaginationItem>

        {paginationItems.map((item, index) => {
          if (item === "ellipsis") {
            return (
              <PaginationItem key={`ellipsis-${index}`}>
                <PaginationEllipsis className="text-muted-foreground flex size-8 items-center justify-center" />
              </PaginationItem>
            );
          }

          const pageNumber = item as number;
          const isCurrent = currentPage === pageNumber;

          return (
            <PaginationItem key={pageNumber}>
              <Button
                variant={isCurrent ? "outline" : "ghost"}
                size="icon"
                className={cn(
                  "size-8 text-xs font-medium tabular-nums",
                  isCurrent &&
                    "border-border/80 bg-background text-foreground font-semibold shadow-xs",
                )}
                onClick={() => onPageChange(pageNumber - 1)}
                aria-label={`Página ${pageNumber}`}
                aria-current={isCurrent ? "page" : undefined}
              >
                {pageNumber}
              </Button>
            </PaginationItem>
          );
        })}

        <PaginationItem>
          <Button
            variant="ghost"
            size="icon"
            className="text-foreground size-8"
            disabled={!hasMore || isFetching}
            onClick={() => onPageChange(page + 1)}
            aria-label="Página siguiente"
          >
            <Icon icon={ChevronRightIcon} size={16} className="size-4" />
          </Button>
        </PaginationItem>
      </PaginationContent>
    </Pagination>
  );
}
