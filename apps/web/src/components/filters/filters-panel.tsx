import { SlidersHorizontal, ChevronDown, X, ChevronLeft, ChevronRight } from "lucide-react";
import { useState, useRef, useEffect, type ReactNode } from "react";

import { Button } from "@/components/ui/button";
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
          <div className="from-background pointer-events-none absolute inset-y-0 left-0 z-10 flex w-12 items-center justify-start bg-gradient-to-r to-transparent pl-1">
            <Button
              type="button"
              variant="outline"
              size="icon"
              className="border-border/80 bg-background text-foreground hover:bg-muted pointer-events-auto size-7 shrink-0 rounded-full border opacity-90 shadow-md transition-all hover:opacity-100 focus-visible:opacity-100"
              onClick={() => scrollByAmount(-200)}
              aria-label="Desplazar filtros a la izquierda"
            >
              <ChevronLeft className="size-3.5" />
            </Button>
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
          <div className="from-background pointer-events-none absolute inset-y-0 right-0 z-10 flex w-12 items-center justify-end bg-gradient-to-l to-transparent pr-1">
            <Button
              type="button"
              variant="outline"
              size="icon"
              className="border-border/80 bg-background text-foreground hover:bg-muted pointer-events-auto size-7 shrink-0 rounded-full border opacity-90 shadow-md transition-all hover:opacity-100 focus-visible:opacity-100"
              onClick={() => scrollByAmount(200)}
              aria-label="Desplazar filtros a la derecha"
            >
              <ChevronRight className="size-3.5" />
            </Button>
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
            <SlidersHorizontal className="size-4" />
            <span className="text-sm font-medium">Filtros</span>
          </div>
          <Button
            type="button"
            variant="ghost"
            size="icon-sm"
            aria-label={isExpanded ? "Ocultar filtros" : "Mostrar filtros"}
            onClick={() => onExpandedChange(!isExpanded)}
          >
            {isExpanded ? <X className="size-4" /> : <ChevronDown className="size-4" />}
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
