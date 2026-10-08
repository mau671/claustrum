import { createContext, use } from "react";

import type { CalendarContextType } from "./calendar-types";

export const CalendarContext = createContext<CalendarContextType | undefined>(undefined);

export function useCalendarContext() {
  const context = use(CalendarContext);
  if (!context) {
    throw new Error("useCalendarContext must be used within a CalendarProvider");
  }
  return context;
}
