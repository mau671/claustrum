import { useEffect, useMemo, useState } from "react";

import type {
  CatalogUniversity,
  CatalogCampus,
  CatalogCareerProgram,
  CatalogStudyPlan,
  AcademicTerm,
} from "@/lib/types";

import { FiltersPanel } from "@/components/filters/filters-panel";
import { Button } from "@/components/ui/button";
import {
  Combobox,
  ComboboxCollection,
  ComboboxContent,
  ComboboxEmpty,
  ComboboxGroup,
  ComboboxInput,
  ComboboxItem,
  ComboboxLabel,
  ComboboxList,
  ComboboxSeparator,
  ComboboxTrigger,
} from "@/components/ui/combobox";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import {
  formatClosedTermLabel,
  formatTermNameWithoutYear,
  groupTermsByYear,
} from "@/lib/academic-terms";
import { cn } from "@/lib/utils";

interface ScheduleFiltersProps {
  universities: CatalogUniversity[];
  campuses: CatalogCampus[];
  careers: CatalogCareerProgram[];
  plans: CatalogStudyPlan[];
  terms: AcademicTerm[];
  selectedUniversityId: number | null;
  selectedCampusId: number | null;
  selectedCareerId: number | null;
  selectedPlanId: number | null;
  selectedTermId: number | null;
  onUniversityChange: (id: number | null) => void;
  onCampusChange: (id: number | null) => void;
  onCareerChange: (id: number | null) => void;
  onPlanChange: (id: number | null) => void;
  onTermChange: (id: number | null) => void;
  isLoadingUniversities: boolean;
  isLoadingCampuses?: boolean;
  isLoadingCareers: boolean;
  isLoadingPlans: boolean;
  isLoadingTerms: boolean;
  showAll?: boolean;
  onShowAllChange?: (checked: boolean) => void;
  showAllDisabled?: boolean;
  showAllDisabledTooltip?: string;
  showOtherCampuses?: boolean;
  onShowOtherCampusesChange?: (checked: boolean) => void;
  isVisible?: boolean;
  onVisibleChange?: (visible: boolean) => void;
}

import {
  FilterCombobox,
  normalizeText,
  removePlanPrefixFromName,
} from "@/components/filters/shared-filters";

export function ScheduleFilters({
  universities,
  campuses,
  careers,
  plans,
  terms,
  selectedUniversityId,
  selectedCampusId,
  selectedCareerId,
  selectedPlanId,
  selectedTermId,
  onUniversityChange,
  onCampusChange,
  onCareerChange,
  onPlanChange,
  onTermChange,
  isLoadingUniversities,
  isLoadingCampuses = false,
  isLoadingCareers,
  isLoadingPlans,
  isLoadingTerms,
  showAll,
  onShowAllChange,
  showAllDisabled = false,
  showAllDisabledTooltip,
  showOtherCampuses,
  onShowOtherCampusesChange,
  isVisible = true,
  onVisibleChange,
}: ScheduleFiltersProps) {
  const hasUniversities = universities.length > 0;
  const shouldShowUniversityFilter = universities.length > 1;
  const canSelectCampus = shouldShowUniversityFilter ? !!selectedUniversityId : hasUniversities;

  const isUniversityFilterReady = shouldShowUniversityFilter && !isLoadingUniversities;
  const isCampusFilterReady = canSelectCampus && !isLoadingCampuses;
  const isCareerFilterReady = !!selectedCampusId && !isLoadingCareers;
  const isPlanFilterReady = !!selectedCareerId && !isLoadingPlans;
  const isTermFilterReady = !!selectedPlanId && !isLoadingTerms;

  const showUniversityFilter = isUniversityFilterReady;
  const showCampusFilter = isCampusFilterReady;
  const showCareerFilter = isCareerFilterReady;
  const showPlanFilter = isPlanFilterReady;
  const showTermFilter = isTermFilterReady;
  const showSwitches = !!selectedTermId;

  const [skipUniversityAnimation, setSkipUniversityAnimation] = useState(
    () => showUniversityFilter,
  );
  const [skipCampusAnimation, setSkipCampusAnimation] = useState(() => showCampusFilter);
  const [skipGroupsAnimation, setSkipGroupsAnimation] = useState(
    () => showCareerFilter || showPlanFilter || showTermFilter,
  );
  const [skipSwitchesAnimation, setSkipSwitchesAnimation] = useState(() => showSwitches);

  useEffect(() => {
    if (!showUniversityFilter) setSkipUniversityAnimation(false);
  }, [showUniversityFilter]);

  useEffect(() => {
    if (!showCampusFilter) setSkipCampusAnimation(false);
  }, [showCampusFilter]);

  useEffect(() => {
    if (!(showCareerFilter || showPlanFilter || showTermFilter)) {
      setSkipGroupsAnimation(false);
    }
  }, [showCareerFilter, showPlanFilter, showTermFilter]);

  useEffect(() => {
    if (!showSwitches) {
      setSkipSwitchesAnimation(false);
    }
  }, [showSwitches]);
  const isShowAllDisabled = showAllDisabled;
  const termGroups = useMemo(() => groupTermsByYear(terms), [terms]);
  const selectedTerm = terms.find((term) => term.id === selectedTermId) ?? null;

  const showAllControl = (
    <div className="flex shrink-0 items-center gap-2">
      <Switch
        id="showAll"
        checked={showAll ?? true}
        onCheckedChange={onShowAllChange}
        disabled={isShowAllDisabled}
      />
      <Label htmlFor="showAll" className="cursor-pointer text-xs font-normal">
        Todos los cursos
      </Label>
    </div>
  );

  return (
    <FiltersPanel
      isExpanded={isVisible}
      onExpandedChange={onVisibleChange ?? (() => {})}
      className="w-full"
    >
      <FilterCombobox
        label="Universidad"
        value={selectedUniversityId?.toString() || ""}
        placeholder="Universidad"
        items={universities}
        onChange={(val) => onUniversityChange(val ? parseInt(val) : null)}
        isVisible={showUniversityFilter}
        skipAnimation={skipUniversityAnimation}
      />

      <FilterCombobox
        label="Sede"
        value={selectedCampusId?.toString() || ""}
        placeholder="Sede"
        items={campuses}
        onChange={(val) => onCampusChange(val ? parseInt(val) : null)}
        isVisible={showCampusFilter}
        itemLabel={(item) =>
          item.code
            ? `${normalizeText(item.code)}: ${normalizeText(item.name)}`
            : normalizeText(item.name)
        }
        skipAnimation={skipCampusAnimation}
      />

      <FilterCombobox
        label="Carrera"
        value={selectedCareerId?.toString() || ""}
        placeholder="Carrera"
        items={careers}
        onChange={(val) => onCareerChange(val ? parseInt(val) : null)}
        isVisible={showCareerFilter}
        itemLabel={(item) =>
          item.code
            ? `${normalizeText(item.code)}: ${normalizeText(item.name)}`
            : normalizeText(item.name)
        }
        skipAnimation={skipGroupsAnimation}
      />

      <FilterCombobox
        label="Plan"
        value={selectedPlanId?.toString() || ""}
        placeholder="Plan de estudios"
        items={plans}
        onChange={(val) => onPlanChange(val ? parseInt(val) : null)}
        isVisible={showPlanFilter}
        itemLabel={(item) =>
          item.external_plan_id !== undefined
            ? `${item.external_plan_id}: ${removePlanPrefixFromName(item.name, item.external_plan_id)}`
            : normalizeText(item.name)
        }
        skipAnimation={skipGroupsAnimation}
      />

      {showTermFilter && (
        <div
          className={cn(
            "min-w-0 shrink-0",
            !skipGroupsAnimation && "animate-in fade-in-0 slide-in-from-left-2 duration-300",
          )}
        >
          {terms.length === 0 ? (
            <Button
              variant="outline"
              disabled
              className="text-muted-foreground h-8 w-full min-w-0 justify-between text-xs font-normal sm:max-w-[360px] sm:min-w-[240px]"
            >
              <span className="block min-w-0 flex-1 truncate text-left">Sin oferta disponible</span>
            </Button>
          ) : (
            <Combobox
              items={termGroups}
              value={selectedTerm}
              onValueChange={(term) => onTermChange(term ? term.id : null)}
              itemToStringValue={(term) => formatTermNameWithoutYear(term.display_name)}
            >
              <ComboboxTrigger
                render={
                  <Button
                    variant="outline"
                    className="h-8 w-full min-w-0 justify-between text-xs font-normal sm:max-w-[360px] sm:min-w-[240px]"
                  />
                }
              >
                <span
                  className={`block min-w-0 flex-1 truncate text-left ${!selectedTerm ? "text-muted-foreground" : ""}`}
                >
                  {selectedTerm ? formatClosedTermLabel(selectedTerm) : "Período académico"}
                </span>
              </ComboboxTrigger>
              <ComboboxContent className="w-(--anchor-width) min-w-(--anchor-width)">
                <ComboboxInput showTrigger={false} placeholder="Buscar período" />
                <ComboboxEmpty>No se encontraron resultados.</ComboboxEmpty>
                <ComboboxList className="max-h-56 scrollbar-none">
                  {(group, index) => (
                    <ComboboxGroup key={group.value} items={group.items}>
                      <ComboboxLabel>{group.value}</ComboboxLabel>
                      <ComboboxCollection>
                        {(term) => (
                          <ComboboxItem key={term.id} value={term}>
                            <span className="block w-full min-w-0 truncate">
                              {formatTermNameWithoutYear(term.display_name)}
                            </span>
                          </ComboboxItem>
                        )}
                      </ComboboxCollection>
                      {index < termGroups.length - 1 && <ComboboxSeparator />}
                    </ComboboxGroup>
                  )}
                </ComboboxList>
              </ComboboxContent>
            </Combobox>
          )}
        </div>
      )}

      {showSwitches &&
        (onShowAllChange !== undefined || onShowOtherCampusesChange !== undefined) && (
          <div
            className={cn(
              "flex shrink-0 flex-nowrap items-center gap-x-4 gap-y-2",
              !skipSwitchesAnimation && "animate-in fade-in-0 slide-in-from-left-2 duration-300",
            )}
          >
            {onShowAllChange !== undefined &&
              (isShowAllDisabled && showAllDisabledTooltip ? (
                <Tooltip>
                  <TooltipTrigger asChild>
                    <div>{showAllControl}</div>
                  </TooltipTrigger>
                  <TooltipContent side="top">
                    <p>{showAllDisabledTooltip}</p>
                  </TooltipContent>
                </Tooltip>
              ) : (
                showAllControl
              ))}

            {onShowOtherCampusesChange !== undefined && (
              <div className="flex shrink-0 items-center gap-2">
                <Switch
                  id="otherCampuses"
                  checked={showOtherCampuses ?? false}
                  onCheckedChange={onShowOtherCampusesChange}
                />
                <Label htmlFor="otherCampuses" className="cursor-pointer text-xs font-normal">
                  Todas las sedes
                </Label>
              </div>
            )}
          </div>
        )}
    </FiltersPanel>
  );
}
