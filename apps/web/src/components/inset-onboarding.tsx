import { useQueryClient } from "@tanstack/react-query";
import { useNavigate } from "@tanstack/react-router";
import { Loader2Icon } from "lucide-react";
import { useMemo, useRef, useState } from "react";

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
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
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

  const campusTriggerRef = useRef<HTMLButtonElement | null>(null);
  const academicUnitTriggerRef = useRef<HTMLButtonElement | null>(null);
  const studyPlanTriggerRef = useRef<HTMLButtonElement | null>(null);

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

  const finishOnboarding = async () => {
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
  };

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

  const isLoading = isAuthLoading;
  if (isLoading) {
    return (
      <div className="flex min-h-svh items-center justify-center">
        <Loader2Icon className="text-muted-foreground size-6 animate-spin" />
      </div>
    );
  }

  return (
    <div className="bg-background text-foreground relative h-screen overflow-hidden">
      <AuthPageBackdrop />
      <div className="relative grid h-screen w-full grid-cols-1 lg:grid-cols-[1fr_minmax(440px,560px)]">
        <AuthLeftPanel />
        <div className="bg-card text-foreground relative flex h-full flex-col overflow-y-auto">
          <div className="mx-auto flex w-full max-w-md flex-1 flex-col justify-center px-6 py-8 lg:py-10">
            <div className="mb-6 flex items-center justify-between gap-3 text-sm">
              <div className="font-medium">
                Paso {step} de {TOTAL_STEPS}
              </div>
              <div className="flex gap-2">
                <Tooltip>
                  <TooltipTrigger asChild>
                    <Button variant="ghost" size="sm" onClick={skipForNow}>
                      Configurar más tarde
                    </Button>
                  </TooltipTrigger>
                  <TooltipContent>Se te volverá a preguntar en 24 horas</TooltipContent>
                </Tooltip>
              </div>
            </div>

            <h1 className="text-2xl font-semibold tracking-tight">Completa tu perfil académico</h1>

            {submitError ? (
              <Alert variant="destructive" className="mb-4">
                <AlertTitle>No se pudo guardar</AlertTitle>
                <AlertDescription>{submitError}</AlertDescription>
              </Alert>
            ) : null}

            <div className="space-y-4">
              {step === 1 ? (
                <Field>
                  <FieldLabel>Sede</FieldLabel>
                  <Combobox
                    items={campuses.data ?? []}
                    value={
                      (campuses.data ?? []).find((item) => String(item.id) === campusId) ?? null
                    }
                    onValueChange={(item) => {
                      const value = item ? String(item.id) : "";
                      setCampusId(value);
                      setAcademicUnitId("");
                      setStudyPlanId("");
                      setShowStepError(false);
                    }}
                    itemToStringValue={(item) =>
                      item.code ? `${item.code}: ${item.name}` : item.name
                    }
                  >
                    <ComboboxTrigger
                      ref={campusTriggerRef}
                      render={
                        <Button
                          variant="outline"
                          className={cn(
                            "w-full justify-between font-normal",
                            showCampusError && "border-destructive text-destructive",
                          )}
                        />
                      }
                    >
                      <span
                        className={`block min-w-0 flex-1 truncate text-left ${!campusId ? "text-muted-foreground" : ""}`}
                      >
                        {(() => {
                          const item = (campuses.data ?? []).find((c) => String(c.id) === campusId);
                          if (!item) return "Selecciona una sede";
                          return item.code ? `${item.code}: ${item.name}` : item.name;
                        })()}
                      </span>
                    </ComboboxTrigger>
                    <ComboboxContent
                      anchor={campusTriggerRef}
                      className="w-[var(--anchor-width)] min-w-[var(--anchor-width)]"
                    >
                      <ComboboxInput showTrigger={false} placeholder="Buscar sede" />
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
                  <FieldError>{showCampusError ? currentStepError : null}</FieldError>
                </Field>
              ) : null}

              {step === 2 ? (
                <Field>
                  <FieldLabel>Carrera</FieldLabel>
                  <Combobox
                    items={academicUnits.data ?? []}
                    value={
                      (academicUnits.data ?? []).find(
                        (item) => String(item.id) === academicUnitId,
                      ) ?? null
                    }
                    onValueChange={(item) => {
                      const value = item ? String(item.id) : "";
                      setAcademicUnitId(value);
                      setStudyPlanId("");
                      setShowStepError(false);
                    }}
                    itemToStringValue={(item) =>
                      item.code ? `${item.code}: ${item.name}` : item.name
                    }
                  >
                    <ComboboxTrigger
                      ref={academicUnitTriggerRef}
                      render={
                        <Button
                          variant="outline"
                          className={cn(
                            "w-full justify-between font-normal",
                            showAcademicUnitError && "border-destructive text-destructive",
                          )}
                        />
                      }
                    >
                      <span
                        className={`block min-w-0 flex-1 truncate text-left ${!academicUnitId ? "text-muted-foreground" : ""}`}
                      >
                        {(() => {
                          const item = (academicUnits.data ?? []).find(
                            (c) => String(c.id) === academicUnitId,
                          );
                          if (!item) return "Selecciona una carrera";
                          return item.code ? `${item.code}: ${item.name}` : item.name;
                        })()}
                      </span>
                    </ComboboxTrigger>
                    <ComboboxContent
                      anchor={academicUnitTriggerRef}
                      className="w-[var(--anchor-width)] min-w-[var(--anchor-width)]"
                    >
                      <ComboboxInput showTrigger={false} placeholder="Buscar carrera" />
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
                  <FieldError>{showAcademicUnitError ? currentStepError : null}</FieldError>
                </Field>
              ) : null}

              {step === 3 ? (
                <Field>
                  <FieldLabel>Plan de estudios</FieldLabel>
                  <Combobox
                    items={studyPlans.data ?? []}
                    value={
                      (studyPlans.data ?? []).find((item) => String(item.id) === studyPlanId) ??
                      null
                    }
                    onValueChange={(item) => {
                      setStudyPlanId(item ? String(item.id) : "");
                      setShowStepError(false);
                    }}
                    itemToStringValue={(item) =>
                      item.external_plan_id
                        ? `${item.external_plan_id}: ${item.name.replace(new RegExp(`^${item.external_plan_id}\\s*-\\s*`), "")}`
                        : item.name
                    }
                  >
                    <ComboboxTrigger
                      ref={studyPlanTriggerRef}
                      render={
                        <Button
                          variant="outline"
                          className={cn(
                            "w-full justify-between font-normal",
                            showStudyPlanError && "border-destructive text-destructive",
                          )}
                        />
                      }
                    >
                      <span
                        className={`block min-w-0 flex-1 truncate text-left ${!studyPlanId ? "text-muted-foreground" : ""}`}
                      >
                        {(() => {
                          const item = (studyPlans.data ?? []).find(
                            (p) => String(p.id) === studyPlanId,
                          );
                          if (!item) return "Selecciona un plan de estudios";
                          return item.external_plan_id
                            ? `${item.external_plan_id}: ${item.name.replace(new RegExp(`^${item.external_plan_id}\\s*-\\s*`), "")}`
                            : item.name;
                        })()}
                      </span>
                    </ComboboxTrigger>
                    <ComboboxContent
                      anchor={studyPlanTriggerRef}
                      className="w-[var(--anchor-width)] min-w-[var(--anchor-width)]"
                    >
                      <ComboboxInput showTrigger={false} placeholder="Buscar plan" />
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
                  <FieldError>{showStudyPlanError ? currentStepError : null}</FieldError>
                </Field>
              ) : null}

              {step === 4 ? (
                <Field>
                  <FieldLabel>Carnet</FieldLabel>
                  <Input
                    value={carnet}
                    onChange={(e) => {
                      setCarnet(e.target.value.replace(/[^0-9]/g, ""));
                      setShowStepError(false);
                    }}
                    placeholder="Ej: 2024123456"
                  />
                </Field>
              ) : null}
            </div>

            <div className="mt-8 flex items-center justify-between">
              <Button variant="outline" onClick={prevStep} disabled={step === 1 || isSaving}>
                Anterior
              </Button>
              {step < TOTAL_STEPS ? (
                <Button onClick={nextStep} disabled={isNextDisabled}>
                  Siguiente
                </Button>
              ) : (
                <Button onClick={finishOnboarding} disabled={isSaving}>
                  {isSaving ? <Loader2Icon className="size-4 animate-spin" /> : null}
                  Finalizar
                </Button>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
