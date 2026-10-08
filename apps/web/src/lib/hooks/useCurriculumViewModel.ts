import { useMemo } from "react";

import type { StudyPlanDetail, StudentCourseStatusMap, Course, StudyPeriod } from "@/lib/types";

import { normalizeCourseName, getLevelLabel } from "@/lib/utils/course-utils";

interface CourseRelations {
  prerequisites: number[];
  corequisites: number[];
  equivalents?: number[];
}

export function useCurriculumViewModel(
  planDetail: StudyPlanDetail | null,
  statusMap: StudentCourseStatusMap | undefined,
) {
  const semesters = useMemo(() => {
    if (!planDetail) return [];

    const checkEligibility = (courseId: number, visited: Set<number> = new Set()): boolean => {
      if (visited.has(courseId)) return true;
      visited.add(courseId);

      const status = statusMap?.get(courseId)?.status || "not_taken";
      if (status === "approved" || status === "in_progress") {
        return true;
      }

      const relations = planDetail.courseRelations.get(courseId) as CourseRelations | undefined;
      if (!relations) return true;

      if (relations.prerequisites && relations.prerequisites.length > 0) {
        const prereqsMet = relations.prerequisites.every((prereqId) => {
          return statusMap?.get(prereqId)?.status === "approved";
        });
        if (!prereqsMet) return false;
      }

      if (relations.corequisites && relations.corequisites.length > 0) {
        const coreqsMet = relations.corequisites.every((coreqId) => {
          return checkEligibility(coreqId, visited);
        });
        if (!coreqsMet) return false;
      }

      return true;
    };

    return planDetail.periods.map((period: StudyPeriod) => {
      const courses = period.courses.map((course) => {
        const courseIdStr = String(course.courseId);
        const relations: CourseRelations = (planDetail.courseRelations.get(
          course.courseId,
        ) as CourseRelations) || { prerequisites: [], corequisites: [] };
        const effectiveStatus = statusMap?.get(course.courseId);
        const status = effectiveStatus?.status || "not_taken";

        const isAvailable =
          !!statusMap &&
          status !== "approved" &&
          status !== "in_progress" &&
          checkEligibility(course.courseId);

        return {
          id: courseIdStr,
          code: course.courseCode,
          name: normalizeCourseName(course.courseName),
          credits: course.credits,
          hours: course.weeklyHours,
          semester: course.levelNumber ?? 0,
          status,
          prerequisites: relations.prerequisites?.map(String) || [],
          corequisites: relations.corequisites?.map(String) || [],
          equivalents: relations.equivalents?.map(String) || [],
          statusOriginType: effectiveStatus?.originType ?? null,
          statusOriginCourseId: effectiveStatus?.originCourseId ?? null,
          statusOriginCourseCode: effectiveStatus?.originCourseCode ?? null,
          statusOriginCourseName: effectiveStatus?.originCourseName ?? null,
          statusOriginStudyPlanId: effectiveStatus?.originStudyPlanId ?? null,
          statusOriginAttemptId: effectiveStatus?.originAttemptId ?? null,
          statusOriginAttemptNumber: effectiveStatus?.originAttemptNumber ?? null,
          statusOriginGrade: effectiveStatus?.originGrade ?? null,
          statusOriginRecordedAt: effectiveStatus?.originRecordedAt ?? null,
          statusOriginAcademicTermId: effectiveStatus?.originAcademicTermId ?? null,
          statusOriginAcademicTermName: effectiveStatus?.originAcademicTermName ?? null,
          isAvailable,
        } satisfies Course;
      });

      return {
        levelNumber: period.levelNumber ?? 0,
        levelLabel: getLevelLabel(period.levelNumber, period.levelLabel),
        courses,
      };
    });
  }, [planDetail, statusMap]);

  const courses = useMemo(() => semesters.flatMap((s) => s.courses), [semesters]);

  const courseById = useMemo(() => new Map(courses.map((c) => [c.id, c])), [courses]);

  const levelLabelsMap = useMemo(
    () => new Map(semesters.map((s) => [s.levelNumber, s.levelLabel])),
    [semesters],
  );

  return {
    semesters,
    courses,
    courseById,
    levelLabelsMap,
  };
}
