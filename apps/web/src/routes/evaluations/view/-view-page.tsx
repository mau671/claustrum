import { ArrowLeft01Icon } from "@hugeicons/core-free-icons";
import { useParams } from "@tanstack/react-router";
import { useEffect, useState } from "react";

import { PdfDocumentViewer } from "@/components/pdf-document-viewer";
import { Button } from "@/components/ui/button";
import { Icon } from "@/components/ui/icon";
import { Spinner } from "@/components/ui/spinner";
import { getEvaluationAnswersDocument, getEvaluationDocument } from "@/lib/evaluations/api";
import { useBlobUrl } from "@/lib/hooks/use-blob-url";

export function EvaluationViewPage() {
  const { evaluationSlug } = useParams({ from: "/evaluations/view/$evaluationSlug" });
  const match = evaluationSlug.match(/^(\d+)(_answers)?\.pdf$/);
  const evaluationId = match ? parseInt(match[1], 10) : null;
  const isAnswers = Boolean(match?.[2]);

  const [blob, setBlob] = useState<Blob | null>(null);
  const [fileName, setFileName] = useState<string>("evaluacion.pdf");
  const [error, setError] = useState<string | null>(null);
  const blobUrl = useBlobUrl(blob);

  const [requestKey, setRequestKey] = useState(`${evaluationId}:${String(isAnswers)}`);
  const currentRequestKey = `${evaluationId}:${String(isAnswers)}`;
  if (requestKey !== currentRequestKey) {
    setRequestKey(currentRequestKey);
    setBlob(null);
    setFileName("evaluacion.pdf");
    setError(null);
  }

  const invalidUrl = evaluationId === null;
  const errorMessage = invalidUrl ? "URL inválida" : error;
  const isLoading = !invalidUrl && !errorMessage && blob === null;

  useEffect(() => {
    if (!evaluationId) return;

    const id: number = evaluationId;
    let cancelled = false;

    async function load() {
      try {
        const result = isAnswers
          ? await getEvaluationAnswersDocument(id)
          : await getEvaluationDocument(id);
        if (cancelled) return;
        setBlob(result.blob);
        setFileName(result.fileName);
      } catch (err) {
        if (!cancelled) {
          setError(err instanceof Error ? err.message : "No se pudo cargar el PDF");
        }
      }
    }

    void load();

    return () => {
      cancelled = true;
    };
  }, [evaluationId, isAnswers]);

  if (isLoading) {
    return (
      <div className="flex flex-1 flex-col items-center justify-center gap-4">
        <Spinner className="text-muted-foreground size-8" />
        <p className="text-muted-foreground text-sm">Cargando documento…</p>
      </div>
    );
  }

  if (errorMessage || !blobUrl) {
    return (
      <div className="flex flex-1 flex-col items-center justify-center gap-4 px-4">
        <p className="text-destructive text-sm">
          {errorMessage ?? "No se pudo cargar el documento"}
        </p>
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
