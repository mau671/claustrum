"use client";

import { ArrowLeft01Icon } from "@hugeicons/core-free-icons";
import { ClientOnly } from "@tanstack/react-router";
import { lazy, Suspense, type ReactNode } from "react";

import type { PDFViewerZoomLevel } from "@/components/extend/pdf-viewer";

import { Button } from "@/components/ui/button";
import { Icon } from "@/components/ui/icon";
import { Spinner } from "@/components/ui/spinner";
import { cn } from "@/lib/utils";

const ExtendPdfViewer = lazy(() =>
  import("@/components/extend/pdf-viewer").then((mod) => ({ default: mod.PDFViewer })),
);

export interface PdfDocumentViewerProps {
  /** Object URL of the PDF to display. The caller owns its lifecycle. */
  blobUrl: string;
  /** File name used by the download action. */
  fileName?: string;
  /** Initial zoom. Defaults to fitting the page width. */
  defaultZoom?: PDFViewerZoomLevel;
  showDownload?: boolean;
  /** Renders a back button in the toolbar when provided. */
  onBack?: () => void;
  backLabel?: string;
  /** Extra actions rendered in the toolbar. */
  toolbarActions?: ReactNode;
  /** Placeholder shown while the viewer bundle and engine load. */
  loadingLabel?: string;
  className?: string;
}

/**
 * PDF viewer that fills its container. The parent element must have a definite
 * height (a flex parent with `min-h-0`, or an explicit height), otherwise the
 * document expands past the viewport instead of scrolling internally.
 */
export function PdfDocumentViewer({
  blobUrl,
  fileName,
  defaultZoom = "fit-width",
  showDownload = true,
  onBack,
  backLabel = "Volver",
  toolbarActions,
  loadingLabel = "Cargando visor…",
  className,
}: PdfDocumentViewerProps) {
  const actions =
    onBack || toolbarActions ? (
      <>
        {toolbarActions}
        {onBack && (
          <Button
            type="button"
            variant="ghost"
            size="sm"
            className="cursor-pointer"
            onClick={onBack}
          >
            <Icon icon={ArrowLeft01Icon} className="mr-1.5 size-4" />
            {backLabel}
          </Button>
        )}
      </>
    ) : null;

  return (
    <div
      className={cn(
        "bg-card text-card-foreground flex h-full min-h-0 min-w-0 flex-1 flex-col overflow-hidden",
        className,
      )}
    >
      <ClientOnly fallback={<ViewerLoading label={loadingLabel} />}>
        <Suspense fallback={<ViewerLoading label={loadingLabel} />}>
          <ExtendPdfViewer
            key={blobUrl}
            className="h-full min-h-0 flex-1 rounded-[inherit]"
            defaultZoom={defaultZoom}
            fileName={fileName}
            showDownload={showDownload}
            showUpload={false}
            src={blobUrl}
            toolbarActions={actions}
          />
        </Suspense>
      </ClientOnly>
    </div>
  );
}

function ViewerLoading({ label }: { label: string }) {
  return (
    <div className="flex flex-1 flex-col items-center justify-center gap-4">
      <Spinner className="text-muted-foreground size-8" />
      <p className="text-muted-foreground text-sm">{label}</p>
    </div>
  );
}
