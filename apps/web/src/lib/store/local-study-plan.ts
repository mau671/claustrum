import { Store } from "@tanstack/store";

export interface LocalStudyPlan {
  universityId: number | null;
  campusId: number | null;
  academicUnitId: number | null;
  studyPlanId: number | null;
  termId: number | null;
}

const LOCAL_STORAGE_KEY = "local-study-plan";

function getEmptyState(): LocalStudyPlan {
  return {
    universityId: null,
    campusId: null,
    academicUnitId: null,
    studyPlanId: null,
    termId: null,
  };
}

export const localStudyPlanStore = new Store<LocalStudyPlan>(getEmptyState());

export function hydrateLocalStudyPlan() {
  if (typeof window === "undefined") return;
  const stored = localStorage.getItem(LOCAL_STORAGE_KEY);
  if (stored) {
    try {
      const parsed = JSON.parse(stored) as Partial<LocalStudyPlan>;
      localStudyPlanStore.setState(() => ({ ...getEmptyState(), ...parsed }));
    } catch (e) {
      console.error("Failed to parse local study plan", e);
    }
  }
}

export function saveLocalStudyPlan(plan: Partial<LocalStudyPlan>) {
  localStudyPlanStore.setState((state) => {
    const newState = { ...state, ...plan };
    if (typeof window !== "undefined") {
      localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(newState));
    }
    return newState;
  });
}

export function resetLocalStudyPlan() {
  localStudyPlanStore.setState(() => {
    const newState = {
      universityId: null,
      campusId: null,
      academicUnitId: null,
      studyPlanId: null,
      termId: null,
    };
    if (typeof window !== "undefined") {
      localStorage.removeItem(LOCAL_STORAGE_KEY);
    }
    return newState;
  });
}
