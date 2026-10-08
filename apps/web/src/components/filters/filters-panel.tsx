import { SlidersHorizontal, ChevronDown, X, ChevronLeft, ChevronRight } from "lucide-react";
import { useState, useRef, useEffect, type ReactNode } from "react";

import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

interface FiltersPanelProps {
  isExpanded: boolean;
  onExpandedChange: (open: boolean) => void;
  children: ReactNode;
  className?: string;
}

export function FiltersPanel({
  isExpanded,
  onExpandedChange,
  children,
  className,
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

  return (
    <div className={cn("relative", className)}>
      {/* Desktop: horizontal scrollable bar with gradients */}
      <div className="bg-muted/30 group relative hidden min-h-12 items-center overflow-hidden rounded-lg md:flex">
        {canScrollLeft && (
          <div className="from-background absolute inset-y-0 left-0 z-10 flex w-12 items-center justify-start bg-gradient-to-r to-transparent pl-1">
            <Button
              type="button"
              variant="secondary"
              size="icon"
              className="size-6 rounded-full opacity-0 shadow-sm transition-opacity group-hover:opacity-100 focus-visible:opacity-100"
              onClick={() => scrollByAmount(-200)}
            >
              <ChevronLeft className="size-3" />
            </Button>
          </div>
        )}
        <div
          ref={scrollRef}
          onScroll={checkScroll}
          className="flex w-full scrollbar-none items-center gap-2.5 overflow-x-auto px-3 py-2 [&>*]:shrink-0"
        >
          {children}
        </div>
        {canScrollRight && (
          <div className="from-background absolute inset-y-0 right-0 z-10 flex w-12 items-center justify-end bg-gradient-to-l to-transparent pr-1">
            <Button
              type="button"
              variant="secondary"
              size="icon"
              className="size-6 rounded-full opacity-0 shadow-sm transition-opacity group-hover:opacity-100 focus-visible:opacity-100"
              onClick={() => scrollByAmount(200)}
            >
              <ChevronRight className="size-3" />
            </Button>
          </div>
        )}
      </div>

      {/* Mobile: collapsible */}
      <div className="md:hidden">
        <div className="bg-muted/30 flex items-center justify-between gap-2 rounded-lg px-3 py-2">
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
            <div className="bg-muted/30 space-y-2.5 rounded-lg p-3">{children}</div>
          </div>
        )}
      </div>
    </div>
  );
}
