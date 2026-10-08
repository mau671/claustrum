import {
  useQuery,
  useMutation,
  keepPreviousData,
  useQueryClient,
  queryOptions,
} from "@tanstack/react-query";

import type {
  AcademicTerm,
  StudyPeriod,
  CatalogStudyPlan,
  StudyPlanCourse,
  StudyPlanDetail,
  UserProfileContextRow,
  DashboardStats,
  SemesterProgress,
  NextCourse,
  CourseAttempt,
  CourseEffectiveStatus,
  CourseLatestTermGroup,
  CourseRecentProfessor,
  CourseStatus,
  CourseDetailRelatedCourse,
} from "@/lib/types";

import { authClient } from "@/lib/auth/client";
import { appStateServerFn } from "@/lib/auth/server-fn";
import {
  getUniversitiesServerFn,
  getCampusesServerFn,
  getAcademicUnitsServerFn,
  getStudyPlansServerFn,
  getAcademicTermsServerFn,
} from "@/lib/catalog-server-fns";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser-client";
import { getLocalCourseStatusChanges } from "@/lib/utils/local-storage-utils";

export function universitiesQueryOptions() {
  return queryOptions({
    queryKey: ["universities"],
    queryFn: async () => {
      const data = await getUniversitiesServerFn();
      return data ?? [];
    },
    staleTime: Infinity,
    refetchOnMount: false,
    refetchOnWindowFocus: false,
  });
}

export function useUniversities() {
  return useQuery(universitiesQueryOptions());
}

export function useAcademicUnitsWithProfessors() {
  return useQuery({
    queryKey: ["academic-units-with-professors"],
    queryFn: async () => {
      const { getAcademicUnitsWithProfessors } = await import("@/lib/api");
      return getAcademicUnitsWithProfessors();
    },
    staleTime: Infinity,
  });
}

export function campusesQueryOptions(universityId: number | null) {
  return queryOptions({
    queryKey: ["campuses", universityId],
    queryFn: async () => {
      if (!universityId) return [];
      const data = await getCampusesServerFn({ data: universityId });
      return (data ?? []) as CampusRow[];
    },
    enabled: !!universityId,
    placeholderData: keepPreviousData,
  });
}

export function useCampuses(universityId: number | null) {
  return useQuery(campusesQueryOptions(universityId));
}

export function academicUnitsQueryOptions(campusId: number | null) {
  return queryOptions({
    queryKey: ["academicUnits", campusId],
    queryFn: async () => {
      if (!campusId) return [];
      const data = await getAcademicUnitsServerFn({ data: campusId });
      return (data ?? []) as AcademicUnitRow[];
    },
    enabled: !!campusId,
    placeholderData: keepPreviousData,
  });
}

export function useAcademicUnits(campusId: number | null) {
  return useQuery(academicUnitsQueryOptions(campusId));
}

export function studyPlansQueryOptions(academicUnitId: number | null) {
  return queryOptions({
    queryKey: ["studyPlansV2", academicUnitId],
    queryFn: async () => {
      if (!academicUnitId) return [];
      const data = await getStudyPlansServerFn({ data: academicUnitId });
      return (data ?? []) as CatalogStudyPlan[];
    },
    enabled: !!academicUnitId,
    staleTime: 5 * 60 * 1000,
    placeholderData: keepPreviousData,
  });
}

export function useStudyPlans(academicUnitId: number | null) {
  return useQuery(studyPlansQueryOptions(academicUnitId));
}

export function profileContextQueryOptions(userId: string | null) {
  return queryOptions({
    ...appStateQueryOptions(),
    enabled: !!userId,
    select: (data) => data?.profileContext ?? null,
  });
}

export function useProfileContext(userId: string | null) {
  return useQuery(profileContextQueryOptions(userId));
}

export function appStateQueryOptions() {
  return queryOptions({
    queryKey: ["appState"],
    queryFn: async () => {
      let data = null;
      try {
        data = await appStateServerFn();
      } catch (error) {
        if (typeof window !== "undefined") {
          const res = await fetch("/api/auth/me");
          if (!res.ok) throw new Error("Client appState fetch failed");
          data = await res.json();
        } else {
          throw error;
        }
      }

      if (!data?.user) return null;
      const userMetadata =
        "userMetadata" in data.user && typeof data.user.userMetadata === "object"
          ? data.user.userMetadata
          : null;

      const user = {
        ...data.user,
        user_metadata: {
          ...userMetadata,
          full_name: data.user.name,
          avatar_url: data.user.image ?? undefined,
        },
      };

      return {
        user,
        session: data.session,
        profileContext: data.profileContext as UserProfileContextRow | null,
        onboardingStatus: data.onboardingStatus as {
          onboarding_dismissed_at: string | null;
          onboarding_completed_at: string | null;
        } | null,
      };
    },
    staleTime: 5 * 60 * 1000,
  });
}

export function authUserQueryOptions() {
  return queryOptions({
    ...appStateQueryOptions(),
    select: (data) => data?.user ?? null,
  });
}

export function useAuthUser({ enabled = true }: { enabled?: boolean } = {}) {
  return useQuery({
    ...authUserQueryOptions(),
    enabled,
  });
}

type AuthAccountsResult = {
  hasCredentialAccount: boolean;
  linkedProviderIds: string[];
};

export function useAuthAccounts(enabled = true) {
  const { data: authUser } = useAuthUser({ enabled });

  return useQuery({
    queryKey: ["authAccounts", authUser?.id],
    queryFn: async (): Promise<AuthAccountsResult> => {
      const client = authClient as unknown as {
        listAccounts?: () => Promise<{
          data: { providerId: string }[] | null;
          error: unknown;
        }>;
        listUserAccounts?: () => Promise<{
          data: { providerId: string }[] | null;
          error: unknown;
        }>;
      };

      const response = client.listAccounts
        ? await client.listAccounts()
        : client.listUserAccounts
          ? await client.listUserAccounts()
          : null;

      if (!response) {
        return { hasCredentialAccount: true, linkedProviderIds: [] };
      }

      if (response.error) throw response.error;

      const accounts = response.data ?? [];
      const hasCredentialAccount = accounts.some((account) =>
        ["credential", "email-password", "emailAndPassword"].includes(account.providerId),
      );
      const linkedProviderIds = accounts.map((account) => account.providerId);

      return { hasCredentialAccount, linkedProviderIds };
    },
    enabled: !!authUser?.id,
    staleTime: 30 * 60 * 1000,
    refetchOnMount: false,
  });
}

export function onboardingStatusQueryOptions(userId: string | null) {
  return queryOptions({
    ...appStateQueryOptions(),
    enabled: !!userId,
    select: (data) => data?.onboardingStatus ?? null,
  });
}

export function useOnboardingStatus(userId: string | null) {
  return useQuery(onboardingStatusQueryOptions(userId));
}

export type UniversityRow = {
  id: number;
  name: string;
  short_name: string;
};

export type CampusRow = {
  id: number;
  university_id: number;
  code: string;
  name: string;
};

export type AcademicUnitRow = {
  id: number;
  code: string;
  name: string;
};

export type CourseRelation = {
  fromCourseId: number;
  toCourseId: number;
  relationType: "PREREQUISITE" | "COREQUISITE" | "EQUIVALENT";
};

function buildStudyPlanPeriods(items: Array<Record<string, unknown>>): StudyPeriod[] {
  const periods = new Map<number | null, { levelLabel?: string; courses: StudyPlanCourse[] }>();
  for (const item of items ?? []) {
    const course: StudyPlanCourse = {
      courseId: item.course_id as number,
      levelNumber: item.level_number as number | null,
      credits: item.credits as number,
      weeklyHours: item.weekly_hours as number,
      sortOrder: item.sort_order as number,
      courseCode: item.course_code as string,
      courseName: item.course_name as string,
      courseDefaultCredits: item.default_credits as number,
      courseDefaultWeeklyHours: item.default_weekly_hours as number,
    };
    const level = (item.level_number as number | null) ?? 0;
    if (!periods.has(level)) {
      periods.set(level, { levelLabel: item.level_label as string | undefined, courses: [] });
    }
    periods.get(level)!.courses.push(course);
  }

  return Array.from(periods.entries())
    .sort(([a], [b]) => (a ?? 0) - (b ?? 0))
    .map(
      ([levelNumber, { levelLabel, courses }]): StudyPeriod => ({
        levelNumber: levelNumber ?? 0,
        levelLabel,
        courses,
      }),
    );
}

export function studyPlanCoursesDetailsQueryOptions(planId: number | null) {
  return queryOptions({
    queryKey: ["studyPlanCourses", planId],
    queryFn: async () => {
      if (!planId) return null;
      const sb = getSupabaseBrowserClient();
      const coursesResult = await sb.rpc("get_study_plan_courses_details", {
        p_study_plan_id: planId,
      });
      if (coursesResult.error) throw coursesResult.error;
      return buildStudyPlanPeriods(coursesResult.data ?? []);
    },
    staleTime: 5 * 60 * 1000,
  });
}

export function useStudyPlanCoursesDetails(planId: number | null) {
  return useQuery({
    ...studyPlanCoursesDetailsQueryOptions(planId),
    enabled: !!planId,
  });
}

export function studyPlanDetailQueryOptions(planId: number | null) {
  return queryOptions({
    queryKey: ["studyPlanDetail", planId],
    queryFn: async () => {
      if (!planId) return null;
      const sb = getSupabaseBrowserClient();

      const [coursesResult, relationsResult, planResult] = await Promise.all([
        sb.rpc("get_study_plan_courses_details", { p_study_plan_id: planId }),
        sb
          .from("course_relation")
          .select("from_course_id, to_course_id, relation_type")
          .eq("study_plan_id", planId),
        sb
          .from("study_plan")
          .select(
            "id, academic_unit_id, external_plan_id, name, academic_degree, academic_modality(name)",
          )
          .eq("id", planId)
          .single(),
      ]);

      if (coursesResult.error) throw coursesResult.error;
      if (relationsResult.error) throw relationsResult.error;
      if (planResult.error) throw planResult.error;

      const courseRelations = new Map<
        number,
        { prerequisites: number[]; corequisites: number[]; equivalents: number[] }
      >();
      for (const r of relationsResult.data ?? []) {
        const existing = courseRelations.get(r.from_course_id) ?? {
          prerequisites: [],
          corequisites: [],
          equivalents: [],
        };
        if (r.relation_type === "PREREQUISITE") {
          existing.prerequisites.push(r.to_course_id);
        } else if (r.relation_type === "COREQUISITE") {
          existing.corequisites.push(r.to_course_id);
        } else if (r.relation_type === "EQUIVALENT") {
          existing.equivalents.push(r.to_course_id);
        }
        courseRelations.set(r.from_course_id, existing);
      }

      const periodArray = buildStudyPlanPeriods(coursesResult.data ?? []);

      const rawPlan = planResult.data;
      const formattedPlan: CatalogStudyPlan = {
        id: rawPlan.id,
        academic_unit_id: rawPlan.academic_unit_id,
        external_plan_id: rawPlan.external_plan_id,
        name: `${rawPlan.external_plan_id} - ${rawPlan.name}`,
        academic_degree: rawPlan.academic_degree,
        modality_name: (rawPlan.academic_modality as any)?.name,
      };

      return {
        plan: formattedPlan,
        periods: periodArray,
        courseRelations,
      } as StudyPlanDetail;
    },
    staleTime: 5 * 60 * 1000,
  });
}

export function useStudyPlanDetail(
  planId: number | null,
  selectedPlanData: CatalogStudyPlan | undefined,
) {
  return useQuery({
    ...studyPlanDetailQueryOptions(planId),
    select: (data) => {
      if (!data) return data;
      return {
        ...data,
        plan: selectedPlanData ? ({ ...selectedPlanData } as CatalogStudyPlan) : data.plan,
      };
    },
    enabled: !!planId,
  });
}

export function useUserStudyPlan(userId: string | null) {
  const query = useProfileContext(userId);
  const profile = query.data;

  const userStudyPlan = profile?.study_plan_id
    ? {
        userId,
        universityId: Number(profile.university_id),
        campusId: Number(profile.campus_id),
        academicUnitId: Number(profile.academic_unit_id),
        studyPlanId: Number(profile.study_plan_id),
        studyPlanName: profile.study_plan_name,
        termId: profile.term_id ? Number(profile.term_id) : null,
      }
    : null;

  return {
    ...query,
    data: userStudyPlan,
  };
}

export function academicTermsQueryOptions(campusId: number | null, studyPlanId?: number | null) {
  return queryOptions({
    queryKey: ["academicTerms", campusId, studyPlanId],
    queryFn: async () => {
      if (!campusId) return [];
      const data = await getAcademicTermsServerFn({ data: { campusId, studyPlanId } });
      return (data ?? []) as AcademicTerm[];
    },
    enabled: !!campusId,
    placeholderData: keepPreviousData,
  });
}

export function useAcademicTerms(campusId: number | null, studyPlanId?: number | null) {
  return useQuery(academicTermsQueryOptions(campusId, studyPlanId));
}

export function useCourseOfferingTerms(
  courseId: number | null,
  campusId: number | null,
  academicUnitId: number | null,
  studyPlanId: number | null = null,
) {
  return useQuery({
    queryKey: ["courseOfferingTerms", courseId, campusId, academicUnitId, studyPlanId],
    queryFn: async () => {
      if (!courseId) return [];

      const sb = getSupabaseBrowserClient();
      const { data, error } = await sb
        .rpc("get_course_offering_terms", {
          p_course_id: courseId,
          p_campus_id: campusId,
          p_academic_unit_id: academicUnitId,
          p_study_plan_id: studyPlanId,
        })
        .select("*")
        .order("year", { ascending: false })
        .order("period_number", { ascending: false });

      if (error) throw error;
      return (data ?? []) as AcademicTerm[];
    },
    enabled: !!courseId,
    placeholderData: keepPreviousData,
  });
}

export function scheduleCoursesQueryOptions(params: {
  termId: number | null;
  campusId: number | null;
  careerId: number | null;
  planId: number | null;
  includeOtherCampuses: boolean;
  showAllCourses: boolean;
  userId: string | null;
}) {
  return queryOptions({
    queryKey: [
      "scheduleCourses",
      params.termId,
      params.campusId,
      params.careerId,
      params.planId,
      params.includeOtherCampuses,
      params.userId ? params.showAllCourses : true,
      params.userId,
    ],
    queryFn: async () => {
      if (!params.termId || !params.campusId) return null;
      const sb = getSupabaseBrowserClient();

      const { data, error } = await sb
        .rpc("get_schedule_courses", {
          p_user_id: params.userId,
          p_academic_term_id: params.termId,
          p_campus_id: params.campusId,
          p_study_plan_id: params.planId,
          p_academic_unit_id: params.careerId,
          p_include_other_campuses: params.includeOtherCampuses,
          p_show_all_courses: params.userId ? params.showAllCourses : true,
        })
        .select("*");

      if (error) throw error;
      return (data ?? []) as import("@/lib/types").ScheduleCourse[];
    },
    staleTime: 2 * 60 * 1000,
  });
}

export function useScheduleCourses(params: {
  termId: number | null;
  campusId: number | null;
  careerId: number | null;
  planId: number | null;
  includeOtherCampuses: boolean;
  showAllCourses: boolean;
  userId: string | null;
  isAuthReady: boolean;
}) {
  return useQuery({
    ...scheduleCoursesQueryOptions(params),
    enabled: params.isAuthReady && !!params.termId && !!params.campusId,
    placeholderData: keepPreviousData,
  });
}

export function useSuggestedAcademicTerm(studyPlanId: number | null, enabled = true) {
  return useQuery({
    queryKey: ["suggestedAcademicTerm", studyPlanId],
    queryFn: async () => {
      if (!studyPlanId) return null;
      const sb = getSupabaseBrowserClient();
      const { data, error } = await sb.rpc("get_suggested_academic_term", {
        p_study_plan_id: studyPlanId,
      });
      if (error) throw error;
      return data as number | null;
    },
    enabled: enabled && !!studyPlanId,
    staleTime: 60 * 60 * 1000, // 1 hour
    gcTime: 24 * 60 * 60 * 1000, // 24 hours
  });
}

export function useStudentCourseStatuses(userId: string | null, studyPlanId: number | null) {
  return useQuery({
    queryKey: ["studentCourseStatuses", userId, studyPlanId],
    queryFn: async () => {
      let statusMap = new Map<number, CourseEffectiveStatus>();

      if (!userId || !studyPlanId) {
        const localChanges = getLocalCourseStatusChanges();
        for (const change of localChanges) {
          if (change.studyPlanId === studyPlanId) {
            statusMap.set(change.courseId, {
              status: change.status,
              grade: null,
              recordedAt: null,
              originCourseId: change.courseId,
              originCourseCode: null,
              originCourseName: null,
              originStudyPlanId: change.studyPlanId,
              originAttemptId: null,
              originAttemptNumber: null,
              originGrade: null,
              originRecordedAt: null,
              originAcademicTermId: null,
              originAcademicTermName: null,
              originType: "direct_plan_status",
            });
          }
        }
        return statusMap;
      }

      const sb = getSupabaseBrowserClient();

      const { data, error } = await sb.rpc("get_user_course_effective_status_details", {
        p_user_id: userId,
        p_study_plan_id: studyPlanId,
      });

      if (error) throw error;

      for (const record of (data ?? []) as Array<{
        course_id: number;
        status: string;
        grade: number | null;
        recorded_at: string | null;
        origin_course_id: number | null;
        origin_course_code: string | null;
        origin_course_name: string | null;
        origin_study_plan_id: number | null;
        origin_attempt_id: number | null;
        origin_attempt_number: number | null;
        origin_academic_term_id: number | null;
        origin_academic_term_name: string | null;
        origin_type: string | null;
      }>) {
        statusMap.set(record.course_id, {
          status: record.status.toLowerCase() as CourseStatus,
          grade: record.grade,
          recordedAt: record.recorded_at,
          originCourseId: record.origin_course_id,
          originCourseCode: record.origin_course_code,
          originCourseName: record.origin_course_name,
          originStudyPlanId: record.origin_study_plan_id,
          originAttemptId: record.origin_attempt_id,
          originAttemptNumber: record.origin_attempt_number,
          originGrade: record.grade,
          originRecordedAt: record.recorded_at,
          originAcademicTermId: record.origin_academic_term_id,
          originAcademicTermName: record.origin_academic_term_name,
          originType: record.origin_type as CourseEffectiveStatus["originType"],
        });
      }

      const localChanges = getLocalCourseStatusChanges();
      for (const change of localChanges) {
        if (change.studyPlanId === studyPlanId) {
          statusMap.set(change.courseId, {
            status: change.status,
            grade: null,
            recordedAt: null,
            originCourseId: change.courseId,
            originCourseCode: null,
            originCourseName: null,
            originStudyPlanId: change.studyPlanId,
            originAttemptId: null,
            originAttemptNumber: null,
            originGrade: null,
            originRecordedAt: null,
            originAcademicTermId: null,
            originAcademicTermName: null,
            originType: "direct_plan_status",
          });
        }
      }

      return statusMap;
    },
    enabled: true,
    staleTime: 5 * 60 * 1000,
  });
}

export function useCreateCourseAttempt() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (params: {
      userId: string;
      studyPlanId: number;
      courseId: number;
      status: "approved" | "failed" | "withdrawn" | "in_progress";
      grade: number | null;
      academicTermId?: number | null;
      equivalentCourseId?: number | null;
    }) => {
      const sb = getSupabaseBrowserClient();

      const { error } = await sb.rpc("insert_student_course_attempt", {
        p_user_id: params.userId,
        p_study_plan_id: params.studyPlanId,
        p_course_id: params.courseId,
        p_status: params.status.toUpperCase(),
        p_grade: params.grade,
        p_academic_term_id: params.academicTermId ?? null,
        p_equivalent_course_id: params.equivalentCourseId ?? null,
      });

      if (error) throw error;
    },
    onSuccess: (_, variables) => {
      void queryClient.invalidateQueries({
        queryKey: ["studentCourseStatuses", variables.userId],
      });
      void queryClient.invalidateQueries({ queryKey: ["scheduleCourses"] });
      void queryClient.invalidateQueries({
        queryKey: ["dashboardStats", variables.userId],
      });
      void queryClient.invalidateQueries({
        queryKey: ["courseAttempts", variables.userId, variables.studyPlanId],
      });
    },
  });
}

export function useUpdateCourseAttempt() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (params: {
      userId: string;
      studyPlanId: number;
      courseId: number;
      attemptId: number;
      grade: number | null;
      academicTermId: number | null;
      status?: string;
      equivalentCourseId?: number | null;
    }) => {
      const sb = getSupabaseBrowserClient();

      const { error } = await sb.rpc("update_student_course_attempt", {
        p_attempt_id: params.attemptId,
        p_academic_term_id: params.academicTermId,
        p_grade: params.grade,
        p_status: params.status ?? null,
        p_equivalent_course_id: params.equivalentCourseId ?? null,
      });

      if (error) throw error;
    },
    onSuccess: (_, variables) => {
      void queryClient.invalidateQueries({
        queryKey: ["studentCourseStatuses", variables.userId],
      });
      void queryClient.invalidateQueries({ queryKey: ["scheduleCourses"] });
      void queryClient.invalidateQueries({
        queryKey: ["dashboardStats", variables.userId],
      });
      void queryClient.invalidateQueries({
        queryKey: ["courseAttempts", variables.userId, variables.studyPlanId],
      });
    },
  });
}

export function useCourseAttempts(
  userId: string | null,
  studyPlanId: number | null,
  courseId: number | null,
) {
  return useQuery({
    queryKey: ["courseAttempts", userId, studyPlanId, courseId],
    queryFn: async () => {
      if (!userId || !studyPlanId || !courseId) return [] as CourseAttempt[];

      const sb = getSupabaseBrowserClient();
      const { data, error } = await sb.rpc("get_student_course_attempts", {
        p_user_id: userId,
        p_study_plan_id: studyPlanId,
        p_course_id: courseId,
      });

      if (error) throw error;

      return (data ?? []).map(
        (attempt: {
          id: number;
          course_id: number;
          course_code: string | null;
          course_name: string | null;
          attempt_number: number;
          status: string;
          grade: number | null;
          academic_term_id: number | null;
          recorded_at: string;
          equivalent_course_id?: number | null;
          equivalent_course_code?: string | null;
          equivalent_course_name?: string | null;
        }) =>
          ({
            id: attempt.id,
            courseId: attempt.course_id,
            courseCode: attempt.course_code,
            courseName: attempt.course_name,
            attemptNumber: attempt.attempt_number,
            status: attempt.status.toLowerCase() as CourseAttempt["status"],
            grade: attempt.grade,
            academicTermId: attempt.academic_term_id,
            recordedAt: attempt.recorded_at,
            equivalentCourseId: attempt.equivalent_course_id ?? null,
            equivalentCourseCode: attempt.equivalent_course_code ?? null,
            equivalentCourseName: attempt.equivalent_course_name ?? null,
          }) satisfies CourseAttempt,
      );
    },
    enabled: !!userId && !!studyPlanId && !!courseId,
    staleTime: 30 * 1000,
  });
}

export function useCoursesByIds(courseIds: number[] | null) {
  return useQuery({
    queryKey: ["coursesByIds", courseIds],
    queryFn: async () => {
      if (!courseIds || courseIds.length === 0) return [];

      const sb = getSupabaseBrowserClient();

      const { data, error } = await sb.from("course").select("id, code, name").in("id", courseIds);

      if (error) throw error;
      return data ?? [];
    },
    enabled: !!courseIds && courseIds.length > 0,
    staleTime: 10 * 60 * 1000,
  });
}

export function useCourseDetailRelatedCourses(
  studyPlanId: number | null,
  courseId: number | null,
  page: number = 0,
  limit: number = 100,
) {
  return useQuery({
    queryKey: ["courseDetailRelatedCourses", studyPlanId, courseId, page, limit],
    queryFn: async () => {
      if (!studyPlanId || !courseId) return { data: [], totalCount: 0, isPlaceholder: false };

      const sb = getSupabaseBrowserClient();
      const { data, error } = await sb.rpc("get_course_detail_related_courses", {
        p_study_plan_id: studyPlanId,
        p_course_id: courseId,
        p_limit: limit,
        p_offset: page * limit,
      });

      if (error) throw error;

      const relatedCourses: CourseDetailRelatedCourse[] = (data ?? []).map(
        (item: {
          course_id: number;
          course_code: string | null;
          course_name: string | null;
          course_credits: number | null;
          course_weekly_hours: number | null;
          relation_kind: "base" | "equivalent";
          is_placeholder: boolean;
          has_offerings: boolean | null;
          total_equivalents: number | null;
        }) => ({
          id: item.course_id,
          code: item.course_code ?? String(item.course_id),
          name: item.course_name ?? "",
          credits: item.course_credits,
          weeklyHours: item.course_weekly_hours,
          relationKind: item.relation_kind,
          isPlaceholder: item.is_placeholder,
          hasOfferings: item.has_offerings ?? false,
          totalEquivalents: item.total_equivalents ?? 0,
        }),
      );

      return {
        data: relatedCourses,
        totalCount: relatedCourses[0]?.totalEquivalents ?? 0,
        isPlaceholder: relatedCourses[0]?.isPlaceholder ?? false,
      };
    },
    enabled: !!studyPlanId && !!courseId,
    placeholderData: (previous) => previous,
  });
}

export function useCourseRecentProfessors(
  courseId: number | null,
  campusId: number | null,
  academicUnitId: number | null,
  academicTermId: number | null = null,
) {
  return useQuery({
    queryKey: ["courseRecentProfessors", courseId, campusId, academicUnitId, academicTermId],
    queryFn: async () => {
      if (!courseId) return [] as CourseRecentProfessor[];

      const sb = getSupabaseBrowserClient();
      const { data, error } = await sb.rpc("get_course_recent_professors", {
        p_course_id: courseId,
        p_campus_id: campusId,
        p_academic_unit_id: academicUnitId,
        p_year_window: 2,
        p_academic_term_id: academicTermId,
      });

      if (error) throw error;

      return (data ?? []).map(
        (row: {
          professor_id: number;
          professor_name: string;
          last_taught_term_id: number;
          last_taught_term_name: string;
          last_taught_year: number;
          last_taught_period_number: number;
          groups_in_last_term_count: number;
          terms_taught_count: number;
        }) =>
          ({
            professorId: row.professor_id,
            professorName: row.professor_name,
            lastTaughtTermId: row.last_taught_term_id,
            lastTaughtTermName: row.last_taught_term_name,
            lastTaughtYear: row.last_taught_year,
            lastTaughtPeriodNumber: row.last_taught_period_number,
            groupsInLastTermCount: row.groups_in_last_term_count,
            termsTaughtCount: row.terms_taught_count,
          }) satisfies CourseRecentProfessor,
      );
    },
    enabled: !!courseId,
    staleTime: 5 * 60 * 1000,
  });
}

export function useCourseLatestTermGroups(
  courseId: number | null,
  campusId: number | null,
  academicUnitId: number | null,
  academicTermId: number | null = null,
  studyPlanId: number | null = null,
) {
  return useQuery({
    queryKey: [
      "courseLatestTermGroups",
      courseId,
      campusId,
      academicUnitId,
      academicTermId,
      studyPlanId,
    ],
    queryFn: async () => {
      if (!courseId) return [] as CourseLatestTermGroup[];

      const sb = getSupabaseBrowserClient();
      const { data, error } = await sb.rpc("get_course_latest_term_groups", {
        p_course_id: courseId,
        p_campus_id: campusId,
        p_academic_unit_id: academicUnitId,
        p_academic_term_id: academicTermId,
        p_study_plan_id: studyPlanId,
      });

      if (error) throw error;

      return (data ?? []).map(
        (row: {
          academic_term_id: number;
          term_display_name: string;
          term_year: number;
          term_period_number: number;
          source_course_id: number;
          source_course_code: string;
          source_course_name: string;
          group_id: number;
          group_code: string;
          group_type: string;
          capacity: number;
          campus_id: number | null;
          campus_name: string | null;
          professors: Array<{ id: number; name: string }> | null;
          meetings: Array<{
            weekday: number;
            starts_at: string;
            ends_at: string;
            classroom: string | null;
          }> | null;
        }) =>
          ({
            academicTermId: row.academic_term_id,
            termDisplayName: row.term_display_name,
            termYear: row.term_year,
            termPeriodNumber: row.term_period_number,
            sourceCourseId: row.source_course_id,
            sourceCourseCode: row.source_course_code,
            sourceCourseName: row.source_course_name,
            groupId: row.group_id,
            groupCode: row.group_code,
            groupType: row.group_type,
            capacity: row.capacity,
            campusId: row.campus_id,
            campusName: row.campus_name,
            professors: row.professors ?? [],
            meetings: row.meetings ?? [],
          }) satisfies CourseLatestTermGroup,
      );
    },
    enabled: !!courseId,
    staleTime: 2 * 60 * 1000,
    placeholderData: keepPreviousData,
  });
}

export function useDashboardStats(userId: string | null, studyPlanId: number | null) {
  return useQuery({
    queryKey: ["dashboardStats", userId, studyPlanId],
    queryFn: async () => {
      if (!userId || !studyPlanId) return null;

      const sb = getSupabaseBrowserClient();

      const { data, error } = await sb.rpc("get_user_dashboard_stats", {
        p_user_id: userId,
        p_study_plan_id: studyPlanId,
      });

      if (error) throw error;

      return data as {
        stats: DashboardStats;
        semesters: SemesterProgress[];
        nextCourses: NextCourse[];
      } | null;
    },
    enabled: !!userId && !!studyPlanId,
    staleTime: 30 * 1000,
  });
}

export function useDeleteCourseAttempt() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (params: { userId: string; studyPlanId: number; attemptId: number }) => {
      const sb = getSupabaseBrowserClient();

      const { error } = await sb.rpc("delete_student_course_attempt", {
        p_attempt_id: params.attemptId,
      });

      if (error) throw error;
    },
    onSuccess: (_, variables) => {
      void queryClient.invalidateQueries({
        queryKey: ["studentCourseStatuses", variables.userId],
      });
      void queryClient.invalidateQueries({ queryKey: ["scheduleCourses"] });
      void queryClient.invalidateQueries({
        queryKey: ["dashboardStats", variables.userId],
      });
      void queryClient.invalidateQueries({
        queryKey: ["courseAttempts", variables.userId, variables.studyPlanId],
      });
    },
  });
}
