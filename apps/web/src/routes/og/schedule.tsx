import { createFileRoute } from "@tanstack/react-router";
import { startOfWeek } from "date-fns";
import { Suspense, lazy, useState } from "react";

import type { Mode } from "@/components/calendar/calendar-types";

import { demoCalendarEvents } from "@/routes/home/-data";
import { Logo } from "@/routes/home/-icons";

const Calendar = lazy(() => import("@/components/calendar/calendar"));

export const Route = createFileRoute("/og/schedule")({
  component: OgScheduleRoute,
});

function OgScheduleRoute() {
  const [events] = useState(demoCalendarEvents);
  const [mode] = useState<Mode>("week");
  const [date] = useState(() => startOfWeek(new Date(2026, 4, 4), { weekStartsOn: 1 }));

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
          <h2 className="text-muted-foreground text-2xl">Generador de horarios para estudiantes</h2>
        </div>
      </div>

      <div className="border-border bg-background flex-1 overflow-hidden rounded-t-2xl border border-b-0 shadow-xs">
        <Suspense fallback={<div className="bg-background flex-1" />}>
          <Calendar
            events={events}
            setEvents={() => {}}
            mode={mode}
            setMode={() => {}}
            date={date}
            setDate={() => {}}
            hourHeight={64}
            setHourHeight={() => {}}
          />
        </Suspense>
      </div>
    </div>
  );
}
