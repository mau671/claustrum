import { format } from "date-fns";
import { es } from "date-fns/locale";

import { cn } from "@/lib/utils";

import { useCalendarContext } from "../../calendar-context";

// Rango de horas: 7 AM a 10 PM (22:00)
export const START_HOUR = 7;
export const END_HOUR = 22;
export const hours = Array.from({ length: END_HOUR - START_HOUR + 1 }, (_, i) => i + START_HOUR);

export default function CalendarBodyDayMargin({ className }: { className?: string }) {
  const { hourHeight, cornerAction } = useCalendarContext();

  return (
    <div className={cn("bg-background sticky left-0 z-10 flex w-12 flex-col", className)}>
      <div className="sticky top-0 left-0 z-20 flex h-[33px] items-start justify-stretch p-0">
        <div className="bg-background flex h-6 w-full items-center justify-center">
          {cornerAction}
        </div>
      </div>
      <div className="bg-background sticky left-0 z-10 flex w-12 flex-col">
        {hours.map((hour) => (
          <div
            key={hour}
            className="relative transition-[height] duration-200 first:mt-0"
            style={{ height: `${hourHeight}px` }}
          >
            <span className="text-muted-foreground absolute -top-2.5 left-2 text-xs">
              {format(new Date(2000, 0, 1, hour, 0, 0, 0), "h a", { locale: es })}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}
