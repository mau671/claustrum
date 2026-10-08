export function formatTermNameWithoutYear(displayName: string): string {
  return displayName.replace(/^\s*\d{4}\s*-\s*/, "").trim();
}

export function formatClosedTermLabel<T extends { year: number; display_name: string }>(
  term: T,
): string {
  return `${term.year}: ${formatTermNameWithoutYear(term.display_name)}`;
}

export function groupTermsByYear<T extends { year: number }>(terms: T[]) {
  const byYear = new Map<number, T[]>();
  for (const term of terms) {
    const bucket = byYear.get(term.year);
    if (bucket) bucket.push(term);
    else byYear.set(term.year, [term]);
  }
  return [...byYear.entries()]
    .sort((a, b) => b[0] - a[0])
    .map(([year, items]) => ({ value: String(year), items }));
}

export function sortTermsLogical<
  T extends { year: number; display_name: string; period_number: number },
>(terms: T[]): T[] {
  return [...terms].sort((a, b) => {
    if (a.year !== b.year) return b.year - a.year;

    const aPrefix = a.display_name.replace(/\d+/g, "").trim();
    const bPrefix = b.display_name.replace(/\d+/g, "").trim();
    const prefixCompare = aPrefix.localeCompare(bPrefix);
    if (prefixCompare !== 0) return prefixCompare;

    return b.period_number - a.period_number;
  });
}
