"use client";

import type { ReactNode } from "react";

import { PDFViewer, type Layout, type ViewerConfig } from "@embedpdf/viewer-react";
import { useEffect, useRef } from "react";

import { cn } from "@/lib/utils";

export interface PdfDocumentViewerProps {
  /** Object URL of the PDF to display. */
  blobUrl: string | Blob | null;
  /** Kept for API compatibility with existing call sites. */
  fileName?: string;
  /** Kept for API compatibility with existing call sites. */
  defaultZoom?: number | "fit-page" | "fit-width" | "automatic";
  /** Kept for API compatibility with existing call sites. */
  showDownload?: boolean;
  /** Renders a back button at the start of the toolbar. */
  onBack?: () => void;
  backLabel?: string;
  /** Kept for API compatibility with existing call sites. */
  toolbarActions?: ReactNode;
  /** Kept for API compatibility with existing call sites. */
  loadingLabel?: string;
  className?: string;
}

const BACK_ICON = ["M19 12H5", "M12 19l-7-7 7-7"];

const INTERNAL_ROOT = "[data-embedpdf-root]";

/**
 * EmbedPDF's internal root only fills the host when its content has intrinsic
 * height. At compact widths the page area starts collapsed, so the viewer shows
 * its toolbar but no pages. Mirror the host height explicitly until the viewer
 * provides a public sizing hook.
 */
function useFillShadowRoot(containerRef: React.RefObject<HTMLDivElement | null>) {
  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;

    let frame = 0;
    let observer: ResizeObserver | null = null;
    let host: HTMLElement | null = null;
    let root: HTMLElement | null = null;

    const fill = () => {
      host ??= container.querySelector<HTMLElement>("embedpdf-viewer");
      if (!root || !root.isConnected) {
        root = host?.shadowRoot?.querySelector<HTMLElement>(INTERNAL_ROOT) ?? null;
      }
      if (!host || !root) return false;

      const height = host.clientHeight;
      if (height > 0) {
        root.style.height = `${height}px`;
      }
      return true;
    };

    const start = () => {
      if (!fill()) {
        frame = requestAnimationFrame(start);
        return;
      }
      if (host) {
        observer = new ResizeObserver(() => {
          fill();
        });
        observer.observe(host);
      }
    };

    start();

    return () => {
      cancelAnimationFrame(frame);
      observer?.disconnect();
    };
  }, [containerRef]);
}

export function PdfDocumentViewer({
  blobUrl,
  onBack,
  backLabel = "Volver",
  className,
}: PdfDocumentViewerProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  useFillShadowRoot(containerRef);

  const config = {
    locale: "es",
    theme: "system",
    warnBeforeLeaving: false,
    icons: { "claustrum-back": BACK_ICON },
    commands: onBack
      ? [
          {
            id: "claustrum:back",
            label: backLabel,
            icon: "claustrum-back",
            run: () => onBack(),
          },
        ]
      : [],
    layout: (layout: Layout) =>
      onBack ? layout.add("claustrum:back", { to: "main", section: "start" }) : layout,
  } satisfies ViewerConfig;

  return (
    <div ref={containerRef} className="contents">
      <PDFViewer
        {...config}
        src={blobUrl ?? undefined}
        className={cn("h-full min-h-0 w-full", className)}
        style={{ width: "100%", height: "100%" }}
      />
    </div>
  );
}
