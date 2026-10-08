import { isSameMonth } from "date-fns";

import { useCalendarContext } from "../../calendar-context";

export default function CalendarHeaderDateBadge() {
  const { events, date } = useCalendarContext();
  const monthEvents = events.filter((event) => isSameMonth(event.start, date));

  if (!monthEvents.length) return null;
  return (
    <div className="rounded-sm border px-1.5 py-0.5 text-xs whitespace-nowrap">
      {monthEvents.length} eventos
    </div>
  );
}
