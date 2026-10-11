import { createServerFn } from "@tanstack/react-start";

import { apiClient } from "@/lib/api/client";

const MAIN_CAMPUS_CODES = new Set(["AL", "CA", "LM", "SC", "SJ"]);

const cache = new Map<string, { data: any; timestamp: number }>();
const CACHE_TTL = 1000 * 60 * 60; // 1 hour

async function withCache<T>(key: string, fetcher: () => Promise<T>): Promise<T> {
  const now = Date.now();
  const cached = cache.get(key);
  if (cached && now - cached.timestamp < CACHE_TTL) {
    return cached.data;
  }
  const data = await fetcher();
  cache.set(key, { data, timestamp: now });
  return data;
}

export const getUniversitiesServerFn = createServerFn({ method: "GET" }).handler(async () => {
  return withCache("universities", async () => {
    const data = await apiClient<any[]>("/universities");
    return data ?? [];
  });
});

export const getCampusesServerFn = createServerFn({ method: "GET" })
  .validator((universityId: number) => universityId)
  .handler(async ({ data: universityId }) => {
    return withCache(`campuses-${universityId}`, async () => {
      const data = await apiClient<any[]>(`/campuses?universityId=${universityId}`);
      return (data ?? []).filter((c) => MAIN_CAMPUS_CODES.has(c.code));
    });
  });

export const getAcademicUnitsServerFn = createServerFn({ method: "GET" })
  .validator((campusId: number) => campusId)
  .handler(async ({ data: campusId }) => {
    return withCache(`academic-units-${campusId}`, async () => {
      const data = await apiClient<any[]>(`/academicunits?campusId=${campusId}`);
      return data ?? [];
    });
  });

export const getStudyPlansServerFn = createServerFn({ method: "GET" })
  .validator((academicUnitId: number) => academicUnitId)
  .handler(async ({ data: academicUnitId }) => {
    return withCache(`study-plans-${academicUnitId}`, async () => {
      const data = await apiClient<any[]>(`/studyplans?academicUnitId=${academicUnitId}`);
      return (data ?? []).sort(
        (a, b) =>
          Number(b.external_plan_id ?? b.id) - Number(a.external_plan_id ?? a.id) ||
          Number(b.id) - Number(a.id),
      );
    });
  });

export const getAcademicTermsServerFn = createServerFn({ method: "GET" })
  .validator((params: { campusId: number; studyPlanId?: number | null }) => params)
  .handler(async ({ data: { campusId, studyPlanId } }) => {
    return withCache(`academic-terms-${campusId}-${studyPlanId ?? "none"}`, async () => {
      const query = studyPlanId
        ? `/terms?campusId=${campusId}&studyPlanId=${studyPlanId}`
        : `/terms?campusId=${campusId}`;
      const data = await apiClient<any[]>(query);
      return data ?? [];
    });
  });
