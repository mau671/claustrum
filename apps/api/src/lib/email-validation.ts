import MailChecker from "mailchecker";

/**
 * Dominios institucionales del Tecnológico de Costa Rica
 */
export const ALLOWED_INSTITUTIONAL_DOMAINS = new Set(["estudiantec.cr", "tec.ac.cr", "itcr.ac.cr"]);

/**
 * Patrones de dominios desechables comunes no siempre indexados por listas estáticas
 */
const DISPOSABLE_DOMAIN_PATTERN =
  /(^|\.)(temp|temp-mail|tempmail|tempimail|throwaway|disposable|burnermail|10minute|guerrillamail|mailinator|yopmail|repaut|fakeinbox)/i;

/**
 * Normaliza una dirección de correo electrónico (elimina espacios en blanco y pasa a minúsculas)
 */
export function normalizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

/**
 * Determina si un correo proviene de un proveedor de correo temporal/desechable
 */
export function isDisposableEmail(email: string): boolean {
  if (!email || typeof email !== "string") return false;
  const normalized = normalizeEmail(email);
  const parts = normalized.split("@");
  if (parts.length !== 2) return false;

  const domain = parts[1]?.toLowerCase();
  if (!domain) return false;

  // Dominios institucionales del TEC nunca se consideran desechables
  if (ALLOWED_INSTITUTIONAL_DOMAINS.has(domain)) {
    return false;
  }

  // 1. Verificación primaria mediante mailchecker (55,000+ dominios)
  if (!MailChecker.isValid(normalized)) {
    return true;
  }

  // 2. Verificación secundaria por heurística de dominios temporales
  if (DISPOSABLE_DOMAIN_PATTERN.test(domain)) {
    return true;
  }

  return false;
}
