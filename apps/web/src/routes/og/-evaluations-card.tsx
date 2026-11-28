import {
  ChevronDownIcon,
  ChevronRightIcon,
  File01Icon,
  File02Icon,
} from "@hugeicons/core-free-icons";

import type { EvaluationRow } from "@/lib/evaluations/types";

import { Icon } from "@/components/ui/icon";
import { formatEvaluationLevelLabel, formatEvaluationTypeLabel } from "@/lib/evaluations/types";
import { cn } from "@/lib/utils";
import { Logo } from "@/routes/home/-icons";

type LevelGroup = {
  key: string;
  extraordinary: boolean;
  variant: number | null;
  label: string;
  rows: EvaluationRow[];
};

type ExamGroup = {
  key: string;
  label: string;
  levels: LevelGroup[];
  showLevels: boolean;
};

const course = {
  id: 605,
  code: "MA1102",
  name: "CÁLCULO DIFERENCIAL E INTEGRAL",
};

function demoEvaluation(
  row: Pick<EvaluationRow, "id" | "course_id" | "course_code" | "course_name" | "type" | "number"> &
    Partial<EvaluationRow>,
): EvaluationRow {
  return {
    term_id: 1,
    professor_id: null,
    name: null,
    coordinated: true,
    answers_included: false,
    answers_separate: false,
    file_key: "",
    file_size: 0,
    answer_file_key: null,
    status: "approved",
    created_at: "2026-01-01T00:00:00.000Z",
    term_display_name: "2025 - SEMESTRE 2",
    professor_name: null,
    extraordinary: false,
    variant: null,
    ...row,
  };
}

const demoRows: EvaluationRow[] = [
  demoEvaluation({
    id: 722,
    course_id: course.id,
    course_code: course.code,
    course_name: course.name,
    type: "parcial",
    number: 1,
    file_size: 239206,
    answers_separate: true,
    answer_file_key: "demo-answers.pdf",
  }),
  demoEvaluation({
    id: 723,
    course_id: course.id,
    course_code: course.code,
    course_name: course.name,
    type: "parcial",
    number: 1,
    extraordinary: true,
    file_size: 136192,
  }),
  demoEvaluation({
    id: 728,
    course_id: course.id,
    course_code: course.code,
    course_name: course.name,
    type: "parcial",
    number: 2,
    file_size: 128614,
    answers_separate: true,
    answer_file_key: "demo-answers.pdf",
  }),
  demoEvaluation({
    id: 735,
    course_id: course.id,
    course_code: course.code,
    course_name: course.name,
    type: "parcial",
    number: 3,
    file_size: 191078,
  }),
];

const otherCourses = [
  { id: 1029, code: "IC2001", name: "ESTRUCTURAS DE DATOS" },
  { id: 1017, code: "FI1102", name: "FÍSICA GENERAL II" },
  { id: 1022, code: "EL4701", name: "MODELOS DE SISTEMAS" },
  { id: 1020, code: "IC5821", name: "REQUERIMIENTOS DE SOFTWARE" },
  { id: 539, code: "MA0101", name: "MATEMÁTICA GENERAL" },
  { id: 554, code: "IC1802", name: "INTRODUCCIÓN A LA PROGRAMACIÓN" },
];

function groupEvaluations(rows: EvaluationRow[]): ExamGroup[] {
  const exams = new Map<string, ExamGroup>();

  for (const row of rows) {
    const examKey = `${row.type}:${row.number ?? 0}:${row.name ?? ""}`;
    let exam = exams.get(examKey);
    if (!exam) {
      exam = {
        key: examKey,
        label: formatEvaluationTypeLabel(row.type, row.number, row.name),
        levels: [],
        showLevels: false,
      };
      exams.set(examKey, exam);
    }

    const levelKey = `${row.extraordinary}:${row.variant ?? ""}`;
    let level = exam.levels.find((item) => item.key === levelKey);
    if (!level) {
      level = {
        key: levelKey,
        extraordinary: row.extraordinary,
        variant: row.variant,
        label: formatEvaluationLevelLabel(row.extraordinary, row.variant),
        rows: [],
      };
      exam.levels.push(level);
    }
    level.rows.push(row);
  }

  return [...exams.values()].map((exam) => {
    const levels = [...exam.levels].sort((a, b) => {
      if (a.extraordinary !== b.extraordinary) return a.extraordinary ? 1 : -1;
      return (a.variant ?? 0) - (b.variant ?? 0);
    });
    return {
      ...exam,
      levels,
      showLevels:
        levels.length > 1 || levels.some((level) => level.extraordinary || level.variant !== null),
    };
  });
}

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

function GroupRow({
  label,
  expanded,
  className,
  meta,
}: {
  label: string;
  expanded: boolean;
  className?: string;
  meta?: string;
}) {
  return (
    <div
      className={cn("flex w-full items-center gap-2 rounded-md px-2 py-1.5 text-left", className)}
    >
      <Icon
        icon={expanded ? ChevronDownIcon : ChevronRightIcon}
        size={20}
        className="text-muted-foreground size-5 shrink-0"
      />
      <span className="text-foreground min-w-0 truncate">{label}</span>
      {meta && (
        <span className="text-muted-foreground/80 ml-auto min-w-0 shrink-0 truncate text-base font-normal">
          {meta}
        </span>
      )}
    </div>
  );
}

function DocumentRow({ kind, size }: { kind: "enunciado" | "solucion"; size: number | null }) {
  const isSolution = kind === "solucion";
  return (
    <div className="text-muted-foreground -mx-1 flex items-center gap-2 rounded-md px-1 py-1 text-lg">
      <Icon
        icon={isSolution ? File02Icon : File01Icon}
        size={20}
        className="text-muted-foreground/70 size-5 shrink-0"
      />
      <span className="flex min-w-0 flex-1 flex-col">
        <span className="flex items-baseline justify-between gap-2">
          <span>{isSolution ? "Solución" : "Enunciado"}</span>
          {size !== null && (
            <span className="text-muted-foreground/70 font-mono text-base tabular-nums">
              {formatFileSize(size)}
            </span>
          )}
        </span>
      </span>
    </div>
  );
}

function DocumentList({ rows }: { rows: EvaluationRow[] }) {
  return (
    <>
      {rows.map((row) => (
        <div key={row.id} className="flex flex-col gap-0.5">
          <DocumentRow kind="enunciado" size={row.file_size} />
          {row.answers_separate && <DocumentRow kind="solucion" size={null} />}
        </div>
      ))}
    </>
  );
}

function LevelRow({ level }: { level: LevelGroup }) {
  const professorName = level.rows.find((row) => row.professor_name)?.professor_name ?? null;

  return (
    <div className="py-0.5">
      <div className="flex items-baseline justify-between gap-2 px-2">
        <span className="text-muted-foreground text-lg font-medium">{level.label}</span>
        {professorName && (
          <span className="text-muted-foreground/80 min-w-0 truncate text-lg">{professorName}</span>
        )}
      </div>
      <div className="mt-0.5 ml-4 flex flex-col gap-0.5 sm:ml-5">
        <DocumentList rows={level.rows} />
      </div>
    </div>
  );
}

function ExamRow({ exam }: { exam: ExamGroup }) {
  const professorName =
    exam.levels.flatMap((level) => level.rows).find((row) => row.professor_name)?.professor_name ??
    null;

  return (
    <div className="py-1">
      <GroupRow
        label={exam.label}
        expanded
        className="text-foreground text-xl font-medium"
        meta={exam.showLevels ? undefined : (professorName ?? undefined)}
      />
      <div className="border-border/60 mt-0.5 ml-4 space-y-1 border-l pl-3 sm:ml-5">
        {exam.showLevels ? (
          exam.levels.map((level) => <LevelRow key={level.key} level={level} />)
        ) : (
          <div className="flex flex-col gap-0.5 py-0.5">
            <DocumentList rows={exam.levels[0]?.rows ?? []} />
          </div>
        )}
      </div>
    </div>
  );
}

export function OgEvaluationsCard() {
  const exams = groupEvaluations(demoRows);

  return (
    <div
      className="bg-background flex h-[630px] w-[1200px] flex-col px-12 pt-12 pb-0"
      style={{
        backgroundImage:
          "radial-gradient(circle at 100% 100%, color-mix(in oklch, var(--primary) 10%, transparent), transparent 50%), radial-gradient(circle at 0% 0%, color-mix(in oklch, var(--primary) 5%, transparent), transparent 50%)",
      }}
    >
      <div className="mb-8 flex items-center justify-between px-4">
        <div className="flex flex-col gap-2">
          <div className="flex items-center gap-3">
            <Logo main="currentColor" accent="currentColor" className="text-primary size-10" />
            <h1 className="text-4xl font-bold tracking-tight">Claustrum</h1>
          </div>
          <h2 className="text-muted-foreground text-2xl">Explorador de exámenes y evaluaciones</h2>
        </div>
      </div>

      <div className="border-border bg-card flex-1 overflow-hidden rounded-t-2xl border border-b-0 shadow-xs">
        <div className="flex flex-col gap-3 px-8 pt-6">
          <div className="divide-border/60 divide-y">
            <div className="py-2">
              <div className="flex items-center gap-2">
                <GroupRow
                  label={`${course.code}: ${course.name}`}
                  expanded
                  className="min-w-0 flex-1 py-2 text-2xl"
                />
              </div>

              <div className="border-border/60 mt-1 ml-4 space-y-2 border-l pl-3 sm:ml-5">
                <div>
                  <div className="text-muted-foreground px-2 font-mono text-lg tracking-wide">
                    2025
                  </div>
                  <div className="border-border/60 mt-1 ml-4 space-y-0.5 border-l pl-3 sm:ml-5">
                    <div className="py-0.5">
                      <GroupRow
                        label="SEMESTRE 2"
                        expanded
                        className="text-muted-foreground text-lg tracking-wide uppercase"
                      />
                      <div className="border-border/60 mt-1 ml-4 space-y-1 border-l pl-3 sm:ml-5">
                        {exams.map((exam) => (
                          <ExamRow key={exam.key} exam={exam} />
                        ))}
                      </div>
                    </div>
                    <div className="py-0.5">
                      <GroupRow
                        label="SEMESTRE 1"
                        expanded={false}
                        className="text-muted-foreground text-lg tracking-wide uppercase"
                      />
                    </div>
                  </div>
                </div>
                <div>
                  <div className="text-muted-foreground px-2 font-mono text-lg tracking-wide">
                    2024
                  </div>
                  <div className="border-border/60 mt-1 ml-4 space-y-0.5 border-l pl-3 sm:ml-5">
                    <div className="py-0.5">
                      <GroupRow
                        label="SEMESTRE 2"
                        expanded={false}
                        className="text-muted-foreground text-lg tracking-wide uppercase"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {otherCourses.map((item) => (
              <div key={item.id} className="flex items-center gap-2 py-2">
                <GroupRow
                  label={`${item.code}: ${item.name}`}
                  expanded={false}
                  className="min-w-0 flex-1 py-2 text-2xl"
                />
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
