import { useNavigate } from "@tanstack/react-router";
import { Eye } from "lucide-react";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { formatEvaluationTypeLabel } from "@/lib/evaluations/types";
import { useCourseEvaluations } from "@/lib/hooks/use-evaluations";

interface EvaluationListProps {
  courseId: number;
}

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

export function EvaluationList({ courseId }: EvaluationListProps) {
  const { data: evaluations, isLoading } = useCourseEvaluations(courseId);
  const navigate = useNavigate();

  if (isLoading) {
    return (
      <div className="rounded-md border">
        <div className="text-muted-foreground p-4 text-sm">Cargando evaluaciones…</div>
      </div>
    );
  }

  if (!evaluations || evaluations.length === 0) {
    return (
      <div className="rounded-md border">
        <div className="text-muted-foreground p-4 text-sm">
          Aún no hay evaluaciones publicadas para este curso.
        </div>
      </div>
    );
  }

  return (
    <div className="overflow-x-auto rounded-md border">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tipo</TableHead>
            <TableHead>Período</TableHead>
            <TableHead>Profesor</TableHead>
            <TableHead>Cátedra</TableHead>
            <TableHead>Respuestas</TableHead>
            <TableHead>Tamaño</TableHead>
            <TableHead className="w-24" />
          </TableRow>
        </TableHeader>
        <TableBody>
          {evaluations.map((evaluation) => (
            <TableRow key={evaluation.id}>
              <TableCell>
                <Badge variant="secondary" className="text-xs">
                  {formatEvaluationTypeLabel(
                    evaluation.evaluation_type,
                    evaluation.evaluation_number,
                    evaluation.custom_name,
                  )}
                </Badge>
              </TableCell>
              <TableCell className="text-sm">
                {evaluation.term_display_name
                  ? evaluation.term_display_name.replace(" - ", ": ")
                  : "—"}
              </TableCell>
              <TableCell className="text-sm">{evaluation.professor_name ?? "—"}</TableCell>
              <TableCell className="text-sm">{evaluation.is_catedra ? "Sí" : "No"}</TableCell>
              <TableCell className="text-sm">
                {evaluation.has_separate_answers
                  ? "Archivo aparte"
                  : evaluation.includes_answers
                    ? "Incluidas"
                    : "No"}
              </TableCell>
              <TableCell className="font-mono text-sm">
                {formatFileSize(evaluation.file_size)}
              </TableCell>
              <TableCell>
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={() =>
                    void navigate({
                      to: "/evaluations/view/$evaluationSlug",
                      params: { evaluationSlug: `${evaluation.id}.pdf` },
                    })
                  }
                  aria-label="Vista previa"
                >
                  <Eye className="size-4" />
                </Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
