/* oxlint-disable prefer-tag-over-role -- role="progressbar" on a div is intentional: a native <progress> element cannot be themed per semester status */
"use client";

import { useMemo } from "react";

import type { SemesterProgress } from "@/lib/types";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Stepper, type StepperStep } from "@/components/ui/stepper";

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
        const inProgressCourses =
          typeof semester.inProgressCourses === "number" ? semester.inProgressCourses : 0;
        const completedCredits =
          typeof semester.completedCredits === "number" ? semester.completedCredits : 0;
        const totalCourses = Math.max(semester.totalCourses, 1);
        const completedPercentage = Math.min(
          100,
          Math.max(0, (completedCourses / totalCourses) * 100),
        );
        const inProgressPercentage = Math.min(
          100 - completedPercentage,
          Math.max(0, (inProgressCourses / totalCourses) * 100),
        );

        return {
          id: String(semester.levelNumber),
          label: semester.levelLabel,
          status: semester.status,
          details: (
            <div className="flex flex-col gap-1.5">
              <div
                className="bg-muted relative flex h-1.5 overflow-hidden rounded-full"
                role="progressbar"
                aria-label={`${semester.levelLabel}: ${completedCourses} aprobados${
                  inProgressCourses > 0 ? `, ${inProgressCourses} en curso` : ""
                } de ${semester.totalCourses} cursos`}
                aria-valuemin={0}
                aria-valuemax={semester.totalCourses}
                aria-valuenow={completedCourses + inProgressCourses}
              >
                {completedPercentage > 0 ? (
                  <div
                    className="bg-status-success h-full transition-all duration-300"
                    style={{ width: `${completedPercentage}%` }}
                  />
                ) : null}
                {inProgressPercentage > 0 ? (
                  <div
                    className="bg-status-info h-full transition-all duration-300"
                    style={{ width: `${inProgressPercentage}%` }}
                  />
                ) : null}
              </div>
              <div className="flex items-center justify-between gap-2 text-xs">
                <span className="font-medium tabular-nums">
                  {inProgressCourses > 0 ? (
                    <>
                      <span>
                        {completedCourses}/{semester.totalCourses} aprobados
                      </span>
                      <span className="text-status-info ml-1.5 font-normal">
                        ({inProgressCourses} en curso)
                      </span>
                    </>
                  ) : (
                    <span>
                      {completedCourses}/{semester.totalCourses} cursos
                    </span>
                  )}
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
          <Stepper steps={steps} orientation="vertical" label="Progreso por semestre" />
        )}
      </CardContent>
    </Card>
  );
}
