import { isSameDay } from "date-fns";
import { useMemo } from "react";

import type { CalendarEvent as CalendarEventType } from "@/lib/types";

import { useCalendarContext } from "../../calendar-context";
import CalendarBodyHeader from "../calendar-body-header";
import CalendarEvent from "../calendar-event";
import { hours, START_HOUR, END_HOUR } from "./calendar-body-day-margin";

interface EventPosition {
  left: string;
  width: string;
  top: string;
  height: string;
}

interface EventLayoutsMap {
  [eventId: string]: EventPosition;
}

function calculateEventPosition(
  event: CalendarEventType,
  allEvents: CalendarEventType[],
  hourHeight: number,
): EventPosition {
  const overlappingEvents = allEvents.filter((otherEvent) => {
    if (otherEvent.id === event.id) return false;
    return event.start < otherEvent.end && event.end > otherEvent.start;
  });

  const group = [event, ...overlappingEvents].sort((a, b) => a.start.getTime() - b.start.getTime());
  const position = group.indexOf(event);
  const width = `${100 / (overlappingEvents.length + 1)}%`;
  const left = `${(position * 100) / (overlappingEvents.length + 1)}%`;

  const startHour = event.start.getHours();
  const startMinutes = event.start.getMinutes();

  let endHour = event.end.getHours();
  let endMinutes = event.end.getMinutes();

  if (!isSameDay(event.start, event.end)) {
    endHour = END_HOUR;
    endMinutes = 0;
  }

  const adjustedStartHour = Math.max(startHour - START_HOUR, 0);
  const adjustedEndHour = Math.min(endHour, END_HOUR) - START_HOUR;

  const topPosition = adjustedStartHour * hourHeight + (startMinutes / 60) * hourHeight;
  const adjustedStartMinutes = startHour < START_HOUR ? 0 : startMinutes;
  const duration =
    adjustedEndHour * 60 + endMinutes - (adjustedStartHour * 60 + adjustedStartMinutes);
  const height = Math.max((duration / 60) * hourHeight, 24);

  return {
    left,
    width,
    top: `${topPosition}px`,
    height: `${height}px`,
  };
}

function calculateEventLayouts(events: CalendarEventType[], hourHeight: number): EventLayoutsMap {
  const layouts: EventLayoutsMap = {};

  events.forEach((event) => {
    layouts[event.id] = calculateEventPosition(event, events, hourHeight);
  });

  return layouts;
}

export default function CalendarBodyDayContent({
  date,
  headerClassName,
}: {
  date: Date;
  headerClassName?: string;
}) {
  const { events, hourHeight } = useCalendarContext();

  const dayEvents = useMemo(
    () => events.filter((event) => isSameDay(event.start, date)),
    [events, date],
  );

  const eventLayouts = useMemo(
    () => calculateEventLayouts(dayEvents, hourHeight),
    [dayEvents, hourHeight],
  );

  return (
    <div className="flex flex-grow flex-col">
      <CalendarBodyHeader date={date} onlyDay className={headerClassName} />

      <div className="relative flex-1">
        {hours.map((hour) => (
          <div
            key={hour}
            className="border-border/50 group border-b transition-[height] duration-200"
            style={{ height: `${hourHeight}px` }}
          />
        ))}

        {dayEvents.map((event) => (
          <CalendarEvent key={event.id} event={event} position={eventLayouts[event.id]} />
        ))}
      </div>
    </div>
  );
}
