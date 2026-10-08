import type {
  CatalogUniversity,
  CatalogCampus,
  CatalogCareerProgram,
  CatalogStudyPlan,
  StudyPlanCoursesResponse,
  CoursePrerequisitesResponse,
  UserProfileContextRow,
} from "@/lib/types";

import { getSession } from "@/lib/auth/client";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser-client";

export interface UserStudyPlanContext {
  userStudyPlanId: number;
  studyPlanId: number;
  campusId: number;
  entryYear: number;
  studyPlanName: string;
  campusName: string;
  universityId: number | null;
  departmentId: number | null;
  academicUnitId: number | null;
  termId: number | null;
}

const supabase = getSupabaseBrowserClient();

export async function getCurrentUser() {
  const { data } = await getSession();
  return data?.user ?? null;
}

export async function getUserStudyPlan(): Promise<UserStudyPlanContext | null> {
  const user = await getCurrentUser();
  if (!user) return null;

  const { data, error } = await supabase
    .rpc("get_user_profile_with_context", { p_user_id: user.id })
    .single();

  if (error) throw error;

  const profile = data as unknown as UserProfileContextRow;

  if (!profile || !profile.study_plan_id) return null;

  return {
    userStudyPlanId: profile.study_plan_id!,
    studyPlanId: profile.study_plan_id,
    campusId: profile.campus_id!,
    entryYear: profile.entry_year!,
    studyPlanName: profile.study_plan_name!,
    campusName: profile.campus_name!,
    universityId: profile.university_id,
    departmentId: profile.academic_unit_id,
    academicUnitId: profile.academic_unit_id,
    termId: profile.term_id,
  };
}

export async function getAcademicUnitsWithProfessors(): Promise<CatalogCareerProgram[]> {
  const { data, error } = await supabase.rpc("get_academic_units_with_professors");

  if (error) throw error;

  return (data ?? []).map((row: any) => ({
    id: row.id,
    code: row.code,
    name: row.name,
  }));
}

export async function getAcademicUnitsForCampus(campusId: number): Promise<CatalogCareerProgram[]> {
  const { data, error } = await supabase.rpc("get_academic_units_for_campus", {
    p_campus_id: campusId,
  });

  if (error) throw error;

  return (data ?? []).map((row: any) => ({
    id: row.id,
    code: row.code,
    name: row.name,
  }));
}

export async function getStudyPlansForAcademicUnit(
  academicUnitId: number,
): Promise<CatalogStudyPlan[]> {
  const { data, error } = await supabase.rpc("get_study_plans_for_academic_unit", {
    p_academic_unit_id: academicUnitId,
  });

  if (error) throw error;

  return (data ?? []).map((plan: any) => ({
    id: plan.id,
    academic_unit_id: plan.academic_unit_id,
    external_plan_id: plan.external_plan_id,
    name: plan.name,
    academic_degree: plan.academic_degree,
  }));
}

export async function getUniversities(): Promise<CatalogUniversity[]> {
  const { data, error } = await supabase.from("university").select("*").order("name");

  if (error) throw error;

  return data.map((univ) => ({
    id: univ.id,
    name: univ.name,
    short_name: univ.short_name,
  }));
}

export async function getCampuses(universityId?: number): Promise<CatalogCampus[]> {
  let query = supabase.from("campus").select("*").eq("is_active", true).order("name");

  if (universityId) {
    query = query.eq("university_id", universityId);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map((campus) => ({
    id: campus.id,
    university_id: campus.university_id,
    code: campus.code,
    name: campus.name,
  }));
}

export async function getStudyPlans(academicUnitId?: number): Promise<CatalogStudyPlan[]> {
  let query = supabase.from("study_plan").select("*");

  if (academicUnitId) {
    query = query.eq("academic_unit_id", academicUnitId);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map((plan) => ({
    id: plan.id,
    academic_unit_id: plan.academic_unit_id,
    external_plan_id: plan.external_plan_id,
    name: plan.name,
    academic_degree: plan.academic_degree,
  }));
}

export async function getStudyPlanCourses(planId: number): Promise<StudyPlanCoursesResponse> {
  const { data, error } = await supabase.rpc("get_study_plan_courses_details", {
    p_study_plan_id: planId,
  });

  if (error) throw error;

  const courses = (data as any[]).map((item) => ({
    courseId: item.course_id,
    levelNumber: item.level_number,
    credits: item.credits,
    weeklyHours: item.weekly_hours,
    sortOrder: item.sort_order,
    courseCode: item.course_code,
    courseName: item.course_name,
    courseDefaultCredits: item.default_credits,
    courseDefaultWeeklyHours: item.default_weekly_hours,
  }));

  return { courses };
}

export type StudyPlanCourseRelation = {
  fromCourseId: number;
  toCourseId: number;
  relationType: "PREREQUISITE" | "COREQUISITE" | "EQUIVALENT";
};

export async function getStudyPlanCourseRelations(
  planId: number,
): Promise<StudyPlanCourseRelation[]> {
  const { data, error } = await supabase
    .from("course_relation")
    .select("from_course_id, to_course_id, relation_type")
    .eq("study_plan_id", planId);

  if (error) throw error;

  return (
    data as Array<{
      from_course_id: number;
      to_course_id: number;
      relation_type: StudyPlanCourseRelation["relationType"];
    }>
  ).map((r) => ({
    fromCourseId: r.from_course_id,
    toCourseId: r.to_course_id,
    relationType: r.relation_type,
  }));
}

export async function getCoursePrerequisites(
  courseId: number,
  planId: number,
): Promise<CoursePrerequisitesResponse> {
  const { data, error } = await supabase
    .from("course_relation")
    .select("from_course_id, to_course_id, relation_type")
    .eq("study_plan_id", planId)
    .or(`from_course_id.eq.${courseId},to_course_id.eq.${courseId}`);

  if (error) throw error;

  const prerequisites: number[] = [];
  const corequisites: number[] = [];

  for (const relation of data) {
    // In `course_relation`, `from_course_id` is the dependent course and `to_course_id` is the required course.
    // So prerequisites/corequisites for `courseId` are stored where `from_course_id = courseId`.
    if (relation.from_course_id !== courseId) continue;
    if (relation.relation_type === "PREREQUISITE") {
      prerequisites.push(relation.to_course_id);
    } else if (relation.relation_type === "COREQUISITE") {
      corequisites.push(relation.to_course_id);
    }
  }

  return { prerequisites, corequisites };
}
