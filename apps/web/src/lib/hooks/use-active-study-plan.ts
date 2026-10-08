import { useStore } from "@tanstack/react-store";
import { useMemo } from "react";

import { CURRICULUM_DEFAULT_UNIVERSITY_ID } from "@/routes/curriculum/-curriculum-search";

import { localStudyPlanStore } from "../store/local-study-plan";
import { useAuthUser, useUserStudyPlan } from "./use-queries";

export function useActiveStudyPlan() {
  const { data: authUser, isLoading: isAuthLoading } = useAuthUser();
  const { data: userStudyPlan, isLoading: isUserStudyPlanLoading } = useUserStudyPlan(
    authUser?.id ?? null,
  );

  const localPlan = useStore(localStudyPlanStore);

  const isLoading = isAuthLoading || isUserStudyPlanLoading;

  const activePlan = useMemo(() => {
    return authUser
      ? {
          universityId: userStudyPlan?.universityId ?? CURRICULUM_DEFAULT_UNIVERSITY_ID,
          campusId: userStudyPlan?.campusId ?? null,
          academicUnitId: userStudyPlan?.academicUnitId ?? null,
          studyPlanId: userStudyPlan?.studyPlanId ?? null,
          termId: userStudyPlan?.termId ?? null,
        }
      : localPlan;
  }, [authUser, userStudyPlan, localPlan]);

  return {
    activePlan,
    isLoading,
    isAuthenticated: !!authUser,
    authUser,
    isAuthLoading,
  };
}
