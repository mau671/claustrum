"use client";

import type { ReactNode } from "react";

import { PDFViewer, type Layout, type ViewerConfig } from "@embedpdf/viewer-react";

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

export function PdfDocumentViewer({
  blobUrl,
  onBack,
  backLabel = "Volver",
  className,
}: PdfDocumentViewerProps) {
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
    <PDFViewer
      {...config}
      src={blobUrl ?? undefined}
      className={cn("h-full min-h-0 w-full", className)}
      style={{ width: "100%", height: "100%" }}
    />
  );
}
