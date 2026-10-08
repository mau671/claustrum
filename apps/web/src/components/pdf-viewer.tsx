import { ArrowLeft, Download, Loader2, Minus, Plus } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { Document, Page, pdfjs } from "react-pdf";

import { Button } from "@/components/ui/button";

import "react-pdf/dist/Page/AnnotationLayer.css";
import "react-pdf/dist/Page/TextLayer.css";

if (typeof window !== "undefined") {
  pdfjs.GlobalWorkerOptions.workerSrc = `//unpkg.com/pdfjs-dist@${pdfjs.version}/build/pdf.worker.min.mjs`;
}

const MIN_ZOOM = 0.6;
const MAX_ZOOM = 2;
const ZOOM_STEP = 0.2;

interface PdfViewerProps {
  blobUrl: string;
  fileName: string;
  onClose?: () => void;
  className?: string;
}

export function PdfViewer({ blobUrl, fileName, onClose, className = "" }: PdfViewerProps) {
  const [error, setError] = useState<string | null>(null);
  const [numPages, setNumPages] = useState(0);
  const [zoom, setZoom] = useState(1);
  const [containerWidth, setContainerWidth] = useState(0);
  const [documentLoaded, setDocumentLoaded] = useState(false);
  const [firstPageRendered, setFirstPageRendered] = useState(false);
  const scrollContainerRef = useRef<HTMLDivElement | null>(null);
  const pendingCenterRatioRef = useRef<number | null>(null);
  const shouldCenterOnLoadRef = useRef(true);

  useEffect(() => {
    setDocumentLoaded(false);
    setFirstPageRendered(false);
    setNumPages(0);
    setZoom(1);
    setError(null);
  }, [blobUrl]);

  function onDocumentLoadSuccess({ numPages }: { numPages: number }) {
    setNumPages(numPages);
    setDocumentLoaded(true);
    pendingCenterRatioRef.current = 0.5;
    shouldCenterOnLoadRef.current = true;
    setZoom(1);
  }

  function onDocumentLoadError(err: Error) {
    setError(err.message);
  }

  function onFirstPageRenderSuccess() {
    setFirstPageRendered((current) => current || true);
  }

  function handleZoomChange(delta: number) {
    const nextZoom = Math.max(MIN_ZOOM, Math.min(MAX_ZOOM, Number((zoom + delta).toFixed(1))));
    if (nextZoom === zoom) return;

    const container = scrollContainerRef.current;
    if (container) {
      const viewportCenter = container.scrollLeft + container.clientWidth / 2;
      pendingCenterRatioRef.current =
        container.scrollWidth > 0 ? viewportCenter / container.scrollWidth : 0.5;
    }

    setZoom(nextZoom);
  }

  useEffect(() => {
    const container = scrollContainerRef.current;
    if (!container) return;

    const updateWidth = () => setContainerWidth(container.clientWidth);
    updateWidth();

    const resizeObserver = new ResizeObserver(updateWidth);
    resizeObserver.observe(container);
    return () => resizeObserver.disconnect();
  }, [blobUrl]); // re-bind observer on new blobUrl just in case

  const isReady = documentLoaded && containerWidth > 0 && numPages > 0;
  const isViewerReady = isReady && firstPageRendered;

  const pageWidth =
    containerWidth > 0 ? Math.max(220, Math.floor((containerWidth - 32) * zoom)) : undefined;

  useEffect(() => {
    const container = scrollContainerRef.current;
    if (!container || numPages === 0) return;

    const ratio = pendingCenterRatioRef.current;
    const shouldCenter = ratio !== null || shouldCenterOnLoadRef.current;
    if (!shouldCenter) return;

    const centerRatio = ratio ?? 0.5;

    const raf = requestAnimationFrame(() => {
      const maxScrollLeft = Math.max(0, container.scrollWidth - container.clientWidth);
      const target = centerRatio * container.scrollWidth - container.clientWidth / 2;
      container.scrollLeft = Math.min(maxScrollLeft, Math.max(0, target));
      pendingCenterRatioRef.current = null;
      shouldCenterOnLoadRef.current = false;
    });

    return () => cancelAnimationFrame(raf);
  }, [numPages, pageWidth]);

  if (error) {
    return (
      <div className={`flex flex-1 flex-col items-center justify-center gap-4 px-4 ${className}`}>
        <p className="text-destructive text-sm">{error}</p>
        {onClose && (
          <Button variant="outline" onClick={onClose}>
            <ArrowLeft className="mr-2 size-4" />
            Volver
          </Button>
        )}
      </div>
    );
  }

  return (
    <div
      className={`bg-background relative flex min-h-0 min-w-0 flex-1 flex-col overflow-hidden ${className}`}
    >
      {!isViewerReady && (
        <div className="bg-background absolute inset-0 z-50 flex flex-col items-center justify-center gap-4">
          <Loader2 className="text-muted-foreground size-8 animate-spin" />
          <p className="text-muted-foreground text-sm">Cargando documento…</p>
        </div>
      )}

      <div
        ref={scrollContainerRef}
        className={`min-h-0 w-full flex-1 overflow-auto overscroll-contain ${isViewerReady ? "opacity-100 transition-opacity duration-300" : "opacity-0"}`}
      >
        <div className="py-4">
          <Document
            file={blobUrl}
            onLoadSuccess={onDocumentLoadSuccess}
            onLoadError={onDocumentLoadError}
            loading={null}
          >
            {isReady ? (
              <div className="mx-auto flex w-max flex-col items-center gap-4 px-4 [&_.react-pdf__Page__canvas]:!h-auto [&_.react-pdf__Page__canvas]:max-w-none [&_.react-pdf__Page__canvas]:rounded-md [&_.react-pdf__Page__canvas]:shadow-lg">
                {Array.from({ length: numPages }, (_, index) => (
                  <Page
                    key={`page_${index + 1}`}
                    pageNumber={index + 1}
                    width={pageWidth}
                    onRenderSuccess={index === 0 ? onFirstPageRenderSuccess : undefined}
                    renderTextLayer={false}
                    renderAnnotationLayer={false}
                    loading={null}
                  />
                ))}
              </div>
            ) : null}
          </Document>
        </div>
      </div>

      {numPages > 0 && (
        <div className="absolute inset-x-0 bottom-6 z-50 flex justify-center px-2">
          <div className="bg-background/90 flex max-w-full flex-nowrap items-center gap-1 overflow-x-auto rounded-full border px-2 py-1 shadow-lg backdrop-blur-sm">
            {onClose && (
              <>
                <Button
                  variant="ghost"
                  size="icon"
                  className="size-8 cursor-pointer"
                  onClick={onClose}
                  aria-label="Volver"
                  title="Volver"
                >
                  <ArrowLeft className="size-4" />
                </Button>
                <div className="bg-border mx-1 h-4 w-px" />
              </>
            )}
            <div className="hidden items-center min-[430px]:flex">
              <span className="text-muted-foreground shrink-0 px-2 text-sm whitespace-nowrap tabular-nums">
                {numPages} páginas
              </span>
              <div className="bg-border mx-1 h-4 w-px" />
            </div>
            <Button
              variant="ghost"
              size="icon"
              className="size-8 cursor-pointer"
              onClick={() => handleZoomChange(-ZOOM_STEP)}
              disabled={zoom <= MIN_ZOOM}
              aria-label="Reducir zoom"
            >
              <Minus className="size-4" />
            </Button>
            <span className="text-muted-foreground w-12 text-center text-sm tabular-nums">
              {Math.round(zoom * 100)}%
            </span>
            <Button
              variant="ghost"
              size="icon"
              className="size-8 cursor-pointer"
              onClick={() => handleZoomChange(ZOOM_STEP)}
              disabled={zoom >= MAX_ZOOM}
              aria-label="Aumentar zoom"
            >
              <Plus className="size-4" />
            </Button>
            <div className="bg-border mx-1 h-4 w-px" />
            <Button asChild variant="ghost" size="icon" className="size-8 cursor-pointer">
              <a
                href={blobUrl}
                download={fileName}
                aria-label="Descargar PDF"
                title="Descargar PDF"
              >
                <Download className="size-4" />
              </a>
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}
