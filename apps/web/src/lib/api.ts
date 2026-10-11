import type {
  CatalogUniversity,
  CatalogCampus,
  CatalogCareerProgram,
  CatalogStudyPlan,
  StudyPlanCoursesResponse,
  CoursePrerequisitesResponse,
  UserStudyPlanContext,
} from "@/lib/types";

import { apiClient, ApiError } from "@/lib/api/client";
import { getSession } from "@/lib/auth/client";

export type { UserStudyPlanContext };

export type StudyPlanCourseRelation = {
  fromCourseId: number;
  toCourseId: number;
  relationType: "PREREQUISITE" | "COREQUISITE" | "EQUIVALENT";
};

export async function getCurrentUser() {
  const { data } = await getSession();
  return data?.user ?? null;
}

export async function getUserStudyPlan(): Promise<UserStudyPlanContext | null> {
  try {
    return await apiClient<UserStudyPlanContext>("/users/me");
  } catch (error) {
    if (error instanceof ApiError && (error.status === 401 || error.status === 404)) {
      return null;
    }
    throw error;
  }
}

export async function getAcademicUnitsWithProfessors(): Promise<CatalogCareerProgram[]> {
  return apiClient<CatalogCareerProgram[]>("/academicunits?withProfessors=true");
}

export async function getAcademicUnitsForCampus(campusId: number): Promise<CatalogCareerProgram[]> {
  return apiClient<CatalogCareerProgram[]>(`/academicunits?campusId=${campusId}`);
}

export async function getStudyPlansForAcademicUnit(
  academicUnitId: number,
): Promise<CatalogStudyPlan[]> {
  const plans = await apiClient<CatalogStudyPlan[]>(`/studyplans?academicUnitId=${academicUnitId}`);
  return (plans ?? []).sort(
    (a, b) =>
      Number(b.external_plan_id ?? b.id) - Number(a.external_plan_id ?? a.id) ||
      Number(b.id) - Number(a.id),
  );
}

export async function getUniversities(): Promise<CatalogUniversity[]> {
  return apiClient<CatalogUniversity[]>("/universities");
}

export async function getCampuses(universityId?: number): Promise<CatalogCampus[]> {
  return apiClient<CatalogCampus[]>(
    universityId ? `/campuses?universityId=${universityId}` : "/campuses",
  );
}

export async function getStudyPlans(academicUnitId?: number): Promise<CatalogStudyPlan[]> {
  const plans = await apiClient<CatalogStudyPlan[]>(
    academicUnitId ? `/studyplans?academicUnitId=${academicUnitId}` : "/studyplans",
  );
  return (plans ?? []).sort(
    (a, b) =>
      Number(b.external_plan_id ?? b.id) - Number(a.external_plan_id ?? a.id) ||
      Number(b.id) - Number(a.id),
  );
}

export async function getStudyPlanCourses(planId: number): Promise<StudyPlanCoursesResponse> {
  const data = await apiClient<any>(`/studyplans/${planId}/courses`);
  const courses = Array.isArray(data) ? data : (data?.courses ?? []);
  return { courses };
}

export async function getStudyPlanCourseRelations(
  planId: number,
): Promise<StudyPlanCourseRelation[]> {
  return apiClient<StudyPlanCourseRelation[]>(`/studyplans/${planId}/relations`);
}

export async function getCoursePrerequisites(
  courseId: number,
  planId: number,
): Promise<CoursePrerequisitesResponse> {
  return apiClient<CoursePrerequisitesResponse>(
    `/studyplans/${planId}/relations?courseId=${courseId}`,
  );
}
