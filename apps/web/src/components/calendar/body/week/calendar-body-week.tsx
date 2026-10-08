import type { CSSProperties } from "react";

import { startOfWeek, addDays } from "date-fns";

import { useCalendarContext } from "../../calendar-context";
import CalendarBodyDayContent from "../day/calendar-body-day-content";
import CalendarBodyDayMargin from "../day/calendar-body-day-margin";
import { START_HOUR, END_HOUR } from "../day/calendar-body-day-margin";

const HEADER_HEIGHT = 33;

export default function CalendarBodyWeek() {
  const { date, hourHeight, dayWidth } = useCalendarContext();

  const weekStart = startOfWeek(date, { weekStartsOn: 1 });
  const weekDays = Array.from({ length: 6 }, (_, i) => addDays(weekStart, i));
  const totalHours = END_HOUR - START_HOUR + 1;
  const contentHeight = totalHours * hourHeight + HEADER_HEIGHT;

  const weekMinWidth = dayWidth * weekDays.length + 48 + (weekDays.length - 1);

  return (
    <div className="min-w-0 flex-1 overflow-x-auto">
      <div
        className="relative flex min-w-[var(--week-min-width)] lg:min-w-0"
        style={
          {
            minHeight: contentHeight,
            "--week-min-width": `${weekMinWidth}px`,
          } as CSSProperties
        }
      >
        <CalendarBodyDayMargin />
        {weekDays.map((day, index) => (
          <div
            key={day.toISOString()}
            className={`flex min-w-[var(--day-width)] flex-1 lg:min-w-0 ${index > 0 ? "border-l" : ""}`}
            style={{ "--day-width": `${dayWidth}px` } as CSSProperties}
          >
            <CalendarBodyDayContent
              date={day}
              headerClassName={index === 0 ? "border-l" : undefined}
            />
          </div>
        ))}
      </div>
    </div>
  );
}
