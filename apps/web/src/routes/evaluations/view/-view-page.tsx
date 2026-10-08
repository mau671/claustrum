import { useParams } from "@tanstack/react-router";
import { ArrowLeft, Loader2 } from "lucide-react";
import { useEffect, useState } from "react";
import { lazy, Suspense } from "react";

const PdfViewer = lazy(() =>
  import("@/components/pdf-viewer").then((mod) => ({ default: mod.PdfViewer })),
);
import { Button } from "@/components/ui/button";
import { getEvaluationDocument } from "@/lib/evaluations/api";

export function EvaluationViewPage() {
  const { evaluationSlug } = useParams({ from: "/evaluations/view/$evaluationSlug" });
  const match = evaluationSlug.match(/^(\d+)\.pdf$/);
  const evaluationId = match ? parseInt(match[1], 10) : null;

  const [blobUrl, setBlobUrl] = useState<string | null>(null);
  const [fileName, setFileName] = useState<string>("evaluacion.pdf");
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!evaluationId) {
      setError("URL inválida");
      setIsLoading(false);
      return;
    }

    const id: number = evaluationId;
    let cancelled = false;
    let objectUrl: string | null = null;

    async function load() {
      try {
        const result = await getEvaluationDocument(id);
        if (cancelled) return;
        objectUrl = URL.createObjectURL(result.blob);
        setBlobUrl(objectUrl);
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
      if (objectUrl) URL.revokeObjectURL(objectUrl);
    };
  }, [evaluationId]);

  if (isLoading) {
    return (
      <div className="flex flex-1 flex-col items-center justify-center gap-4">
        <Loader2 className="text-muted-foreground size-8 animate-spin" />
        <p className="text-muted-foreground text-sm">Cargando documento…</p>
      </div>
    );
  }

  if (error || !blobUrl) {
    return (
      <div className="flex flex-1 flex-col items-center justify-center gap-4 px-4">
        <p className="text-destructive text-sm">{error ?? "No se pudo cargar el documento"}</p>
        <Button variant="outline" onClick={() => window.history.back()}>
          <ArrowLeft className="mr-2 size-4" />
          Volver
        </Button>
      </div>
    );
  }

  return (
    <Suspense
      fallback={
        <div className="flex flex-1 flex-col items-center justify-center gap-4">
          <Loader2 className="text-muted-foreground size-8 animate-spin" />
          <p className="text-muted-foreground text-sm">Cargando visor…</p>
        </div>
      }
    >
      <PdfViewer blobUrl={blobUrl} fileName={fileName} onClose={() => window.history.back()} />
    </Suspense>
  );
}
