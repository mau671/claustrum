import { useState, useEffect, type ReactNode } from "react";

import type {
  CatalogUniversity,
  CatalogCampus,
  CatalogCareerProgram,
  CatalogStudyPlan,
} from "@/lib/types";

import { FiltersPanel } from "@/components/filters/filters-panel";
import { normalizeText, removePlanPrefixFromName } from "@/components/filters/shared-filters";
import { SearchableCombobox } from "@/components/ui/searchable-combobox";
import { cn } from "@/lib/utils";

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
  actions?: ReactNode;
  isVisible?: boolean;
  onVisibleChange?: (visible: boolean) => void;
  className?: string;
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
  actions,
  className,
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
    <FiltersPanel
      isExpanded={isVisible}
      onExpandedChange={onVisibleChange ?? (() => {})}
      actions={actions}
      variant="plain"
      className={cn("w-full", className)}
    >
      {showUniversityFilter && (
        <div
          className={cn(
            "relative min-w-0 shrink-0",
            !skipAnimation && "animate-in fade-in-0 slide-in-from-left-2 duration-300",
          )}
        >
          <SearchableCombobox
            label="Universidad"
            placeholder="Universidad"
            items={universities}
            value={universities.find((item) => item.id === selectedUniversityId) ?? null}
            onValueChange={(item) => {
              setSkipAnimation(false);
              onUniversityChange(item ? item.id : null);
            }}
            itemToString={(item) => item.name}
            clearable
          />
        </div>
      )}

      {showCampusFilter && (
        <div
          className={cn(
            "relative min-w-0 shrink-0",
            !skipAnimation && "animate-in fade-in-0 slide-in-from-left-2 duration-300",
          )}
        >
          <SearchableCombobox
            label="Sede"
            placeholder="Sede"
            items={campuses}
            value={campuses.find((item) => item.id === selectedCampusId) ?? null}
            onValueChange={(item) => {
              setSkipAnimation(false);
              onCampusChange(item ? item.id : null);
            }}
            itemToString={(item) =>
              item.code
                ? `${normalizeText(item.code)}: ${normalizeText(item.name)}`
                : normalizeText(item.name)
            }
            clearable
          />
        </div>
      )}

      {showCareerFilter && (
        <div
          className={cn(
            "relative min-w-0 shrink-0",
            !skipAnimation && "animate-in fade-in-0 slide-in-from-left-2 duration-300",
          )}
        >
          <SearchableCombobox
            label="Carrera"
            placeholder="Carrera"
            items={careerPrograms}
            value={careerPrograms.find((item) => item.id === selectedCareerProgramId) ?? null}
            onValueChange={(item) => {
              setSkipAnimation(false);
              onCareerProgramChange(item ? item.id : null);
            }}
            itemToString={(item) =>
              item.code
                ? `${normalizeText(item.code)}: ${normalizeText(item.name)}`
                : normalizeText(item.name)
            }
            clearable
          />
        </div>
      )}

      {showPlanFilter && (
        <div
          className={cn(
            "relative min-w-0 shrink-0",
            !skipAnimation && "animate-in fade-in-0 slide-in-from-left-2 duration-300",
          )}
        >
          <SearchableCombobox
            label="Plan"
            placeholder="Plan de estudios"
            items={plans}
            value={plans.find((item) => item.id === selectedPlanId) ?? null}
            onValueChange={(item) => {
              setSkipAnimation(false);
              onPlanChange(item ? item.id : null);
            }}
            itemToString={(item) =>
              item.external_plan_id !== undefined
                ? `${item.external_plan_id}: ${removePlanPrefixFromName(item.name, item.external_plan_id)}`
                : normalizeText(item.name)
            }
            clearable
          />
        </div>
      )}
    </FiltersPanel>
  );
}
