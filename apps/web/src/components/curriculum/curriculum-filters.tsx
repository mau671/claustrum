import { useState, useEffect } from "react";

import type {
  CatalogUniversity,
  CatalogCampus,
  CatalogCareerProgram,
  CatalogStudyPlan,
} from "@/lib/types";

import { FiltersPanel } from "@/components/filters/filters-panel";
import {
  FilterCombobox,
  normalizeText,
  removePlanPrefixFromName,
} from "@/components/filters/shared-filters";

interface CurriculumFiltersProps {
  universities: CatalogUniversity[];
  campuses: CatalogCampus[];
  careerPrograms: CatalogCareerProgram[];
  plans: CatalogStudyPlan[];
  selectedUniversityId: number | null;
  selectedCampusId: number | null;
  selectedCareerProgramId: number | null;
  selectedPlanId: number | null;
  onUniversityChange: (id: number | null) => void;
  onCampusChange: (id: number | null) => void;
  onCareerProgramChange: (id: number | null) => void;
  onPlanChange: (id: number | null) => void;
  isLoadingUniversities: boolean;
  isLoadingCampuses?: boolean;
  isLoadingCareerPrograms: boolean;
  isLoadingPlans: boolean;
  canUseProfileDefaults?: boolean;
  isUsingProfileDefaults?: boolean;
  onUseProfileDefaults?: () => void;
  isVisible?: boolean;
  onVisibleChange?: (visible: boolean) => void;
}

export function CurriculumFilters({
  universities,
  campuses,
  careerPrograms,
  plans,
  selectedUniversityId,
  selectedCampusId,
  selectedCareerProgramId,
  selectedPlanId,
  onUniversityChange,
  onCampusChange,
  onCareerProgramChange,
  onPlanChange,
  isLoadingUniversities,
  isLoadingCampuses = false,
  isLoadingCareerPrograms,
  isLoadingPlans,
  isVisible = true,
  onVisibleChange,
}: CurriculumFiltersProps) {
  const [skipAnimation, setSkipAnimation] = useState(
    () =>
      !!selectedUniversityId && !!selectedCampusId && !!selectedCareerProgramId && !!selectedPlanId,
  );
  useEffect(() => {
    // We moved local storage state up to the page level to sync with search params
  }, []);
  const hasUniversities = universities.length > 0;
  const shouldShowUniversityFilter = universities.length > 1;
  const canSelectCampus = shouldShowUniversityFilter ? !!selectedUniversityId : hasUniversities;

  const isUniversityFilterReady = shouldShowUniversityFilter && !isLoadingUniversities;
  const isCampusFilterReady = canSelectCampus && !isLoadingCampuses;
  const isCareerFilterReady = !!selectedCampusId && !isLoadingCareerPrograms;
  const isPlanFilterReady = !!selectedCareerProgramId && !isLoadingPlans;

  const showUniversityFilter = isUniversityFilterReady;
  const showCampusFilter = isCampusFilterReady;
  const showCareerFilter = isCareerFilterReady;
  const showPlanFilter = isPlanFilterReady;

  useEffect(() => {
    // Synced at page level now
  }, []);

  return (
    <FiltersPanel isExpanded={isVisible} onExpandedChange={onVisibleChange ?? (() => {})}>
      <FilterCombobox
        label="Universidad"
        value={selectedUniversityId?.toString() || ""}
        placeholder="Universidad"
        items={universities}
        onChange={(val) => {
          setSkipAnimation(false);
          onUniversityChange(val ? parseInt(val) : null);
        }}
        isVisible={showUniversityFilter}
        skipAnimation={skipAnimation}
      />

      <FilterCombobox
        label="Sede"
        value={selectedCampusId?.toString() || ""}
        placeholder="Sede"
        items={campuses}
        onChange={(val) => {
          setSkipAnimation(false);
          onCampusChange(val ? parseInt(val) : null);
        }}
        isVisible={showCampusFilter}
        itemLabel={(item) =>
          item.code
            ? `${normalizeText(item.code)}: ${normalizeText(item.name)}`
            : normalizeText(item.name)
        }
        skipAnimation={skipAnimation}
      />

      <FilterCombobox
        label="Carrera"
        value={selectedCareerProgramId?.toString() || ""}
        placeholder="Carrera"
        items={careerPrograms}
        onChange={(val) => {
          setSkipAnimation(false);
          onCareerProgramChange(val ? parseInt(val) : null);
        }}
        isVisible={showCareerFilter}
        itemLabel={(item) =>
          item.code
            ? `${normalizeText(item.code)}: ${normalizeText(item.name)}`
            : normalizeText(item.name)
        }
        skipAnimation={skipAnimation}
      />

      <FilterCombobox
        label="Plan"
        value={selectedPlanId?.toString() || ""}
        placeholder="Plan de estudios"
        items={plans}
        onChange={(val) => {
          setSkipAnimation(false);
          onPlanChange(val ? parseInt(val) : null);
        }}
        isVisible={showPlanFilter}
        itemLabel={(item) =>
          item.external_plan_id !== undefined
            ? `${item.external_plan_id}: ${removePlanPrefixFromName(item.name, item.external_plan_id)}`
            : normalizeText(item.name)
        }
        skipAnimation={skipAnimation}
      />
    </FiltersPanel>
  );
}
