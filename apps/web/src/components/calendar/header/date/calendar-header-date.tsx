import CalendarHeaderDateChevrons from "./calendar-header-date-chevrons";
import CalendarHeaderDateIcon from "./calendar-header-date-icon";

export default function CalendarHeaderDate() {
  return (
    <div className="flex items-center gap-3">
      <CalendarHeaderDateIcon />
      <CalendarHeaderDateChevrons />
    </div>
  );
}
