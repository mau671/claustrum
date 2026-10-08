import { useState, useCallback } from "react";

import type { CalendarEvent, CalendarExportTheme, Mode } from "./calendar-types";

import { CalendarContext } from "./calendar-context";
import {
  DEFAULT_HOUR_HEIGHT,
  MIN_HOUR_HEIGHT,
  MAX_HOUR_HEIGHT,
  DEFAULT_DAY_WIDTH,
  MIN_DAY_WIDTH,
  MAX_DAY_WIDTH,
} from "./calendar-types";

const HOUR_HEIGHT_STORAGE_KEY = "calendar-hour-height";
const DAY_WIDTH_STORAGE_KEY = "calendar-day-width";

function getStoredHourHeight(): number {
  if (typeof window === "undefined") return DEFAULT_HOUR_HEIGHT;
  const stored = localStorage.getItem(HOUR_HEIGHT_STORAGE_KEY);
  if (!stored) return DEFAULT_HOUR_HEIGHT;
  const parsed = parseInt(stored, 10);
  if (isNaN(parsed) || parsed < MIN_HOUR_HEIGHT || parsed > MAX_HOUR_HEIGHT) {
    return DEFAULT_HOUR_HEIGHT;
  }
  return parsed;
}

function getStoredDayWidth(): number {
  if (typeof window === "undefined") return DEFAULT_DAY_WIDTH;
  const stored = localStorage.getItem(DAY_WIDTH_STORAGE_KEY);
  if (!stored) return DEFAULT_DAY_WIDTH;
  const parsed = parseInt(stored, 10);
  if (isNaN(parsed) || parsed < MIN_DAY_WIDTH || parsed > MAX_DAY_WIDTH) {
    return DEFAULT_DAY_WIDTH;
  }
  return parsed;
}

export default function CalendarProvider({
  events,
  setEvents,
  mode,
  setMode,
  date,
  setDate,
  calendarIconIsToday,
  onRemoveEvent,
  hourHeight: externalHourHeight,
  setHourHeight: externalSetHourHeight,
  dayWidth: externalDayWidth,
  setDayWidth: externalSetDayWidth,
  exportTheme,
  children,
}: {
  events: CalendarEvent[];
  setEvents: (events: CalendarEvent[]) => void;
  mode: Mode;
  setMode: (mode: Mode) => void;
  date: Date;
  setDate: (date: Date) => void;
  calendarIconIsToday: boolean;
  onRemoveEvent?: (event: CalendarEvent) => void;
  hourHeight?: number;
  setHourHeight?: (height: number) => void;
  dayWidth?: number;
  setDayWidth?: (width: number) => void;
  exportTheme?: CalendarExportTheme;
  children: React.ReactNode;
}) {
  const [newEventDialogOpen, setNewEventDialogOpen] = useState(false);
  const [manageEventDialogOpen, setManageEventDialogOpen] = useState(false);
  const [selectedEvent, setSelectedEvent] = useState<CalendarEvent | null>(null);
  const [internalHourHeight, setHourHeightState] = useState(getStoredHourHeight);
  const [internalDayWidth, setDayWidthState] = useState(getStoredDayWidth);

  const hourHeight = externalHourHeight ?? internalHourHeight;
  const dayWidth = externalDayWidth ?? internalDayWidth;

  const setHourHeight = useCallback(
    (height: number) => {
      if (externalSetHourHeight) {
        externalSetHourHeight(height);
      } else {
        setHourHeightState(height);
        localStorage.setItem(HOUR_HEIGHT_STORAGE_KEY, String(height));
      }
    },
    [externalSetHourHeight],
  );

  const setDayWidth = useCallback(
    (width: number) => {
      if (externalSetDayWidth) {
        externalSetDayWidth(width);
      } else {
        setDayWidthState(width);
        localStorage.setItem(DAY_WIDTH_STORAGE_KEY, String(width));
      }
    },
    [externalSetDayWidth],
  );

  return (
    <CalendarContext.Provider
      value={{
        events,
        setEvents,
        mode,
        setMode,
        date,
        setDate,
        calendarIconIsToday,
        onRemoveEvent,
        newEventDialogOpen,
        setNewEventDialogOpen,
        manageEventDialogOpen,
        setManageEventDialogOpen,
        selectedEvent,
        setSelectedEvent,
        hourHeight,
        setHourHeight,
        dayWidth,
        setDayWidth,
        exportTheme,
      }}
    >
      {children}
    </CalendarContext.Provider>
  );
}
