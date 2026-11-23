import { Mail01Icon, RefreshCwIcon } from "@hugeicons/core-free-icons";
import { createLazyFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useCallback, useEffect, useRef, useState } from "react";

import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { CardDescription } from "@/components/ui/card";
import { Icon } from "@/components/ui/icon";
import { Spinner } from "@/components/ui/spinner";
import { authClient, getSession } from "@/lib/auth/client";
import { useAuthCallbackError } from "@/lib/hooks/use-auth-callback-error";

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
  const [status, setStatus] = useState<"loading" | "pending">("loading");
  const [resending, setResending] = useState(false);
  const [resendSuccess, setResendSuccess] = useState(false);
  const [resendError, setResendError] = useState<string | null>(null);
  const [secondsLeft, setSecondsLeft] = useState(0);
  const [email, setEmail] = useState<string | null>(null);
  const redirectingRef = useRef(false);
  const callbackError = useAuthCallbackError();

  const checkSession = useCallback(async () => {
    try {
      const { data: session, error } = await getSession();

      if (error) {
        setStatus("pending");
        return;
      }

      if (session?.user?.email) {
        setEmail(session.user.email);
        window.sessionStorage.setItem(VERIFY_EMAIL_KEY, session.user.email);
      }

      if (session) {
        if (!redirectingRef.current) {
          redirectingRef.current = true;
          void navigate({ to: "/schedule", replace: true });
        }
        return;
      }

      setStatus("pending");
    } catch {
      setStatus("pending");
    }
  }, [navigate]);

  useEffect(() => {
    const storedEmail = window.sessionStorage.getItem(VERIFY_EMAIL_KEY);
    if (storedEmail) {
      setEmail(storedEmail);
    }

    void checkSession();

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
        callbackURL: `${window.location.origin}/schedule`,
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

  const title = isLoading ? "Verificando tu correo" : "Revisa tu correo";
  const description = isLoading
    ? "Esto solo tomará un momento."
    : "Enviamos un enlace de verificación a";

  return (
    <>
      <div className="w-full text-center">
        <div className="bg-primary/10 mx-auto mb-4 flex size-14 items-center justify-center rounded-full">
          {isLoading ? (
            <Spinner className="text-muted-foreground size-7" />
          ) : (
            <Icon icon={Mail01Icon} size={28} className="text-primary size-7" />
          )}
        </div>
        <h1 className="text-2xl font-semibold tracking-tight">{title}</h1>
        <CardDescription className="text-center">
          {isLoading ? (
            description
          ) : (
            <>
              {description} {email ?? "tu correo"}.
            </>
          )}
        </CardDescription>

        {callbackError ? (
          <Alert variant="destructive" className="mt-4 text-left">
            <AlertTitle>{callbackError.title}</AlertTitle>
            <AlertDescription>{callbackError.message}</AlertDescription>
          </Alert>
        ) : null}

        {!isLoading ? (
          <>
            <div className="mt-4 flex flex-col gap-4">
              <p className="text-muted-foreground mx-auto max-w-sm text-center text-sm">
                ¿No lo recibiste? Revisa spam o promociones.
              </p>

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
                {resending && (
                  <p className="text-muted-foreground text-center text-xs">Enviando…</p>
                )}
              </div>

              {resendError && <p className="text-destructive text-center text-sm">{resendError}</p>}

              <div className="flex items-center justify-center gap-2 pt-2">
                <Button variant="ghost" size="sm" onClick={() => navigate({ to: "/auth/signin" })}>
                  Volver a inicio de sesión
                </Button>
              </div>
            </div>

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
          </>
        ) : null}
      </div>
    </>
  );
}
