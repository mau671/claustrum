import { createClient } from "@supabase/supabase-js";
import { createServerFn } from "@tanstack/react-start";

import { getSupabasePublicEnv } from "@/lib/env/public";

let publicClient: any = null;

function getSupabasePublicClient(): any {
  if (!publicClient) {
    const { supabaseUrl, supabasePublishableKey } = getSupabasePublicEnv();
    publicClient = createClient(supabaseUrl, supabasePublishableKey, {
      auth: { persistSession: false },
    });
  }
  return publicClient;
}

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
    const sb = getSupabasePublicClient();
    const { data, error } = await sb
      .from("v_universities")
      .select("id,name,short_name")
      .order("name", { ascending: true });
    if (error) throw error;
    return (data ?? []) as any[];
  });
});

export const getCampusesServerFn = createServerFn({ method: "GET" })
  .validator((universityId: number) => universityId)
  .handler(async ({ data: universityId }) => {
    return withCache(`campuses-${universityId}`, async () => {
      const sb = getSupabasePublicClient();
      const { data, error } = await sb
        .rpc("get_campuses_for_university", { p_university_id: universityId })
        .select("id,university_id,code,name")
        .order("name", { ascending: true });
      if (error) throw error;
      return (data ?? []) as any[];
    });
  });

export const getAcademicUnitsServerFn = createServerFn({ method: "GET" })
  .validator((campusId: number) => campusId)
  .handler(async ({ data: campusId }) => {
    return withCache(`academic-units-${campusId}`, async () => {
      const sb = getSupabasePublicClient();
      const { data, error } = await sb
        .rpc("get_academic_units_for_campus", { p_campus_id: campusId })
        .select("id,code,name")
        .order("name", { ascending: true });
      if (error) throw error;
      return (data ?? []) as any[];
    });
  });

export const getStudyPlansServerFn = createServerFn({ method: "GET" })
  .validator((academicUnitId: number) => academicUnitId)
  .handler(async ({ data: academicUnitId }) => {
    return withCache(`study-plans-${academicUnitId}`, async () => {
      const sb = getSupabasePublicClient();
      const { data, error } = await sb
        .rpc("get_study_plans_for_academic_unit", { p_academic_unit_id: academicUnitId })
        .select("id,academic_unit_id,external_plan_id,name,academic_degree,modality_name");
      if (error) throw error;
      return (data ?? []) as any[];
    });
  });

export const getAcademicTermsServerFn = createServerFn({ method: "GET" })
  .validator((params: { campusId: number; studyPlanId?: number | null }) => params)
  .handler(async ({ data: { campusId, studyPlanId } }) => {
    return withCache(`academic-terms-${campusId}-${studyPlanId ?? "none"}`, async () => {
      const sb = getSupabasePublicClient();
      if (studyPlanId) {
        const { data, error } = await sb
          .rpc("get_academic_terms_by_plan", {
            p_study_plan_id: studyPlanId,
            p_campus_id: campusId,
          })
          .select("*")
          .order("year", { ascending: false })
          .order("period_number", { ascending: false });
        if (error) throw error;
        return (data ?? []) as any[];
      }
      const { data, error } = await sb
        .rpc("get_active_academic_terms")
        .select("*")
        .order("year", { ascending: false })
        .order("period_number", { ascending: false });
      if (error) throw error;
      return (data ?? []) as any[];
    });
  });
