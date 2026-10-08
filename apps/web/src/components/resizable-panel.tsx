import {
  useState,
  useCallback,
  useRef,
  useEffect,
  type ReactNode,
  type CSSProperties,
} from "react";

import { cn } from "@/lib/utils";

interface ResizablePanelProps {
  leftContent: ReactNode;
  rightContent: ReactNode;
  initialLeftWidth?: number;
  minLeftWidth?: number;
  maxLeftWidth?: number;
  className?: string;
}

export function ResizablePanel({
  leftContent,
  rightContent,
  initialLeftWidth = 384,
  minLeftWidth = 300,
  maxLeftWidth = 600,
  className,
}: ResizablePanelProps) {
  const [leftWidth, setLeftWidth] = useState(initialLeftWidth);
  const [isResizing, setIsResizing] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);
  const startXRef = useRef<number>(0);
  const startWidthRef = useRef<number>(0);

  const handleMouseDown = useCallback(
    (e: React.MouseEvent) => {
      e.preventDefault();
      setIsResizing(true);
      startXRef.current = e.clientX;
      startWidthRef.current = leftWidth;
      document.body.style.cursor = "col-resize";
      document.body.style.userSelect = "none";
    },
    [leftWidth],
  );

  const handleMouseMove = useCallback(
    (e: MouseEvent) => {
      if (!isResizing) return;

      const deltaX = e.clientX - startXRef.current;
      const newWidth = startWidthRef.current + deltaX;
      const clampedWidth = Math.max(minLeftWidth, Math.min(maxLeftWidth, newWidth));
      setLeftWidth(clampedWidth);
    },
    [isResizing, minLeftWidth, maxLeftWidth],
  );

  const handleMouseUp = useCallback(() => {
    if (isResizing) {
      setIsResizing(false);
      document.body.style.cursor = "";
      document.body.style.userSelect = "";
    }
  }, [isResizing]);

  useEffect(() => {
    if (isResizing) {
      window.addEventListener("mousemove", handleMouseMove);
      window.addEventListener("mouseup", handleMouseUp);
      return () => {
        window.removeEventListener("mousemove", handleMouseMove);
        window.removeEventListener("mouseup", handleMouseUp);
      };
    }
  }, [isResizing, handleMouseMove, handleMouseUp]);

  return (
    <div ref={containerRef} className={cn("flex h-full w-full flex-col lg:flex-row", className)}>
      <div
        style={{ "--left-panel-width": `${leftWidth}px` } as CSSProperties}
        className="w-full flex-shrink-0 overflow-hidden lg:h-full lg:w-[var(--left-panel-width)]"
      >
        {leftContent}
      </div>

      <button
        type="button"
        tabIndex={-1}
        aria-label="Redimensionar panel"
        onMouseDown={handleMouseDown}
        className={cn(
          "hidden h-full w-1 flex-shrink-0 cursor-col-resize items-center justify-center transition-colors duration-200 lg:flex",
          isResizing ? "bg-primary" : "hover:bg-primary/50 bg-border",
        )}
      >
        <div
          className={cn(
            "h-8 w-0.5 rounded-full transition-all duration-200",
            isResizing ? "bg-primary" : "bg-muted-foreground/30 group-hover:bg-muted-foreground/50",
          )}
        />
      </button>

      <div className="w-full flex-1 overflow-hidden lg:h-full">{rightContent}</div>
    </div>
  );
}
