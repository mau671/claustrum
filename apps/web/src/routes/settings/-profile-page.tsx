import { UserIcon } from "@hugeicons/core-free-icons";
import { useQueryClient } from "@tanstack/react-query";
import { ClientOnly } from "@tanstack/react-router";
import { useMemo, useState } from "react";

import { AcademicProgress } from "@/components/dashboard/academic-progress";
import { SettingsPage, SettingsSection } from "@/components/settings/settings-section";
import { Button } from "@/components/ui/button";
import { Field, FieldLabel } from "@/components/ui/field";
import { Icon } from "@/components/ui/icon";
import { Input } from "@/components/ui/input";
import { SearchableCombobox } from "@/components/ui/searchable-combobox";
import { Spinner } from "@/components/ui/spinner";
import { toast } from "@/components/ui/toast";
import { apiClient } from "@/lib/api/client";
import { authClient } from "@/lib/auth/client";
import {
  useAuthUser,
  useUniversities,
  useCampuses,
  useAcademicUnits,
  useStudyPlans,
  useProfileContext,
} from "@/lib/hooks/use-queries";

export function ProfilePageRoute() {
  return (
    <ClientOnly
      fallback={
        <div className="flex items-center justify-center py-12">
          <Spinner className="text-muted-foreground size-6" />
        </div>
      }
    >
      <ProfilePage />
    </ClientOnly>
  );
}

const MAIN_CAMPUS_CODES = new Set(["AL", "CA", "LM", "SC", "SJ"]);

function getErrorMessage(err: unknown): string {
  if (err instanceof Error) return err.message;
  return "Unexpected error";
}

function ProfilePage() {
  const queryClient = useQueryClient();

  const { data: authUser, isLoading: isAuthLoading } = useAuthUser();
  const { data: universities, isLoading: isUniversitiesLoading } = useUniversities();

  const profileContext = useProfileContext(authUser?.id ?? null);

  const [universityIdDraft, setUniversityIdDraft] = useState<string>("");
  const [campusIdDraft, setCampusIdDraft] = useState<string>("");
  const [academicUnitIdDraft, setAcademicUnitIdDraft] = useState<string>("");
  const [studyPlanIdDraft, setStudyPlanIdDraft] = useState<string>("");
  const [carnetDraft, setCarnetDraft] = useState<string>("");
  const [nameDraft, setNameDraft] = useState<string>("");
  const [emailDraft, setEmailDraft] = useState<string>("");
  const [isSaving, setIsSaving] = useState(false);
  const [isSavingIdentity, setIsSavingIdentity] = useState(false);
  const [formError, setFormError] = useState<string | null>(null);

  const universityId = profileContext.data?.university_id ?? null;
  const campusId = profileContext.data?.campus_id ?? null;
  const academicUnitId = profileContext.data?.academic_unit_id ?? null;

  const effectiveUniversityId = universityIdDraft ? Number(universityIdDraft) : universityId;
  const effectiveCampusId = campusIdDraft ? Number(campusIdDraft) : campusId;
  const effectiveAcademicUnitId = academicUnitIdDraft
    ? Number(academicUnitIdDraft)
    : academicUnitId;

  const campuses = useCampuses(effectiveUniversityId);
  const mainCampuses = useMemo(
    () =>
      (campuses.data ?? []).filter(
        (c) => MAIN_CAMPUS_CODES.has(c.code) || String(c.id) === campusIdDraft,
      ),
    [campuses.data, campusIdDraft],
  );
  const academicUnits = useAcademicUnits(effectiveCampusId);
  const studyPlans = useStudyPlans(effectiveAcademicUnitId);

  const isInitialLoading = isAuthLoading || isUniversitiesLoading || profileContext.isLoading;

  const setDraftsFromContext = (ctx: typeof profileContext.data) => {
    if (!ctx) {
      setUniversityIdDraft("");
      setCampusIdDraft("");
      setAcademicUnitIdDraft("");
      setStudyPlanIdDraft("");
      setCarnetDraft("");
      return;
    }

    if (ctx.university_id !== null) setUniversityIdDraft(String(ctx.university_id));
    else setUniversityIdDraft("");

    if (ctx.campus_id !== null) setCampusIdDraft(String(ctx.campus_id));
    else setCampusIdDraft("");

    if (ctx.academic_unit_id !== null) setAcademicUnitIdDraft(String(ctx.academic_unit_id));
    else setAcademicUnitIdDraft("");

    if (ctx.study_plan_id !== null) setStudyPlanIdDraft(String(ctx.study_plan_id));
    else setStudyPlanIdDraft("");

    if (ctx.carnet !== null) setCarnetDraft(ctx.carnet);
    else setCarnetDraft("");
  };

  if (
    profileContext.isSuccess &&
    profileContext.data &&
    universityIdDraft === "" &&
    campusIdDraft === ""
  ) {
    setDraftsFromContext(profileContext.data);
  }

  const [previousAuthUser, setPreviousAuthUser] = useState(authUser);
  if (authUser && authUser !== previousAuthUser) {
    setPreviousAuthUser(authUser);
    setNameDraft(authUser.user_metadata?.full_name ?? "");
    setEmailDraft(authUser.email ?? "");
  }

  if (!universityIdDraft && universities && universities.length > 0) {
    setUniversityIdDraft(String(universities[0].id));
  }

  const hasUnsavedChanges =
    authUser &&
    profileContext.data &&
    ((profileContext.data.university_id !== null &&
      String(profileContext.data.university_id) !== universityIdDraft) ||
      (profileContext.data.campus_id !== null &&
        String(profileContext.data.campus_id) !== campusIdDraft) ||
      (profileContext.data.academic_unit_id !== null &&
        String(profileContext.data.academic_unit_id) !== academicUnitIdDraft) ||
      (profileContext.data.study_plan_id !== null &&
        String(profileContext.data.study_plan_id) !== studyPlanIdDraft) ||
      (profileContext.data.carnet !== null && profileContext.data.carnet !== carnetDraft) ||
      (profileContext.data.university_id === null && universityIdDraft !== ""));
  const hasIdentityChanges = authUser && (authUser.user_metadata?.full_name ?? "") !== nameDraft;

  function handleCampusChange(campusId: string) {
    setFormError(null);
    setCampusIdDraft(campusId);
    setAcademicUnitIdDraft("");
    setStudyPlanIdDraft("");
  }

  function handleAcademicUnitChange(academicUnitId: string) {
    setFormError(null);
    setAcademicUnitIdDraft(academicUnitId);
    setStudyPlanIdDraft("");
  }

  function handleStudyPlanChange(studyPlanId: string) {
    setFormError(null);
    setStudyPlanIdDraft(studyPlanId);
  }

  async function handleSave(): Promise<void> {
    if (!authUser) return;

    setFormError(null);

    if (!campusIdDraft) {
      setFormError("Selecciona una sede.");
      return;
    }

    if (!academicUnitIdDraft) {
      setFormError("Selecciona una escuela.");
      return;
    }

    if (!studyPlanIdDraft) {
      setFormError("Selecciona un plan de estudios.");
      return;
    }

    setIsSaving(true);
    try {
      const studyPlanId = Number(studyPlanIdDraft);
      const campusId = Number(campusIdDraft);
      const entryYear = carnetDraft ? parseInt(carnetDraft.substring(0, 4), 10) : null;

      await apiClient("/users/me/studyplan", {
        method: "PATCH",
        body: JSON.stringify({
          studyPlanId,
          campusId,
          entryYear: entryYear || new Date().getFullYear(),
          carnet: carnetDraft !== "" ? carnetDraft : null,
        }),
      });

      await queryClient.invalidateQueries({ queryKey: ["appState"] });
      toast.success("Perfil actualizado correctamente");
    } catch (err) {
      setFormError(getErrorMessage(err));
    } finally {
      setIsSaving(false);
    }
  }

  async function handleSaveIdentity(): Promise<void> {
    if (!authUser || !hasIdentityChanges) return;

    setIsSavingIdentity(true);
    try {
      const { error } = await authClient.updateUser({ name: nameDraft });
      if (error) throw error;

      await queryClient.invalidateQueries({ queryKey: ["appState"] });
      toast.success("Identidad actualizada correctamente");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Error al actualizar identidad");
    } finally {
      setIsSavingIdentity(false);
    }
  }

  if (isInitialLoading) {
    return (
      <div className="flex items-center justify-center py-12">
        <Spinner className="text-muted-foreground size-6" />
      </div>
    );
  }

  if (profileContext.isError) {
    return (
      <div className="bg-destructive/5 rounded-lg border p-4 text-sm">
        <div className="text-destructive font-medium">Error al cargar el perfil</div>
        <div className="text-muted-foreground mt-1">{getErrorMessage(profileContext.error)}</div>
      </div>
    );
  }

  if (!authUser) {
    return (
      <div className="py-12 text-center">
        <Icon icon={UserIcon} size={48} className="text-muted-foreground mx-auto mb-4 size-12" />
        <h3 className="mb-2 text-lg font-semibold">Inicia sesión para acceder a tu perfil</h3>
        <p className="text-muted-foreground mx-auto mb-6 max-w-md">
          Necesitas estar autenticado para ver y editar tu información académica.
        </p>
        <Button render={<a href="/auth/signin" aria-label="Iniciar sesión" />}>
          Iniciar sesión
        </Button>
      </div>
    );
  }

  return (
    <SettingsPage>
      <SettingsSection
        title="Resumen académico"
        description="Tu avance y proyección según tu plan de estudios."
      >
        <AcademicProgress />
      </SettingsSection>

      <SettingsSection title="Identidad" description="Visible en tu cuenta y menú de usuario.">
        <div className="space-y-4">
          <Field>
            <FieldLabel>Nombre</FieldLabel>
            <Input
              value={nameDraft}
              onChange={(event) => setNameDraft(event.target.value)}
              placeholder="Tu nombre"
              autoComplete="name"
            />
          </Field>
          <Field>
            <FieldLabel>Correo electrónico</FieldLabel>
            <Input
              value={emailDraft}
              placeholder="tu@correo.com"
              type="email"
              autoComplete="email"
              disabled
            />
          </Field>
          <div className="flex justify-end pt-2">
            <Button
              onClick={() => void handleSaveIdentity()}
              loading={isSavingIdentity}
              disabled={!hasIdentityChanges}
            >
              Guardar
            </Button>
          </div>
        </div>
      </SettingsSection>

      <SettingsSection
        title="Información académica"
        description="Usada para horarios, plan de estudios y recomendaciones."
      >
        <div className="space-y-4">
          {formError && (
            <div className="bg-destructive/10 text-destructive rounded-md p-3 text-sm">
              {formError}
            </div>
          )}

          <Field>
            <FieldLabel>Sede</FieldLabel>
            <SearchableCombobox
              label="Sede"
              placeholder="Selecciona tu sede"
              items={mainCampuses}
              value={mainCampuses.find((item) => String(item.id) === campusIdDraft) ?? null}
              onValueChange={(item) => handleCampusChange(item ? String(item.id) : "")}
              itemToString={(item) => (item.code ? `${item.code}: ${item.name}` : item.name)}
              loading={campuses.isLoading && mainCampuses.length === 0}
              disabled={!effectiveUniversityId || campuses.isLoading}
              triggerClassName="justify-between text-base font-normal md:text-sm"
            />
          </Field>

          <Field>
            <FieldLabel>Escuela</FieldLabel>
            <SearchableCombobox
              label="Escuela"
              placeholder="Selecciona tu escuela"
              items={academicUnits.data ?? []}
              value={
                (academicUnits.data ?? []).find(
                  (item) => String(item.id) === academicUnitIdDraft,
                ) ?? null
              }
              onValueChange={(item) => handleAcademicUnitChange(item ? String(item.id) : "")}
              itemToString={(item) => (item.code ? `${item.code}: ${item.name}` : item.name)}
              loading={academicUnits.isLoading && (academicUnits.data ?? []).length === 0}
              disabled={!campusIdDraft || academicUnits.isLoading}
              triggerClassName="justify-between text-base font-normal md:text-sm"
            />
          </Field>

          <Field>
            <FieldLabel>Plan de estudios</FieldLabel>
            <SearchableCombobox
              label="Plan de estudios"
              placeholder="Selecciona tu plan"
              items={studyPlans.data ?? []}
              value={
                (studyPlans.data ?? []).find((item) => String(item.id) === studyPlanIdDraft) ?? null
              }
              onValueChange={(item) => handleStudyPlanChange(item ? String(item.id) : "")}
              itemToString={(item) => item.name.replace(" - ", ": ")}
              loading={studyPlans.isLoading && (studyPlans.data ?? []).length === 0}
              disabled={!academicUnitIdDraft || studyPlans.isLoading}
              triggerClassName="justify-between text-base font-normal md:text-sm"
            />
          </Field>

          <Field>
            <FieldLabel>Carnet</FieldLabel>
            <Input
              value={carnetDraft}
              onChange={(e) => setCarnetDraft(e.target.value)}
              placeholder="Tu número de carnet (opcional)"
            />
          </Field>

          <div className="flex justify-end pt-2">
            <Button
              onClick={() => void handleSave()}
              loading={isSaving}
              disabled={!hasUnsavedChanges}
            >
              Guardar
            </Button>
          </div>
        </div>
      </SettingsSection>
    </SettingsPage>
  );
}
