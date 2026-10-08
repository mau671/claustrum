import { useNavigate, useSearch } from "@tanstack/react-router";
import { AlertTriangle, User, Save, BookOpen } from "lucide-react";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";

import type { CatalogCampus, CatalogStudyPlan } from "@/lib/types";

import { MemoizedCurriculumBoard } from "@/components/curriculum/curriculum-board";
import { CurriculumFilters } from "@/components/curriculum/curriculum-filters";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Spinner } from "@/components/ui/spinner";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { useIsMobile } from "@/hooks/use-mobile";
import { sortTermsLogical } from "@/lib/academic-terms";
import { useActiveStudyPlan } from "@/lib/hooks/use-active-study-plan";
import {
  useUniversities,
  useCampuses,
  useAcademicUnits,
  useStudyPlans,
  useStudyPlanDetail,
  useAcademicTerms,
  useSuggestedAcademicTerm,
} from "@/lib/hooks/use-queries";
import { saveLocalStudyPlan } from "@/lib/store/local-study-plan";

import {
  CURRICULUM_DEFAULT_UNIVERSITY_ID,
  isMeaningfulCurriculumSearch,
  normalizeCurriculumUniversityId,
} from "./-curriculum-search";

const MAIN_CAMPUS_CODES = new Set(["AL", "CA", "LM", "SC", "SJ"]);

export function CurriculumPage() {
  const search = useSearch({ from: "/curriculum/" });
  const navigate = useNavigate({ from: "/curriculum/" });
  const isMobile = useIsMobile();

  const selectedUniversityId = search.university ?? CURRICULUM_DEFAULT_UNIVERSITY_ID;
  const selectedCampusId = search.campus ?? null;
  const selectedAcademicUnitId = search.career ?? null;
  const selectedPlanId = search.plan ?? null;
  const hasMeaningfulSearch = isMeaningfulCurriculumSearch(search);
  const [isUsingProfileDefaults, setIsUsingProfileDefaults] = useState(() => !hasMeaningfulSearch);
  const shouldAutoSelectPlanRef = useRef(false);
  const lastAppliedPlanRef = useRef<typeof userStudyPlan | null>(null);

  const filtersOpen = search.filters ?? !hasMeaningfulSearch;

  const handleFiltersChange = useCallback(
    (open: boolean) => {
      void navigate({
        to: "/curriculum",
        search: {
          ...search,
          filters: open,
        },
        replace: true,
        resetScroll: false,
      });
    },
    [navigate, search],
  );

  const { data: universities, isLoading: isLoadingUniversities } = useUniversities();
  const campusesQuery = useCampuses(selectedUniversityId);
  const academicUnitsQuery = useAcademicUnits(selectedCampusId);
  const plansQuery = useStudyPlans(selectedAcademicUnitId);

  const selectedPlanData = plansQuery.data?.find((p: CatalogStudyPlan) => p.id === selectedPlanId);

  const planDetailQuery = useStudyPlanDetail(selectedPlanId, selectedPlanData);
  const termsQuery = useAcademicTerms(selectedCampusId, selectedPlanId);
  const terms = useMemo(() => sortTermsLogical(termsQuery.data ?? []), [termsQuery.data]);
  const suggestedTermQuery = useSuggestedAcademicTerm(selectedPlanId, !!selectedPlanId);
  const { activePlan: userStudyPlan, isLoading: isProfileLoading, authUser } = useActiveStudyPlan();
  const isAutoSelectingPlan =
    shouldAutoSelectPlanRef.current &&
    !!selectedAcademicUnitId &&
    !selectedPlanId &&
    (plansQuery.isFetching || (plansQuery.data?.length ?? 0) > 0);
  const isPendingFilters = isProfileLoading || isAutoSelectingPlan;
  const userStudyPlanUniversityId = userStudyPlan?.universityId ?? CURRICULUM_DEFAULT_UNIVERSITY_ID;

  const campuses = campusesQuery.data ?? [];
  const academicUnits = academicUnitsQuery.data ?? [];
  const plans = plansQuery.data ?? [];

  const mainCampuses = useMemo(
    () => campuses.filter((c: CatalogCampus) => MAIN_CAMPUS_CODES.has(c.code)),
    [campuses],
  );
  const isAutoSelectingLatestPlan =
    shouldAutoSelectPlanRef.current &&
    !!selectedAcademicUnitId &&
    !selectedPlanId &&
    plans.length > 0;
  const isLoadingPlansForFilters =
    (plansQuery.isFetching && plansQuery.data?.length === 0) || isAutoSelectingLatestPlan;

  useEffect(() => {
    if (!userStudyPlan) return;
    if (lastAppliedPlanRef.current === userStudyPlan) return;

    const hasAnySearch =
      hasMeaningfulSearch || !!selectedCampusId || !!selectedAcademicUnitId || !!selectedPlanId;
    const isEmptySearch = !hasMeaningfulSearch;

    // Case 1: no params at all → load full profile
    if (isEmptySearch) {
      lastAppliedPlanRef.current = userStudyPlan;
      setIsUsingProfileDefaults(true);
      void navigate({
        to: "/curriculum",
        search: {
          university: normalizeCurriculumUniversityId(userStudyPlan.universityId),
          u: normalizeCurriculumUniversityId(userStudyPlan.universityId),
          campus: userStudyPlan.campusId ?? undefined,
          c: userStudyPlan.campusId ?? undefined,
          career: userStudyPlan.academicUnitId ?? undefined,
          r: userStudyPlan.academicUnitId ?? undefined,
          plan: userStudyPlan.studyPlanId ?? undefined,
          p: userStudyPlan.studyPlanId ?? undefined,
        } as never,
        replace: true,
      });
      return;
    }

    // Case 2: some params exist, university matches profile, but missing campus/career/plan
    // → fill in the missing ones from profile
    if (
      hasAnySearch &&
      isUsingProfileDefaults &&
      selectedUniversityId === userStudyPlanUniversityId
    ) {
      const missingCampus = !selectedCampusId && userStudyPlan.campusId;
      const missingCareer = !selectedAcademicUnitId && userStudyPlan.academicUnitId;
      const missingPlan = !selectedPlanId && userStudyPlan.studyPlanId;

      if (missingCampus || missingCareer || missingPlan) {
        lastAppliedPlanRef.current = userStudyPlan;
        setIsUsingProfileDefaults(true);
        void navigate({
          to: "/curriculum",
          search: {
            ...search,
            campus: selectedCampusId ?? userStudyPlan.campusId ?? undefined,
            c: selectedCampusId ?? userStudyPlan.campusId ?? undefined,
            career: selectedAcademicUnitId ?? userStudyPlan.academicUnitId ?? undefined,
            r: selectedAcademicUnitId ?? userStudyPlan.academicUnitId ?? undefined,
            plan: selectedPlanId ?? userStudyPlan.studyPlanId ?? undefined,
            p: selectedPlanId ?? userStudyPlan.studyPlanId ?? undefined,
          } as never,
          replace: true,
        });
        return;
      }
    }

    lastAppliedPlanRef.current = userStudyPlan;
  }, [
    userStudyPlan,
    isUsingProfileDefaults,
    selectedUniversityId,
    selectedCampusId,
    selectedAcademicUnitId,
    selectedPlanId,
    navigate,
    search,
    hasMeaningfulSearch,
    userStudyPlanUniversityId,
  ]);

  useEffect(() => {
    if (!userStudyPlan) return;
    const hasSearch = hasMeaningfulSearch;
    if (!hasSearch) {
      setIsUsingProfileDefaults(true);
      return;
    }

    const matchesProfile =
      selectedUniversityId === userStudyPlanUniversityId &&
      selectedCampusId === (userStudyPlan.campusId ?? null) &&
      selectedAcademicUnitId === (userStudyPlan.academicUnitId ?? null) &&
      selectedPlanId === (userStudyPlan.studyPlanId ?? null);

    setIsUsingProfileDefaults(matchesProfile);
  }, [search, userStudyPlan, selectedUniversityId, userStudyPlanUniversityId, hasMeaningfulSearch]);

  const handleUniversityChange = useCallback(
    (id: number | null) => {
      shouldAutoSelectPlanRef.current = false;
      setIsUsingProfileDefaults(false);
      void navigate({
        to: "/curriculum",
        search: (prev) => ({
          ...prev,
          u: normalizeCurriculumUniversityId(id),
          university: normalizeCurriculumUniversityId(id),
          filters: isMobile ? filtersOpen : undefined,
        }),
      });
    },
    [navigate, filtersOpen, isMobile],
  );

  const handleCampusChange = useCallback(
    (id: number | null) => {
      shouldAutoSelectPlanRef.current = false;
      setIsUsingProfileDefaults(false);
      void navigate({
        to: "/curriculum",
        search: (prev) => ({
          ...prev,
          c: id ?? undefined,
          campus: id ?? undefined,
          filters: isMobile ? filtersOpen : undefined,
        }),
      });
    },
    [navigate, filtersOpen, isMobile],
  );

  const handleAcademicUnitChange = useCallback(
    (id: number | null) => {
      shouldAutoSelectPlanRef.current = id !== null;
      setIsUsingProfileDefaults(false);
      void navigate({
        to: "/curriculum",
        search: (prev) => ({
          ...prev,
          r: id ?? undefined,
          career: id ?? undefined,
          p: undefined,
          plan: undefined,
          filters: isMobile ? filtersOpen : undefined,
        }),
      });
    },
    [navigate, filtersOpen, isMobile],
  );

  const handlePlanChange = useCallback(
    (id: number | null) => {
      shouldAutoSelectPlanRef.current = false;
      setIsUsingProfileDefaults(false);
      void navigate({
        to: "/curriculum",
        search: (prev) => ({
          ...prev,
          p: id ?? undefined,
          plan: id ?? undefined,
          filters: isMobile ? filtersOpen : undefined,
        }),
      });
    },
    [navigate, filtersOpen, isMobile],
  );

  const handleSaveLocalPlan = useCallback(() => {
    let termToSave = suggestedTermQuery.data ?? null;
    if (!termToSave && terms && terms.length > 0) {
      termToSave = terms[0].id;
    }

    saveLocalStudyPlan({
      universityId:
        selectedUniversityId === CURRICULUM_DEFAULT_UNIVERSITY_ID ? null : selectedUniversityId,
      campusId: selectedCampusId,
      academicUnitId: selectedAcademicUnitId,
      studyPlanId: selectedPlanId,
      termId: termToSave,
    });
  }, [
    selectedUniversityId,
    selectedCampusId,
    selectedAcademicUnitId,
    selectedPlanId,
    suggestedTermQuery.data,
    terms,
  ]);

  const handleUseProfileDefaults = useCallback(() => {
    if (!userStudyPlan) return;
    shouldAutoSelectPlanRef.current = false;
    setIsUsingProfileDefaults(true);

    const newSearch: Record<string, unknown> = {
      ...search,
      university: normalizeCurriculumUniversityId(userStudyPlan.universityId),
      u: normalizeCurriculumUniversityId(userStudyPlan.universityId),
      campus: userStudyPlan.campusId ?? undefined,
      c: userStudyPlan.campusId ?? undefined,
      career: userStudyPlan.academicUnitId ?? undefined,
      r: userStudyPlan.academicUnitId ?? undefined,
      plan: userStudyPlan.studyPlanId ?? undefined,
      p: userStudyPlan.studyPlanId ?? undefined,
    };

    void navigate({
      to: "/curriculum",
      search: newSearch as never,
    });
  }, [navigate, search, userStudyPlan]);

  useEffect(() => {
    if (!selectedCampusId) return;
    if (campusesQuery.isFetching) return;
    if (mainCampuses.some((c: CatalogCampus) => Number(c.id) === Number(selectedCampusId))) return;

    shouldAutoSelectPlanRef.current = false;
    const validateCampusSearch: Record<string, unknown> = {
      ...search,
      c: undefined,
      campus: undefined,
      r: undefined,
      career: undefined,
      p: undefined,
      plan: undefined,
    };
    void navigate({
      to: "/curriculum",
      search: validateCampusSearch as never,
    });
  }, [selectedCampusId, mainCampuses, campusesQuery.isFetching, navigate, search]);

  useEffect(() => {
    if (!selectedAcademicUnitId) return;
    if (academicUnitsQuery.isFetching) return;
    if (academicUnits.some((c) => c.id === selectedAcademicUnitId)) return;

    shouldAutoSelectPlanRef.current = false;
    const validateCareerSearch: Record<string, unknown> = {
      ...search,
      r: undefined,
      career: undefined,
      p: undefined,
      plan: undefined,
    };
    void navigate({
      to: "/curriculum",
      search: validateCareerSearch as never,
    });
  }, [selectedAcademicUnitId, academicUnits, academicUnitsQuery.isFetching, navigate, search]);

  useEffect(() => {
    if (!selectedPlanId) return;
    if (plansQuery.isFetching) return;
    if (plans.some((p) => p.id === selectedPlanId)) return;

    shouldAutoSelectPlanRef.current = true;
    const validatePlanSearch: Record<string, unknown> = {
      ...search,
      p: undefined,
      plan: undefined,
    };
    void navigate({
      to: "/curriculum",
      search: validatePlanSearch as never,
    });
  }, [selectedPlanId, plans, plansQuery.isFetching, navigate, search]);

  useEffect(() => {
    if (!shouldAutoSelectPlanRef.current) return;
    if (!selectedAcademicUnitId) return;
    if (selectedPlanId) {
      shouldAutoSelectPlanRef.current = false;
      return;
    }
    if (plansQuery.isFetching) return;
    if (!plans.length) {
      shouldAutoSelectPlanRef.current = false;
      return;
    }

    shouldAutoSelectPlanRef.current = false;
    const autoPlanSearch: Record<string, unknown> = {
      ...search,
      p: plans[0].id,
      plan: plans[0].id,
    };
    void navigate({
      to: "/curriculum",
      search: autoPlanSearch as never,
    });
  }, [navigate, plans, plansQuery.isFetching, search, selectedAcademicUnitId, selectedPlanId]);

  return (
    <div className="flex flex-1 flex-col">
      <div className="@container/main flex flex-1 flex-col gap-2">
        <div className="flex flex-1 flex-col gap-4 py-4 md:gap-6 md:py-6">
          <header className="sr-only">
            <h1>Plan de estudios TEC</h1>
            <p>
              Consulta planes de estudio del TEC por sede, carrera y plan. Revisa cursos,
              requisitos, correquisitos, equivalencias y avance academico para entender mejor tu
              malla curricular.
            </p>
          </header>

          <div className="px-4 lg:px-6">
            <div className="flex flex-col gap-3 md:flex-row md:items-center">
              <div className="min-w-0 flex-1">
                <CurriculumFilters
                  universities={universities ?? []}
                  campuses={mainCampuses}
                  careerPrograms={academicUnits}
                  plans={plans}
                  selectedUniversityId={selectedUniversityId}
                  selectedCampusId={selectedCampusId}
                  selectedCareerProgramId={selectedAcademicUnitId}
                  selectedPlanId={selectedPlanId}
                  onUniversityChange={handleUniversityChange}
                  onCampusChange={handleCampusChange}
                  onCareerProgramChange={handleAcademicUnitChange}
                  onPlanChange={handlePlanChange}
                  isLoadingUniversities={isLoadingUniversities}
                  isLoadingCampuses={campusesQuery.isFetching && campusesQuery.data?.length === 0}
                  isLoadingCareerPrograms={
                    academicUnitsQuery.isFetching && academicUnitsQuery.data?.length === 0
                  }
                  isLoadingPlans={isLoadingPlansForFilters}
                  canUseProfileDefaults={!!authUser && !!userStudyPlan}
                  isUsingProfileDefaults={isUsingProfileDefaults}
                  onUseProfileDefaults={handleUseProfileDefaults}
                  isVisible={filtersOpen}
                  onVisibleChange={handleFiltersChange}
                />
              </div>
              {!!authUser && !!userStudyPlan && (
                <Button
                  type="button"
                  variant={isUsingProfileDefaults ? "secondary" : "outline"}
                  size="sm"
                  onClick={handleUseProfileDefaults}
                  disabled={isUsingProfileDefaults}
                  className="h-8 shrink-0 gap-1.5 text-xs"
                >
                  <User className="size-3.5" />
                  {isUsingProfileDefaults ? "Perfil activo" : "Usar mi perfil"}
                </Button>
              )}
              {!authUser && (
                <Tooltip>
                  <TooltipTrigger asChild>
                    <Button
                      type="button"
                      variant={isUsingProfileDefaults ? "secondary" : "outline"}
                      size="sm"
                      onClick={handleSaveLocalPlan}
                      onPointerDown={(e) => e.preventDefault()}
                      disabled={isUsingProfileDefaults}
                      className="h-8 shrink-0 gap-1.5 text-xs"
                    >
                      <Save className="size-3.5" />
                      {isUsingProfileDefaults ? "Guardado" : "Guardar"}
                    </Button>
                  </TooltipTrigger>
                  <TooltipContent>Solo se guarda en este dispositivo</TooltipContent>
                </Tooltip>
              )}
            </div>
          </div>

          {planDetailQuery.isError && (
            <div className="flex flex-1 px-4 lg:px-6">
              <EmptyState
                title="Error al cargar el plan de estudios"
                description={
                  planDetailQuery.error instanceof Error
                    ? planDetailQuery.error.message
                    : "Ocurrió un problema de conexión o el plan no existe. Intenta de nuevo."
                }
                icon={AlertTriangle}
                variant="error"
              />
            </div>
          )}

          {selectedPlanId && planDetailQuery.isLoading && (
            <div className="flex flex-1 px-4 lg:px-6">
              <Card className="flex min-h-[45svh] w-full items-center justify-center p-6 md:min-h-96">
                <Spinner className="text-muted-foreground size-6" />
              </Card>
            </div>
          )}

          {selectedPlanId && planDetailQuery.isSuccess && planDetailQuery.data && (
            <div className="min-h-0 flex-1 px-4 lg:px-6">
              <Card className="h-full min-h-0 overflow-auto py-0">
                <MemoizedCurriculumBoard planDetail={planDetailQuery.data} />
              </Card>
            </div>
          )}

          {isPendingFilters && !selectedPlanId && (
            <div className="flex flex-1 px-4 lg:px-6">
              <Card className="flex min-h-[45svh] w-full items-center justify-center p-6 md:min-h-96">
                <Spinner className="text-muted-foreground size-6" />
              </Card>
            </div>
          )}

          {!selectedPlanId && !planDetailQuery.isLoading && !isPendingFilters && (
            <div className="flex flex-1 px-4 lg:px-6">
              <EmptyState
                title="Busca un plan de estudios"
                description="Selecciona una sede y una carrera para visualizar la malla curricular correspondiente."
                icon={BookOpen}
              />
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
