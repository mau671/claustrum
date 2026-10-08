import type { CalendarEvent as CalendarEventType } from "@/lib/types";

export type { CalendarEventType as CalendarEvent };
export const calendarModes = ["day", "week", "month"] as const;
export type Mode = (typeof calendarModes)[number];
export type CalendarExportTheme = "light" | "dark";

// Altura de hora en píxeles (por defecto 128px = h-32)
export const DEFAULT_HOUR_HEIGHT = 128;
export const MIN_HOUR_HEIGHT = 64;
export const MAX_HOUR_HEIGHT = 192;

export const DEFAULT_DAY_WIDTH = 150;
export const MIN_DAY_WIDTH = 110;
export const MAX_DAY_WIDTH = 220;

export type CalendarProps = {
  events: CalendarEventType[];
  setEvents: (events: CalendarEventType[]) => void;
  mode: Mode;
  setMode: (mode: Mode) => void;
  date: Date;
  setDate: (date: Date) => void;
  calendarIconIsToday?: boolean;
  onRemoveEvent?: (event: CalendarEventType) => void;
  hourHeight?: number;
  setHourHeight?: (height: number) => void;
  dayWidth?: number;
  setDayWidth?: (width: number) => void;
  exportTheme?: CalendarExportTheme;
};

export type CalendarContextType = CalendarProps & {
  newEventDialogOpen: boolean;
  setNewEventDialogOpen: (open: boolean) => void;
  manageEventDialogOpen: boolean;
  setManageEventDialogOpen: (open: boolean) => void;
  selectedEvent: CalendarEventType | null;
  setSelectedEvent: (event: CalendarEventType | null) => void;
  hourHeight: number;
  setHourHeight: (height: number) => void;
  dayWidth: number;
  setDayWidth: (width: number) => void;
};
