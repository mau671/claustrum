"use client";

import { CheckCircle2, Circle, CircleDashed } from "lucide-react";

import type { SemesterProgress } from "@/lib/types";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

interface ProgressTimelineProps {
  semesters: SemesterProgress[];
}

export function ProgressTimeline({ semesters }: ProgressTimelineProps) {
  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-base">Progreso por semestre</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="relative">
          {semesters.map((semester, index) => (
            <div key={semester.levelNumber} className="flex items-start pb-6 last:pb-0">
              <div className="relative mr-4 flex flex-col items-center">
                <div
                  className={`relative z-10 flex size-8 items-center justify-center rounded-full ${
                    semester.status === "completed"
                      ? "bg-emerald-500 text-white"
                      : semester.status === "in_progress"
                        ? "bg-blue-500 text-white"
                        : "bg-muted text-muted-foreground"
                  }`}
                >
                  {semester.status === "completed" ? (
                    <CheckCircle2 className="size-5" />
                  ) : semester.status === "in_progress" ? (
                    <CircleDashed className="size-5 animate-pulse" />
                  ) : (
                    <Circle className="size-5" />
                  )}
                </div>
                {index < semesters.length - 1 && (
                  <div
                    className={`absolute top-8 bottom-0 w-0.5 -translate-y-1/2 ${
                      semester.status === "completed" ? "bg-emerald-500" : "bg-muted"
                    }`}
                    style={{ height: "calc(100% + 1.5rem)" }}
                  />
                )}
              </div>
              <div className="flex-1 pt-1">
                <div className="flex items-center justify-between">
                  <span className="font-medium">{semester.levelLabel}</span>
                  <span className="text-muted-foreground text-sm">
                    {semester.completedCourses}/{semester.totalCourses} cursos
                  </span>
                </div>
                <div className="bg-muted mt-2 h-2 overflow-hidden rounded-full">
                  <div
                    className={`h-full rounded-full transition-all ${
                      semester.status === "completed"
                        ? "bg-emerald-500"
                        : semester.status === "in_progress"
                          ? "bg-blue-500"
                          : "bg-muted-foreground/30"
                    }`}
                    style={{
                      width: `${semester.totalCourses > 0 ? (semester.completedCourses / semester.totalCourses) * 100 : 0}%`,
                    }}
                  />
                </div>
                <div className="text-muted-foreground mt-1 flex items-center gap-2 text-xs">
                  <span>
                    {semester.completedCredits}/{semester.credits} créditos
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}
