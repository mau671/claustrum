import type { CalendarProps } from "./calendar-types";

import CalendarBody from "./body/calendar-body";
import CalendarProvider from "./calendar-provider";

export default function Calendar({
  events,
  setEvents,
  mode,
  setMode,
  date,
  setDate,
  calendarIconIsToday = true,
  onRemoveEvent,
  hourHeight,
  setHourHeight,
  dayWidth,
  setDayWidth,
  exportTheme,
}: CalendarProps) {
  return (
    <CalendarProvider
      events={events}
      setEvents={setEvents}
      mode={mode}
      setMode={setMode}
      date={date}
      setDate={setDate}
      calendarIconIsToday={calendarIconIsToday}
      onRemoveEvent={onRemoveEvent}
      hourHeight={hourHeight}
      setHourHeight={setHourHeight}
      dayWidth={dayWidth}
      setDayWidth={setDayWidth}
      exportTheme={exportTheme}
    >
      <CalendarBody />
    </CalendarProvider>
  );
}
