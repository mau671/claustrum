import { Cancel01Icon, Tick01Icon, ViewIcon, ViewOffSlashIcon } from "@hugeicons/core-free-icons";
import { useMemo, useState } from "react";

import type { InputProps } from "@/components/ui/input";

import { Button } from "@/components/ui/button";
import { Icon, MorphIcon } from "@/components/ui/icon";
import { InputGroup, InputGroupAddon, InputGroupInput } from "@/components/ui/input-group";
import { cn } from "@/lib/utils";

export const passwordRequirements = [
  { regex: /.{8,}/, text: "Al menos 8 caracteres" },
  { regex: /[a-z]/, text: "Al menos 1 letra minúscula" },
  { regex: /[A-Z]/, text: "Al menos 1 letra mayúscula" },
  { regex: /[0-9]/, text: "Al menos 1 número" },
  {
    regex: /[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]/,
    text: "Al menos 1 carácter especial",
  },
];

export function getPasswordStrength(password: string) {
  return passwordRequirements.map((requirement) => ({
    met: requirement.regex.test(password),
    text: requirement.text,
  }));
}

export function getPasswordStrengthScore(password: string) {
  return getPasswordStrength(password).filter((requirement) => requirement.met).length;
}

export function meetsAllPasswordRequirements(password: string) {
  return getPasswordStrengthScore(password) === passwordRequirements.length;
}

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

export type PasswordInputProps = Omit<InputProps, "type"> & {
  showLabel?: string;
  hideLabel?: string;
};

export function PasswordInput({
  showLabel = "Mostrar contraseña",
  hideLabel = "Ocultar contraseña",
  disabled,
  ...props
}: PasswordInputProps) {
  const [isVisible, setIsVisible] = useState(false);

  return (
    <InputGroup>
      <InputGroupInput {...props} type={isVisible ? "text" : "password"} disabled={disabled} />
      <InputGroupAddon align="inline-end">
        <Button
          type="button"
          variant="ghost"
          size="icon-xs"
          onClick={() => setIsVisible((value) => !value)}
          aria-label={isVisible ? hideLabel : showLabel}
          className="text-muted-foreground hover:text-foreground"
          disabled={disabled}
        >
          <MorphIcon icon={isVisible ? ViewOffSlashIcon : ViewIcon} size={16} className="size-4" />
        </Button>
      </InputGroupAddon>
    </InputGroup>
  );
}

export function PasswordStrengthIndicator({
  password,
  className,
}: {
  password: string;
  className?: string;
}) {
  const strength = useMemo(() => getPasswordStrength(password), [password]);
  const score = strength.filter((requirement) => requirement.met).length;

  return (
    <div className={cn("space-y-1 pt-1", className)}>
      <div className="flex h-1 w-full gap-1">
        {Array.from({ length: passwordRequirements.length }).map((_, index) => (
          <span
            key={index}
            className={cn(
              "h-full flex-1 rounded-full transition-all duration-300 ease-out",
              index < score ? getStrengthColor(score) : "bg-border",
            )}
          />
        ))}
      </div>
      <p className="text-sm font-medium">{getStrengthText(score)}.</p>
      <ul className="space-y-1">
        {strength.map((requirement) => (
          <li key={requirement.text} className="flex items-center gap-2">
            {requirement.met ? (
              <Icon
                icon={Tick01Icon}
                size={16}
                className="size-4 text-green-600 dark:text-green-400"
              />
            ) : (
              <Icon icon={Cancel01Icon} size={16} className="text-muted-foreground size-4" />
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

export function PasswordMatchIndicator({
  password,
  confirmPassword,
  className,
}: {
  password: string;
  confirmPassword: string;
  className?: string;
}) {
  const doPasswordsMatch = Boolean(confirmPassword && password === confirmPassword);

  return (
    <div className={cn("mt-1 space-y-1", className)}>
      <div className="flex items-center gap-2">
        {doPasswordsMatch ? (
          <Icon icon={Tick01Icon} size={16} className="size-4 text-green-600 dark:text-green-400" />
        ) : (
          <Icon icon={Cancel01Icon} size={16} className="text-muted-foreground size-4" />
        )}
        <span
          className={cn(
            "text-xs",
            doPasswordsMatch
              ? "font-medium text-green-600 dark:text-green-400"
              : "text-muted-foreground",
          )}
        >
          {doPasswordsMatch ? "Las contraseñas coinciden" : "Las contraseñas no coinciden"}
          <span className="sr-only">
            {doPasswordsMatch ? " - Requisito cumplido" : " - Requisito pendiente"}
          </span>
        </span>
      </div>
    </div>
  );
}
