import { CheckmarkCircle02Icon, Mail01Icon, RefreshCwIcon } from "@hugeicons/core-free-icons";
import { createLazyFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useCallback, useEffect, useRef, useState } from "react";

import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { CardDescription } from "@/components/ui/card";
import { Icon } from "@/components/ui/icon";
import { Spinner } from "@/components/ui/spinner";
import { authClient, getSession } from "@/lib/auth/client";
import { useAuthCallbackError } from "@/lib/hooks/use-auth-callback-error";
import { useSessionStorageValue } from "@/lib/hooks/use-session-storage";

const VERIFY_EMAIL_KEY = "claustrum.auth.verify_email";
const RESEND_SECONDS = 30;

function formatCountdown(seconds: number) {
  const minutes = Math.floor(seconds / 60);
  const remainder = seconds % 60;
  return `${minutes}:${String(remainder).padStart(2, "0")}`;
}

export const Route = createLazyFileRoute("/auth/verify-email/")({
  component: VerifyEmailPage,
});

function VerifyEmailPage() {
  const navigate = useNavigate();
  const [status, setStatus] = useState<"loading" | "success" | "pending">("loading");
  const [resending, setResending] = useState(false);
  const [resendSuccess, setResendSuccess] = useState(false);
  const [resendError, setResendError] = useState<string | null>(null);
  const [secondsLeft, setSecondsLeft] = useState(0);
  const [sessionEmail, setSessionEmail] = useState<string | null>(null);
  const storedEmail = useSessionStorageValue(VERIFY_EMAIL_KEY);
  const email = sessionEmail ?? (storedEmail || null);
  const redirectScheduledRef = useRef(false);
  const callbackError = useAuthCallbackError();

  const checkSession = useCallback(async () => {
    try {
      const { data: session, error } = await getSession();

      if (error) {
        setStatus("pending");
        return;
      }

      if (session?.user?.email) {
        setSessionEmail(session.user.email);
        window.sessionStorage.setItem(VERIFY_EMAIL_KEY, session.user.email);
      }

      if (session) {
        setStatus("success");
        if (!redirectScheduledRef.current) {
          redirectScheduledRef.current = true;
          window.setTimeout(() => {
            void navigate({ to: "/" });
          }, 2000);
        }
      } else {
        setStatus("pending");
      }
    } catch {
      setStatus("pending");
    }
  }, [navigate]);

  useEffect(() => {
    // Defer to a microtask so the mount effect does not synchronously update state.
    void Promise.resolve().then(checkSession);

    const onFocus = () => {
      void checkSession();
    };
    const onVisibilityChange = () => {
      if (document.visibilityState === "visible") {
        void checkSession();
      }
    };

    window.addEventListener("focus", onFocus);
    document.addEventListener("visibilitychange", onVisibilityChange);

    return () => {
      window.removeEventListener("focus", onFocus);
      document.removeEventListener("visibilitychange", onVisibilityChange);
    };
  }, [checkSession]);

  useEffect(() => {
    if (secondsLeft <= 0) return undefined;

    const timer = window.setInterval(() => {
      setSecondsLeft((current) => Math.max(0, current - 1));
    }, 1000);

    return () => window.clearInterval(timer);
  }, [secondsLeft]);

  const handleResendEmail = async () => {
    if (secondsLeft > 0 || resending) return;

    if (!email) {
      setResendError("Inicia sesión de nuevo para que te enviemos otro enlace.");
      return;
    }

    setResending(true);
    setResendError(null);

    try {
      const trimmedEmail = email.trim();
      const { error } = await authClient.sendVerificationEmail({
        email: trimmedEmail,
        callbackURL: `${window.location.origin}/auth/verify-email`,
      });

      if (error) {
        setResendError(error.message ?? "No se pudo reenviar el correo");
      } else {
        setResendSuccess(true);
        setSecondsLeft(RESEND_SECONDS);
      }
    } catch {
      setResendError("Ocurrió un error inesperado");
    } finally {
      setResending(false);
    }
  };

  const isLoading = status === "loading";
  const isSuccess = status === "success";
  const isPending = status === "pending";

  const title = isLoading
    ? "Verificando tu correo"
    : isSuccess
      ? "¡Correo verificado!"
      : "Revisa tu correo";
  const description = isLoading
    ? "Esto solo tomará un momento."
    : isSuccess
      ? "Redirigiendo a tu panel..."
      : "Enviamos un enlace de verificación a";

  return (
    <>
      <div className="w-full text-center">
        <div
          className={`mx-auto mb-4 flex size-14 items-center justify-center rounded-full ${
            isSuccess ? "bg-emerald-500/10" : "bg-primary/10"
          }`}
        >
          {isLoading ? (
            <Spinner className="text-muted-foreground size-7" />
          ) : isSuccess ? (
            <Icon
              icon={CheckmarkCircle02Icon}
              size={28}
              className="size-7 text-emerald-600 dark:text-emerald-400"
            />
          ) : (
            <Icon icon={Mail01Icon} size={28} className="text-primary size-7" />
          )}
        </div>
        <h1 className="text-2xl font-semibold tracking-tight">{title}</h1>
        <CardDescription className="text-center">
          {isPending ? (
            <>
              {description} {email ?? "tu correo"}.
            </>
          ) : (
            description
          )}
        </CardDescription>

        {callbackError ? (
          <Alert variant="destructive" className="mt-4 text-left">
            <AlertTitle>{callbackError.title}</AlertTitle>
            <AlertDescription>{callbackError.message}</AlertDescription>
          </Alert>
        ) : null}

        <div className="mt-4 flex flex-col gap-4">
          {isPending && (
            <p className="text-muted-foreground mx-auto max-w-sm text-center text-sm">
              ¿No lo recibiste? Revisa spam o promociones.
            </p>
          )}

          {isPending && (
            <div className="flex flex-col gap-3">
              {resendSuccess ? (
                <div className="rounded-lg bg-emerald-50 p-4 text-sm text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300">
                  <p>Correo enviado correctamente. Por favor revisa tu bandeja de entrada.</p>
                </div>
              ) : null}
              <Button
                variant="outline"
                className="w-full"
                onClick={handleResendEmail}
                loading={resending}
                disabled={secondsLeft > 0}
              >
                <Icon icon={RefreshCwIcon} size={16} className="mr-2 size-4" />
                {secondsLeft > 0
                  ? `Reenviar en ${formatCountdown(secondsLeft)}`
                  : "Reenviar correo de verificación"}
              </Button>
              {resending && <p className="text-muted-foreground text-center text-xs">Enviando…</p>}
            </div>
          )}

          {isPending && resendError && (
            <p className="text-destructive text-center text-sm">{resendError}</p>
          )}

          {isPending && (
            <div className="flex items-center justify-center gap-2 pt-2">
              <Button variant="ghost" size="sm" onClick={() => navigate({ to: "/auth/signin" })}>
                Volver a inicio de sesión
              </Button>
            </div>
          )}
        </div>

        {isPending ? (
          <p className="text-muted-foreground mt-4 text-xs leading-relaxed">
            ¿Ya tenías una cuenta con este correo?{" "}
            <Link
              to="/auth/reset-password"
              className="hover:text-foreground underline underline-offset-4"
            >
              Restablece tu contraseña
            </Link>
            .
          </p>
        ) : null}
      </div>
    </>
  );
}
