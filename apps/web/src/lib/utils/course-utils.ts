export function normalizeCourseName(name: string): string {
  return name.toUpperCase();
}

export function getLevelLabel(
  levelNumber: number | null,
  levelLabel: string | undefined,
  fallback: string = `SEMESTRE ${levelNumber}`,
): string {
  return levelLabel || fallback;
}
