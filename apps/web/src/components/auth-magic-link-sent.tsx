import { ArrowLeft01Icon, LinkSquare01Icon } from "@hugeicons/core-free-icons";
import { Link } from "@tanstack/react-router";
import { type FormEvent, useEffect, useState } from "react";

import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Field, FieldLabel } from "@/components/ui/field";
import { Icon } from "@/components/ui/icon";
import { Input } from "@/components/ui/input";
import { Spinner } from "@/components/ui/spinner";
import { normalizeAuthError } from "@/lib/auth/auth-error-messages";
import { signIn } from "@/lib/auth/client";

const RESEND_SECONDS = 30;
const MAGIC_LINK_EMAIL_KEY = "claustrum.auth.magic_link_email";

const EMAIL_PROVIDER_URLS: Record<string, string> = {
  "gmail.com": "https://mail.google.com",
  "googlemail.com": "https://mail.google.com",
  "outlook.com": "https://outlook.live.com/mail/",
  "hotmail.com": "https://outlook.live.com/mail/",
  "live.com": "https://outlook.live.com/mail/",
  "msn.com": "https://outlook.live.com/mail/",
  "yahoo.com": "https://mail.yahoo.com",
  "yahoo.es": "https://mail.yahoo.com",
  "icloud.com": "https://www.icloud.com/mail",
  "me.com": "https://www.icloud.com/mail",
  "mac.com": "https://www.icloud.com/mail",
  "proton.me": "https://mail.proton.me",
  "protonmail.com": "https://mail.proton.me",
  "aol.com": "https://mail.aol.com",
  "zoho.com": "https://mail.zoho.com",
};

function getEmailProviderUrl(email: string | null): string {
  if (!email) return "mailto:";
  const domain = email.split("@")[1]?.toLowerCase() ?? "";
  return EMAIL_PROVIDER_URLS[domain] ?? "mailto:";
}

type Mode = "request" | "sent";

export function AuthMagicLinkSentPage() {
  const [mode, setMode] = useState<Mode>("request");
  const [email, setEmail] = useState("");
  const [sentEmail, setSentEmail] = useState("");
  const [isSending, setIsSending] = useState(false);
  const [secondsLeft, setSecondsLeft] = useState(RESEND_SECONDS);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  useEffect(() => {
    const storedEmail = window.sessionStorage.getItem(MAGIC_LINK_EMAIL_KEY);
    if (storedEmail) {
      setEmail(storedEmail);
    }
  }, []);

  useEffect(() => {
    if (mode !== "sent" || secondsLeft <= 0) return;
    const timer = window.setInterval(() => setSecondsLeft((s) => s - 1), 1000);
    return () => window.clearInterval(timer);
  }, [mode, secondsLeft]);

  const handleSendMagicLink = async (targetEmail: string, isResend = false) => {
    const trimmedEmail = targetEmail.trim();
    if (!trimmedEmail || !/^\S+@\S+\.\S+$/.test(trimmedEmail)) {
      setErrorMessage("Ingresa un correo electrónico válido para enviar el enlace.");
      return;
    }

    if (isResend && secondsLeft > 0) return;

    setIsSending(true);
    setErrorMessage(null);

    const { error } = await signIn.magicLink({
      email: trimmedEmail,
      callbackURL: `${window.location.origin}/`,
    });

    if (error) {
      setErrorMessage(normalizeAuthError(error, "login").message);
      setIsSending(false);
      return;
    }

    window.sessionStorage.setItem(MAGIC_LINK_EMAIL_KEY, trimmedEmail);
    setSentEmail(trimmedEmail);
    setSecondsLeft(RESEND_SECONDS);
    setMode("sent");
    setIsSending(false);
  };

  const onSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    await handleSendMagicLink(email);
  };

  const onResend = async () => {
    if (!sentEmail) return;
    await handleSendMagicLink(sentEmail, true);
  };

  const formatCountdown = (s: number) => {
    const m = Math.floor(s / 60);
    const r = s % 60;
    return `${m}:${String(r).padStart(2, "0")}`;
  };

  return (
    <div className="w-full">
      {mode === "request" ? (
        <RequestState
          email={email}
          setEmail={setEmail}
          isSending={isSending}
          errorMessage={errorMessage}
          onSubmit={onSubmit}
        />
      ) : (
        <SentState
          sentEmail={sentEmail}
          secondsLeft={secondsLeft}
          isSending={isSending}
          formatCountdown={formatCountdown}
          onResend={onResend}
          onTryDifferent={() => {
            setMode("request");
            setErrorMessage(null);
          }}
        />
      )}
    </div>
  );
}

function RequestState({
  email,
  setEmail,
  isSending,
  errorMessage,
  onSubmit,
}: {
  email: string;
  setEmail: (value: string) => void;
  isSending: boolean;
  errorMessage: string | null;
  onSubmit: (e: FormEvent<HTMLFormElement>) => void;
}) {
  return (
    <>
      <div className="flex flex-col gap-1.5">
        <h1 className="font-heading text-2xl font-semibold tracking-tight">
          Acceso con enlace mágico
        </h1>
        <p className="text-muted-foreground text-sm">
          Ingresa tu correo y te enviaremos un enlace para iniciar sesión sin contraseña.
        </p>
      </div>

      <div className="mt-6">
        <form onSubmit={onSubmit} className="flex flex-col gap-4">
          {errorMessage ? (
            <Alert variant="destructive">
              <AlertTitle>No se pudo enviar el enlace</AlertTitle>
              <AlertDescription>{errorMessage}</AlertDescription>
            </Alert>
          ) : null}

          <Field>
            <FieldLabel htmlFor="magic-link-email">Correo electrónico</FieldLabel>
            <Input
              id="magic-link-email"
              type="email"
              required
              placeholder="nombre@ejemplo.com"
              autoComplete="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </Field>

          <Button type="submit" size="lg" disabled={isSending} className="mt-1">
            {isSending ? <Spinner className="size-4" /> : null}
            {isSending ? "Enviando enlace..." : "Enviar enlace mágico"}
          </Button>
        </form>
      </div>

      <div className="mt-5 text-center text-sm">
        <Link
          to="/auth/signin"
          className="text-muted-foreground hover:text-foreground inline-flex items-center gap-1.5"
        >
          <Icon icon={ArrowLeft01Icon} size={14} className="size-3.5" />
          Volver a iniciar sesión
        </Link>
      </div>
    </>
  );
}

function SentState({
  sentEmail,
  secondsLeft,
  isSending,
  formatCountdown,
  onResend,
  onTryDifferent,
}: {
  sentEmail: string;
  secondsLeft: number;
  isSending: boolean;
  formatCountdown: (seconds: number) => string;
  onResend: () => Promise<void>;
  onTryDifferent: () => void;
}) {
  return (
    <>
      <div className="flex flex-col gap-1.5">
        <h1 className="font-heading text-2xl font-semibold tracking-tight">Revisa tu correo</h1>
        <p className="text-muted-foreground text-sm leading-relaxed break-words">
          Si la dirección <strong className="text-foreground break-all">{sentEmail}</strong> está
          registrada en Claustrum recibirás un mensaje con un enlace para iniciar sesión, el cual
          expira en 10 minutos, por lo que si no encuentras el correo revisa tu carpeta de spam o
          promociones.
        </p>
      </div>

      <div className="mt-6 flex flex-col gap-3">
        <Button
          variant="default"
          size="lg"
          className="w-full"
          render={
            <a
              href={getEmailProviderUrl(sentEmail)}
              target="_blank"
              rel="noreferrer"
              aria-label="Abrir proveedor de correo"
            />
          }
        >
          Abrir correo
          <Icon icon={LinkSquare01Icon} size={16} />
        </Button>

        <div className="flex items-center justify-between px-1 text-xs">
          <button
            type="button"
            disabled={secondsLeft > 0 || isSending}
            onClick={onResend}
            className="text-muted-foreground hover:text-foreground cursor-pointer transition-colors disabled:cursor-not-allowed disabled:opacity-50"
          >
            {secondsLeft > 0
              ? `Reenviar en ${formatCountdown(secondsLeft)}`
              : isSending
                ? "Reenviando..."
                : "Reenviar enlace"}
          </button>
          <button
            type="button"
            onClick={onTryDifferent}
            className="text-muted-foreground hover:text-foreground cursor-pointer transition-colors"
          >
            Cambiar correo
          </button>
        </div>
      </div>

      <div className="mt-6 text-center text-sm">
        <Link
          to="/auth/signin"
          className="text-muted-foreground hover:text-foreground inline-flex items-center gap-1.5"
        >
          <Icon icon={ArrowLeft01Icon} size={14} className="size-3.5" />
          Volver a iniciar sesión
        </Link>
      </div>
    </>
  );
}
