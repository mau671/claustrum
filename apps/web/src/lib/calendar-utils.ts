import { startOfWeek, addDays } from "date-fns";

import type { ScheduleSession, CalendarEvent, ScheduleGroup } from "./types";

const DAY_MAP: Record<string, number> = {
  lunes: 1,
  martes: 2,
  miércoles: 3,
  miercoles: 3,
  jueves: 4,
  viernes: 5,
  sábado: 6,
  sabado: 6,
  domingo: 0,
  "0": 0,
  "1": 1,
  "2": 2,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
};

function normalizeDayName(day: string): string {
  return day.toLowerCase().trim();
}

export function parseTimeToDate(time: string, dayOfWeek: number, weekStart: Date): Date {
  const [hours, minutes] = time.split(":").map(Number);
  const dayOffset = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
  const date = addDays(weekStart, dayOffset);
  date.setHours(hours, minutes, 0, 0);
  return date;
}

export function sessionToEvent({
  session,
  courseId,
  courseCode,
  courseName,
  groupCode,
  groupId,
  groupType,
  professors,
  classroom,
  campusName,
  color,
  weekStart,
  credits,
}: {
  session: ScheduleSession;
  courseId: string;
  courseCode: string;
  courseName: string;
  groupCode: string;
  groupId: string;
  groupType: string | null;
  professors: Array<{ id: number; name: string }> | null;
  classroom: string | null;
  campusName: string | null;
  color: string;
  weekStart: Date;
  credits: number;
}): CalendarEvent {
  const normalizedDay = normalizeDayName(String(session.weekday));
  const dayOfWeek = DAY_MAP[normalizedDay];
  if (dayOfWeek === undefined) {
    throw new Error(`Invalid day: ${session.weekday}`);
  }

  const start = parseTimeToDate(session.starts_at, dayOfWeek, weekStart);
  const end = parseTimeToDate(session.ends_at, dayOfWeek, weekStart);

  const groupNumber = parseInt(groupCode, 10);

  return {
    id: `${groupId}-${session.weekday}-${session.starts_at}-${weekStart.getTime()}`,
    title: courseName,
    courseName,
    courseCode,
    groupCode,
    groupId,
    groupType,
    professors,
    classroom,
    campusName,
    color,
    start,
    end,
    courseId,
    group: groupNumber,
    credits,
  };
}

interface Group {
  group_code: string;
  meetings: ScheduleSession[] | null;
}

export function groupsHaveConflict(group1: Group, group2: Group): boolean {
  const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

  const sessions1 = group1.meetings || [];
  const sessions2 = group2.meetings || [];

  for (const session1 of sessions1) {
    for (const session2 of sessions2) {
      const day1 = String(session1.weekday);
      const day2 = String(session2.weekday);
      if (day1 !== day2) continue;

      const dayOfWeek = DAY_MAP[day1];
      if (dayOfWeek === undefined) continue;

      const start1 = parseTimeToDate(session1.starts_at, dayOfWeek, weekStart);
      const end1 = parseTimeToDate(session1.ends_at, dayOfWeek, weekStart);
      const start2 = parseTimeToDate(session2.starts_at, dayOfWeek, weekStart);
      const end2 = parseTimeToDate(session2.ends_at, dayOfWeek, weekStart);

      if (start1 < end2 && end1 > start2) {
        return true;
      }
    }
  }

  return false;
}

export interface ConflictInfo {
  hasConflict: boolean;
  conflictingGroupIds: string[];
  conflictMessages: Map<string, string>;
}

export function getConflictInfo(
  courseCode: string,
  groupCode: string,
  group: ScheduleGroup,
  selectedGroups: Set<string>,
  allGroups: Array<{
    course: { course_code: string; offering_id?: number | null };
    group: ScheduleGroup;
  }>,
): ConflictInfo {
  const result: ConflictInfo = {
    hasConflict: false,
    conflictingGroupIds: [],
    conflictMessages: new Map(),
  };

  const groupId = getGroupId(courseCode, groupCode);
  if (!selectedGroups.has(groupId)) {
    return result;
  }

  const selectedSessions = group.meetings || [];

  for (const other of allGroups) {
    const otherGroupId = getGroupId(other.course.course_code, other.group.group_code);
    if (otherGroupId === groupId) continue;
    if (!selectedGroups.has(otherGroupId)) continue;

    const otherSessions = other.group.meetings || [];

    for (const selSession of selectedSessions) {
      for (const otherSession of otherSessions) {
        if (selSession.weekday !== otherSession.weekday) continue;

        const dayOfWeek = selSession.weekday;
        const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });
        const start1 = parseTimeToDate(selSession.starts_at, dayOfWeek, weekStart);
        const end1 = parseTimeToDate(selSession.ends_at, dayOfWeek, weekStart);
        const start2 = parseTimeToDate(otherSession.starts_at, dayOfWeek, weekStart);
        const end2 = parseTimeToDate(otherSession.ends_at, dayOfWeek, weekStart);

        if (start1 < end2 && end1 > start2) {
          const dayNames = [
            "Domingo",
            "Lunes",
            "Martes",
            "Miércoles",
            "Jueves",
            "Viernes",
            "Sábado",
          ];
          const dayName = dayNames[dayOfWeek] || "";
          const timeInfo = `${dayName} ${formatTime(selSession.starts_at)}-${formatTime(selSession.ends_at)}`;

          result.hasConflict = true;
          if (!result.conflictingGroupIds.includes(otherGroupId)) {
            result.conflictingGroupIds.push(otherGroupId);
          }

          const existingMsg = result.conflictMessages.get(otherGroupId) || "";
          if (!existingMsg.includes(timeInfo)) {
            result.conflictMessages.set(
              otherGroupId,
              existingMsg ? `${existingMsg}, ${timeInfo}` : `Choque: ${timeInfo}`,
            );
          }
        }
      }
    }
  }

  return result;
}

function formatTime(time: string): string {
  const [hours, minutes] = time.split(":");
  return `${hours.padStart(2, "0")}:${minutes}`;
}

export function getGroupId(courseCode: string, groupCode: string): string {
  return `${courseCode}-${groupCode}`;
}
