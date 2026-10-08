import { useQueryClient } from "@tanstack/react-query";
import { Link, useNavigate } from "@tanstack/react-router";
import { CircleHelpIcon, Loader2Icon } from "lucide-react";
import { type FormEvent, useEffect, useRef, useState } from "react";

import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { authClient, getSession } from "@/lib/auth/client";
import { cn } from "@/lib/utils";

const CODE_LENGTH = 6;

export function AuthTwoFactorPage() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [code, setCode] = useState<string[]>(() => Array.from({ length: CODE_LENGTH }, () => ""));
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isLoadingFactor, setIsLoadingFactor] = useState(true);
  const [isVerifying, setIsVerifying] = useState(false);
  const inputRefs = useRef<Array<HTMLInputElement | null>>([]);

  const verificationCode = code.join("");
  const canVerify = verificationCode.length === CODE_LENGTH;

  useEffect(() => {
    async function loadFactor() {
      setIsLoadingFactor(true);
      setErrorMessage(null);

      const { data } = await getSession();
      if (data?.user && !data.user.twoFactorEnabled) {
        void navigate({ to: "/overview", replace: true });
        return;
      }

      setIsLoadingFactor(false);
    }

    void loadFactor();
  }, [navigate]);

  function focusInput(index: number) {
    inputRefs.current[index]?.focus();
    inputRefs.current[index]?.select();
  }

  function setCodeAt(index: number, value: string) {
    const normalizedValue = value.replace(/\D/g, "");

    if (normalizedValue.length > 1) {
      handlePaste(normalizedValue);
      return;
    }

    const digit = normalizedValue.slice(-1);
    const nextCode = [...code];
    nextCode[index] = digit;
    setCode(nextCode);

    if (digit && index < CODE_LENGTH - 1) {
      focusInput(index + 1);
    }
  }

  function handlePaste(value: string) {
    const digits = value.replace(/\D/g, "").slice(0, CODE_LENGTH).split("");
    if (digits.length === 0) return;

    const nextCode = Array.from({ length: CODE_LENGTH }, (_, index) => digits[index] ?? "");
    setCode(nextCode);
    focusInput(Math.min(digits.length, CODE_LENGTH - 1));
  }

  function handleKeyDown(index: number, key: string) {
    if (key === "Backspace" && !code[index] && index > 0) {
      focusInput(index - 1);
    }

    if (key === "ArrowLeft" && index > 0) {
      focusInput(index - 1);
    }

    if (key === "ArrowRight" && index < CODE_LENGTH - 1) {
      focusInput(index + 1);
    }
  }

  async function handleVerify(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!canVerify || isVerifying) return;

    setIsVerifying(true);
    setErrorMessage(null);

    const { error } = await authClient.twoFactor.verifyTotp({
      code: verificationCode,
      trustDevice: true,
    });

    if (error) {
      setErrorMessage(error.message ?? "Código inválido");
      setIsVerifying(false);
      return;
    }

    await queryClient.invalidateQueries({ queryKey: ["appState"] });
    setIsVerifying(false);
    void navigate({ to: "/overview", replace: true });
  }

  return (
    <form onSubmit={handleVerify} className="flex flex-col gap-5 text-center">
      <div className="space-y-2">
        <p className="text-muted-foreground text-[0.65rem] font-medium tracking-[0.28em] uppercase">
          Paso 2 de 2
        </p>
        <h1 className="font-heading text-2xl font-semibold tracking-tight">
          Autenticación de dos factores
        </h1>
        <p className="text-muted-foreground mx-auto max-w-sm text-sm leading-6">
          Abre tu aplicación autenticadora e ingresa el código de 6 dígitos.
        </p>
      </div>

      {errorMessage ? (
        <Alert variant="destructive" className="text-left">
          <AlertTitle>No se pudo verificar</AlertTitle>
          <AlertDescription>{errorMessage}</AlertDescription>
        </Alert>
      ) : null}

      <fieldset
        className="flex items-center justify-center gap-2"
        aria-label="Código de autenticación"
      >
        {code.map((digit, index) => (
          <div key={`code-input-${index}`} className="flex items-center gap-2">
            <input
              ref={(element) => {
                inputRefs.current[index] = element;
              }}
              inputMode="numeric"
              pattern="[0-9]*"
              autoComplete={index === 0 ? "one-time-code" : "off"}
              value={digit}
              onChange={(event) => setCodeAt(index, event.target.value)}
              onPaste={(event) => {
                event.preventDefault();
                handlePaste(event.clipboardData.getData("text"));
              }}
              onKeyDown={(event) => handleKeyDown(index, event.key)}
              aria-label={`Dígito ${index + 1}`}
              className={cn(
                "border-input bg-background h-12 w-10 rounded-lg border text-center text-lg font-medium tabular-nums shadow-xs transition-[color,box-shadow] outline-none",
                "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
                "sm:h-13 sm:w-11",
              )}
            />
            {index === 2 ? <span className="text-muted-foreground">-</span> : null}
          </div>
        ))}
      </fieldset>

      <Button type="submit" size="lg" disabled={!canVerify || isVerifying || isLoadingFactor}>
        {isVerifying && <Loader2Icon className="mr-2 size-4 animate-spin" />}
        {isLoadingFactor ? "Cargando..." : "Verificar"}
      </Button>

      <p className="text-muted-foreground flex items-center justify-center gap-1.5 text-xs">
        <CircleHelpIcon className="size-3.5" />
        ¿Perdiste el acceso?{" "}
        <Link to="/policies" className="text-foreground underline underline-offset-4">
          Contactar a soporte
        </Link>
      </p>
    </form>
  );
}
