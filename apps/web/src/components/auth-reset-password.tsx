import { Link } from "@tanstack/react-router";
import { CheckIcon, ChevronLeftIcon, Loader2Icon } from "lucide-react";
import { type FormEvent, useEffect, useMemo, useState } from "react";

import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { CardDescription } from "@/components/ui/card";
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import { normalizeAuthError } from "@/lib/auth/auth-error-messages";
import { authClient } from "@/lib/auth/client";

type Mode = "request" | "sent" | "update";

export function AuthResetPasswordPage() {
  const [mode, setMode] = useState<Mode>("request");
  const [email, setEmail] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [pending, setPending] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  const [resetToken, setResetToken] = useState<string | null>(null);

  useEffect(() => {
    const token = new URLSearchParams(window.location.search).get("token");
    if (token) {
      setResetToken(token);
      setMode("update");
    }
  }, []);

  const passwordMismatch = useMemo(
    () => confirmPassword.length > 0 && newPassword !== confirmPassword,
    [confirmPassword, newPassword],
  );

  const onRequestSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const trimmedEmail = email.trim();
    if (!trimmedEmail || pending) return;

    setPending(true);
    setErrorMessage(null);
    setSuccessMessage(null);

    const { error } = await authClient.requestPasswordReset({
      email: trimmedEmail,
      redirectTo: `${window.location.origin}/auth/reset-password`,
    });

    if (error) {
      setErrorMessage(normalizeAuthError(error, "login").message);
      setPending(false);
      return;
    }

    setMode("sent");
    setPending(false);
  };

  const onUpdateSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (pending) return;

    setErrorMessage(null);
    setSuccessMessage(null);

    if (!newPassword || newPassword.length < 8) {
      setErrorMessage("La contraseña debe tener al menos 8 caracteres.");
      return;
    }
    if (newPassword !== confirmPassword) {
      setErrorMessage("Las contraseñas no coinciden.");
      return;
    }
    if (!resetToken) {
      setErrorMessage("El enlace de restablecimiento no es válido o expiró.");
      return;
    }

    setPending(true);
    const { error } = await authClient.resetPassword({ newPassword, token: resetToken });

    if (error) {
      setErrorMessage(normalizeAuthError(error, "login").message);
      setPending(false);
      return;
    }

    setSuccessMessage("Contraseña actualizada. Ya puedes iniciar sesión con tu nueva contraseña.");
    setPending(false);
  };

  return (
    <>
      <div className="w-full">
        {mode === "request" ? (
          <RequestState
            email={email}
            setEmail={setEmail}
            pending={pending}
            errorMessage={errorMessage}
            onSubmit={onRequestSubmit}
          />
        ) : null}

        {mode === "sent" ? (
          <SentState
            email={email}
            onTryDifferent={() => {
              setMode("request");
              setErrorMessage(null);
            }}
          />
        ) : null}

        {mode === "update" ? (
          <UpdateState
            pending={pending}
            newPassword={newPassword}
            confirmPassword={confirmPassword}
            setNewPassword={setNewPassword}
            setConfirmPassword={setConfirmPassword}
            errorMessage={errorMessage}
            successMessage={successMessage}
            passwordMismatch={passwordMismatch}
            onSubmit={onUpdateSubmit}
          />
        ) : null}
      </div>
    </>
  );
}

function BrandMark() {
  return (
    <div className="flex items-center justify-center">
      <div className="bg-foreground flex size-8 items-center justify-center rounded-md">
        <span className="bg-background block size-2 rounded-full" />
      </div>
    </div>
  );
}

function RequestState({
  email,
  setEmail,
  pending,
  errorMessage,
  onSubmit,
}: {
  email: string;
  setEmail: (value: string) => void;
  pending: boolean;
  errorMessage: string | null;
  onSubmit: (e: FormEvent<HTMLFormElement>) => void;
}) {
  return (
    <>
      <div className="items-center text-center">
        <BrandMark />
        <h1 className="font-heading mt-4 text-2xl tracking-tight">Restablecer contraseña</h1>
        <CardDescription className="text-sm">
          Ingresa tu correo y te enviaremos un enlace para crear una nueva contraseña.
        </CardDescription>
      </div>
      <div className="mt-4">
        <form onSubmit={onSubmit} className="flex flex-col gap-4">
          {errorMessage ? (
            <Alert variant="destructive">
              <AlertTitle>No se pudo enviar el enlace</AlertTitle>
              <AlertDescription>{errorMessage}</AlertDescription>
            </Alert>
          ) : null}

          <Field>
            <FieldLabel htmlFor="reset-email">Correo electrónico</FieldLabel>
            <Input
              id="reset-email"
              type="email"
              required
              placeholder="nombre@ejemplo.com"
              autoComplete="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </Field>

          <Button type="submit" size="lg" disabled={pending} className="mt-1">
            {pending ? <Loader2Icon className="animate-spin" /> : null}
            {pending ? "Enviando..." : "Enviar enlace"}
          </Button>
        </form>
      </div>
      <div className="mt-4 flex justify-center">
        <Link
          to="/auth/signin"
          className="text-muted-foreground hover:text-foreground inline-flex items-center gap-1.5 text-sm"
        >
          <ChevronLeftIcon className="size-3.5" />
          Volver a iniciar sesión
        </Link>
      </div>
    </>
  );
}

function SentState({ email, onTryDifferent }: { email: string; onTryDifferent: () => void }) {
  return (
    <>
      <div className="items-center text-center">
        <div className="flex size-14 items-center justify-center rounded-full bg-emerald-500/15">
          <CheckIcon className="size-6 text-emerald-600" />
        </div>
        <h1 className="font-heading mt-4 text-2xl tracking-tight">Revisa tu correo</h1>
        <CardDescription className="text-sm break-words">
          Te enviamos un enlace de recuperación a{" "}
          <strong className="text-foreground break-all">{email}</strong>
        </CardDescription>
      </div>
      <div className="mt-4 flex flex-col gap-4">
        <p className="text-muted-foreground text-center text-xs">
          El enlace expira en 1 hora. Si no lo ves, revisa spam o promociones.
        </p>
        <Button variant="ghost" size="lg" onClick={onTryDifferent}>
          Usar otro correo
        </Button>
      </div>
      <div className="mt-4 flex justify-center">
        <Link to="/auth/signin" className="text-muted-foreground hover:text-foreground text-xs">
          Volver a iniciar sesión
        </Link>
      </div>
    </>
  );
}

function UpdateState({
  pending,
  newPassword,
  confirmPassword,
  setNewPassword,
  setConfirmPassword,
  errorMessage,
  successMessage,
  passwordMismatch,
  onSubmit,
}: {
  pending: boolean;
  newPassword: string;
  confirmPassword: string;
  setNewPassword: (value: string) => void;
  setConfirmPassword: (value: string) => void;
  errorMessage: string | null;
  successMessage: string | null;
  passwordMismatch: boolean;
  onSubmit: (e: FormEvent<HTMLFormElement>) => void;
}) {
  return (
    <>
      <div className="items-center text-center">
        <BrandMark />
        <h1 className="font-heading mt-4 text-2xl tracking-tight">Crea una nueva contraseña</h1>
        <CardDescription className="text-sm">
          Elige una contraseña segura para tu cuenta.
        </CardDescription>
      </div>
      <div className="mt-4">
        <form onSubmit={onSubmit} className="flex flex-col gap-4">
          {errorMessage ? (
            <Alert variant="destructive">
              <AlertTitle>No se pudo actualizar</AlertTitle>
              <AlertDescription>{errorMessage}</AlertDescription>
            </Alert>
          ) : null}

          {successMessage ? (
            <Alert>
              <AlertTitle>Contraseña actualizada</AlertTitle>
              <AlertDescription>{successMessage}</AlertDescription>
            </Alert>
          ) : null}

          <Field>
            <FieldLabel htmlFor="new-password">Nueva contraseña</FieldLabel>
            <Input
              id="new-password"
              type="password"
              required
              minLength={8}
              autoComplete="new-password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
            />
          </Field>

          <Field>
            <FieldLabel htmlFor="confirm-new-password">Confirmar contraseña</FieldLabel>
            <Input
              id="confirm-new-password"
              type="password"
              required
              minLength={8}
              autoComplete="new-password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
            />
            <FieldError>{passwordMismatch ? "Las contraseñas no coinciden." : null}</FieldError>
          </Field>

          <Button type="submit" size="lg" disabled={pending || passwordMismatch} className="mt-1">
            {pending ? <Loader2Icon className="animate-spin" /> : null}
            {pending ? "Actualizando..." : "Guardar nueva contraseña"}
          </Button>
        </form>
      </div>
      <div className="mt-4 flex justify-center">
        <Link to="/auth/signin" className="text-muted-foreground hover:text-foreground text-xs">
          Volver a iniciar sesión
        </Link>
      </div>
    </>
  );
}
