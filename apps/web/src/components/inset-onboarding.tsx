import { Loading02Icon, Search01Icon, UnfoldMoreIcon } from "@hugeicons/core-free-icons";
import { useQueryClient } from "@tanstack/react-query";
import { useNavigate } from "@tanstack/react-router";
import { useCallback, useMemo, useState } from "react";

import { AuthLeftPanel, AuthPageBackdrop } from "@/components/inset-auth";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import {
  Combobox,
  ComboboxContent,
  ComboboxEmpty,
  ComboboxInput,
  ComboboxItem,
  ComboboxList,
  ComboboxTrigger,
} from "@/components/ui/combobox";
import { Icon } from "@/components/ui/icon";
import { Input } from "@/components/ui/input";
import { Stepper, type StepperStep } from "@/components/ui/stepper";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { authClient } from "@/lib/auth/client";
import {
  useAcademicUnits,
  useAuthUser,
  useCampuses,
  useStudyPlans,
  useUniversities,
} from "@/lib/hooks/use-queries";
import { cn } from "@/lib/utils";

const TOTAL_STEPS = 4;
const MAIN_CAMPUS_CODES = new Set(["AL", "CA", "LM", "SC", "SJ"]);

export function InsetOnboardingPage() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const { data: authUser, isLoading: isAuthLoading } = useAuthUser();
  const { data: universities } = useUniversities();

  const defaultUniversity = useMemo(() => {
    const tec = (universities ?? []).find((u) => u.name.toLowerCase().includes("tecnologico"));
    return tec ?? universities?.[0] ?? null;
  }, [universities]);

  const [step, setStep] = useState(1);
  const [campusId, setCampusId] = useState("");
  const [academicUnitId, setAcademicUnitId] = useState("");
  const [studyPlanId, setStudyPlanId] = useState("");
  const [carnet, setCarnet] = useState("");
  const [isSaving, setIsSaving] = useState(false);
  const [submitError, setSubmitError] = useState<string | null>(null);
  const [showStepError, setShowStepError] = useState(false);

  const campuses = useCampuses(defaultUniversity?.id ?? null);
  const academicUnits = useAcademicUnits(campusId ? Number(campusId) : null);
  const studyPlans = useStudyPlans(academicUnitId ? Number(academicUnitId) : null);

  const skipForNow = () => {
    void (async () => {
      if (!authUser) return;
      await authClient.$fetch("/onboarding/dismiss", { method: "POST" });
      await queryClient.invalidateQueries({ queryKey: ["appState"] });
      void navigate({ to: "/overview" });
    })();
  };

  const nextStep = () => {
    setSubmitError(null);
    if (isNextDisabled) {
      setShowStepError(true);
      return;
    }
    setShowStepError(false);
    setStep((prev) => Math.min(TOTAL_STEPS, prev + 1));
  };

  const prevStep = () => {
    setSubmitError(null);
    setShowStepError(false);
    setStep((prev) => Math.max(1, prev - 1));
  };

  const finishOnboarding = useCallback(async () => {
    if (!authUser) return;
    if (!campusId || !academicUnitId || !studyPlanId) {
      setShowStepError(true);
      return;
    }

    setIsSaving(true);
    setSubmitError(null);

    try {
      const parsedCampusId = Number(campusId);
      const parsedStudyPlanId = Number(studyPlanId);
      const entryYear = carnet ? parseInt(carnet.substring(0, 4), 10) : null;

      const response = await authClient.$fetch("/onboarding/submit", {
        method: "POST",
        body: {
          campusId: parsedCampusId,
          academicUnitId: Number(academicUnitId),
          studyPlanId: parsedStudyPlanId,
          entryYear,
          carnet,
        },
      });

      if (response.error) {
        throw new Error(response.error.message || "No se pudo guardar el onboarding.");
      }

      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ["appState"] }),
        queryClient.invalidateQueries({ queryKey: ["dashboardStats", authUser.id] }),
      ]);
      void navigate({ to: "/overview" });
    } catch (err) {
      setSubmitError(err instanceof Error ? err.message : "No se pudo guardar el onboarding.");
    } finally {
      setIsSaving(false);
    }
  }, [academicUnitId, authUser, campusId, carnet, navigate, queryClient, studyPlanId]);

  const isNextDisabled =
    (step === 1 && !campusId) || (step === 2 && !academicUnitId) || (step === 3 && !studyPlanId);

  const currentStepError =
    step === 1
      ? "Selecciona una sede."
      : step === 2
        ? "Selecciona una carrera."
        : step === 3
          ? "Selecciona un plan de estudios."
          : null;

  const showCampusError = showStepError && step === 1 && !campusId;
  const showAcademicUnitError = showStepError && step === 2 && !academicUnitId;
  const showStudyPlanError = showStepError && step === 3 && !studyPlanId;

  const mainCampuses = useMemo(
    () => (campuses.data ?? []).filter((c) => MAIN_CAMPUS_CODES.has(c.code)),
    [campuses.data],
  );

  const selectedCampus = useMemo(
    () => mainCampuses.find((c) => String(c.id) === campusId) ?? null,
    [mainCampuses, campusId],
  );
  const selectedAcademicUnit = useMemo(
    () => (academicUnits.data ?? []).find((a) => String(a.id) === academicUnitId) ?? null,
    [academicUnits.data, academicUnitId],
  );
  const selectedStudyPlan = useMemo(
    () => (studyPlans.data ?? []).find((p) => String(p.id) === studyPlanId) ?? null,
    [studyPlans.data, studyPlanId],
  );

  const onboardingSteps: StepperStep[] = useMemo(
    () => [
      {
        id: "campus",
        label: "Sede",
        summary: selectedCampus
          ? selectedCampus.code
            ? `${selectedCampus.code}: ${selectedCampus.name}`
            : selectedCampus.name
          : undefined,
        error: showCampusError ? (currentStepError ?? undefined) : undefined,
        content: (
          <Combobox
            items={mainCampuses}
            value={selectedCampus}
            onValueChange={(item) => {
              const value = item ? String(item.id) : "";
              setCampusId(value);
              setAcademicUnitId("");
              setStudyPlanId("");
              setShowStepError(false);
              if (value) {
                setStep(2);
              }
            }}
            itemToStringValue={(item) => (item.code ? `${item.code}: ${item.name}` : item.name)}
          >
            <ComboboxTrigger
              aria-label={
                selectedCampus
                  ? `Sede: ${selectedCampus.code ? `${selectedCampus.code}: ${selectedCampus.name}` : selectedCampus.name}`
                  : "Selecciona una sede"
              }
              render={
                <Button
                  variant="outline"
                  aria-label={
                    selectedCampus
                      ? `Sede: ${selectedCampus.code ? `${selectedCampus.code}: ${selectedCampus.name}` : selectedCampus.name}`
                      : "Selecciona una sede"
                  }
                  className={cn(
                    "!h-10 w-full justify-between text-sm font-normal",
                    showCampusError &&
                      "border-destructive text-destructive ring-destructive/40 ring-1",
                  )}
                />
              }
            >
              <span
                className={cn(
                  "block min-w-0 flex-1 truncate text-left",
                  !campusId && "text-muted-foreground",
                )}
              >
                {selectedCampus
                  ? selectedCampus.code
                    ? `${selectedCampus.code}: ${selectedCampus.name}`
                    : selectedCampus.name
                  : "Selecciona una sede"}
              </span>
              <Icon
                icon={UnfoldMoreIcon}
                size={14}
                className="-me-1! size-3.5 shrink-0 opacity-60"
              />
            </ComboboxTrigger>
            <ComboboxContent
              aria-label="Sede"
              className="w-[var(--anchor-width)] min-w-[var(--anchor-width)]"
            >
              <div className="border-b p-2">
                <ComboboxInput
                  className="rounded-md before:rounded-[calc(var(--radius-md)-1px)]"
                  placeholder="Buscar sede..."
                  showTrigger={false}
                  startAddon={<Icon icon={Search01Icon} size={16} />}
                />
              </div>
              <ComboboxEmpty>No se encontraron resultados.</ComboboxEmpty>
              <ComboboxList className="max-h-56 scrollbar-none">
                {(item) => (
                  <ComboboxItem key={item.id} value={item}>
                    <span className="block w-full min-w-0 truncate">
                      {item.code ? `${item.code}: ${item.name}` : item.name}
                    </span>
                  </ComboboxItem>
                )}
              </ComboboxList>
            </ComboboxContent>
          </Combobox>
        ),
      },
      {
        id: "career",
        label: "Carrera",
        summary: selectedAcademicUnit
          ? selectedAcademicUnit.code
            ? `${selectedAcademicUnit.code}: ${selectedAcademicUnit.name}`
            : selectedAcademicUnit.name
          : undefined,
        error: showAcademicUnitError ? (currentStepError ?? undefined) : undefined,
        content: (
          <Combobox
            items={academicUnits.data ?? []}
            value={selectedAcademicUnit}
            onValueChange={(item) => {
              const value = item ? String(item.id) : "";
              setAcademicUnitId(value);
              setStudyPlanId("");
              setShowStepError(false);
              if (value) {
                setStep(3);
              }
            }}
            itemToStringValue={(item) => (item.code ? `${item.code}: ${item.name}` : item.name)}
          >
            <ComboboxTrigger
              aria-label={
                selectedAcademicUnit
                  ? `Carrera: ${selectedAcademicUnit.code ? `${selectedAcademicUnit.code}: ${selectedAcademicUnit.name}` : selectedAcademicUnit.name}`
                  : "Selecciona una carrera"
              }
              render={
                <Button
                  variant="outline"
                  aria-label={
                    selectedAcademicUnit
                      ? `Carrera: ${selectedAcademicUnit.code ? `${selectedAcademicUnit.code}: ${selectedAcademicUnit.name}` : selectedAcademicUnit.name}`
                      : "Selecciona una carrera"
                  }
                  className={cn(
                    "!h-10 w-full justify-between text-sm font-normal",
                    showAcademicUnitError &&
                      "border-destructive text-destructive ring-destructive/40 ring-1",
                  )}
                />
              }
            >
              <span
                className={cn(
                  "block min-w-0 flex-1 truncate text-left",
                  !academicUnitId && "text-muted-foreground",
                )}
              >
                {selectedAcademicUnit
                  ? selectedAcademicUnit.code
                    ? `${selectedAcademicUnit.code}: ${selectedAcademicUnit.name}`
                    : selectedAcademicUnit.name
                  : "Selecciona una carrera"}
              </span>
              <Icon
                icon={UnfoldMoreIcon}
                size={14}
                className="-me-1! size-3.5 shrink-0 opacity-60"
              />
            </ComboboxTrigger>
            <ComboboxContent
              aria-label="Carrera"
              className="w-[var(--anchor-width)] min-w-[var(--anchor-width)]"
            >
              <div className="border-b p-2">
                <ComboboxInput
                  className="rounded-md before:rounded-[calc(var(--radius-md)-1px)]"
                  placeholder="Buscar carrera..."
                  showTrigger={false}
                  startAddon={<Icon icon={Search01Icon} size={16} />}
                />
              </div>
              <ComboboxEmpty>No se encontraron resultados.</ComboboxEmpty>
              <ComboboxList className="max-h-56 scrollbar-none">
                {(item) => (
                  <ComboboxItem key={item.id} value={item}>
                    <span className="block w-full min-w-0 truncate">
                      {item.code ? `${item.code}: ${item.name}` : item.name}
                    </span>
                  </ComboboxItem>
                )}
              </ComboboxList>
            </ComboboxContent>
          </Combobox>
        ),
      },
      {
        id: "plan",
        label: "Plan de estudios",
        summary: selectedStudyPlan
          ? selectedStudyPlan.external_plan_id
            ? `${selectedStudyPlan.external_plan_id}: ${selectedStudyPlan.name}`
            : selectedStudyPlan.name
          : undefined,
        error: showStudyPlanError ? (currentStepError ?? undefined) : undefined,
        content: (
          <Combobox
            items={studyPlans.data ?? []}
            value={selectedStudyPlan}
            onValueChange={(item) => {
              const value = item ? String(item.id) : "";
              setStudyPlanId(value);
              setShowStepError(false);
              if (value) {
                setStep(4);
              }
            }}
            itemToStringValue={(item) =>
              item.external_plan_id
                ? `${item.external_plan_id}: ${item.name.replace(new RegExp(`^${item.external_plan_id}\\s*-\\s*`), "")}`
                : item.name
            }
          >
            <ComboboxTrigger
              aria-label={
                selectedStudyPlan
                  ? `Plan de estudios: ${selectedStudyPlan.external_plan_id ? `${selectedStudyPlan.external_plan_id}: ${selectedStudyPlan.name.replace(new RegExp(`^${selectedStudyPlan.external_plan_id}\\s*-\\s*`), "")}` : selectedStudyPlan.name}`
                  : "Selecciona un plan de estudios"
              }
              render={
                <Button
                  variant="outline"
                  aria-label={
                    selectedStudyPlan
                      ? `Plan de estudios: ${selectedStudyPlan.external_plan_id ? `${selectedStudyPlan.external_plan_id}: ${selectedStudyPlan.name.replace(new RegExp(`^${selectedStudyPlan.external_plan_id}\\s*-\\s*`), "")}` : selectedStudyPlan.name}`
                      : "Selecciona un plan de estudios"
                  }
                  className={cn(
                    "!h-10 w-full justify-between text-sm font-normal",
                    showStudyPlanError &&
                      "border-destructive text-destructive ring-destructive/40 ring-1",
                  )}
                />
              }
            >
              <span
                className={cn(
                  "block min-w-0 flex-1 truncate text-left",
                  !studyPlanId && "text-muted-foreground",
                )}
              >
                {selectedStudyPlan
                  ? selectedStudyPlan.external_plan_id
                    ? `${selectedStudyPlan.external_plan_id}: ${selectedStudyPlan.name.replace(new RegExp(`^${selectedStudyPlan.external_plan_id}\\s*-\\s*`), "")}`
                    : selectedStudyPlan.name
                  : "Selecciona un plan de estudios"}
              </span>
              <Icon
                icon={UnfoldMoreIcon}
                size={14}
                className="-me-1! size-3.5 shrink-0 opacity-60"
              />
            </ComboboxTrigger>
            <ComboboxContent
              aria-label="Plan de estudios"
              className="w-[var(--anchor-width)] min-w-[var(--anchor-width)]"
            >
              <div className="border-b p-2">
                <ComboboxInput
                  className="rounded-md before:rounded-[calc(var(--radius-md)-1px)]"
                  placeholder="Buscar plan..."
                  showTrigger={false}
                  startAddon={<Icon icon={Search01Icon} size={16} />}
                />
              </div>
              <ComboboxEmpty>No se encontraron resultados.</ComboboxEmpty>
              <ComboboxList className="max-h-56 scrollbar-none">
                {(item) => (
                  <ComboboxItem key={item.id} value={item}>
                    <span className="block w-full min-w-0 truncate">
                      {item.external_plan_id
                        ? `${item.external_plan_id}: ${item.name.replace(new RegExp(`^${item.external_plan_id}\\s*-\\s*`), "")}`
                        : item.name}
                    </span>
                  </ComboboxItem>
                )}
              </ComboboxList>
            </ComboboxContent>
          </Combobox>
        ),
      },
      {
        id: "carnet",
        label: "Carnet",
        summary: carnet ? carnet : undefined,
        content: (
          <Input
            value={carnet}
            onChange={(e) => {
              setCarnet(e.target.value.replace(/[^0-9]/g, ""));
              setShowStepError(false);
            }}
            onKeyDown={(e) => {
              if (e.key === "Enter") {
                e.preventDefault();
                void finishOnboarding();
              }
            }}
            placeholder="Ej: 2024123456 (opcional)"
            className="!h-10 w-full text-sm font-normal"
          />
        ),
      },
    ],
    [
      mainCampuses,
      selectedCampus,
      campusId,
      showCampusError,
      academicUnits.data,
      selectedAcademicUnit,
      academicUnitId,
      showAcademicUnitError,
      studyPlans.data,
      selectedStudyPlan,
      studyPlanId,
      showStudyPlanError,
      carnet,
      currentStepError,
      finishOnboarding,
    ],
  );

  const isLoading = isAuthLoading;
  if (isLoading) {
    return (
      <div className="flex min-h-svh items-center justify-center">
        <Icon
          icon={Loading02Icon}
          size={24}
          className="text-muted-foreground size-6 animate-spin"
        />
      </div>
    );
  }

  return (
    <div className="bg-background text-foreground relative h-screen overflow-hidden">
      <AuthPageBackdrop />
      <div className="relative grid h-screen w-full grid-cols-1 lg:grid-cols-[1fr_minmax(440px,560px)]">
        <AuthLeftPanel />
        <main className="bg-card text-foreground relative flex h-full flex-col overflow-y-auto">
          <div className="mx-auto flex w-full max-w-md flex-1 flex-col justify-center px-6 py-8 lg:py-10">
            <div className="mb-6 flex items-center justify-between gap-3">
              <h1 className="text-xl font-semibold tracking-tight md:text-2xl">Completar perfil</h1>
              <Tooltip>
                <TooltipTrigger
                  render={
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={skipForNow}
                      className="text-muted-foreground hover:text-foreground shrink-0 text-xs"
                    >
                      Saltar
                    </Button>
                  }
                />
                <TooltipContent>Se te volverá a preguntar en 24 horas</TooltipContent>
              </Tooltip>
            </div>

            {submitError ? (
              <Alert variant="destructive" className="mb-4">
                <AlertTitle>No se pudo guardar</AlertTitle>
                <AlertDescription>{submitError}</AlertDescription>
              </Alert>
            ) : null}

            <Stepper
              steps={onboardingSteps}
              current={step - 1}
              onStepSelect={(index) => {
                setStep(index + 1);
                setShowStepError(false);
              }}
              orientation="responsive"
              className="my-4"
            />

            <div className="mt-8 flex items-center justify-between">
              <Button
                variant="outline"
                onClick={prevStep}
                disabled={step === 1 || isSaving}
                className="!h-10 px-4 text-sm"
              >
                Anterior
              </Button>
              {step < TOTAL_STEPS ? (
                <Button onClick={nextStep} disabled={isNextDisabled} className="!h-10 px-5 text-sm">
                  Siguiente
                </Button>
              ) : (
                <Button
                  onClick={finishOnboarding}
                  disabled={isSaving}
                  className="!h-10 px-5 text-sm"
                >
                  {isSaving ? (
                    <Icon icon={Loading02Icon} size={16} className="mr-2 size-4 animate-spin" />
                  ) : null}
                  Finalizar
                </Button>
              )}
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
