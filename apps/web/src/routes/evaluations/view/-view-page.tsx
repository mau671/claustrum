import { ArrowLeft01Icon, Loading03Icon } from "@hugeicons/core-free-icons";
import { useParams } from "@tanstack/react-router";
import { useEffect, useState } from "react";

import { PdfDocumentViewer } from "@/components/pdf-document-viewer";
import { Button } from "@/components/ui/button";
import { Icon } from "@/components/ui/icon";
import { getEvaluationDocument } from "@/lib/evaluations/api";
import { useBlobUrl } from "@/lib/hooks/use-blob-url";

export function EvaluationViewPage() {
  const { evaluationSlug } = useParams({ from: "/evaluations/view/$evaluationSlug" });
  const match = evaluationSlug.match(/^(\d+)\.pdf$/);
  const evaluationId = match ? parseInt(match[1], 10) : null;

  const [blob, setBlob] = useState<Blob | null>(null);
  const [fileName, setFileName] = useState<string>("evaluacion.pdf");
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const blobUrl = useBlobUrl(blob);

  useEffect(() => {
    if (!evaluationId) {
      setError("URL inválida");
      setIsLoading(false);
      return;
    }

    const id: number = evaluationId;
    let cancelled = false;
    setIsLoading(true);
    setError(null);

    async function load() {
      try {
        const result = await getEvaluationDocument(id);
        if (cancelled) return;
        setBlob(result.blob);
        setFileName(result.fileName);
      } catch (err) {
        if (!cancelled) {
          setError(err instanceof Error ? err.message : "No se pudo cargar el PDF");
        }
      } finally {
        if (!cancelled) setIsLoading(false);
      }
    }

    void load();

    return () => {
      cancelled = true;
    };
  }, [evaluationId]);

  if (isLoading) {
    return (
      <div className="flex flex-1 flex-col items-center justify-center gap-4">
        <Icon icon={Loading03Icon} className="text-muted-foreground size-8 animate-spin" />
        <p className="text-muted-foreground text-sm">Cargando documento…</p>
      </div>
    );
  }

  if (error || !blobUrl) {
    return (
      <div className="flex flex-1 flex-col items-center justify-center gap-4 px-4">
        <p className="text-destructive text-sm">{error ?? "No se pudo cargar el documento"}</p>
        <Button variant="outline" onClick={() => window.history.back()}>
          <Icon icon={ArrowLeft01Icon} className="mr-2 size-4" />
          Volver
        </Button>
      </div>
    );
  }

  return (
    <div className="flex h-dvh min-h-0 flex-1 flex-col p-3 md:h-[calc(100dvh-var(--header-height))] md:flex-none md:p-4">
      <PdfDocumentViewer
        blobUrl={blobUrl}
        fileName={fileName}
        onBack={() => window.history.back()}
        className="min-h-0 rounded-xl border shadow-xs"
      />
    </div>
  );
}
