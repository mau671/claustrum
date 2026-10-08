"use client";

import { Label, PolarGrid, PolarRadiusAxis, RadialBar, RadialBarChart } from "recharts";

import type { DashboardStats } from "@/lib/types";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ChartContainer, type ChartConfig } from "@/components/ui/chart";

interface DashboardStatsCardsProps {
  stats: DashboardStats;
}

function RadialProgressCard({
  title,
  value,
  total,
  percentage,
  description,
  color,
}: {
  title: string;
  value: number | string;
  total?: number | string;
  percentage: number;
  description: string;
  color: string;
}) {
  const chartData = [{ progress: percentage, fill: color }];
  const chartConfig = {
    progress: { label: title, color },
  } satisfies ChartConfig;

  return (
    <Card className="flex flex-col">
      <CardContent className="flex flex-col justify-center gap-4 p-4 md:flex-row md:items-center">
        <ChartContainer
          config={chartConfig}
          className="aspect-square size-[100px] shrink-0 self-center md:self-auto"
        >
          <RadialBarChart
            data={chartData}
            startAngle={90}
            endAngle={90 - (percentage / 100) * 360}
            innerRadius={38}
            outerRadius={50}
          >
            <PolarGrid
              gridType="circle"
              radialLines={false}
              stroke="none"
              className="first:fill-muted last:fill-background"
              polarRadius={[33, 27]}
            />
            <RadialBar dataKey="progress" background cornerRadius={10} />
            <PolarRadiusAxis tick={false} tickLine={false} axisLine={false}>
              <Label
                content={({ viewBox }) => {
                  if (viewBox && "cx" in viewBox && "cy" in viewBox) {
                    return (
                      <text
                        x={viewBox.cx}
                        y={viewBox.cy}
                        textAnchor="middle"
                        dominantBaseline="middle"
                      >
                        <tspan
                          x={viewBox.cx}
                          y={viewBox.cy}
                          className="fill-foreground text-lg font-bold"
                        >
                          {percentage}%
                        </tspan>
                      </text>
                    );
                  }
                }}
              />
            </PolarRadiusAxis>
          </RadialBarChart>
        </ChartContainer>
        <div className="mx-auto flex w-full flex-col gap-1 text-center md:mx-0 md:text-left">
          <span className="text-muted-foreground text-sm font-medium">{title}</span>
          <span className="text-2xl font-bold tracking-tight">
            {value}
            {total ? (
              <span className="text-muted-foreground text-lg font-normal">/{total}</span>
            ) : null}
          </span>
          <span className="text-muted-foreground text-xs">{description}</span>
        </div>
      </CardContent>
    </Card>
  );
}

function MiniBarCard({
  title,
  value,
  total,
  segments,
  percentageLabel = "del total",
  color,
}: {
  title: string;
  value: number;
  total: number;
  segments?: { value: number; color: string; label: string }[];
  percentageLabel?: string;
  color: string;
}) {
  const percentage = total > 0 ? Math.round((value / total) * 100) : 0;
  const displayValue = Number.isInteger(value) ? String(value) : value.toFixed(2);

  return (
    <Card className="flex flex-col">
      <CardContent className="flex flex-col gap-2 p-4">
        <span className="text-muted-foreground text-sm font-medium">{title}</span>
        <div className="flex items-baseline gap-2">
          <span className="text-2xl font-bold tracking-tight">{displayValue}</span>
          <span className="text-muted-foreground text-sm">/ {total}</span>
        </div>
        <div className="flex flex-col gap-1.5">
          <div className="bg-muted flex h-2 overflow-hidden rounded-full">
            {segments ? (
              segments.map((segment) => {
                const segmentWidth = total > 0 ? (segment.value / total) * 100 : 0;
                return (
                  <div
                    key={segment.label}
                    className="h-full transition-all first:rounded-l-full last:rounded-r-full"
                    style={{
                      width: `${segmentWidth}%`,
                      backgroundColor: segment.color,
                    }}
                  />
                );
              })
            ) : (
              <div
                className="h-full rounded-full transition-all"
                style={{
                  width: `${percentage}%`,
                  backgroundColor: color,
                }}
              />
            )}
          </div>
          <span className="text-muted-foreground text-xs">
            {percentage}% {percentageLabel}
          </span>
        </div>
      </CardContent>
    </Card>
  );
}

function SemesterCard({
  currentSemester,
  totalSemesters,
}: {
  currentSemester: number;
  totalSemesters: number;
}) {
  return (
    <Card className="flex flex-col">
      <CardContent className="flex flex-col gap-2 p-4">
        <span className="text-muted-foreground text-sm font-medium">Semestre actual</span>
        <div className="flex items-baseline gap-2">
          <span className="text-2xl font-bold tracking-tight">{currentSemester}</span>
          <span className="text-muted-foreground text-sm">de {totalSemesters}</span>
        </div>
        <div className="flex gap-1">
          {Array.from({ length: totalSemesters }, (_, i) => (
            <div
              key={`sem-${i}`}
              className="h-2 flex-1 rounded-full transition-all"
              style={{
                backgroundColor:
                  i < currentSemester
                    ? "var(--color-emerald-500)"
                    : i === currentSemester
                      ? "var(--color-blue-500)"
                      : "hsl(var(--muted))",
              }}
            />
          ))}
        </div>
        <span className="text-muted-foreground text-xs">
          {totalSemesters - currentSemester} semestres restantes
        </span>
      </CardContent>
    </Card>
  );
}

export function DashboardStatsCards({ stats }: DashboardStatsCardsProps) {
  const totalCredits = stats.totalCredits || 1;
  const creditsPercentage = Math.round((stats.completedCredits / totalCredits) * 100);
  const pendingCourses = Math.max(stats.totalCourses - stats.completedCourses, 0);

  return (
    <div className="grid grid-cols-2 gap-3 lg:grid-cols-3">
      <RadialProgressCard
        title="Progreso general"
        value={stats.completedCourses}
        total={stats.totalCourses}
        percentage={stats.progressPercentage}
        description="cursos completados"
        color="var(--color-emerald-500)"
      />
      <RadialProgressCard
        title="Créditos"
        value={stats.completedCredits}
        total={stats.totalCredits}
        percentage={creditsPercentage}
        description="créditos aprobados"
        color="var(--color-emerald-500)"
      />
      <MiniBarCard
        title="Cursos aprobados"
        value={stats.completedCourses}
        total={stats.totalCourses}
        color="var(--color-emerald-500)"
      />
      <MiniBarCard
        title="En curso"
        value={stats.inProgressCourses}
        total={pendingCourses}
        percentageLabel="de pendientes"
        color="var(--color-blue-500)"
      />
      <MiniBarCard
        title="Promedio ponderado"
        value={stats.weightedAverage}
        total={100}
        percentageLabel="sobre 100"
        color="var(--color-indigo-500)"
      />
      <SemesterCard currentSemester={stats.currentSemester} totalSemesters={10} />
    </div>
  );
}

interface CourseStatusChartProps {
  stats: DashboardStats;
}

export function CourseStatusChart({ stats }: CourseStatusChartProps) {
  const total = stats.totalCourses || 1;
  const data = [
    { name: "Aprobados", value: stats.completedCourses, color: "var(--color-emerald-500)" },
    { name: "En curso", value: stats.inProgressCourses, color: "var(--color-blue-500)" },
    { name: "No cursados", value: stats.notTakenCourses, color: "var(--color-zinc-500)" },
    { name: "Reprobados", value: stats.failedCourses, color: "var(--color-red-500)" },
    { name: "Retirados", value: stats.withdrawnCourses, color: "var(--color-amber-500)" },
  ];

  const maxValue = Math.max(...data.map((d) => d.value));

  return (
    <Card className="flex h-full w-full flex-col gap-1">
      <CardHeader className="pb-1">
        <CardTitle className="text-base">Distribución de cursos</CardTitle>
      </CardHeader>
      <CardContent className="flex-1 pt-0">
        <div className="h-full space-y-3">
          {data.map((item) => {
            const percentage = Math.round((item.value / total) * 100);
            const width = maxValue > 0 ? (item.value / maxValue) * 100 : 0;
            return (
              <div key={item.name} className="space-y-1">
                <div className="flex items-center justify-between text-sm">
                  <div className="flex items-center gap-2">
                    <div className="size-3 rounded-full" style={{ backgroundColor: item.color }} />
                    <span>{item.name}</span>
                  </div>
                  <span className="text-muted-foreground">
                    {item.value} ({percentage}%)
                  </span>
                </div>
                <div className="bg-muted h-2 overflow-hidden rounded-full">
                  <div
                    className="h-full rounded-full transition-all"
                    style={{
                      width: `${width}%`,
                      backgroundColor: item.color,
                    }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      </CardContent>
    </Card>
  );
}
