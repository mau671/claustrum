import {
  Cancel01Icon,
  ChevronDownIcon,
  ChevronLeftIcon,
  ChevronRightIcon,
  SlidersHorizontalIcon,
} from "@hugeicons/core-free-icons";
import { useState, useRef, useEffect, type ReactNode } from "react";

import { Button } from "@/components/ui/button";
import { Icon, MorphIcon } from "@/components/ui/icon";
import { ScrollArea } from "@/components/ui/scroll-area";
import { cn } from "@/lib/utils";

interface FiltersPanelProps {
  isExpanded: boolean;
  onExpandedChange: (open: boolean) => void;
  children: ReactNode;
  actions?: ReactNode;
  className?: string;
  variant?: "card" | "plain";
}

export function FiltersPanel({
  isExpanded,
  onExpandedChange,
  children,
  actions,
  className,
  variant = "card",
}: FiltersPanelProps) {
  const scrollRef = useRef<HTMLDivElement>(null);
  const [canScrollLeft, setCanScrollLeft] = useState(false);
  const [canScrollRight, setCanScrollRight] = useState(false);

  const scrollByAmount = (offset: number) => {
    if (scrollRef.current) {
      scrollRef.current.scrollBy({ left: offset, behavior: "smooth" });
    }
  };

  useEffect(() => {
    const viewport = scrollRef.current;
    if (!viewport) return;

    const checkScroll = () => {
      const { scrollLeft, scrollWidth, clientWidth } = viewport;
      setCanScrollLeft(scrollLeft > 1);
      setCanScrollRight(scrollWidth - clientWidth - scrollLeft > 1);
    };

    checkScroll();
    const frame = requestAnimationFrame(checkScroll);
    viewport.addEventListener("scroll", checkScroll, { passive: true });
    window.addEventListener("resize", checkScroll);

    const observer = new ResizeObserver(checkScroll);
    observer.observe(viewport);
    const content = viewport.firstElementChild;
    if (content) observer.observe(content);

    return () => {
      cancelAnimationFrame(frame);
      viewport.removeEventListener("scroll", checkScroll);
      window.removeEventListener("resize", checkScroll);
      observer.disconnect();
    };
  }, [children]);

  const isPlain = variant === "plain";

  return (
    <div className={cn("relative", className)}>
      {/* Desktop: horizontal scrollable bar with unified fade */}
      <div className="hidden md:flex md:items-center md:gap-3">
        <div
          className={cn(
            "group relative flex min-h-10 min-w-0 flex-1 items-center overflow-hidden",
            isPlain ? "" : "bg-muted/30 min-h-12 rounded-lg",
          )}
        >
          <ScrollArea
            fade="x"
            fadeSize="2.25rem"
            hideScrollbar
            className="w-full"
            viewportRef={scrollRef}
          >
            <div
              className={cn(
                "flex w-max min-w-full items-center gap-2.5 [&>*]:shrink-0",
                isPlain ? "px-0.5 py-1" : "px-3 py-2",
              )}
            >
              {children}
            </div>
          </ScrollArea>
          {canScrollLeft && (
            <button
              type="button"
              className="border-border absolute top-1/2 left-1 z-10 flex size-7 shrink-0 -translate-y-1/2 items-center justify-center rounded-full border bg-white text-neutral-800 shadow-md transition-all hover:bg-neutral-100 hover:text-neutral-900 active:scale-95 dark:border-neutral-700 dark:bg-neutral-800 dark:text-neutral-100 dark:hover:bg-neutral-700"
              onClick={() => scrollByAmount(-200)}
              aria-label="Desplazar filtros a la izquierda"
            >
              <Icon icon={ChevronLeftIcon} size={16} className="size-4" />
            </button>
          )}
          {canScrollRight && (
            <button
              type="button"
              className="border-border absolute top-1/2 right-1 z-10 flex size-7 shrink-0 -translate-y-1/2 items-center justify-center rounded-full border bg-white text-neutral-800 shadow-md transition-all hover:bg-neutral-100 hover:text-neutral-900 active:scale-95 dark:border-neutral-700 dark:bg-neutral-800 dark:text-neutral-100 dark:hover:bg-neutral-700"
              onClick={() => scrollByAmount(200)}
              aria-label="Desplazar filtros a la derecha"
            >
              <Icon icon={ChevronRightIcon} size={16} className="size-4" />
            </button>
          )}
        </div>
        {actions && <div className="flex shrink-0 items-center">{actions}</div>}
      </div>

      {/* Mobile: collapsible */}
      <div className="md:hidden">
        <div
          className={cn(
            "flex items-center justify-between gap-2",
            isPlain ? "px-0.5 py-1.5" : "bg-muted/30 rounded-lg px-3 py-2",
          )}
        >
          <div className="text-muted-foreground flex shrink-0 items-center gap-2">
            <Icon icon={SlidersHorizontalIcon} size={16} className="size-4" />
            <span className="text-sm font-medium">Filtros</span>
          </div>
          <div className="flex items-center gap-1.5">
            {actions}
            <Button
              type="button"
              variant="ghost"
              size="icon-sm"
              aria-label={isExpanded ? "Ocultar filtros" : "Mostrar filtros"}
              onClick={() => onExpandedChange(!isExpanded)}
            >
              <MorphIcon icon={isExpanded ? Cancel01Icon : ChevronDownIcon} size={16} />
            </Button>
          </div>
        </div>

        {isExpanded && (
          <div className="pt-2">
            <div className={cn("space-y-2.5", isPlain ? "px-0.5" : "bg-muted/30 rounded-lg p-3")}>
              {children}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
