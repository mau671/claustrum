export type AuthErrorType =
  | "invalid_credentials"
  | "email_unconfirmed"
  | "already_registered"
  | "invalid_email"
  | "weak_password"
  | "rate_limit"
  | "network"
  | "banned"
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
    rawCode.includes("invalid_email_or_password") ||
    rawCode.includes("invalid_login_credentials")
  ) {
    return {
      type: "invalid_credentials",
      message: "Correo o contraseña incorrectos, vuelve a revisar los datos ingresados",
    };
  }

  if (
    rawCode.includes("banned") ||
    rawMessage.includes("banned") ||
    rawMessage.includes("suspend")
  ) {
    return {
      type: "banned",
      message: "Tu cuenta está suspendida. Escríbenos si crees que es un error.",
    };
  }

  if (
    rawMessage.includes("email not confirmed") ||
    rawCode.includes("email_not_confirmed") ||
    rawMessage.includes("email not verified") ||
    rawCode.includes("email_not_verified") ||
    rawCode.includes("not_verified")
  ) {
    return {
      type: "email_unconfirmed",
      message: "Debes confirmar tu correo antes de iniciar sesión.",
    };
  }

  if (
    rawMessage.includes("user already registered") ||
    rawCode.includes("user_already_exists") ||
    rawCode.includes("user_already_registered")
  ) {
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

  if (
    rawMessage.includes("password should be at least") ||
    rawCode.includes("weak_password") ||
    rawCode.includes("password_too_short")
  ) {
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

export interface AuthCallbackError {
  title: string;
  message: string;
}

export function getAuthCallbackError(search: Record<string, unknown>): AuthCallbackError | null {
  const rawError = typeof search.error === "string" ? search.error.trim() : "";
  if (!rawError) return null;

  switch (rawError.toLowerCase()) {
    case "account_not_linked":
      return {
        title: "Ese correo ya tiene una cuenta",
        message:
          "Inicia sesión con tu contraseña y confirma tu correo. Después podrás usar Google con la misma dirección.",
      };
    case "email_not_verified":
    case "email_not_confirmed":
      return {
        title: "Confirma tu correo",
        message:
          "Debes confirmar tu dirección antes de continuar. Revisa el enlace que te enviamos.",
      };
    case "access_denied":
      return {
        title: "Acceso cancelado",
        message:
          "Cancelaste el inicio de sesión con Google. Puedes intentarlo de nuevo cuando quieras.",
      };
    case "new_user_signup_disabled":
      return {
        title: "No pudimos iniciar sesión",
        message:
          "Ese enlace no sirve para crear una cuenta. Regístrate o inicia sesión con tu correo y contraseña.",
      };
    case "invalid_token":
    case "token_expired":
      return {
        title: "El enlace no es válido",
        message: "Expiró o ya fue usado. Solicita uno nuevo para continuar.",
      };
    case "state_mismatch":
    case "please_restart_the_process":
      return {
        title: "La sesión expiró",
        message: "Vuelve a intentarlo desde el inicio de sesión.",
      };
    case "banned_user":
      return {
        title: "Cuenta suspendida",
        message: "Tu cuenta está suspendida. Escríbenos si crees que es un error.",
      };
    default:
      return {
        title: "No pudimos completar el acceso",
        message: "Inténtalo de nuevo en unos segundos.",
      };
  }
}
