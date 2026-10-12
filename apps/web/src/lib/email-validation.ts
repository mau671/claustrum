/**
 * Dominios institucionales del Tecnológico de Costa Rica
 */
export const ALLOWED_INSTITUTIONAL_DOMAINS = ["estudiantec.cr", "tec.ac.cr", "itcr.ac.cr"] as const;

/**
 * Lista de dominios conocidos esperados (institucionales y proveedores comunes)
 */
export const KNOWN_DOMAINS = [
  ...ALLOWED_INSTITUTIONAL_DOMAINS,
  "gmail.com",
  "outlook.com",
  "hotmail.com",
  "yahoo.com",
  "icloud.com",
] as const;

const INSTITUTIONAL_SET = new Set<string>(ALLOWED_INSTITUTIONAL_DOMAINS);
const KNOWN_SET = new Set<string>(KNOWN_DOMAINS);

/**
 * Patrón heurístico para detectar dominios de correo desechable en el frontend
 */
const DISPOSABLE_DOMAIN_PATTERN =
  /(^|\.)(temp|temp-mail|tempmail|tempimail|throwaway|disposable|burnermail|10minute|guerrillamail|mailinator|yopmail|repaut|fakeinbox)/i;

/**
 * Normaliza una dirección de correo electrónico
 */
export function normalizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

/**
 * Determina si un correo proviene de un proveedor temporal/desechable
 * (Validación inicial en frontend; el backend complementa con mailchecker completo)
 */
export function isDisposableEmail(email: string): boolean {
  if (!email || typeof email !== "string") return false;
  const normalized = normalizeEmail(email);
  const parts = normalized.split("@");
  if (parts.length !== 2) return false;

  const domain = parts[1];
  if (!domain) return false;

  // Dominios institucionales del TEC nunca se consideran desechables
  if (INSTITUTIONAL_SET.has(domain)) {
    return false;
  }

  // Comprobación heurística de dominios temporales
  if (DISPOSABLE_DOMAIN_PATTERN.test(domain)) {
    return true;
  }

  return false;
}

/**
 * Calcula la distancia de Levenshtein entre dos cadenas
 */
function levenshteinDistance(a: string, b: string): number {
  const m = a.length;
  const n = b.length;
  const dp: number[][] = Array.from({ length: m + 1 }, () => Array(n + 1).fill(0));

  for (let i = 0; i <= m; i++) dp[i][0] = i;
  for (let j = 0; j <= n; j++) dp[0][j] = j;

  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      const cost = a[i - 1] === b[j - 1] ? 0 : 1;
      dp[i][j] = Math.min(
        dp[i - 1][j] + 1, // eliminación
        dp[i][j - 1] + 1, // inserción
        dp[i - 1][j - 1] + cost, // sustitución
      );
    }
  }

  return dp[m][n];
}

/**
 * Analiza un correo y sugiere una corrección si detecta un posible typo en el dominio
 */
export function suggestEmailCorrection(email: string): string | null {
  if (!email || typeof email !== "string") return null;
  const normalized = normalizeEmail(email);
  const atIndex = normalized.lastIndexOf("@");
  if (atIndex <= 0 || atIndex === normalized.length - 1) return null;

  const localPart = normalized.slice(0, atIndex);
  const domain = normalized.slice(atIndex + 1);

  // Si el dominio ya es uno de los conocidos exactos, no hay nada que sugerir
  if (KNOWN_SET.has(domain)) {
    return null;
  }

  // 1. Reglas específicas para typos frecuentes del TEC
  // Typo teclado QWERTY: 'w' antes de 'estudiantec.cr' (wstudiantec.cr) o prefijos omitidos
  if (domain === "wstudiantec.cr" || domain === "studiantec.cr" || domain === "estudiante.cr") {
    return `${localPart}@estudiantec.cr`;
  }
  if (
    domain === "tecc.ac.cr" ||
    domain === "tec.cr" ||
    domain === "te.ac.cr" ||
    domain === "tec.ac"
  ) {
    return `${localPart}@tec.ac.cr`;
  }
  if (domain === "itcr.cr" || domain === "ictr.ac.cr" || domain === "itcr.ac") {
    return `${localPart}@itcr.ac.cr`;
  }

  // 2. Reglas para proveedores globales populares
  if (
    domain === "gmial.com" ||
    domain === "gmai.com" ||
    domain === "gamil.com" ||
    domain === "gmail.co"
  ) {
    return `${localPart}@gmail.com`;
  }
  if (domain === "hotmial.com" || domain === "hotmai.com") {
    return `${localPart}@hotmail.com`;
  }
  if (domain === "outlok.com" || domain === "outloo.com") {
    return `${localPart}@outlook.com`;
  }

  // 3. Regla general mediante distancia de Levenshtein (distancia <= 2)
  let bestMatch: string | null = null;
  let minDistance = Infinity;

  for (const known of KNOWN_DOMAINS) {
    const dist = levenshteinDistance(domain, known);
    if (dist < minDistance && dist <= 2) {
      minDistance = dist;
      bestMatch = known;
    }
  }

  return bestMatch ? `${localPart}@${bestMatch}` : null;
}
