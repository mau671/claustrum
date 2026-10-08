import { useCalendarContext } from "../../calendar-context";
import CalendarBodyDayContent from "./calendar-body-day-content";
import CalendarBodyDayMargin from "./calendar-body-day-margin";
import { START_HOUR, END_HOUR } from "./calendar-body-day-margin";

const HEADER_HEIGHT = 33;

export default function CalendarBodyDay() {
  const { date, hourHeight } = useCalendarContext();
  const totalHours = END_HOUR - START_HOUR + 1;
  const contentHeight = totalHours * hourHeight + HEADER_HEIGHT;

  return (
    <div className="flex min-w-0 flex-1 divide-x">
      <div className="flex min-w-0 flex-1 flex-col divide-y">
        <div className="flex min-w-0 flex-1 flex-col">
          <div className="relative flex min-w-0 flex-1" style={{ minHeight: contentHeight }}>
            <CalendarBodyDayMargin />
            <CalendarBodyDayContent date={date} headerClassName="border-l" />
          </div>
        </div>
      </div>
    </div>
  );
}
