export const CURRICULUM_DEFAULT_UNIVERSITY_ID = 1;

type SearchInput = Record<string, unknown>;

export interface CurriculumSearch {
  university?: number;
  campus?: number;
  career?: number;
  plan?: number;
  action?: string;
  filters?: boolean;
}

export interface CurriculumUrlSearch {
  u?: number;
  c?: number;
  r?: number;
  p?: number;
  a?: string;
  f?: boolean;
}

const LEGACY_SEARCH_KEYS = ["university", "campus", "career", "plan"];

const parseNumber = (value: unknown): number | undefined => {
  if (value === undefined || value === null || value === "") return undefined;
  if (typeof value === "number") return Number.isFinite(value) ? value : undefined;
  if (typeof value === "string") {
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : undefined;
  }
  return undefined;
};

const parseBoolean = (value: unknown): boolean | undefined => {
  if (value === undefined || value === null || value === "") return undefined;
  if (typeof value === "boolean") return value;
  if (typeof value === "number") return value !== 0;
  if (typeof value === "string") {
    const normalized = value.trim().toLowerCase();
    if (normalized === "true" || normalized === "1") return true;
    if (normalized === "false" || normalized === "0") return false;
  }
  return undefined;
};

const getSearchValue = (search: SearchInput, longKey: string, shortKey: string) =>
  search[longKey] ?? search[shortKey];

export function parseCurriculumSearch(search: SearchInput): CurriculumSearch {
  return {
    university: parseNumber(getSearchValue(search, "university", "u")),
    campus: parseNumber(getSearchValue(search, "campus", "c")),
    career: parseNumber(getSearchValue(search, "career", "r")),
    plan: parseNumber(getSearchValue(search, "plan", "p")),
    action: getSearchValue(search, "action", "a") as string | undefined,
    filters: parseBoolean(getSearchValue(search, "filters", "f")),
  };
}

export function normalizeCurriculumUniversityId(
  universityId: number | null | undefined,
): number | undefined {
  if (universityId === undefined || universityId === null) return undefined;
  return universityId === CURRICULUM_DEFAULT_UNIVERSITY_ID ? undefined : universityId;
}

export function hasLegacyCurriculumSearchParams(searchString: string): boolean {
  const params = new URLSearchParams(searchString);
  return LEGACY_SEARCH_KEYS.some((key) => params.has(key));
}

export function isMeaningfulCurriculumSearch(search: CurriculumSearch): boolean {
  return (
    (search.university !== undefined && search.university !== CURRICULUM_DEFAULT_UNIVERSITY_ID) ||
    search.campus !== undefined ||
    search.career !== undefined ||
    search.plan !== undefined
  );
}

export function toCurriculumUrlSearch(search: CurriculumSearch): CurriculumUrlSearch {
  return {
    u: normalizeCurriculumUniversityId(search.university),
    c: search.campus,
    r: search.career,
    p: search.plan,
    a: search.action,
    f: search.filters,
  };
}
