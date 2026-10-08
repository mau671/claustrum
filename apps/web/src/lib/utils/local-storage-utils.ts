import type { CourseStatus } from "@/lib/types";

const LOCAL_STORAGE_KEY = "course_status_local_changes";

export interface LocalCourseStatusChange {
  courseId: number;
  studyPlanId: number | null;
  status: CourseStatus;
  timestamp: number;
}

export function saveLocalCourseStatus(
  courseId: number,
  studyPlanId: number | null,
  status: CourseStatus,
): void {
  const changes = getLocalCourseStatusChanges();
  const index = changes.findIndex((c) => c.courseId === courseId && c.studyPlanId === studyPlanId);

  const newChange: LocalCourseStatusChange = {
    courseId,
    studyPlanId,
    status,
    timestamp: Date.now(),
  };

  if (index >= 0) {
    changes[index] = newChange;
  } else {
    changes.push(newChange);
  }

  localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(changes));
}

export function getLocalCourseStatusChanges(): LocalCourseStatusChange[] {
  try {
    const stored = localStorage.getItem(LOCAL_STORAGE_KEY);
    if (!stored) return [];
    return JSON.parse(stored) as LocalCourseStatusChange[];
  } catch {
    return [];
  }
}

export function clearLocalCourseStatusChanges(): void {
  localStorage.removeItem(LOCAL_STORAGE_KEY);
}
