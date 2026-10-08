import { useQueryClient } from "@tanstack/react-query";
import { ClientOnly } from "@tanstack/react-router";
import { UserIcon, Loader2Icon, UploadIcon } from "lucide-react";
import { useState, useEffect } from "react";
import { useRef } from "react";
import { toast } from "sonner";

import { SettingsPage, SettingsSection } from "@/components/settings/settings-section";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
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
import { Field, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import { authClient } from "@/lib/auth/client";
import {
  useAuthUser,
  useUniversities,
  useCampuses,
  useAcademicUnits,
  useStudyPlans,
  useProfileContext,
} from "@/lib/hooks/use-queries";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser-client";

export function ProfilePageRoute() {
  return (
    <ClientOnly
      fallback={
        <div className="flex items-center justify-center py-12">
          <Loader2Icon className="text-muted-foreground size-6 animate-spin" />
        </div>
      }
    >
      <ProfilePage />
    </ClientOnly>
  );
}

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
  const campusTriggerRef = useRef<HTMLButtonElement | null>(null);
  const academicUnitTriggerRef = useRef<HTMLButtonElement | null>(null);
  const studyPlanTriggerRef = useRef<HTMLButtonElement | null>(null);

  const universityId = profileContext.data?.university_id ?? null;
  const campusId = profileContext.data?.campus_id ?? null;
  const academicUnitId = profileContext.data?.academic_unit_id ?? null;

  const effectiveUniversityId = universityIdDraft ? Number(universityIdDraft) : universityId;
  const effectiveCampusId = campusIdDraft ? Number(campusIdDraft) : campusId;
  const effectiveAcademicUnitId = academicUnitIdDraft
    ? Number(academicUnitIdDraft)
    : academicUnitId;

  const campuses = useCampuses(effectiveUniversityId);
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

  useEffect(() => {
    if (
      profileContext.isSuccess &&
      profileContext.data &&
      universityIdDraft === "" &&
      campusIdDraft === ""
    ) {
      setDraftsFromContext(profileContext.data);
    }
  }, [profileContext.isSuccess, profileContext.data, universityIdDraft, campusIdDraft]);

  useEffect(() => {
    if (!authUser) return;
    setNameDraft(authUser.user_metadata?.full_name ?? "");
    setEmailDraft(authUser.email ?? "");
  }, [authUser]);

  useEffect(() => {
    if (universityIdDraft) return;
    if (!universities || universities.length === 0) return;
    setUniversityIdDraft(String(universities[0].id));
  }, [universities, universityIdDraft]);

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
      const supabase = getSupabaseBrowserClient();

      const studyPlanId = Number(studyPlanIdDraft);
      const campusId = Number(campusIdDraft);
      const entryYear = carnetDraft ? parseInt(carnetDraft.substring(0, 4), 10) : null;

      if (carnetDraft !== "") {
        const { error: userError } = await supabase.from("user").upsert({
          id: authUser.id,
          carnet: carnetDraft,
        });

        if (userError) throw userError;
      }

      const { data: uspData, error: uspCheckError } = await supabase
        .from("user_study_plan")
        .select("id")
        .eq("user_id", authUser.id)
        .eq("is_active", true)
        .maybeSingle();

      if (uspCheckError) throw uspCheckError;

      if (uspData) {
        const { error: updateError } = await supabase
          .from("user_study_plan")
          .update({
            study_plan_id: studyPlanId,
            campus_id: campusId,
            ...(entryYear && { entry_year: entryYear }),
          })
          .eq("id", uspData.id);

        if (updateError) throw updateError;
      } else {
        const { error: insertError } = await supabase.from("user_study_plan").insert({
          user_id: authUser.id,
          study_plan_id: studyPlanId,
          campus_id: campusId,
          entry_year: entryYear || new Date().getFullYear(),
        });

        if (insertError) throw insertError;
      }

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
        <Loader2Icon className="text-muted-foreground size-6 animate-spin" />
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
        <UserIcon className="text-muted-foreground mx-auto mb-4 size-12" />
        <h3 className="mb-2 text-lg font-semibold">Inicia sesión para acceder a tu perfil</h3>
        <p className="text-muted-foreground mx-auto mb-6 max-w-md">
          Necesitas estar autenticado para ver y editar tu información académica.
        </p>
        <Button asChild>
          <a href="/auth/signin">Iniciar sesión</a>
        </Button>
      </div>
    );
  }

  return (
    <SettingsPage
      title="Perfil"
      description="Gestiona tu identidad y los datos académicos que personalizan Claustrum."
    >
      <SettingsSection title="Identidad" description="Visible en tu cuenta y menú de usuario.">
        <div className="space-y-4">
          <div className="flex items-center gap-4">
            <Avatar className="size-16 rounded-full">
              <AvatarImage src={authUser.user_metadata?.avatar_url} />
              <AvatarFallback className="rounded-full text-lg font-medium">
                {(nameDraft || authUser.email || "U").charAt(0).toUpperCase()}
              </AvatarFallback>
            </Avatar>
            <div className="space-y-1.5">
              <Button disabled size="sm" variant="outline" className="w-fit">
                <UploadIcon className="mr-2 size-4" />
                Subir foto
              </Button>
              <p className="text-muted-foreground text-xs">PNG o SVG, 1024x1024 máx.</p>
            </div>
          </div>
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
              disabled={isSavingIdentity || !hasIdentityChanges}
            >
              {isSavingIdentity && <Loader2Icon className="mr-2 size-4 animate-spin" />}
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
            <Combobox
              items={campuses.data ?? []}
              value={
                (campuses.data ?? []).find((item) => String(item.id) === campusIdDraft) ?? null
              }
              onValueChange={(item) => handleCampusChange(item ? String(item.id) : "")}
              itemToStringValue={(item) => (item.code ? `${item.code}: ${item.name}` : item.name)}
              disabled={!effectiveUniversityId || campuses.isLoading}
            >
              <ComboboxTrigger
                ref={campusTriggerRef}
                render={
                  <Button
                    variant="outline"
                    className="w-full justify-between text-base font-normal md:text-sm"
                  />
                }
              >
                <span
                  className={`block min-w-0 flex-1 truncate text-left ${!campusIdDraft ? "text-muted-foreground" : ""}`}
                >
                  {campuses.isLoading
                    ? "Cargando..."
                    : (campuses.data ?? []).find((item) => String(item.id) === campusIdDraft)
                      ? (campuses.data ?? []).find((item) => String(item.id) === campusIdDraft)!
                          .code
                        ? `${(campuses.data ?? []).find((item) => String(item.id) === campusIdDraft)!.code}: ${(campuses.data ?? []).find((item) => String(item.id) === campusIdDraft)!.name}`
                        : (campuses.data ?? []).find((item) => String(item.id) === campusIdDraft)!
                            .name
                      : "Selecciona tu sede"}
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
          </Field>

          <Field>
            <FieldLabel>Escuela</FieldLabel>
            <Combobox
              items={academicUnits.data ?? []}
              value={
                (academicUnits.data ?? []).find(
                  (item) => String(item.id) === academicUnitIdDraft,
                ) ?? null
              }
              onValueChange={(item) => handleAcademicUnitChange(item ? String(item.id) : "")}
              itemToStringValue={(item) => (item.code ? `${item.code}: ${item.name}` : item.name)}
              disabled={!campusIdDraft || academicUnits.isLoading}
            >
              <ComboboxTrigger
                ref={academicUnitTriggerRef}
                render={
                  <Button
                    variant="outline"
                    className="w-full justify-between text-base font-normal md:text-sm"
                  />
                }
              >
                <span
                  className={`block min-w-0 flex-1 truncate text-left ${!academicUnitIdDraft ? "text-muted-foreground" : ""}`}
                >
                  {academicUnits.isLoading
                    ? "Cargando..."
                    : (academicUnits.data ?? []).find(
                          (item) => String(item.id) === academicUnitIdDraft,
                        )
                      ? (academicUnits.data ?? []).find(
                          (item) => String(item.id) === academicUnitIdDraft,
                        )!.code
                        ? `${(academicUnits.data ?? []).find((item) => String(item.id) === academicUnitIdDraft)!.code}: ${(academicUnits.data ?? []).find((item) => String(item.id) === academicUnitIdDraft)!.name}`
                        : (academicUnits.data ?? []).find(
                            (item) => String(item.id) === academicUnitIdDraft,
                          )!.name
                      : "Selecciona tu escuela"}
                </span>
              </ComboboxTrigger>
              <ComboboxContent
                anchor={academicUnitTriggerRef}
                className="w-[var(--anchor-width)] min-w-[var(--anchor-width)]"
              >
                <ComboboxInput showTrigger={false} placeholder="Buscar escuela" />
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
          </Field>

          <Field>
            <FieldLabel>Plan de estudios</FieldLabel>
            <Combobox
              items={studyPlans.data ?? []}
              value={
                (studyPlans.data ?? []).find((item) => String(item.id) === studyPlanIdDraft) ?? null
              }
              onValueChange={(item) => handleStudyPlanChange(item ? String(item.id) : "")}
              itemToStringValue={(item) => item.name.replace(" - ", ": ")}
              disabled={!academicUnitIdDraft || studyPlans.isLoading}
            >
              <ComboboxTrigger
                ref={studyPlanTriggerRef}
                render={
                  <Button
                    variant="outline"
                    className="w-full justify-between text-base font-normal md:text-sm"
                  />
                }
              >
                <span
                  className={`block min-w-0 flex-1 truncate text-left ${!studyPlanIdDraft ? "text-muted-foreground" : ""}`}
                >
                  {studyPlans.isLoading
                    ? "Cargando..."
                    : (studyPlans.data ?? []).find((item) => String(item.id) === studyPlanIdDraft)
                      ? (studyPlans.data ?? [])
                          .find((item) => String(item.id) === studyPlanIdDraft)!
                          .name.replace(" - ", ": ")
                      : "Selecciona tu plan"}
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
                        {item.name.replace(" - ", ": ")}
                      </span>
                    </ComboboxItem>
                  )}
                </ComboboxList>
              </ComboboxContent>
            </Combobox>
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
            <Button onClick={() => void handleSave()} disabled={isSaving || !hasUnsavedChanges}>
              {isSaving && <Loader2Icon className="mr-2 size-4 animate-spin" />}
              Guardar
            </Button>
          </div>
        </div>
      </SettingsSection>
    </SettingsPage>
  );
}
