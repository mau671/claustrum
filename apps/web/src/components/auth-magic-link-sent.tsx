import { Link } from "@tanstack/react-router";
import { ExternalLinkIcon } from "lucide-react";
import { type FormEvent, useEffect, useState } from "react";

import { Button } from "@/components/ui/button";
import { Field, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
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

export function AuthMagicLinkSentPage() {
  const [email, setEmail] = useState("");
  const [lastSentEmail, setLastSentEmail] = useState<string | null>(null);
  const [isSending, setIsSending] = useState(false);
  const [secondsLeft, setSecondsLeft] = useState(RESEND_SECONDS);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);

  useEffect(() => {
    const storedEmail = window.sessionStorage.getItem(MAGIC_LINK_EMAIL_KEY);
    if (!storedEmail) {
      setSecondsLeft(0);
      return;
    }

    setEmail(storedEmail);
    setLastSentEmail(storedEmail);
  }, []);

  useEffect(() => {
    if (secondsLeft <= 0) return;
    const t = window.setInterval(() => setSecondsLeft((s) => s - 1), 1000);
    return () => window.clearInterval(t);
  }, [secondsLeft]);

  const sendMagicLink = async (targetEmail: string, isResend = false) => {
    const trimmedEmail = targetEmail.trim();
    if (!trimmedEmail || !/^\S+@\S+\.\S+$/.test(trimmedEmail)) {
      setErrorMessage("Ingresa un correo válido para enviar el enlace.");
      return;
    }

    if (isResend && secondsLeft > 0) return;

    setIsSending(true);
    setErrorMessage(null);
    setSuccessMessage(null);

    const { error } = await signIn.magicLink({
      email: trimmedEmail,
      callbackURL: `${window.location.origin}/auth/signin`,
    });

    if (error) {
      setErrorMessage(normalizeAuthError(error, "login").message);
      setIsSending(false);
      return;
    }

    window.sessionStorage.setItem(MAGIC_LINK_EMAIL_KEY, trimmedEmail);
    setLastSentEmail(trimmedEmail);
    setEmail(trimmedEmail);
    setSecondsLeft(RESEND_SECONDS);
    setSuccessMessage("Enlace enviado. Revisa tu correo.");
    setIsSending(false);
  };

  const onSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    await sendMagicLink(email);
  };

  const onResend = async () => {
    if (!lastSentEmail) return;
    await sendMagicLink(lastSentEmail, true);
  };

  const formatCountdown = (s: number) => {
    const m = Math.floor(s / 60);
    const r = s % 60;
    return `${m}:${String(r).padStart(2, "0")}`;
  };

  return (
    <>
      <style>{`
        @keyframes magic-float-a {
          0%, 100% { transform: translate(0, 0); opacity: 0.55; }
          50% { transform: translate(0, -6px); opacity: 0.95; }
        }
        @keyframes magic-float-b {
          0%, 100% { transform: translate(0, 0); opacity: 0.45; }
          50% { transform: translate(0, -8px); opacity: 0.85; }
        }
        @keyframes magic-float-c {
          0%, 100% { transform: translate(0, 0); opacity: 0.35; }
          50% { transform: translate(2px, -5px); opacity: 0.75; }
        }
        @keyframes magic-pulse-dot {
          0%, 100% { opacity: 0.55; transform: scale(1); }
          50% { opacity: 1; transform: scale(1.2); }
        }
      `}</style>
      <div className="flex flex-col items-center text-center">
        <EnvelopeArt />
        <h1 className="font-heading mt-3 text-3xl tracking-tight">Acceso con enlace mágico</h1>

        <p className="text-muted-foreground mt-3 text-sm">
          Te enviaremos un enlace para iniciar sesión sin contraseña.
        </p>

        <form onSubmit={onSubmit} className="mt-5 w-full space-y-3 text-left">
          <Field>
            <FieldLabel htmlFor="magic-link-email">Correo</FieldLabel>
            <Input
              id="magic-link-email"
              type="email"
              autoComplete="email"
              placeholder="nombre@ejemplo.com"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
            />
          </Field>
          <Button type="submit" size="lg" className="w-full" disabled={isSending}>
            {isSending ? "Enviando enlace..." : "Enviar enlace mágico"}
          </Button>
        </form>

        <p className="text-muted-foreground mt-4 max-w-xs text-xs leading-relaxed">
          El enlace expira en 10 minutos.
        </p>

        {lastSentEmail ? (
          <div className="text-foreground mt-1 font-mono text-sm">{lastSentEmail}</div>
        ) : null}

        {successMessage ? (
          <p className="mt-3 max-w-xs text-center text-sm text-emerald-600">{successMessage}</p>
        ) : null}

        {errorMessage ? (
          <p className="text-destructive mt-3 max-w-xs text-center text-sm">{errorMessage}</p>
        ) : null}

        <div className="mt-7 flex w-full flex-col gap-2">
          <Button variant="outline" size="lg" className="w-full" asChild>
            <a href={getEmailProviderUrl(lastSentEmail)} target="_blank" rel="noreferrer">
              Abrir correo
              <ExternalLinkIcon />
            </a>
          </Button>
          <Button
            variant="ghost"
            size="default"
            className="w-full"
            type="button"
            disabled={secondsLeft > 0 || !lastSentEmail || isSending}
            onClick={onResend}
          >
            {secondsLeft > 0 ? `Reenviar en ${formatCountdown(secondsLeft)}` : "Reenviar enlace"}
          </Button>
        </div>

        <p className="text-muted-foreground mt-6 text-xs">
          ¿No te llegó? Revisa spam o promociones, o{" "}
          <Link to="/auth/signin" className="underline">
            vuelve a iniciar sesión
          </Link>
          .
        </p>
      </div>
    </>
  );
}

function EnvelopeArt() {
  return (
    <div className="relative flex size-24 items-center justify-center">
      <div className="border-border bg-card text-foreground relative flex size-16 items-center justify-center rounded-2xl border shadow-sm">
        <svg
          viewBox="0 0 20 16"
          aria-hidden
          className="h-8 w-10"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.4"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          <rect x="1" y="2" width="18" height="12" rx="2.4" />
          <path d="M2 4l8 5.2L18 4" />
          <circle cx="16.2" cy="11.8" r="1.4" fill="currentColor" stroke="none" />
        </svg>
      </div>
    </div>
  );
}
