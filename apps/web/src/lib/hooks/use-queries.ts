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

import { apiClient } from "@/lib/api/client";
import { authClient } from "@/lib/auth/client";
import { appStateServerFn } from "@/lib/auth/server-fn";
import {
  getUniversitiesServerFn,
  getCampusesServerFn,
  getAcademicUnitsServerFn,
  getStudyPlansServerFn,
} from "@/lib/catalog-server-fns";
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
    queryKey: ["studyPlans", academicUnitId],
    queryFn: async () => {
      if (!academicUnitId) return [];
      const data = await getStudyPlansServerFn({ data: academicUnitId });
      return ((data ?? []) as CatalogStudyPlan[]).sort(
        (a, b) =>
          Number(b.external_plan_id ?? b.id) - Number(a.external_plan_id ?? a.id) ||
          Number(b.id) - Number(a.id),
      );
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

function buildStudyPlanPeriods(
  items:
    | Array<Record<string, unknown>>
    | { courses?: Array<Record<string, unknown>> }
    | null
    | undefined,
): StudyPeriod[] {
  const list = Array.isArray(items)
    ? items
    : Array.isArray((items as { courses?: Array<Record<string, unknown>> })?.courses)
      ? (items as { courses: Array<Record<string, unknown>> }).courses
      : [];
  const periods = new Map<number | null, { levelLabel?: string; courses: StudyPlanCourse[] }>();
  for (const item of list ?? []) {
    const courseCode =
      typeof item.courseCode === "string"
        ? item.courseCode
        : typeof item.course_code === "string"
          ? item.course_code
          : "";
    const courseName =
      typeof item.courseName === "string"
        ? item.courseName
        : typeof item.course_name === "string"
          ? item.course_name
          : "";

    const course: StudyPlanCourse = {
      courseId: Number(item.courseId ?? item.course_id ?? 0),
      levelNumber: (item.levelNumber ?? item.level_number ?? null) as number | null,
      credits: Number(item.credits ?? 0),
      weeklyHours: Number(item.weeklyHours ?? item.weekly_hours ?? 0),
      sortOrder: Number(item.sortOrder ?? item.sort_order ?? 0),
      courseCode,
      courseName,
      courseDefaultCredits: Number(item.courseDefaultCredits ?? item.default_credits ?? 0),
      courseDefaultWeeklyHours: Number(
        item.courseDefaultWeeklyHours ?? item.default_weekly_hours ?? 0,
      ),
    };
    const level = (item.levelNumber ?? item.level_number ?? 0) as number;
    if (!periods.has(level)) {
      periods.set(level, {
        levelLabel: (item.levelLabel ?? item.level_label) as string | undefined,
        courses: [],
      });
    }
    periods.get(level)!.courses.push(course);
  }

  return Array.from(periods.entries())
    .sort(([a], [b]) => (a ?? 0) - (b ?? 0))
    .map(([levelNumber, { levelLabel, courses }]): StudyPeriod => ({
      levelNumber: levelNumber ?? 0,
      levelLabel,
      courses,
    }));
}

export function studyPlanCoursesDetailsQueryOptions(planId: number | null) {
  return queryOptions({
    queryKey: ["studyPlanCourses", planId],
    queryFn: async () => {
      if (!planId) return null;
      const coursesResult = await apiClient<Array<Record<string, unknown>>>(
        `/studyplans/${planId}/courses`,
      );
      return buildStudyPlanPeriods(coursesResult ?? []);
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

      type PlanRelation = {
        from_course_id?: number;
        fromCourseId?: number;
        to_course_id?: number;
        toCourseId?: number;
        relation_type?: "PREREQUISITE" | "COREQUISITE" | "EQUIVALENT";
        relationType?: "PREREQUISITE" | "COREQUISITE" | "EQUIVALENT";
      };

      type RawPlanDetail = {
        id: number;
        academic_unit_id?: number;
        academicUnitId?: number;
        external_plan_id?: number | string;
        externalPlanId?: number | string;
        name: string;
        academic_degree?: string | null;
        academicDegree?: string | null;
        modality_name?: string;
        academic_modality?: { name: string } | null;
      };

      const [coursesResult, relationsResult, planResult] = await Promise.all([
        apiClient<Array<Record<string, unknown>>>(`/studyplans/${planId}/courses`),
        apiClient<PlanRelation[]>(`/studyplans/${planId}/relations`),
        apiClient<RawPlanDetail>(`/studyplans/${planId}`),
      ]);

      const courseRelations = new Map<
        number,
        { prerequisites: number[]; corequisites: number[]; equivalents: number[] }
      >();
      for (const r of relationsResult ?? []) {
        const fromId = (r.fromCourseId ?? r.from_course_id)!;
        const toId = (r.toCourseId ?? r.to_course_id)!;
        const relType = (r.relationType ?? r.relation_type)!;
        const existing = courseRelations.get(fromId) ?? {
          prerequisites: [],
          corequisites: [],
          equivalents: [],
        };
        if (relType === "PREREQUISITE") {
          existing.prerequisites.push(toId);
        } else if (relType === "COREQUISITE") {
          existing.corequisites.push(toId);
        } else if (relType === "EQUIVALENT") {
          existing.equivalents.push(toId);
        }
        courseRelations.set(fromId, existing);
      }

      const periodArray = buildStudyPlanPeriods(coursesResult ?? []);

      const rawPlan =
        (planResult as { plan?: RawPlanDetail })?.plan ?? (planResult as RawPlanDetail);
      const rawExternalId = rawPlan?.externalPlanId ?? rawPlan?.external_plan_id ?? 0;
      const externalIdStr = String(rawExternalId);
      const rawName = rawPlan?.name ?? "Plan de Estudios";
      const planName = rawName.includes(externalIdStr) ? rawName : `${externalIdStr} - ${rawName}`;

      const formattedPlan: CatalogStudyPlan = {
        id: rawPlan?.id ?? planId,
        academic_unit_id: rawPlan?.academicUnitId ?? rawPlan?.academic_unit_id ?? 0,
        external_plan_id:
          typeof rawExternalId === "number" ? rawExternalId : parseInt(rawExternalId, 10) || 0,
        name: planName,
        academic_degree: rawPlan?.academicDegree ?? rawPlan?.academic_degree ?? null,
        modality_name: rawPlan?.modality_name ?? rawPlan?.academic_modality?.name,
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
      const q = new URLSearchParams();
      q.set("campusId", String(campusId));
      if (studyPlanId) q.set("studyPlanId", String(studyPlanId));
      const data = await apiClient<AcademicTerm[]>(`/terms?${q.toString()}`);
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

      const q = new URLSearchParams();
      if (campusId) q.set("campusId", String(campusId));
      if (academicUnitId) q.set("academicUnitId", String(academicUnitId));
      if (studyPlanId) q.set("studyPlanId", String(studyPlanId));

      const data = await apiClient<AcademicTerm[]>(`/courses/${courseId}/terms?${q.toString()}`);
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

      const q = new URLSearchParams();
      q.set("termId", String(params.termId));
      q.set("campusId", String(params.campusId));
      if (params.careerId) q.set("careerId", String(params.careerId));
      if (params.planId) q.set("planId", String(params.planId));
      q.set("otherCampuses", String(params.includeOtherCampuses));
      q.set("showAll", String(params.userId ? params.showAllCourses : true));

      const data = await apiClient<import("@/lib/types").ScheduleCourse[]>(
        `/schedules/courses?${q.toString()}`,
      );
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
      const data = await apiClient<{ termId?: number } | number | null>(
        `/terms/suggested?studyPlanId=${studyPlanId}`,
      );
      if (typeof data === "number") return data;
      if (data && typeof data === "object" && "termId" in data && typeof data.termId === "number") {
        return data.termId;
      }
      return null;
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
      const statusMap = new Map<number, CourseEffectiveStatus>();

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

      type RawStatus = {
        course_id?: number;
        courseId?: number;
        status: string;
        grade?: number | null;
        recorded_at?: string | null;
        recordedAt?: string | null;
        origin_course_id?: number | null;
        originCourseId?: number | null;
        origin_course_code?: string | null;
        originCourseCode?: string | null;
        origin_course_name?: string | null;
        originCourseName?: string | null;
        origin_study_plan_id?: number | null;
        originStudyPlanId?: number | null;
        origin_attempt_id?: number | null;
        originAttemptId?: number | null;
        origin_attempt_number?: number | null;
        originAttemptNumber?: number | null;
        origin_academic_term_id?: number | null;
        originAcademicTermId?: number | null;
        origin_academic_term_name?: string | null;
        originAcademicTermName?: string | null;
        origin_type?: string | null;
        originType?: string | null;
      };

      const data = await apiClient<RawStatus[]>(`/students/me/statuses?studyPlanId=${studyPlanId}`);

      for (const record of data ?? []) {
        const courseId = record.courseId ?? record.course_id;
        if (!courseId) continue;
        const grade = record.grade ?? null;
        const recordedAt = record.recordedAt ?? record.recorded_at ?? null;
        statusMap.set(courseId, {
          status: record.status.toLowerCase() as CourseStatus,
          grade,
          recordedAt,
          originCourseId: record.originCourseId ?? record.origin_course_id ?? null,
          originCourseCode: record.originCourseCode ?? record.origin_course_code ?? null,
          originCourseName: record.originCourseName ?? record.origin_course_name ?? null,
          originStudyPlanId: record.originStudyPlanId ?? record.origin_study_plan_id ?? null,
          originAttemptId: record.originAttemptId ?? record.origin_attempt_id ?? null,
          originAttemptNumber: record.originAttemptNumber ?? record.origin_attempt_number ?? null,
          originGrade: grade,
          originRecordedAt: recordedAt,
          originAcademicTermId:
            record.originAcademicTermId ?? record.origin_academic_term_id ?? null,
          originAcademicTermName:
            record.originAcademicTermName ?? record.origin_academic_term_name ?? null,
          originType: (record.originType ??
            record.origin_type) as CourseEffectiveStatus["originType"],
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
      await apiClient("/students/me/attempts", {
        method: "POST",
        body: JSON.stringify({
          studyPlanId: params.studyPlanId,
          courseId: params.courseId,
          status: params.status.toUpperCase(),
          grade: params.grade,
          academicTermId: params.academicTermId ?? null,
          equivalentCourseId: params.equivalentCourseId ?? null,
        }),
      });
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
      await apiClient(`/students/me/attempts/${params.attemptId}`, {
        method: "PATCH",
        body: JSON.stringify({
          academicTermId: params.academicTermId,
          grade: params.grade,
          status: params.status ? params.status.toUpperCase() : undefined,
          equivalentCourseId: params.equivalentCourseId ?? null,
        }),
      });
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

      type RawAttempt = {
        id: number;
        course_id?: number;
        courseId?: number;
        course_code?: string | null;
        courseCode?: string | null;
        course_name?: string | null;
        courseName?: string | null;
        attempt_number?: number;
        attemptNumber?: number;
        status: string;
        grade: number | null;
        academic_term_id?: number | null;
        academicTermId?: number | null;
        recorded_at?: string;
        recordedAt?: string;
        equivalent_course_id?: number | null;
        equivalentCourseId?: number | null;
        equivalent_course_code?: string | null;
        equivalentCourseCode?: string | null;
        equivalent_course_name?: string | null;
        equivalentCourseName?: string | null;
      };

      const data = await apiClient<RawAttempt[]>(
        `/students/me/attempts?studyPlanId=${studyPlanId}&courseId=${courseId}`,
      );

      return (data ?? []).map(
        (attempt) =>
          ({
            id: attempt.id,
            courseId: (attempt.courseId ?? attempt.course_id)!,
            courseCode: attempt.courseCode ?? attempt.course_code ?? null,
            courseName: attempt.courseName ?? attempt.course_name ?? null,
            attemptNumber: attempt.attemptNumber ?? attempt.attempt_number ?? 1,
            status: attempt.status.toLowerCase() as CourseAttempt["status"],
            grade: attempt.grade,
            academicTermId: attempt.academicTermId ?? attempt.academic_term_id ?? null,
            recordedAt: (attempt.recordedAt ?? attempt.recorded_at)!,
            equivalentCourseId: attempt.equivalentCourseId ?? attempt.equivalent_course_id ?? null,
            equivalentCourseCode:
              attempt.equivalentCourseCode ?? attempt.equivalent_course_code ?? null,
            equivalentCourseName:
              attempt.equivalentCourseName ?? attempt.equivalent_course_name ?? null,
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
      const idsParam = courseIds.join(",");
      const data = await apiClient<Array<{ id: number; code: string; name: string }>>(
        `/courses?ids=${idsParam}`,
      );
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

      const q = new URLSearchParams();
      q.set("studyPlanId", String(studyPlanId));
      q.set("offset", String(page * limit));
      q.set("limit", String(limit));

      type RawRelated = {
        course_id?: number;
        courseId?: number;
        course_code?: string | null;
        courseCode?: string | null;
        course_name?: string | null;
        courseName?: string | null;
        course_credits?: number | null;
        courseCredits?: number | null;
        course_weekly_hours?: number | null;
        courseWeeklyHours?: number | null;
        relation_kind?: "base" | "equivalent";
        relationKind?: "base" | "equivalent";
        is_placeholder?: boolean;
        isPlaceholder?: boolean;
        has_offerings?: boolean | null;
        hasOfferings?: boolean | null;
        total_equivalents?: number | null;
        totalEquivalents?: number | null;
      };

      const data = await apiClient<RawRelated[]>(
        `/courses/${courseId}/equivalents?${q.toString()}`,
      );

      const relatedCourses: CourseDetailRelatedCourse[] = (data ?? []).map((item) => {
        const id = (item.courseId ?? item.course_id)!;
        const code = item.courseCode ?? item.course_code ?? String(id);
        const name = item.courseName ?? item.course_name ?? "";
        return {
          id,
          code,
          name,
          credits: item.courseCredits ?? item.course_credits ?? null,
          weeklyHours: item.courseWeeklyHours ?? item.course_weekly_hours ?? null,
          relationKind: (item.relationKind ?? item.relation_kind ?? "base") as
            | "base"
            | "equivalent",
          isPlaceholder: item.isPlaceholder ?? item.is_placeholder ?? false,
          hasOfferings: item.hasOfferings ?? item.has_offerings ?? false,
          totalEquivalents: item.totalEquivalents ?? item.total_equivalents ?? 0,
        };
      });

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

      const q = new URLSearchParams();
      if (campusId) q.set("campusId", String(campusId));
      if (academicUnitId) q.set("academicUnitId", String(academicUnitId));
      if (academicTermId) q.set("academicTermId", String(academicTermId));

      type RawRecentProf = {
        professor_id?: number;
        professorId?: number;
        professor_name?: string;
        professorName?: string;
        last_taught_term_id?: number;
        lastTaughtTermId?: number;
        last_taught_term_name?: string;
        lastTaughtTermName?: string;
        last_taught_year?: number;
        lastTaughtYear?: number;
        last_taught_period_number?: number;
        lastTaughtPeriodNumber?: number;
        groups_in_last_term_count?: number;
        groupsInLastTermCount?: number;
        terms_taught_count?: number;
        termsTaughtCount?: number;
      };

      const data = await apiClient<RawRecentProf[]>(
        `/courses/${courseId}/professors?${q.toString()}`,
      );

      return (data ?? []).map(
        (row) =>
          ({
            professorId: (row.professorId ?? row.professor_id)!,
            professorName: (row.professorName ?? row.professor_name)!,
            lastTaughtTermId: (row.lastTaughtTermId ?? row.last_taught_term_id)!,
            lastTaughtTermName: (row.lastTaughtTermName ?? row.last_taught_term_name)!,
            lastTaughtYear: (row.lastTaughtYear ?? row.last_taught_year)!,
            lastTaughtPeriodNumber: (row.lastTaughtPeriodNumber ?? row.last_taught_period_number)!,
            groupsInLastTermCount: (row.groupsInLastTermCount ?? row.groups_in_last_term_count)!,
            termsTaughtCount: (row.termsTaughtCount ?? row.terms_taught_count)!,
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

      const q = new URLSearchParams();
      if (campusId) q.set("campusId", String(campusId));
      if (academicUnitId) q.set("academicUnitId", String(academicUnitId));
      if (academicTermId) q.set("academicTermId", String(academicTermId));
      if (studyPlanId) q.set("studyPlanId", String(studyPlanId));

      type RawGroup = {
        academic_term_id?: number;
        academicTermId?: number;
        term_display_name?: string;
        termDisplayName?: string;
        term_year?: number;
        termYear?: number;
        term_period_number?: number;
        termPeriodNumber?: number;
        source_course_id?: number;
        sourceCourseId?: number;
        source_course_code?: string;
        sourceCourseCode?: string;
        source_course_name?: string;
        sourceCourseName?: string;
        group_id?: number;
        groupId?: number;
        group_code?: string;
        groupCode?: string;
        group_type?: string;
        groupType?: string;
        capacity?: number;
        campus_id?: number | null;
        campusId?: number | null;
        campus_name?: string | null;
        campusName?: string | null;
        professors?: Array<{ id: number; name: string }> | null;
        meetings?: Array<{
          weekday: number;
          starts_at: string;
          ends_at: string;
          classroom: string | null;
        }> | null;
      };

      const data = await apiClient<RawGroup[]>(`/courses/${courseId}/groups?${q.toString()}`);

      return (data ?? []).map(
        (row) =>
          ({
            academicTermId: (row.academicTermId ?? row.academic_term_id)!,
            termDisplayName: (row.termDisplayName ?? row.term_display_name)!,
            termYear: (row.termYear ?? row.term_year)!,
            termPeriodNumber: (row.termPeriodNumber ?? row.term_period_number)!,
            sourceCourseId: (row.sourceCourseId ?? row.source_course_id)!,
            sourceCourseCode: (row.sourceCourseCode ?? row.source_course_code)!,
            sourceCourseName: (row.sourceCourseName ?? row.source_course_name)!,
            groupId: (row.groupId ?? row.group_id)!,
            groupCode: (row.groupCode ?? row.group_code)!,
            groupType: (row.groupType ?? row.group_type)!,
            capacity: row.capacity ?? 0,
            campusId: row.campusId ?? row.campus_id ?? null,
            campusName: row.campusName ?? row.campus_name ?? null,
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

      const data = await apiClient<{
        stats: DashboardStats;
        semesters: SemesterProgress[];
        nextCourses: NextCourse[];
      } | null>(`/students/me/stats?studyPlanId=${studyPlanId}`);

      return data ?? null;
    },
    enabled: !!userId && !!studyPlanId,
    staleTime: 30 * 1000,
  });
}

export function useDeleteCourseAttempt() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (params: { userId: string; studyPlanId: number; attemptId: number }) => {
      await apiClient(`/students/me/attempts/${params.attemptId}`, {
        method: "DELETE",
      });
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
