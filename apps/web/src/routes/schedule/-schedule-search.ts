export const SCHEDULE_DEFAULT_UNIVERSITY_ID = 1;

type SearchInput = Record<string, unknown>;

export interface ScheduleSearch {
  view?: "card" | "table";
  university?: number;
  campus?: number;
  career?: number;
  plan?: number;
  term?: number;
  otherCampuses?: boolean;
  showAll?: boolean;
  groups?: string;
  loadSchedule?: number;
  filters?: boolean;
  q?: string;
}

export interface ScheduleUrlSearch {
  v?: ScheduleSearch["view"];
  u?: number;
  c?: number;
  r?: number;
  p?: number;
  t?: number;
  oc?: boolean;
  a?: boolean;
  g?: string;
  l?: number;
  f?: boolean;
  q?: string;
}

const LEGACY_SEARCH_KEYS = [
  "view",
  "university",
  "campus",
  "career",
  "plan",
  "term",
  "otherCampuses",
  "showAll",
  "groups",
  "loadSchedule",
];

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

const parseString = (value: unknown): string | undefined => {
  if (typeof value !== "string") return undefined;
  const trimmed = value.trim();
  return trimmed ? trimmed : undefined;
};

const parseView = (value: unknown): ScheduleSearch["view"] => {
  const parsed = parseString(value);
  if (parsed === "card" || parsed === "table") return parsed;
  return undefined;
};

const getSearchValue = (search: SearchInput, longKey: string, shortKey: string) =>
  search[longKey] ?? search[shortKey];

export function parseScheduleSearch(search: SearchInput): ScheduleSearch {
  return {
    view: parseView(getSearchValue(search, "view", "v")),
    university: parseNumber(getSearchValue(search, "university", "u")),
    campus: parseNumber(getSearchValue(search, "campus", "c")),
    career: parseNumber(getSearchValue(search, "career", "r")),
    plan: parseNumber(getSearchValue(search, "plan", "p")),
    term: parseNumber(getSearchValue(search, "term", "t")),
    otherCampuses: parseBoolean(getSearchValue(search, "otherCampuses", "oc")),
    showAll: parseBoolean(getSearchValue(search, "showAll", "a")),
    groups: parseString(getSearchValue(search, "groups", "g")),
    loadSchedule: parseNumber(getSearchValue(search, "loadSchedule", "l")),
    filters: parseBoolean(getSearchValue(search, "filters", "f")),
    q: parseString(search.q ?? search.s),
  };
}

export function isMeaningfulScheduleSearch(search: ScheduleSearch): boolean {
  return (
    search.view !== undefined ||
    (search.university !== undefined && search.university !== SCHEDULE_DEFAULT_UNIVERSITY_ID) ||
    search.campus !== undefined ||
    search.career !== undefined ||
    search.plan !== undefined ||
    search.term !== undefined ||
    search.otherCampuses !== undefined ||
    search.showAll !== undefined ||
    search.groups !== undefined ||
    search.loadSchedule !== undefined ||
    search.q !== undefined
  );
}

export function normalizeScheduleUniversityId(
  universityId: number | null | undefined,
): number | undefined {
  if (universityId === undefined || universityId === null) return undefined;
  return universityId === SCHEDULE_DEFAULT_UNIVERSITY_ID ? undefined : universityId;
}

export function hasLegacyScheduleSearchParams(searchString: string): boolean {
  const params = new URLSearchParams(searchString);
  return LEGACY_SEARCH_KEYS.some((key) => params.has(key));
}

export function toScheduleUrlSearch(search: ScheduleSearch): ScheduleUrlSearch {
  return {
    v: search.view,
    u: normalizeScheduleUniversityId(search.university),
    c: search.campus,
    r: search.career,
    p: search.plan,
    t: search.term,
    oc: search.otherCampuses,
    a: search.showAll,
    g: search.groups,
    l: search.loadSchedule,
    f: search.filters,
    q: search.q,
  };
}

const appendNumber = (params: URLSearchParams, key: string, value: number | undefined) => {
  if (value !== undefined) {
    params.set(key, String(value));
  }
};

const appendString = (params: URLSearchParams, key: string, value: string | undefined) => {
  if (value) {
    params.set(key, value);
  }
};

const appendBoolean = (params: URLSearchParams, key: string, value: boolean | undefined) => {
  if (value !== undefined) {
    params.set(key, value ? "1" : "0");
  }
};

export function buildScheduleShortSearchParams(search: ScheduleSearch): URLSearchParams {
  const params = new URLSearchParams();
  const urlSearch = toScheduleUrlSearch(search);

  appendString(params, "v", urlSearch.v);
  appendNumber(params, "u", urlSearch.u);
  appendNumber(params, "c", urlSearch.c);
  appendNumber(params, "r", urlSearch.r);
  appendNumber(params, "p", urlSearch.p);
  appendNumber(params, "t", urlSearch.t);
  appendBoolean(params, "oc", urlSearch.oc);
  appendBoolean(params, "a", urlSearch.a);
  appendString(params, "g", urlSearch.g);
  appendNumber(params, "l", urlSearch.l);
  appendString(params, "q", urlSearch.q);

  return params;
}

export function buildScheduleShortUrl(search: ScheduleSearch, origin: string): string {
  const params = buildScheduleShortSearchParams(search).toString();
  return `${origin}/schedule${params ? `?${params}` : ""}`;
}
