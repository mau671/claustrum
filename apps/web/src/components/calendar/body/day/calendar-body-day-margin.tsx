import { format } from "date-fns";
import { es } from "date-fns/locale";

import { cn } from "@/lib/utils";

import { useCalendarContext } from "../../calendar-context";

// Rango de horas: 7 AM a 10 PM (22:00)
export const START_HOUR = 7;
export const END_HOUR = 22;
export const hours = Array.from({ length: END_HOUR - START_HOUR + 1 }, (_, i) => i + START_HOUR);

export default function CalendarBodyDayMargin({ className }: { className?: string }) {
  const { hourHeight } = useCalendarContext();

  return (
    <div className={cn("bg-background sticky left-0 z-10 flex w-12 flex-col", className)}>
      <div className="bg-background sticky top-0 left-0 z-20 h-[33px] border-b" />
      <div className="bg-background sticky left-0 z-10 flex w-12 flex-col">
        {hours.map((hour, index) => (
          <div
            key={hour}
            className="relative transition-[height] duration-200 first:mt-0"
            style={{ height: `${hourHeight}px` }}
          >
            <span
              className={cn(
                "text-muted-foreground absolute left-2 text-xs",
                index === 0 ? "top-1" : "-top-2.5",
              )}
            >
              {format(new Date(2000, 0, 1, hour, 0, 0, 0), "h a", { locale: es })}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}
