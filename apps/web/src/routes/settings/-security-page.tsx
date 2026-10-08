import { useQueryClient } from "@tanstack/react-query";
import { useNavigate } from "@tanstack/react-router";
import {
  CheckIcon,
  CopyIcon,
  EyeIcon,
  EyeOffIcon,
  LinkIcon,
  MailIcon,
  Loader2Icon,
  LogOutIcon,
  MonitorIcon,
  ShieldIcon,
  SmartphoneIcon,
  TabletIcon,
  GlobeIcon,
  XIcon,
} from "lucide-react";
import { useEffect, useRef, useState } from "react";
import ReactQrCode from "react-qr-code";
import { toast } from "sonner";

import { SettingsPage, SettingsSection } from "@/components/settings/settings-section";
import { Button } from "@/components/ui/button";
import { Field, FieldLabel } from "@/components/ui/field";
import { InputGroup, InputGroupAddon, InputGroupInput } from "@/components/ui/input-group";
import { StatefulButton } from "@/components/ui/stateful-button";
import { authClient, signOut } from "@/lib/auth/client";
import { useAuthAccounts, useAuthUser } from "@/lib/hooks/use-queries";
import { resetSupabaseAuthTokenState } from "@/lib/supabase/browser-client";
import { cn } from "@/lib/utils";

const passwordRequirements = [
  { regex: /.{8,}/, text: "Al menos 8 caracteres" },
  { regex: /[a-z]/, text: "Al menos 1 letra minúscula" },
  { regex: /[A-Z]/, text: "Al menos 1 letra mayúscula" },
  { regex: /[0-9]/, text: "Al menos 1 número" },
  {
    regex: /[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]/,
    text: "Al menos 1 carácter especial",
  },
];

type ActiveSession = {
  id: string;
  token: string;
  createdAt?: string | Date;
  updatedAt?: string | Date;
  expiresAt: string | Date;
  ipAddress?: string | null;
  userAgent?: string | null;
};

type AuthConnectionItem = {
  key: "email" | "google" | "github";
  label: string;
  available: boolean;
  linked: boolean;
  description: string;
};

function getStrengthColor(score: number) {
  if (score === 0) return "bg-border";
  if (score <= 1) return "bg-destructive";
  if (score <= 2) return "bg-orange-500";
  if (score <= 3) return "bg-amber-500";
  if (score === 4) return "bg-yellow-400";
  return "bg-green-500";
}

function getStrengthText(score: number) {
  if (score === 0) return "Ingresa una contraseña";
  if (score <= 2) return "Contraseña débil";
  if (score <= 3) return "Contraseña media";
  if (score === 4) return "Contraseña fuerte";
  return "Contraseña muy fuerte";
}

function getSessionDeviceType(userAgent: string | null | undefined) {
  if (!userAgent) return "unknown" as const;

  const normalizedUserAgent = userAgent.toLowerCase();
  if (normalizedUserAgent.includes("tablet") || normalizedUserAgent.includes("ipad")) {
    return "tablet" as const;
  }

  if (
    normalizedUserAgent.includes("mobile") ||
    normalizedUserAgent.includes("android") ||
    normalizedUserAgent.includes("iphone")
  ) {
    return "mobile" as const;
  }

  if (
    normalizedUserAgent.includes("windows") ||
    normalizedUserAgent.includes("macintosh") ||
    normalizedUserAgent.includes("linux") ||
    normalizedUserAgent.includes("cros")
  ) {
    return "desktop" as const;
  }

  return "unknown" as const;
}

function getDeviceName(userAgent: string | null | undefined) {
  if (!userAgent) return "Dispositivo desconocido";

  const ua = userAgent;

  if (/iPhone/i.test(ua)) return "iPhone";
  if (/iPad/i.test(ua)) return "iPad";
  if (/Macintosh/i.test(ua)) return "Mac";
  if (/Windows NT/i.test(ua)) return "Windows PC";
  if (/Android/i.test(ua)) return "Android";
  if (/Linux/i.test(ua)) return "Linux";

  return "Dispositivo desconocido";
}

function getBrowserLabel(userAgent: string | null | undefined) {
  if (!userAgent) return "Navegador desconocido";

  const patterns = [
    { name: "Edge", regex: /Edg\/(\d+)/i },
    { name: "Opera", regex: /OPR\/(\d+)/i },
    { name: "Chrome", regex: /Chrome\/(\d+)/i },
    { name: "Firefox", regex: /Firefox\/(\d+)/i },
    { name: "Safari", regex: /Version\/(\d+).+Safari/i },
  ];

  for (const pattern of patterns) {
    const match = userAgent.match(pattern.regex);
    if (match) {
      const majorVersion = match[1];
      return `${pattern.name} ${majorVersion}`;
    }
  }

  return "Navegador desconocido";
}

function getSessionMetaItems(session: ActiveSession) {
  const items = [getBrowserLabel(session.userAgent)];

  const ipAddress = session.ipAddress?.trim();
  if (ipAddress) items.push(ipAddress);

  return items;
}

function SessionDeviceIcon({ userAgent }: { userAgent: string | null | undefined }) {
  const deviceType = getSessionDeviceType(userAgent);
  if (deviceType === "mobile") return <SmartphoneIcon className="size-4" />;
  if (deviceType === "tablet") return <TabletIcon className="size-4" />;
  if (deviceType === "desktop") return <MonitorIcon className="size-4" />;
  return <GlobeIcon className="size-4" />;
}

function getReadableErrorMessage(err: unknown, fallback: string) {
  if (err instanceof Error && err.message.trim()) return err.message;
  if (typeof err === "string" && err.trim()) return err;

  if (typeof err === "object" && err !== null) {
    if ("message" in err && typeof err.message === "string" && err.message.trim()) {
      return err.message;
    }

    if (
      "error" in err &&
      typeof err.error === "object" &&
      err.error !== null &&
      "message" in err.error &&
      typeof err.error.message === "string" &&
      err.error.message.trim()
    ) {
      return err.error.message;
    }
  }

  return fallback;
}

function toErrorWithCode(err: unknown, fallback: string) {
  const message = getReadableErrorMessage(err, fallback);
  const wrappedError = new Error(message) as Error & { code?: string };

  if (typeof err === "object" && err !== null && "code" in err && typeof err.code === "string") {
    wrappedError.code = err.code;
    return wrappedError;
  }

  if (
    typeof err === "object" &&
    err !== null &&
    "error" in err &&
    typeof err.error === "object" &&
    err.error !== null &&
    "code" in err.error &&
    typeof err.error.code === "string"
  ) {
    wrappedError.code = err.error.code;
  }

  return wrappedError;
}

function isUnauthorizedError(err: unknown) {
  if (!(typeof err === "object" && err !== null)) return false;

  if ("status" in err && err.status === 401) return true;
  if ("code" in err && err.code === "UNAUTHORIZED") return true;

  if (
    "error" in err &&
    typeof err.error === "object" &&
    err.error !== null &&
    (("status" in err.error && err.error.status === 401) ||
      ("code" in err.error && err.error.code === "UNAUTHORIZED"))
  ) {
    return true;
  }

  return false;
}

function getRelativeLastUsedLabel(session: ActiveSession, isCurrentSession: boolean) {
  if (isCurrentSession) return "Activa ahora";

  const value = session.updatedAt ?? session.createdAt ?? null;
  if (!value) return "Ultimo uso no disponible";

  const date = value instanceof Date ? value : new Date(value);
  if (Number.isNaN(date.getTime())) return "Ultimo uso no disponible";

  const diffMs = date.getTime() - Date.now();
  const diffMinutes = Math.round(diffMs / (1000 * 60));
  const rtf = new Intl.RelativeTimeFormat("es", { numeric: "auto" });

  if (Math.abs(diffMinutes) < 60) return rtf.format(diffMinutes, "minute");

  const diffHours = Math.round(diffMinutes / 60);
  if (Math.abs(diffHours) < 24) return rtf.format(diffHours, "hour");

  const diffDays = Math.round(diffHours / 24);
  if (Math.abs(diffDays) < 30) return rtf.format(diffDays, "day");

  const diffMonths = Math.round(diffDays / 30);
  if (Math.abs(diffMonths) < 12) return rtf.format(diffMonths, "month");

  const diffYears = Math.round(diffDays / 365);
  return rtf.format(diffYears, "year");
}

function getTotpSecretFromUri(uri: string) {
  try {
    const parsedUri = new URL(uri);
    const secret = parsedUri.searchParams.get("secret");
    return secret?.trim() || null;
  } catch {
    return null;
  }
}

function getSessionLastActivityTimestamp(session: ActiveSession) {
  const value = session.updatedAt ?? session.createdAt;
  if (!value) return 0;
  const timestamp = new Date(value).getTime();
  return Number.isNaN(timestamp) ? 0 : timestamp;
}

function sortSessionsByActivity(
  sessions: ActiveSession[],
  currentToken: string | null,
): ActiveSession[] {
  return [...sessions].sort((a, b) => {
    const isCurrentA = currentToken !== null && a.token === currentToken;
    const isCurrentB = currentToken !== null && b.token === currentToken;

    if (isCurrentA && !isCurrentB) return -1;
    if (!isCurrentA && isCurrentB) return 1;

    return getSessionLastActivityTimestamp(b) - getSessionLastActivityTimestamp(a);
  });
}

function PasswordStrengthIndicator({ password }: { password: string }) {
  const passwordStrength = passwordRequirements.map((requirement) => ({
    met: requirement.regex.test(password),
    text: requirement.text,
  }));
  const passwordStrengthScore = passwordStrength.filter((requirement) => requirement.met).length;

  return (
    <div className="space-y-1 pt-1">
      <div className="flex h-1 w-full gap-1">
        {Array.from({ length: 5 }).map((_, index) => (
          <span
            key={index}
            className={cn(
              "h-full flex-1 rounded-full transition-all duration-300 ease-out",
              index < passwordStrengthScore ? getStrengthColor(passwordStrengthScore) : "bg-border",
            )}
          />
        ))}
      </div>
      <p className="text-sm font-medium">{getStrengthText(passwordStrengthScore)}.</p>
      <ul className="space-y-1">
        {passwordStrength.map((requirement) => (
          <li key={requirement.text} className="flex items-center gap-2">
            {requirement.met ? (
              <CheckIcon className="size-4 text-green-600 dark:text-green-400" />
            ) : (
              <XIcon className="text-muted-foreground size-4" />
            )}
            <span
              className={cn(
                "text-xs",
                requirement.met ? "text-green-600 dark:text-green-400" : "text-muted-foreground",
              )}
            >
              {requirement.text}
              <span className="sr-only">
                {requirement.met ? " - Requisito cumplido" : " - Requisito pendiente"}
              </span>
            </span>
          </li>
        ))}
      </ul>
    </div>
  );
}

export function SecurityPage() {
  const QRCodeComponent =
    (ReactQrCode as unknown as { default?: typeof ReactQrCode }).default ?? ReactQrCode;

  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const { data: authUser, isLoading } = useAuthUser();

  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [isNewPasswordVisible, setIsNewPasswordVisible] = useState(false);
  const [isConfirmPasswordVisible, setIsConfirmPasswordVisible] = useState(false);
  const [isSendingPasswordReset, setIsSendingPasswordReset] = useState(false);
  const [isLoadingMfa, setIsLoadingMfa] = useState(false);
  const [isDisablingMfa, setIsDisablingMfa] = useState(false);
  const [isMfaPasswordVerified, setIsMfaPasswordVerified] = useState(false);
  const [mfaPassword, setMfaPassword] = useState("");
  const [verifiedTotpFactorId, setVerifiedTotpFactorId] = useState<string | null>(null);
  const [totpEnrollment, setTotpEnrollment] = useState<{
    qrCode: string;
    secret: string | null;
  } | null>(null);
  const [totpCode, setTotpCode] = useState("");
  const [isRevokingOtherSessions, setIsRevokingOtherSessions] = useState(false);
  const [isLoadingSessions, setIsLoadingSessions] = useState(false);
  const [activeSessions, setActiveSessions] = useState<ActiveSession[]>([]);
  const [currentSessionToken, setCurrentSessionToken] = useState<string | null>(null);
  const [revokingSessionToken, setRevokingSessionToken] = useState<string | null>(null);
  const accountsQuery = useAuthAccounts();
  const hasCredentialAccount = accountsQuery.data?.hasCredentialAccount ?? true;
  const linkedProviderIds = accountsQuery.data?.linkedProviderIds ?? [];
  const pendingTotpEnrollmentRef = useRef<{ qrCode: string; secret: string | null } | null>(null);
  const pendingTotpActivationRef = useRef(false);
  const canSavePassword = newPassword.length >= 8 && newPassword === confirmPassword;
  const canVerifyMfaEnrollment = totpCode.length === 6 && !!totpEnrollment;
  const canVerifyMfaPassword =
    !isMfaPasswordVerified &&
    !isLoadingMfa &&
    !verifiedTotpFactorId &&
    (!hasCredentialAccount || !!mfaPassword.trim());
  const authConnections: AuthConnectionItem[] = [
    {
      key: "email",
      label: "Correo",
      available: true,
      linked:
        hasCredentialAccount ||
        linkedProviderIds.includes("credential") ||
        linkedProviderIds.includes("email-password") ||
        linkedProviderIds.includes("emailAndPassword"),
      description: "Ingresa con correo y contraseña",
    },
    {
      key: "google",
      label: "Google",
      available: true,
      linked: linkedProviderIds.includes("google"),
      description: "Conecta tu cuenta de Google",
    },
    {
      key: "github",
      label: "GitHub",
      available: false,
      linked: linkedProviderIds.includes("github"),
      description: "Próximamente disponible",
    },
  ];

  useEffect(() => {
    if (!authUser) return;
    void loadMfaFactors();
    void loadActiveSessions();
  }, [authUser]);

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-12">
        <Loader2Icon className="text-muted-foreground size-6 animate-spin" />
      </div>
    );
  }

  if (!authUser) {
    return (
      <div className="py-12 text-center">
        <ShieldIcon className="text-muted-foreground mx-auto mb-4 size-12" />
        <h3 className="mb-2 text-lg font-semibold">Inicia sesión para acceder a seguridad</h3>
        <p className="text-muted-foreground mx-auto mb-6 max-w-md">
          Necesitas estar autenticado para cambiar tu contraseña y configurar opciones de seguridad.
        </p>
        <Button asChild>
          <a href="/auth/signin">Iniciar sesión</a>
        </Button>
      </div>
    );
  }

  async function handlePasswordReset() {
    if (!authUser) return;

    if (newPassword !== confirmPassword) {
      toast.error("Las contraseñas no coinciden");
      return;
    }

    if (newPassword.length < 8) {
      toast.error("La contraseña debe tener al menos 8 caracteres");
      return;
    }

    setIsSendingPasswordReset(true);
    try {
      const { error } = await authClient.requestPasswordReset({
        email: authUser.email,
        redirectTo: `${window.location.origin}/auth/reset-password`,
      });
      if (error) throw error;

      toast.success("Te enviamos un enlace para confirmar el cambio de contraseña");
      setNewPassword("");
      setConfirmPassword("");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Error al actualizar contraseña");
    } finally {
      setIsSendingPasswordReset(false);
    }
  }

  async function loadMfaFactors() {
    setIsLoadingMfa(true);
    try {
      const { data, error } = await authClient.getSession();
      if (error) throw error;
      setVerifiedTotpFactorId(data?.user.twoFactorEnabled ? data.user.id : null);
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Error al cargar 2FA");
    } finally {
      setIsLoadingMfa(false);
    }
  }

  async function handleVerifyMfaPassword() {
    if (hasCredentialAccount && !mfaPassword.trim()) return;

    const enablePayload = hasCredentialAccount
      ? { issuer: "Claustrum", password: mfaPassword }
      : { issuer: "Claustrum" };

    const { data, error } = await authClient.twoFactor.enable(enablePayload);
    if (error) throw toErrorWithCode(error, "No se pudo verificar la contraseña");

    pendingTotpEnrollmentRef.current = {
      qrCode: data.totpURI,
      secret: getTotpSecretFromUri(data.totpURI),
    };
  }

  async function handleCancelMfaEnrollment() {
    setTotpEnrollment(null);
    pendingTotpEnrollmentRef.current = null;
    pendingTotpActivationRef.current = false;
    setTotpCode("");
    setIsMfaPasswordVerified(false);
  }

  async function handleCopyTotpSecret() {
    const value = totpEnrollment?.secret ?? totpEnrollment?.qrCode;
    if (!value) return;
    await navigator.clipboard.writeText(value);
    toast.success("Clave copiada");
  }

  async function handleVerifyMfaEnrollment() {
    if (!totpEnrollment || !canVerifyMfaEnrollment) return;

    const { error } = await authClient.twoFactor.verifyTotp({
      code: totpCode,
      trustDevice: true,
    });
    if (error) throw toErrorWithCode(error, "Código inválido");

    pendingTotpActivationRef.current = true;
  }

  async function handleDisableMfa() {
    if (!verifiedTotpFactorId) return;

    setIsDisablingMfa(true);
    try {
      const disablePayload = hasCredentialAccount && mfaPassword ? { password: mfaPassword } : {};
      const { error } = await authClient.twoFactor.disable(disablePayload);
      if (error) throw error;

      toast.success("Autenticación de dos factores desactivada");
      setVerifiedTotpFactorId(null);
      setTotpEnrollment(null);
      setTotpCode("");
      setIsMfaPasswordVerified(false);
      await loadMfaFactors();
    } catch (err) {
      if (
        typeof err === "object" &&
        err !== null &&
        "code" in err &&
        err.code === "INVALID_PASSWORD"
      ) {
        toast.error("Contraseña inválida");
      } else {
        toast.error(err instanceof Error ? err.message : "Error al desactivar 2FA");
      }
    } finally {
      setIsDisablingMfa(false);
    }
  }

  async function handleRevokeOtherSessions() {
    setIsRevokingOtherSessions(true);
    try {
      const { error } = await authClient.revokeOtherSessions();
      if (error) throw error;

      await loadActiveSessions();
      toast.success("Se revocaron todas las demás sesiones");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Error al cerrar sesiones");
    } finally {
      setIsRevokingOtherSessions(false);
    }
  }

  async function loadActiveSessions() {
    setIsLoadingSessions(true);
    try {
      const [{ data: sessions, error: listError }, { data: session, error: currentSessionError }] =
        await Promise.all([authClient.listSessions(), authClient.getSession()]);

      if (listError) throw listError;
      if (currentSessionError) throw currentSessionError;

      const currentToken = session?.session.token ?? null;
      const normalizedSessions = (sessions ?? []) as ActiveSession[];
      setCurrentSessionToken(currentToken);
      setActiveSessions(sortSessionsByActivity(normalizedSessions, currentToken));
    } catch (err) {
      if (isUnauthorizedError(err)) return;
      toast.error(err instanceof Error ? err.message : "Error al cargar sesiones activas");
    } finally {
      setIsLoadingSessions(false);
    }
  }

  async function handleRevokeSession(sessionToken: string) {
    setRevokingSessionToken(sessionToken);
    try {
      const { error } = await authClient.revokeSession({ token: sessionToken });
      if (error) throw error;

      setActiveSessions((sessions) => sessions.filter((session) => session.token !== sessionToken));

      if (sessionToken === currentSessionToken) {
        await signOut();
        resetSupabaseAuthTokenState();
        queryClient.clear();
        void navigate({ to: "/auth/signin", replace: true });
        return;
      }

      toast.success("Sesion cerrada");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Error al cerrar sesion");
    } finally {
      setRevokingSessionToken(null);
    }
  }

  return (
    <SettingsPage
      title="Seguridad"
      description="Protege tu cuenta y prepara controles adicionales de acceso."
    >
      <SettingsSection
        title="Contraseña"
        description="Credencial principal para acceder a tu cuenta."
      >
        {accountsQuery.isLoading ? (
          <div className="max-w-md space-y-4">
            <div className="bg-muted h-10 animate-pulse rounded-md" />
            <div className="bg-muted h-10 animate-pulse rounded-md" />
          </div>
        ) : (
          <div className="max-w-md space-y-4">
            <div className="space-y-4">
              <Field data-disabled={!hasCredentialAccount}>
                <FieldLabel htmlFor="new-password">Nueva contraseña</FieldLabel>
                <InputGroup>
                  <InputGroupInput
                    id="new-password"
                    type={isNewPasswordVisible ? "text" : "password"}
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    autoComplete="new-password"
                    disabled={!hasCredentialAccount}
                  />
                  <InputGroupAddon align="inline-end">
                    <button
                      type="button"
                      onClick={() => setIsNewPasswordVisible((value) => !value)}
                      aria-label={
                        isNewPasswordVisible ? "Ocultar contraseña" : "Mostrar contraseña"
                      }
                      className="text-muted-foreground hover:text-foreground focus-visible:ring-ring/40 cursor-pointer rounded p-1 transition-colors focus-visible:ring-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-60"
                      disabled={!hasCredentialAccount}
                    >
                      {isNewPasswordVisible ? (
                        <EyeOffIcon className="size-4" />
                      ) : (
                        <EyeIcon className="size-4" />
                      )}
                    </button>
                  </InputGroupAddon>
                </InputGroup>
              </Field>
              {hasCredentialAccount && <PasswordStrengthIndicator password={newPassword} />}
              <Field data-disabled={!hasCredentialAccount}>
                <FieldLabel htmlFor="confirm-password">Confirmar contraseña</FieldLabel>
                <InputGroup>
                  <InputGroupInput
                    id="confirm-password"
                    type={isConfirmPasswordVisible ? "text" : "password"}
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    autoComplete="new-password"
                    disabled={!hasCredentialAccount}
                  />
                  <InputGroupAddon align="inline-end">
                    <button
                      type="button"
                      onClick={() => setIsConfirmPasswordVisible((value) => !value)}
                      aria-label={
                        isConfirmPasswordVisible ? "Ocultar confirmación" : "Mostrar confirmación"
                      }
                      className="text-muted-foreground hover:text-foreground focus-visible:ring-ring/40 cursor-pointer rounded p-1 transition-colors focus-visible:ring-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-60"
                      disabled={!hasCredentialAccount}
                    >
                      {isConfirmPasswordVisible ? (
                        <EyeOffIcon className="size-4" />
                      ) : (
                        <EyeIcon className="size-4" />
                      )}
                    </button>
                  </InputGroupAddon>
                </InputGroup>
              </Field>
            </div>
            {!hasCredentialAccount && (
              <p className="text-muted-foreground text-sm">
                Tu cuenta inició sesión con Google. Configura una contraseña para habilitar este
                cambio.
              </p>
            )}
            <div className="flex justify-end">
              <Button
                onClick={handlePasswordReset}
                disabled={!hasCredentialAccount || isSendingPasswordReset || !canSavePassword}
              >
                {isSendingPasswordReset && <Loader2Icon className="mr-2 size-4 animate-spin" />}
                Guardar contraseña
              </Button>
            </div>
          </div>
        )}
      </SettingsSection>

      <SettingsSection
        title="Conexiones"
        description="Métodos de inicio de sesión vinculados a tu cuenta."
      >
        <div className="border-border/70 bg-card/40 max-w-md rounded-xl border">
          {authConnections.map((connection) => (
            <div
              key={connection.key}
              className={cn(
                "flex items-center justify-between px-4 py-3",
                connection.key !== "email" && "border-border/60 border-t",
                !connection.available && "opacity-60",
              )}
            >
              <div className="flex items-center gap-2">
                <div className="bg-muted flex size-10 shrink-0 items-center justify-center rounded-md">
                  {connection.key === "email" ? (
                    <MailIcon className="text-muted-foreground size-4 shrink-0" />
                  ) : connection.key === "github" ? (
                    <GitHubIcon className="size-4 shrink-0" />
                  ) : (
                    <GoogleIcon className="size-4 shrink-0" />
                  )}
                </div>
                <div>
                  <p className="text-sm font-medium">{connection.label}</p>
                  <p className="text-muted-foreground text-sm">{connection.description}</p>
                </div>
              </div>
              <Button variant="outline" size="sm" disabled className="h-8">
                <LinkIcon className="mr-1.5 size-3.5" />
                {connection.linked ? "Desvincular" : "Vincular"}
              </Button>
            </div>
          ))}
        </div>
      </SettingsSection>

      <SettingsSection
        title="Autenticación de dos factores"
        description="Una capa adicional para proteger el inicio de sesión."
      >
        <div className="max-w-md space-y-4">
          {hasCredentialAccount && (
            <Field>
              <FieldLabel htmlFor="mfa-password">Contraseña actual</FieldLabel>
              <div className="flex items-center gap-2">
                <InputGroup>
                  <InputGroupInput
                    id="mfa-password"
                    type="password"
                    value={mfaPassword}
                    onChange={(event) => {
                      const nextValue = event.target.value;
                      setMfaPassword(nextValue);
                      if (isMfaPasswordVerified) {
                        setIsMfaPasswordVerified(false);
                      }
                    }}
                    autoComplete="current-password"
                    placeholder={
                      verifiedTotpFactorId
                        ? "Ingresa tu contraseña para desactivar"
                        : "Ingresa tu contraseña para verificar"
                    }
                    disabled={isMfaPasswordVerified}
                  />
                </InputGroup>
                {!verifiedTotpFactorId && (
                  <StatefulButton
                    onClick={handleVerifyMfaPassword}
                    disabled={!canVerifyMfaPassword}
                    className={!canVerifyMfaPassword ? "opacity-50" : undefined}
                    onComplete={() => {
                      if (!pendingTotpEnrollmentRef.current) return;
                      setIsMfaPasswordVerified(true);
                      setTotpEnrollment(pendingTotpEnrollmentRef.current);
                      pendingTotpEnrollmentRef.current = null;
                      setTotpCode("");
                    }}
                    onError={(err) => {
                      pendingTotpEnrollmentRef.current = null;
                      if (
                        typeof err === "object" &&
                        err !== null &&
                        "code" in err &&
                        err.code === "INVALID_PASSWORD"
                      ) {
                        toast.error("Contraseña inválida");
                        return;
                      }
                      toast.error(
                        getReadableErrorMessage(err, "No se pudo verificar la contraseña"),
                      );
                    }}
                  >
                    Verificar
                  </StatefulButton>
                )}
              </div>
            </Field>
          )}
          {!hasCredentialAccount && !verifiedTotpFactorId && !totpEnrollment && (
            <StatefulButton
              onClick={handleVerifyMfaPassword}
              disabled={!canVerifyMfaPassword}
              className={cn(
                "w-full px-4 sm:w-auto sm:min-w-[220px] sm:justify-center",
                !canVerifyMfaPassword && "opacity-50",
              )}
              onComplete={() => {
                if (!pendingTotpEnrollmentRef.current) return;
                setIsMfaPasswordVerified(true);
                setTotpEnrollment(pendingTotpEnrollmentRef.current);
                pendingTotpEnrollmentRef.current = null;
                setTotpCode("");
              }}
              onError={(err) => {
                pendingTotpEnrollmentRef.current = null;
                toast.error(getReadableErrorMessage(err, "No se pudo iniciar la configuración"));
              }}
            >
              Configurar autenticación
            </StatefulButton>
          )}
          {isLoadingMfa ? (
            <div className="text-muted-foreground flex items-center gap-2 text-sm">
              <Loader2Icon className="size-4 animate-spin" />
              Cargando configuración de 2FA…
            </div>
          ) : verifiedTotpFactorId ? (
            <>
              <div className="flex justify-end">
                <Button
                  variant="outline"
                  onClick={handleDisableMfa}
                  disabled={isDisablingMfa || (hasCredentialAccount && !mfaPassword.trim())}
                >
                  {isDisablingMfa && <Loader2Icon className="mr-2 size-4 animate-spin" />}
                  Desactivar
                </Button>
              </div>
            </>
          ) : totpEnrollment ? (
            <div className="space-y-6">
              <div className="space-y-3">
                <div className="space-y-1">
                  <p className="text-sm font-medium">1. Escanea el código</p>
                  <p className="text-muted-foreground text-sm">
                    Usa Google Authenticator, 1Password, Authy o cualquier app compatible con TOTP.
                  </p>
                </div>
                <div className="grid gap-4 sm:grid-cols-[176px_minmax(0,1fr)] sm:items-center">
                  <div className="mx-auto flex size-44 items-center justify-center sm:mx-0">
                    <div className="border-border rounded-sm border bg-white p-2">
                      <QRCodeComponent
                        value={totpEnrollment.qrCode}
                        size={136}
                        bgColor="#FFFFFF"
                        fgColor="#000000"
                      />
                    </div>
                  </div>
                  <div className="space-y-2">
                    <div className="space-y-1">
                      <p className="text-sm font-medium">Clave manual</p>
                      <p className="text-muted-foreground text-sm">
                        Úsala si no puedes escanear el QR.
                      </p>
                    </div>
                    <div className="flex items-center gap-2">
                      <code className="bg-muted text-muted-foreground min-w-0 flex-1 rounded-md px-2 py-1.5 text-xs break-all">
                        {totpEnrollment.secret ?? totpEnrollment.qrCode}
                      </code>
                      <button
                        type="button"
                        onClick={() => void handleCopyTotpSecret()}
                        aria-label="Copiar clave manual"
                        className="text-muted-foreground hover:text-foreground focus-visible:ring-ring/40 rounded p-1 transition-colors focus-visible:ring-2 focus-visible:outline-none"
                      >
                        <CopyIcon className="size-3.5" />
                      </button>
                    </div>
                  </div>
                </div>
              </div>
              <div className="space-y-3">
                <div className="space-y-1">
                  <p className="text-sm font-medium">2. Verifica el código</p>
                  <p className="text-muted-foreground text-sm">
                    Ingresa el código de 6 dígitos para terminar la configuración.
                  </p>
                </div>
                <Field>
                  <FieldLabel htmlFor="totp-enrollment-code">Código de autenticación</FieldLabel>
                  <InputGroup>
                    <InputGroupInput
                      id="totp-enrollment-code"
                      inputMode="numeric"
                      pattern="[0-9]*"
                      maxLength={6}
                      value={totpCode}
                      onChange={(event) =>
                        setTotpCode(event.target.value.replace(/\D/g, "").slice(0, 6))
                      }
                      autoComplete="one-time-code"
                    />
                  </InputGroup>
                </Field>
              </div>
              <div className="flex justify-end gap-2">
                <Button variant="outline" onClick={() => void handleCancelMfaEnrollment()}>
                  Cancelar
                </Button>
                <StatefulButton
                  onClick={handleVerifyMfaEnrollment}
                  disabled={!canVerifyMfaEnrollment}
                  onComplete={() => {
                    if (!pendingTotpActivationRef.current) return;
                    toast.success("Autenticación de dos factores activada");
                    setTotpEnrollment(null);
                    pendingTotpEnrollmentRef.current = null;
                    setTotpCode("");
                    setIsMfaPasswordVerified(false);
                    pendingTotpActivationRef.current = false;
                    void loadMfaFactors();
                  }}
                  onError={(err) => {
                    pendingTotpActivationRef.current = false;
                    toast.error(getReadableErrorMessage(err, "Código inválido"));
                  }}
                >
                  Activar 2FA
                </StatefulButton>
              </div>
            </div>
          ) : (
            !hasCredentialAccount && (
              <p className="text-muted-foreground text-sm">
                Inicia la configuración para continuar.
              </p>
            )
          )}
        </div>
      </SettingsSection>

      <SettingsSection
        title="Sesiones activas"
        description="Dispositivos donde tu cuenta tiene sesión iniciada."
      >
        <div className="max-w-md space-y-4">
          <div className="flex justify-end">
            <Button
              variant="ghost"
              onClick={handleRevokeOtherSessions}
              disabled={isRevokingOtherSessions || isLoadingSessions || activeSessions.length <= 1}
              className="text-destructive hover:text-destructive/90 hover:bg-destructive/5"
            >
              {isRevokingOtherSessions ? (
                <Loader2Icon className="mr-2 size-4 animate-spin" />
              ) : (
                <LogOutIcon className="mr-2 size-4" />
              )}
              Revocar todas las demás sesiones
            </Button>
          </div>
          <div className="space-y-2">
            {isLoadingSessions ? (
              <div className="text-muted-foreground flex items-center gap-2 text-sm">
                <Loader2Icon className="size-4 animate-spin" />
                Cargando sesiones activas...
              </div>
            ) : activeSessions.length === 0 ? (
              <p className="text-muted-foreground text-sm">No hay sesiones activas.</p>
            ) : (
              activeSessions.map((session) => {
                const isCurrentSession = session.token === currentSessionToken;
                return (
                  <div key={session.id} className="bg-muted/40 flex gap-3 rounded-md border p-3">
                    <div className="text-muted-foreground self-center">
                      <SessionDeviceIcon userAgent={session.userAgent} />
                    </div>
                    <div className="flex min-w-0 flex-1 flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                      <div className="space-y-1">
                        <div className="flex items-center gap-2 text-sm font-medium">
                          <span>{getDeviceName(session.userAgent)}</span>
                          {isCurrentSession && (
                            <span className="rounded-full bg-green-100 px-2 py-0.5 text-[11px] font-semibold text-green-700 dark:bg-green-900/40 dark:text-green-300">
                              Actual
                            </span>
                          )}
                        </div>
                        <p className="text-muted-foreground text-xs">
                          {getSessionMetaItems(session).join(" • ")}
                        </p>
                      </div>
                      <div className="flex items-center gap-3 self-start sm:self-center">
                        <span className="text-muted-foreground text-xs">
                          {getRelativeLastUsedLabel(session, isCurrentSession)}
                        </span>
                        {!isCurrentSession && (
                          <button
                            type="button"
                            onClick={() => void handleRevokeSession(session.token)}
                            disabled={revokingSessionToken === session.token}
                            aria-label="Cerrar sesion"
                            className="text-muted-foreground hover:text-destructive focus-visible:ring-ring/40 cursor-pointer rounded p-1 transition-colors focus-visible:ring-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-50"
                          >
                            {revokingSessionToken === session.token ? (
                              <Loader2Icon className="size-4 animate-spin" />
                            ) : (
                              <LogOutIcon className="size-4" />
                            )}
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })
            )}
          </div>
        </div>
      </SettingsSection>
    </SettingsPage>
  );
}

function GoogleIcon({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" aria-hidden className={className}>
      <path
        fill="#EA4335"
        d="M12 5c1.7 0 3.2.6 4.4 1.7l3.3-3.3C17.7 1.5 15 .5 12 .5 7.3.5 3.3 3.2 1.4 7.1l3.8 3c.9-2.8 3.5-4.6 6.8-4.6Z"
      />
      <path
        fill="#34A853"
        d="M23.5 12.3c0-.8-.1-1.6-.2-2.3H12v4.4h6.5c-.3 1.5-1.1 2.7-2.4 3.6l3.7 2.9c2.2-2 3.7-5 3.7-8.6Z"
      />
      <path
        fill="#FBBC05"
        d="M5.2 14.1c-.2-.7-.4-1.4-.4-2.1s.1-1.4.4-2.1l-3.8-3C.5 8.7 0 10.3 0 12s.5 3.3 1.4 4.7l3.8-2.6Z"
      />
      <path
        fill="#4285F4"
        d="M12 23.5c3.2 0 5.9-1.1 7.9-2.9l-3.7-2.9c-1 .7-2.4 1.2-4.2 1.2-3.3 0-6-2-6.9-4.6l-3.8 3C3.3 20.8 7.3 23.5 12 23.5Z"
      />
    </svg>
  );
}

function GitHubIcon({ className }: { className?: string }) {
  return (
    <svg
      aria-hidden="true"
      viewBox="0 0 24 24"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
      fill="currentColor"
    >
      <title>GitHub</title>
      <path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-0.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12" />
    </svg>
  );
}
