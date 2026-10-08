import { renderMermaidSVG } from "beautiful-mermaid";
import { CodeBlock, Pre } from "fumadocs-ui/components/codeblock";
import { Popover, PopoverContent, PopoverTrigger } from "fumadocs-ui/components/ui/popover";
import {
  ArrowDown,
  ArrowLeft,
  ArrowRight,
  ArrowUp,
  Check,
  Copy,
  Maximize2,
  RotateCcw,
  ZoomIn,
  ZoomOut,
} from "lucide-react";
import {
  useCallback,
  useEffect,
  useLayoutEffect,
  memo,
  useMemo,
  useRef,
  useState,
  type CSSProperties,
  type PointerEvent,
  type ReactNode,
} from "react";

import { Dialog, DialogContent, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { cn } from "@/lib/utils";

const minScale = 0.1;
const maxScale = 3;
const zoomStep = 0.12;
const panStep = 48;
const viewportTransition = "220ms cubic-bezier(0.22, 1, 0.36, 1)";

export function Mermaid({ chart }: { chart: string }) {
  const source = chart.replaceAll("\\n", "\n");

  try {
    const svg = renderMermaidSVG(source, {
      bg: "var(--color-fd-background)",
      fg: "var(--color-fd-foreground)",
      border: "var(--color-fd-border)",
      muted: "var(--color-fd-muted-foreground)",
      surface: "var(--color-fd-card)",
      interactive: true,
      transparent: true,
    });

    return <InteractiveMermaid chart={source} svg={svg} />;
  } catch {
    return (
      <CodeBlock title="Mermaid">
        <Pre>{chart}</Pre>
      </CodeBlock>
    );
  }
}

function InteractiveMermaid({ chart, svg }: { chart: string; svg: string }) {
  return (
    <MermaidFrame
      svg={svg}
      viewportClassName="h-[min(70vh,90vw)] min-h-[18rem] sm:h-[70vh] sm:min-h-[28rem]"
    >
      <div className="absolute top-3 right-3 flex items-center gap-2">
        <OpenDiagramDialogButton svg={svg} />
        <CopyDiagramButton chart={chart} />
      </div>
    </MermaidFrame>
  );
}

function MermaidFrame({
  svg,
  viewportClassName,
  frameClassName,
  children,
}: {
  svg: string;
  viewportClassName?: string;
  frameClassName?: string;
  children?: ReactNode;
}) {
  const viewportRef = useRef<HTMLButtonElement>(null);
  const contentRef = useRef<HTMLDivElement>(null);
  const dragRef = useRef<{
    pointerId: number;
    startX: number;
    startY: number;
    originX: number;
    originY: number;
  } | null>(null);
  const isPointerInsideRef = useRef(false);
  const [isDragging, setIsDragging] = useState(false);
  const [viewport, setViewport] = useState({ scale: 1, x: 0, y: 0 });
  const [baseViewport, setBaseViewport] = useState({ scale: 1, x: 0, y: 0 });
  const svgSize = useMemo(() => getSvgSize(svg), [svg]);
  const isAtBaseZoom = viewport.scale <= baseViewport.scale + 0.001;

  useLayoutEffect(() => {
    const contentElement = contentRef.current;
    if (!contentElement) return;

    contentElement.style.transform = getViewportTransform(viewport);
  }, [viewport]);

  const fitDiagram = useCallback(() => {
    const viewportElement = viewportRef.current;
    if (!viewportElement || svgSize.width === 0 || svgSize.height === 0) return;

    const padding = 48;
    const availableWidth = Math.max(viewportElement.clientWidth - padding, 1);
    const availableHeight = Math.max(viewportElement.clientHeight - padding, 1);
    const nextScale = clamp(
      Math.min(availableWidth / svgSize.width, availableHeight / svgSize.height, 1),
      minScale,
      maxScale,
    );

    const nextViewport = {
      scale: nextScale,
      x: (viewportElement.clientWidth - svgSize.width * nextScale) / 2,
      y: (viewportElement.clientHeight - svgSize.height * nextScale) / 2,
    };

    setBaseViewport(nextViewport);
    setViewport(nextViewport);
  }, [svgSize.height, svgSize.width]);

  function constrainViewport(nextViewport: typeof viewport) {
    const viewportElement = viewportRef.current;
    if (!viewportElement) return nextViewport;

    const viewportWidth = viewportElement.clientWidth;
    const viewportHeight = viewportElement.clientHeight;
    const scaledWidth = svgSize.width * nextViewport.scale;
    const scaledHeight = svgSize.height * nextViewport.scale;

    return {
      ...nextViewport,
      x: constrainAxis(nextViewport.x, viewportWidth, scaledWidth),
      y: constrainAxis(nextViewport.y, viewportHeight, scaledHeight),
    };
  }

  useEffect(() => {
    fitDiagram();

    const viewportElement = viewportRef.current;
    if (!viewportElement) return;

    const observer = new ResizeObserver(() => fitDiagram());
    observer.observe(viewportElement);

    return () => observer.disconnect();
  }, [fitDiagram]);

  function zoomBy(delta: number) {
    setViewport((current) => {
      const viewportElement = viewportRef.current;
      const nextScale = clamp(current.scale + delta, baseViewport.scale, maxScale);

      if (!viewportElement || nextScale === current.scale) return current;

      const centerX = viewportElement.clientWidth / 2;
      const centerY = viewportElement.clientHeight / 2;
      const scaleRatio = nextScale / current.scale;

      return constrainViewport({
        scale: nextScale,
        x: centerX - (centerX - current.x) * scaleRatio,
        y: centerY - (centerY - current.y) * scaleRatio,
      });
    });
  }

  function panBy(x: number, y: number) {
    setViewport((current) => constrainViewport({ ...current, x: current.x + x, y: current.y + y }));
  }

  function resetZoom() {
    setViewport(baseViewport);
  }

  useEffect(() => {
    const viewportElement = viewportRef.current;
    if (!viewportElement) return;

    function handleNativeWheel(event: globalThis.WheelEvent) {
      event.preventDefault();
      event.stopPropagation();

      if (event.ctrlKey || event.metaKey) {
        zoomBy(event.deltaY < 0 ? zoomStep : -zoomStep);
        return;
      }

      if (event.shiftKey) {
        panBy(-(event.deltaX || event.deltaY), 0);
        return;
      }

      panBy(-event.deltaX, -event.deltaY);
    }

    viewportElement.addEventListener("wheel", handleNativeWheel, { passive: false });

    return () => viewportElement.removeEventListener("wheel", handleNativeWheel);
  });

  useEffect(() => {
    function handleWindowKeyDown(event: globalThis.KeyboardEvent) {
      if (!isPointerInsideRef.current || event.defaultPrevented) return;

      handleNavigationKey(event);
    }

    window.addEventListener("keydown", handleWindowKeyDown);

    return () => window.removeEventListener("keydown", handleWindowKeyDown);
  });

  function handlePointerDown(event: PointerEvent<HTMLButtonElement>) {
    if (event.button !== 0) return;

    event.currentTarget.setPointerCapture(event.pointerId);
    dragRef.current = {
      pointerId: event.pointerId,
      startX: event.clientX,
      startY: event.clientY,
      originX: viewport.x,
      originY: viewport.y,
    };
    setIsDragging(true);
  }

  function handlePointerMove(event: PointerEvent<HTMLButtonElement>) {
    const drag = dragRef.current;
    if (!drag || drag.pointerId !== event.pointerId) return;

    setViewport((current) =>
      constrainViewport({
        ...current,
        x: drag.originX + event.clientX - drag.startX,
        y: drag.originY + event.clientY - drag.startY,
      }),
    );
  }

  function handlePointerEnd(event: PointerEvent<HTMLButtonElement>) {
    const drag = dragRef.current;
    if (!drag || drag.pointerId !== event.pointerId) return;

    dragRef.current = null;
    setIsDragging(false);
  }

  function handlePointerEnter() {
    isPointerInsideRef.current = true;
  }

  function handlePointerLeave() {
    isPointerInsideRef.current = false;
  }

  function handleNavigationKey(
    event: Pick<globalThis.KeyboardEvent, "key" | "shiftKey" | "preventDefault">,
  ) {
    const multiplier = event.shiftKey ? 2 : 1;

    if (event.key === "ArrowUp") {
      event.preventDefault();
      panBy(0, panStep * multiplier);
      return;
    }

    if (event.key === "ArrowDown") {
      event.preventDefault();
      panBy(0, -panStep * multiplier);
      return;
    }

    if (event.key === "ArrowLeft") {
      event.preventDefault();
      panBy(panStep * multiplier, 0);
      return;
    }

    if (event.key === "ArrowRight") {
      event.preventDefault();
      panBy(-panStep * multiplier, 0);
      return;
    }

    if (event.key === "+" || event.key === "=") {
      event.preventDefault();
      zoomBy(zoomStep);
      return;
    }

    if (event.key === "-" && !isAtBaseZoom) {
      event.preventDefault();
      zoomBy(-zoomStep);
      return;
    }

    if (event.key === "0") {
      event.preventDefault();
      resetZoom();
    }
  }

  return (
    <div
      className={cn(
        "not-prose bg-fd-background relative overflow-hidden rounded-xl border",
        frameClassName,
      )}
    >
      <button
        ref={viewportRef}
        type="button"
        tabIndex={0}
        aria-label="Diagrama Mermaid interactivo. Usa las flechas para desplazarte, más y menos para zoom, y cero para restablecer."
        className={cn(
          "bg-fd-background focus-visible:ring-fd-ring block w-full touch-none overflow-hidden p-0 text-left outline-none focus-visible:ring-2",
          viewportClassName,
          isDragging ? "cursor-grabbing" : "cursor-grab",
        )}
        onPointerDown={handlePointerDown}
        onPointerEnter={handlePointerEnter}
        onPointerLeave={handlePointerLeave}
        onPointerMove={handlePointerMove}
        onPointerUp={handlePointerEnd}
        onPointerCancel={handlePointerEnd}
      >
        <div
          ref={contentRef}
          className="w-max max-w-none [&_svg]:max-w-none"
          style={{
            transformOrigin: "0 0",
            transition: isDragging ? "none" : `transform ${viewportTransition}`,
          }}
        >
          <SvgMarkup svg={svg} />
        </div>
      </button>

      {children}

      <div className="absolute right-3 bottom-3 grid grid-cols-3 gap-1">
        <span />
        <IconButton label="Mover arriba" onClick={() => panBy(0, panStep)}>
          <ArrowUp className="size-4" />
        </IconButton>
        <IconButton label="Acercar" onClick={() => zoomBy(zoomStep)}>
          <ZoomIn className="size-4" />
        </IconButton>

        <IconButton label="Mover izquierda" onClick={() => panBy(panStep, 0)}>
          <ArrowLeft className="size-4" />
        </IconButton>
        <IconButton label="Restablecer zoom" onClick={resetZoom}>
          <RotateCcw className="size-4" />
        </IconButton>
        <IconButton label="Mover derecha" onClick={() => panBy(-panStep, 0)}>
          <ArrowRight className="size-4" />
        </IconButton>

        <span />
        <IconButton label="Mover abajo" onClick={() => panBy(0, -panStep)}>
          <ArrowDown className="size-4" />
        </IconButton>
        <IconButton label="Alejar" onClick={() => zoomBy(-zoomStep)} disabled={isAtBaseZoom}>
          <ZoomOut className="size-4" />
        </IconButton>
      </div>
    </div>
  );
}

function OpenDiagramDialogButton({ svg }: { svg: string }) {
  const [isOpen, setIsOpen] = useState(false);
  const dialogStyle = useMermaidDialogStyle(svg, isOpen);

  useScrollLock(isOpen);

  return (
    <Dialog modal={false} open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <button
          type="button"
          aria-label="Abrir diagrama ampliado"
          title="Abrir diagrama ampliado"
          className={iconButtonClassName}
        >
          <Maximize2 className="size-4" />
        </button>
      </DialogTrigger>
      {isOpen && <div className="fixed inset-0 z-40 bg-black/45 backdrop-blur-sm" />}
      <DialogContent
        className="bg-fd-background top-4 left-4 h-auto w-auto max-w-none translate-x-0 translate-y-0 gap-0 overflow-hidden p-0 sm:max-w-none"
        showCloseButton
        style={dialogStyle}
      >
        <DialogTitle className="sr-only">Diagrama ampliado</DialogTitle>
        <MermaidFrame
          svg={svg}
          frameClassName="h-full rounded-none border-0"
          viewportClassName="h-full min-h-0"
        />
      </DialogContent>
    </Dialog>
  );
}

function CopyDiagramButton({ chart }: { chart: string }) {
  const timeoutRef = useRef<number | null>(null);
  const [hasCopied, setHasCopied] = useState(false);

  useEffect(() => {
    return () => {
      if (timeoutRef.current !== null) {
        window.clearTimeout(timeoutRef.current);
      }
    };
  }, []);

  async function copySource() {
    await navigator.clipboard.writeText(chart);
    setHasCopied(true);

    if (timeoutRef.current !== null) {
      window.clearTimeout(timeoutRef.current);
    }

    timeoutRef.current = window.setTimeout(() => {
      setHasCopied(false);
      timeoutRef.current = null;
    }, 1400);
  }

  return (
    <Popover open={hasCopied}>
      <PopoverTrigger
        type="button"
        aria-label="Copiar Mermaid"
        title="Copiar Mermaid"
        onClick={copySource}
        className={iconButtonClassName}
      >
        {hasCopied ? <Check className="size-4 text-green-500" /> : <Copy className="size-4" />}
      </PopoverTrigger>
      <PopoverContent
        sideOffset={8}
        align="center"
        className="min-w-0 rounded-lg px-3 py-1.5 text-sm font-medium text-green-500"
      >
        ¡Copiado!
      </PopoverContent>
    </Popover>
  );
}

const SvgMarkup = memo(function SvgMarkup({ svg }: { svg: string }) {
  return <div dangerouslySetInnerHTML={{ __html: svg }} />;
});

function IconButton({
  label,
  disabled = false,
  onClick,
  children,
}: {
  label: string;
  disabled?: boolean;
  onClick: () => void;
  children: ReactNode;
}) {
  return (
    <button
      type="button"
      aria-label={label}
      title={label}
      onClick={onClick}
      disabled={disabled}
      className={iconButtonClassName}
    >
      {children}
    </button>
  );
}

const iconButtonClassName =
  "flex size-9 items-center justify-center rounded-md border bg-fd-card/95 text-fd-muted-foreground shadow-sm backdrop-blur transition-colors hover:bg-fd-accent hover:text-fd-accent-foreground disabled:cursor-not-allowed disabled:opacity-45";

function getSvgSize(svg: string) {
  const widthMatch = /<svg[^>]*\swidth="([\d.]+)"/i.exec(svg);
  const heightMatch = /<svg[^>]*\sheight="([\d.]+)"/i.exec(svg);
  const viewBoxMatch = /<svg[^>]*\sviewBox="[\d.-]+ [\d.-]+ ([\d.]+) ([\d.]+)"/i.exec(svg);

  return {
    width: Number(widthMatch?.[1] ?? viewBoxMatch?.[1] ?? 1),
    height: Number(heightMatch?.[1] ?? viewBoxMatch?.[2] ?? 1),
  };
}

function useMermaidDialogStyle(svg: string, isOpen: boolean): CSSProperties | undefined {
  const svgSize = useMemo(() => getSvgSize(svg), [svg]);
  const [style, setStyle] = useState<CSSProperties>();

  useEffect(() => {
    if (!isOpen) return;

    function updateStyle() {
      const viewportWidth = document.documentElement.clientWidth;
      const viewportHeight = window.innerHeight;
      const margin = viewportWidth < 640 ? 16 : 32;
      const framePadding = 48;
      const naturalWidth = svgSize.width + framePadding;
      const naturalHeight = svgSize.height + framePadding;
      const maxWidth = Math.max(viewportWidth - margin * 2, 1);
      const maxHeightRatio = viewportWidth < 640 ? 0.76 : 0.9;
      const maxHeight = Math.max(
        Math.min(viewportHeight - margin * 2, viewportHeight * maxHeightRatio),
        1,
      );
      const scale = Math.min(maxWidth / naturalWidth, maxHeight / naturalHeight, 1);
      const width = Math.ceil(naturalWidth * scale);
      const height = Math.ceil(naturalHeight * scale);

      setStyle({
        width,
        height,
        left: Math.max((viewportWidth - width) / 2, margin),
        top: Math.max((viewportHeight - height) / 2, margin),
      });
    }

    updateStyle();
    window.addEventListener("resize", updateStyle);

    return () => window.removeEventListener("resize", updateStyle);
  }, [isOpen, svgSize.height, svgSize.width]);

  return style;
}

function useScrollLock(isLocked: boolean) {
  useEffect(() => {
    if (!isLocked) return;

    const scrollX = window.scrollX;
    const scrollY = window.scrollY;

    function preventScroll(event: Event) {
      event.preventDefault();
    }

    function preventScrollKeys(event: globalThis.KeyboardEvent) {
      if (!scrollKeys.has(event.key)) return;

      event.preventDefault();
    }

    function restoreScrollPosition() {
      if (window.scrollX === scrollX && window.scrollY === scrollY) return;

      window.scrollTo(scrollX, scrollY);
    }

    document.addEventListener("wheel", preventScroll, { passive: false });
    document.addEventListener("touchmove", preventScroll, { passive: false });
    window.addEventListener("keydown", preventScrollKeys, { capture: true });
    window.addEventListener("scroll", restoreScrollPosition);

    return () => {
      document.removeEventListener("wheel", preventScroll);
      document.removeEventListener("touchmove", preventScroll);
      window.removeEventListener("keydown", preventScrollKeys, { capture: true });
      window.removeEventListener("scroll", restoreScrollPosition);
    };
  }, [isLocked]);
}

const scrollKeys = new Set([
  "ArrowDown",
  "ArrowLeft",
  "ArrowRight",
  "ArrowUp",
  "End",
  "Home",
  "PageDown",
  "PageUp",
  " ",
]);

function clamp(value: number, min: number, max: number) {
  return Math.min(Math.max(value, min), max);
}

function constrainAxis(offset: number, viewportSize: number, contentSize: number) {
  if (contentSize <= viewportSize) {
    return (viewportSize - contentSize) / 2;
  }

  return clamp(offset, viewportSize - contentSize, 0);
}

function getViewportTransform(viewport: { scale: number; x: number; y: number }) {
  return `translate(${Math.round(viewport.x)}px, ${Math.round(viewport.y)}px) scale(${viewport.scale})`;
}
