import {
  Cancel01Icon,
  ChevronDownIcon,
  ChevronLeftIcon,
  ChevronRightIcon,
  SlidersHorizontalIcon,
} from "@hugeicons/core-free-icons";
import { useState, useRef, useEffect, type ReactNode } from "react";

import { Button } from "@/components/ui/button";
import { Icon } from "@/components/ui/icon";
import { cn } from "@/lib/utils";

interface FiltersPanelProps {
  isExpanded: boolean;
  onExpandedChange: (open: boolean) => void;
  children: ReactNode;
  className?: string;
  variant?: "card" | "plain";
}

export function FiltersPanel({
  isExpanded,
  onExpandedChange,
  children,
  className,
  variant = "card",
}: FiltersPanelProps) {
  const scrollRef = useRef<HTMLDivElement>(null);
  const [canScrollLeft, setCanScrollLeft] = useState(false);
  const [canScrollRight, setCanScrollRight] = useState(false);

  const checkScroll = () => {
    if (scrollRef.current) {
      const { scrollLeft, scrollWidth, clientWidth } = scrollRef.current;
      setCanScrollLeft(scrollLeft > 0);
      setCanScrollRight(Math.ceil(scrollLeft + clientWidth) < scrollWidth);
    }
  };

  const scrollByAmount = (offset: number) => {
    if (scrollRef.current) {
      scrollRef.current.scrollBy({ left: offset, behavior: "smooth" });
    }
  };

  useEffect(() => {
    checkScroll();
    window.addEventListener("resize", checkScroll);
    return () => window.removeEventListener("resize", checkScroll);
  }, [children]);

  const isPlain = variant === "plain";

  return (
    <div className={cn("relative", className)}>
      {/* Desktop: horizontal scrollable bar with gradients */}
      <div
        className={cn(
          "group relative hidden min-h-10 items-center overflow-hidden md:flex",
          isPlain ? "" : "bg-muted/30 min-h-12 rounded-lg",
        )}
      >
        {canScrollLeft && (
          <div
            className={cn(
              "pointer-events-none absolute inset-y-0 left-0 z-10 flex w-14 items-center justify-start bg-gradient-to-r to-transparent pl-1",
              isPlain ? "from-background" : "from-muted/80",
            )}
          >
            <button
              type="button"
              className="border-border pointer-events-auto flex size-7 shrink-0 items-center justify-center rounded-full border bg-white text-neutral-800 shadow-md transition-all hover:bg-neutral-100 hover:text-neutral-900 active:scale-95 dark:border-neutral-700 dark:bg-neutral-800 dark:text-neutral-100 dark:hover:bg-neutral-700"
              onClick={() => scrollByAmount(-200)}
              aria-label="Desplazar filtros a la izquierda"
            >
              <Icon icon={ChevronLeftIcon} size={16} className="size-4" />
            </button>
          </div>
        )}
        <div
          ref={scrollRef}
          onScroll={checkScroll}
          className={cn(
            "flex w-full scrollbar-none items-center gap-2.5 overflow-x-auto [&>*]:shrink-0",
            isPlain ? "px-0.5 py-1" : "px-3 py-2",
          )}
        >
          {children}
        </div>
        {canScrollRight && (
          <div
            className={cn(
              "pointer-events-none absolute inset-y-0 right-0 z-10 flex w-14 items-center justify-end bg-gradient-to-l to-transparent pr-1",
              isPlain ? "from-background" : "from-muted/80",
            )}
          >
            <button
              type="button"
              className="border-border pointer-events-auto flex size-7 shrink-0 items-center justify-center rounded-full border bg-white text-neutral-800 shadow-md transition-all hover:bg-neutral-100 hover:text-neutral-900 active:scale-95 dark:border-neutral-700 dark:bg-neutral-800 dark:text-neutral-100 dark:hover:bg-neutral-700"
              onClick={() => scrollByAmount(200)}
              aria-label="Desplazar filtros a la derecha"
            >
              <Icon icon={ChevronRightIcon} size={16} className="size-4" />
            </button>
          </div>
        )}
      </div>

      {/* Mobile: collapsible */}
      <div className="md:hidden">
        <div
          className={cn(
            "flex items-center justify-between gap-2",
            isPlain ? "py-1.5" : "bg-muted/30 rounded-lg px-3 py-2",
          )}
        >
          <div className="text-muted-foreground flex items-center gap-2">
            <Icon icon={SlidersHorizontalIcon} size={16} className="size-4" />
            <span className="text-sm font-medium">Filtros</span>
          </div>
          <Button
            type="button"
            variant="ghost"
            size="icon-sm"
            aria-label={isExpanded ? "Ocultar filtros" : "Mostrar filtros"}
            onClick={() => onExpandedChange(!isExpanded)}
          >
            {isExpanded ? (
              <Icon icon={Cancel01Icon} size={16} className="size-4" />
            ) : (
              <Icon icon={ChevronDownIcon} size={16} className="size-4" />
            )}
          </Button>
        </div>

        {isExpanded && (
          <div className="pt-2">
            <div className={cn("space-y-2.5", isPlain ? "" : "bg-muted/30 rounded-lg p-3")}>
              {children}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
