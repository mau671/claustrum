import { useParams } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";

import { PdfDocumentViewer } from "@/components/pdf-document-viewer";
import { toast } from "@/components/ui/toast";
import { getEvaluationAnswersDocument, getEvaluationDocument } from "@/lib/evaluations/api";

export function EvaluationViewPage() {
  const { evaluationSlug } = useParams({ from: "/evaluations/view/$evaluationSlug" });
  const match = evaluationSlug.match(/^(\d+)(_answers)?\.pdf$/);
  const evaluationId = match ? parseInt(match[1], 10) : null;
  const isAnswers = Boolean(match?.[2]);

  const [blob, setBlob] = useState<Blob | null>(null);
  const [fileName, setFileName] = useState("evaluacion.pdf");

  const [requestKey, setRequestKey] = useState(`${evaluationId}:${String(isAnswers)}`);
  const currentRequestKey = `${evaluationId}:${String(isAnswers)}`;
  if (requestKey !== currentRequestKey) {
    setRequestKey(currentRequestKey);
    setBlob(null);
    setFileName("evaluacion.pdf");
  }

  useEffect(() => {
    if (!evaluationId) return;

    const id: number = evaluationId;
    let cancelled = false;

    async function load() {
      try {
        const result = isAnswers
          ? await getEvaluationAnswersDocument(id)
          : await getEvaluationDocument(id);
        if (!cancelled) {
          setBlob(result.blob);
          setFileName(result.fileName);
        }
      } catch (error) {
        if (!cancelled) {
          toast.error(error instanceof Error ? error.message : "No se pudo cargar el documento");
        }
      }
    }

    void load();

    return () => {
      cancelled = true;
    };
  }, [evaluationId, isAnswers]);

  const source = useMemo(
    () => (blob ? new File([blob], fileName, { type: "application/pdf" }) : null),
    [blob, fileName],
  );

  return (
    <div className="flex h-dvh min-h-0 flex-1 flex-col md:h-[calc(100dvh-var(--header-height))] md:flex-none">
      <PdfDocumentViewer
        blobUrl={source}
        onBack={() => window.history.back()}
        className="min-h-0 flex-1"
      />
    </div>
  );
}
