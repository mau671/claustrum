/* oxlint-disable prefer-tag-over-role -- role="progressbar" on a div is intentional: a native <progress> element cannot be themed per semester status */
"use client";

import { useMemo } from "react";

import type { SemesterProgress } from "@/lib/types";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Stepper, type StepperStatus, type StepperStep } from "@/components/ui/stepper";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";

interface ProgressTimelineProps {
  semesters: SemesterProgress[];
}

interface ProgressBarTooltipContentProps {
  title: string;
  courses: number;
  credits: number;
}

function ProgressBarTooltipContent({ title, courses, credits }: ProgressBarTooltipContentProps) {
  const courseLabel = courses === 1 ? "Curso" : "Cursos";
  const creditLabel = credits === 1 ? "Crédito" : "Créditos";

  return (
    <div className="flex flex-col gap-1 px-1 py-0.5 text-xs">
      <span className="text-foreground/90 font-semibold">{title}</span>
      <div className="grid grid-cols-[1fr_auto] gap-x-6 gap-y-0.5 tabular-nums">
        <span className="text-muted-foreground">{courseLabel}:</span>
        <span className="text-right font-medium">{courses}</span>
        <span className="text-muted-foreground">{creditLabel}:</span>
        <span className="text-right font-medium">{credits}</span>
      </div>
    </div>
  );
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
        const inProgressCredits =
          typeof semester.inProgressCredits === "number" ? semester.inProgressCredits : 0;
        const totalCourses = Math.max(semester.totalCourses, 1);

        const pendingCourses = Math.max(
          0,
          semester.totalCourses - completedCourses - inProgressCourses,
        );
        const pendingCredits = Math.max(0, semester.credits - completedCredits - inProgressCredits);

        const completedPercentage = Math.min(
          100,
          Math.max(0, (completedCourses / totalCourses) * 100),
        );
        const inProgressPercentage = Math.min(
          100 - completedPercentage,
          Math.max(0, (inProgressCourses / totalCourses) * 100),
        );
        const pendingPercentage = Math.max(0, 100 - completedPercentage - inProgressPercentage);

        // A semester is completed if all courses are completed.
        // A semester is only "in_progress" if there are courses currently being taken.
        // If it has pending courses but nothing in progress, it appears normal ("pending").
        const isCompleted = completedCourses >= semester.totalCourses && semester.totalCourses > 0;
        const isCurrentInProgress = inProgressCourses > 0;
        const status: StepperStatus = isCompleted
          ? "completed"
          : isCurrentInProgress
            ? "in_progress"
            : "pending";

        return {
          id: String(semester.levelNumber),
          label: semester.levelLabel,
          status,
          details: (
            <div className="w-full pt-1">
              <div
                className="bg-muted relative flex h-2 w-full overflow-hidden rounded-full"
                role="progressbar"
                aria-label={`${semester.levelLabel}: ${completedCourses} aprobados${
                  inProgressCourses > 0 ? `, ${inProgressCourses} en curso` : ""
                } de ${semester.totalCourses} cursos`}
                aria-valuemin={0}
                aria-valuemax={semester.totalCourses}
                aria-valuenow={completedCourses + inProgressCourses}
              >
                {completedPercentage > 0 ? (
                  <Tooltip>
                    <TooltipTrigger
                      render={
                        <button
                          type="button"
                          className="bg-status-success h-full cursor-pointer transition-all duration-200 hover:brightness-110 focus-visible:outline-none"
                          style={{ width: `${completedPercentage}%` }}
                          aria-label={`Aprobados: ${completedCourses} ${
                            completedCourses === 1 ? "curso" : "cursos"
                          }, ${completedCredits} créditos`}
                        />
                      }
                    />
                    <TooltipContent side="top" align="center" className="min-w-32 p-2">
                      <ProgressBarTooltipContent
                        title="Aprobados"
                        courses={completedCourses}
                        credits={completedCredits}
                      />
                    </TooltipContent>
                  </Tooltip>
                ) : null}

                {inProgressPercentage > 0 ? (
                  <Tooltip>
                    <TooltipTrigger
                      render={
                        <button
                          type="button"
                          className="bg-status-info h-full cursor-pointer transition-all duration-200 hover:brightness-110 focus-visible:outline-none"
                          style={{ width: `${inProgressPercentage}%` }}
                          aria-label={`En curso: ${inProgressCourses} ${
                            inProgressCourses === 1 ? "curso" : "cursos"
                          }, ${inProgressCredits} créditos`}
                        />
                      }
                    />
                    <TooltipContent side="top" align="center" className="min-w-32 p-2">
                      <ProgressBarTooltipContent
                        title="En curso"
                        courses={inProgressCourses}
                        credits={inProgressCredits}
                      />
                    </TooltipContent>
                  </Tooltip>
                ) : null}

                {pendingPercentage > 0 ? (
                  <Tooltip>
                    <TooltipTrigger
                      render={
                        <button
                          type="button"
                          className="hover:bg-muted-foreground/15 h-full flex-1 cursor-pointer bg-transparent transition-all duration-200 focus-visible:outline-none"
                          style={{ width: `${pendingPercentage}%` }}
                          aria-label={`Pendientes: ${pendingCourses} ${
                            pendingCourses === 1 ? "curso" : "cursos"
                          }, ${pendingCredits} créditos`}
                        />
                      }
                    />
                    <TooltipContent side="top" align="center" className="min-w-32 p-2">
                      <ProgressBarTooltipContent
                        title="Pendientes"
                        courses={pendingCourses}
                        credits={pendingCredits}
                      />
                    </TooltipContent>
                  </Tooltip>
                ) : null}
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
