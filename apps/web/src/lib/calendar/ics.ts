import { format, parseISO, addDays, startOfDay, endOfDay, isValid } from "date-fns";

import type { CalendarEvent, AcademicTerm } from "@/lib/types";

const WEEKDAY_BYDAY = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"] as const;

function escapeIcsText(value: string): string {
  return value
    .replace(/\\/g, "\\\\")
    .replace(/;/g, "\\;")
    .replace(/,/g, "\\,")
    .replace(/\r?\n/g, "\\n");
}

function formatIcsDate(date: Date): string {
  return format(date, "yyyyMMdd'T'HHmmss");
}

function buildFirstOccurrenceDate(eventStart: Date, termStart: Date): Date {
  const startDay = startOfDay(termStart);
  const targetDow = eventStart.getDay();
  const startDow = startDay.getDay();
  const delta = (targetDow - startDow + 7) % 7;
  const candidate = addDays(startDay, delta);
  const result = new Date(candidate);
  result.setHours(eventStart.getHours(), eventStart.getMinutes(), eventStart.getSeconds(), 0);
  return result;
}

function buildRecurrenceRule(eventStart: Date, termEnd: Date): string {
  const byDay = WEEKDAY_BYDAY[eventStart.getDay()];
  const until = formatIcsDate(endOfDay(termEnd));
  return `RRULE:FREQ=WEEKLY;BYDAY=${byDay};UNTIL=${until}`;
}

function buildDescription(event: CalendarEvent): string {
  const parts = [`${event.courseName} (${event.courseCode})`, `Grupo ${event.groupCode}`];

  if (event.groupType) {
    parts.push(`Modalidad: ${event.groupType}`);
  }

  if (event.professors?.length) {
    parts.push(`Profesores: ${event.professors.map((p) => p.name).join(", ")}`);
  }

  if (event.classroom) {
    parts.push(`Aula: ${event.classroom}`);
  }

  if (event.campusName) {
    parts.push(`Sede: ${event.campusName}`);
  }

  return escapeIcsText(parts.join("\n"));
}

function buildLocation(event: CalendarEvent): string {
  const locationParts = [event.classroom, event.campusName].filter(Boolean);
  return escapeIcsText(locationParts.join(" - "));
}

export function buildScheduleIcs(params: {
  events: CalendarEvent[];
  term?: AcademicTerm | null;
}): string {
  const { events, term } = params;
  const nowStamp = formatIcsDate(new Date());
  const lines: string[] = [
    "BEGIN:VCALENDAR",
    "VERSION:2.0",
    "PRODID:-//Claustrum//Horario//ES",
    "CALSCALE:GREGORIAN",
    "METHOD:PUBLISH",
  ];

  const termStart = term?.starts_on ? parseISO(term.starts_on) : null;
  const termEnd = term?.ends_on ? parseISO(term.ends_on) : null;
  const hasTermRange = termStart && termEnd && isValid(termStart) && isValid(termEnd);

  events.forEach((event, index) => {
    const durationMs = event.end.getTime() - event.start.getTime();
    const dtStart = hasTermRange ? buildFirstOccurrenceDate(event.start, termStart) : event.start;
    const dtEnd = new Date(dtStart.getTime() + durationMs);
    const uid = `${event.groupId}-${formatIcsDate(event.start)}-${index}@claustrum`;

    lines.push("BEGIN:VEVENT");
    lines.push(`UID:${uid}`);
    lines.push(`DTSTAMP:${nowStamp}`);
    lines.push(`SUMMARY:${escapeIcsText(event.title)}`);
    lines.push(`DTSTART:${formatIcsDate(dtStart)}`);
    lines.push(`DTEND:${formatIcsDate(dtEnd)}`);
    lines.push(`DESCRIPTION:${buildDescription(event)}`);

    const location = buildLocation(event);
    if (location) {
      lines.push(`LOCATION:${location}`);
    }

    if (hasTermRange) {
      lines.push(buildRecurrenceRule(dtStart, termEnd));
    }

    lines.push("END:VEVENT");
  });

  lines.push("END:VCALENDAR");
  return lines.join("\r\n");
}
