import { createFileRoute } from "@tanstack/react-router";

import type { CourseEffectiveStatus } from "@/lib/types";

import { MemoizedCurriculumBoard } from "@/components/curriculum/curriculum-board";
import { AppAuthProvider } from "@/lib/auth/app-auth-context";
import { demoStudyPlanDetail } from "@/routes/home/-data";
import { Logo } from "@/routes/home/-icons";

export const Route = createFileRoute("/og/curriculum")({
  component: OgCurriculumRoute,
});

function OgCurriculumRoute() {
  const mockStatusMap = new Map<number, CourseEffectiveStatus>([
    // Semester 0 (All Approved)
    [537, { status: "approved" } as CourseEffectiveStatus],
    [539, { status: "approved" } as CourseEffectiveStatus],
    [563, { status: "approved" } as CourseEffectiveStatus],

    // Semester 1 (All Approved)
    [554, { status: "approved" } as CourseEffectiveStatus],
    [1017, { status: "approved" } as CourseEffectiveStatus],
    [1020, { status: "approved" } as CourseEffectiveStatus],
    [1022, { status: "approved" } as CourseEffectiveStatus],
    [1018, { status: "approved" } as CourseEffectiveStatus],

    // Semester 2 (Mixed: Approved, Failed, In Progress, None)
    [600, { status: "approved" } as CourseEffectiveStatus], // CI1107
    [545, { status: "failed" } as CourseEffectiveStatus], // CI1230
    [648, { status: "approved" } as CourseEffectiveStatus], // FH1000
    [1029, { status: "in_progress" } as CourseEffectiveStatus], // IC2001
    [1030, { status: "failed" } as CourseEffectiveStatus], // IC2101
    [605, { status: "in_progress" } as CourseEffectiveStatus], // MA1102

    // Semester 3 (A few in progress, rest have no state)
    [625, { status: "in_progress" } as CourseEffectiveStatus],
  ]);

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
          <h2 className="text-muted-foreground text-2xl">Explorador de planes de estudio</h2>
        </div>
      </div>

      <div className="border-border bg-card flex-1 overflow-hidden rounded-t-2xl border border-b-0 shadow-xs">
        <div className="pointer-events-none h-full w-full">
          <AppAuthProvider>
            <MemoizedCurriculumBoard
              planDetail={{
                ...demoStudyPlanDetail,
                periods: demoStudyPlanDetail.periods.filter((p: any) => p.levelNumber < 6),
              }}
              readOnly={true}
              zoom={1.05}
              mockStatusMap={mockStatusMap}
            />
          </AppAuthProvider>
        </div>
      </div>
    </div>
  );
}
