/* oxlint-disable prefer-tag-over-role -- role="progressbar" on a div is intentional: a native <progress> element cannot host the segmented dots visual */
"use client";

import * as React from "react";

import type { DashboardStats } from "@/lib/types";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { DonutChart, type DonutChartDatum } from "@/components/ui/donut-chart";
import { Gauge } from "@/components/ui/gauge";

interface DashboardStatsCardsProps {
  stats: DashboardStats;
}

export function DashboardStatsCards({ stats }: DashboardStatsCardsProps) {
  // The API returns null for aggregates over empty sets (e.g. SUM with no rows).
  const num = (v: number | null | undefined) =>
    typeof v === "number" && Number.isFinite(v) ? v : 0;
  const completedCourses = num(stats.completedCourses);
  const totalCourses = Math.max(num(stats.totalCourses), 1);
  const completedCredits = num(stats.completedCredits);
  const totalCredits = Math.max(num(stats.totalCredits), 1);
  const weightedAverage = num(stats.weightedAverage);

  return (
    <div className="grid grid-cols-1 gap-3 sm:grid-cols-3">
      <Card className="flex flex-col">
        <CardContent className="flex flex-1 items-center justify-center p-4">
          <Gauge
            label="Progreso general"
            value={completedCourses}
            min={0}
            max={totalCourses}
            detail={`${completedCourses} de ${num(stats.totalCourses)} cursos`}
            tone="success"
          />
        </CardContent>
      </Card>
      <Card className="flex flex-col">
        <CardContent className="flex flex-1 items-center justify-center p-4">
          <Gauge
            label="Créditos aprobados"
            value={completedCredits}
            min={0}
            max={totalCredits}
            detail={`${completedCredits} de ${num(stats.totalCredits)} créditos`}
            tone="success"
          />
        </CardContent>
      </Card>
      <Card className="flex flex-col">
        <CardContent className="flex flex-1 items-center justify-center p-4">
          <Gauge
            label="Promedio ponderado"
            value={weightedAverage}
            min={0}
            max={100}
            detail={`${weightedAverage.toFixed(2)} / 100`}
            tone="success"
          />
        </CardContent>
      </Card>
    </div>
  );
}

interface CourseStatusChartProps {
  stats: DashboardStats;
}

export function CourseStatusChart({ stats }: CourseStatusChartProps) {
  // The API returns null for aggregates over empty sets; the donut needs finite numbers.
  const num = (v: number | null | undefined) =>
    typeof v === "number" && Number.isFinite(v) ? v : 0;
  const completedCourses = num(stats.completedCourses);
  const inProgressCourses = num(stats.inProgressCourses);
  const notTakenCourses = num(stats.notTakenCourses);
  const failedCourses = num(stats.failedCourses);
  const withdrawnCourses = num(stats.withdrawnCourses);

  const chartData: DonutChartDatum[] = React.useMemo(
    () => [
      {
        key: "completed",
        label: "Aprobados",
        value: completedCourses,
        color: "var(--color-status-success)",
      },
      {
        key: "in_progress",
        label: "En curso",
        value: inProgressCourses,
        color: "var(--color-status-info)",
      },
      {
        key: "not_taken",
        label: "No cursados",
        value: notTakenCourses,
        color: "var(--color-status-neutral)",
      },
      {
        key: "failed",
        label: "Reprobados",
        value: failedCourses,
        color: "var(--color-status-danger)",
      },
      {
        key: "withdrawn",
        label: "Retirados",
        value: withdrawnCourses,
        color: "var(--color-status-warning)",
      },
    ],
    [completedCourses, inProgressCourses, notTakenCourses, failedCourses, withdrawnCourses],
  );

  return (
    <Card className="flex h-full w-full flex-col">
      <CardHeader className="pb-1">
        <CardTitle className="text-base font-semibold">Distribución de cursos</CardTitle>
      </CardHeader>
      <CardContent className="flex flex-1 items-center justify-center p-3 pt-1">
        <DonutChart
          data={chartData}
          label="Distribución de cursos del plan de estudios"
          unit="cursos"
          totalLabel="Total"
          emptyLabel="Sin cursos"
          size={180}
          thickness={20}
          groupBelow={0}
          legendAction="toggle"
          className="w-full"
        />
      </CardContent>
    </Card>
  );
}
