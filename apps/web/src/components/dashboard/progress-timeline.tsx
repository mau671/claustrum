/* oxlint-disable prefer-tag-over-role -- role="progressbar" on a div is intentional: a native <progress> element cannot be themed per semester status */
"use client";

import { useMemo } from "react";

import type { SemesterProgress } from "@/lib/types";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Stepper, type StepperStep } from "@/components/ui/stepper";
import { cn } from "@/lib/utils";

interface ProgressTimelineProps {
  semesters: SemesterProgress[];
}

export function ProgressTimeline({ semesters }: ProgressTimelineProps) {
  const steps: StepperStep[] = useMemo(
    () =>
      semesters.map((semester) => {
        // The API returns null for aggregates over empty sets (semester without courses).
        const completedCourses =
          typeof semester.completedCourses === "number" ? semester.completedCourses : 0;
        const completedCredits =
          typeof semester.completedCredits === "number" ? semester.completedCredits : 0;
        const percentage =
          semester.totalCourses > 0 ? (completedCourses / semester.totalCourses) * 100 : 0;

        return {
          id: String(semester.levelNumber),
          label: semester.levelLabel,
          details: (
            <div className="flex flex-col gap-1.5">
              <div
                className="bg-muted h-1.5 overflow-hidden rounded-full"
                role="progressbar"
                aria-label={`${semester.levelLabel}: ${completedCourses} de ${semester.totalCourses} cursos`}
                aria-valuemin={0}
                aria-valuemax={semester.totalCourses}
                aria-valuenow={completedCourses}
              >
                <div
                  className={cn(
                    "h-full rounded-full",
                    semester.status === "completed" && "bg-status-success",
                    semester.status === "in_progress" && "bg-status-info",
                    semester.status === "pending" && "bg-status-neutral/40",
                  )}
                  style={{ width: `${percentage}%` }}
                />
              </div>
              <div className="flex items-center justify-between gap-2 text-xs">
                <span className="font-medium tabular-nums">
                  {completedCourses}/{semester.totalCourses} cursos
                </span>
                <span className="text-muted-foreground tabular-nums">
                  {completedCredits}/{semester.credits} créditos
                </span>
              </div>
            </div>
          ),
        };
      }),
    [semesters],
  );

  const activeIndex = useMemo(() => {
    const firstPending = semesters.findIndex((semester) => semester.status !== "completed");
    return firstPending === -1 ? semesters.length : firstPending;
  }, [semesters]);

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-base font-semibold">Progreso por semestre</CardTitle>
      </CardHeader>
      <CardContent>
        {semesters.length === 0 ? (
          <p className="text-muted-foreground py-4 text-center text-sm">
            No hay semestres para mostrar.
          </p>
        ) : (
          <Stepper
            steps={steps}
            current={activeIndex}
            orientation="vertical"
            label="Progreso por semestre"
          />
        )}
      </CardContent>
    </Card>
  );
}
