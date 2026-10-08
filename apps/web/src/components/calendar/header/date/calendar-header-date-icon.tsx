import { format } from "date-fns";
import { es } from "date-fns/locale";

import { useCalendarContext } from "../../calendar-context";

export default function CalendarHeaderDateIcon() {
  const { calendarIconIsToday, date: calendarDate } = useCalendarContext();
  const date = calendarIconIsToday ? new Date() : calendarDate;
  return (
    <div className="flex size-14 flex-col items-start overflow-hidden rounded-lg border">
      <p className="bg-primary text-background flex h-6 w-full items-center justify-center text-center text-xs font-semibold uppercase">
        {format(date, "MMM", { locale: es })}
      </p>
      <p className="flex w-full items-center justify-center text-lg font-bold">
        {format(date, "dd")}
      </p>
    </div>
  );
}
