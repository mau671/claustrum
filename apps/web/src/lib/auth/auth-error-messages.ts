export type AuthErrorType =
  | "invalid_credentials"
  | "email_unconfirmed"
  | "already_registered"
  | "invalid_email"
  | "weak_password"
  | "rate_limit"
  | "network"
  | "signup_disabled"
  | "unknown";

export interface AuthErrorLike {
  message?: string;
  code?: string;
  status?: number;
}

export interface NormalizedAuthError {
  type: AuthErrorType;
  message: string;
}

type AuthFlow = "login" | "signup";

export function normalizeAuthError(
  error: AuthErrorLike | null,
  flow: AuthFlow,
): NormalizedAuthError {
  const rawMessage = (error?.message ?? "").toLowerCase();
  const rawCode = (error?.code ?? "").toLowerCase();

  if (rawMessage.includes("invalid login credentials") || rawCode.includes("invalid_credentials")) {
    return {
      type: "invalid_credentials",
      message: "Correo o contraseña incorrectos, vuelve a revisar los datos ingresados",
    };
  }

  if (
    rawMessage.includes("email not confirmed") ||
    rawCode.includes("email_not_confirmed") ||
    rawMessage.includes("email not verified") ||
    rawCode.includes("email_not_verified") ||
    rawCode.includes("not_verified") ||
    error?.status === 403 // Better Auth often returns 403 for unverified emails
  ) {
    return {
      type: "email_unconfirmed",
      message: "Debes confirmar tu correo antes de iniciar sesión.",
    };
  }

  if (rawMessage.includes("user already registered") || rawCode.includes("user_already_exists")) {
    return {
      type: "already_registered",
      message: "Ya existe una cuenta con ese correo. Intenta iniciar sesión.",
    };
  }

  if (
    rawMessage.includes("unable to validate email address") ||
    rawMessage.includes("invalid email") ||
    rawCode.includes("invalid_email")
  ) {
    return {
      type: "invalid_email",
      message:
        flow === "login"
          ? "Correo o contraseña incorrectos, vuelve a revisar los datos ingresados"
          : "El correo electrónico no tiene un formato válido.",
    };
  }

  if (rawMessage.includes("password should be at least") || rawCode.includes("weak_password")) {
    return {
      type: "weak_password",
      message: "La contraseña es demasiado corta. Usa al menos 8 caracteres.",
    };
  }

  if (
    rawMessage.includes("too many requests") ||
    rawCode.includes("over_request_rate_limit") ||
    error?.status === 429
  ) {
    return {
      type: "rate_limit",
      message: "Has hecho demasiados intentos. Espera un momento e inténtalo de nuevo.",
    };
  }

  if (
    rawMessage.includes("failed to fetch") ||
    rawMessage.includes("network") ||
    rawCode.includes("network")
  ) {
    return {
      type: "network",
      message: "No pudimos conectarnos. Verifica tu internet e inténtalo de nuevo.",
    };
  }

  if (rawMessage.includes("signup is disabled") || rawCode.includes("signup_disabled")) {
    return {
      type: "signup_disabled",
      message: "El registro de nuevas cuentas está deshabilitado por el momento.",
    };
  }

  if (flow === "login") {
    return {
      type: "unknown",
      message: "No pudimos iniciar sesión. Inténtalo nuevamente en unos segundos.",
    };
  }

  return {
    type: "unknown",
    message: "No pudimos crear tu cuenta. Inténtalo nuevamente en unos segundos.",
  };
}
