import { cn } from "@/lib/utils";

export const normalizeText = (text: string) =>
  text
    .toUpperCase()
    .replace(/\s*\.\.\.$/, "")
    .trim();

export const removePlanPrefixFromName = (name: string, externalPlanId: number | string) => {
  const normalizedName = normalizeText(name).trim();
  const normalizedPlanId = String(externalPlanId).trim();
  const prefixPattern = new RegExp(`^${normalizedPlanId}\\s*-\\s*`);
  return normalizedName.replace(prefixPattern, "");
};

export const truncateText = (text: string, maxLength = 35) => {
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength).trim() + "...";
};

export type FilterItem = {
  id: number;
  name: string;
  code?: string;
  external_plan_id?: number | string;
};

export function parseItemCodeAndName(
  item: FilterItem,
  itemLabel?: (item: FilterItem) => string,
): { code: string | null; name: string } {
  if (
    item.external_plan_id !== undefined &&
    item.external_plan_id !== null &&
    item.external_plan_id !== ""
  ) {
    return {
      code: String(item.external_plan_id),
      name: removePlanPrefixFromName(item.name, item.external_plan_id),
    };
  }
  if (item.code) {
    return {
      code: normalizeText(item.code),
      name: normalizeText(item.name),
    };
  }
  if (itemLabel) {
    const raw = itemLabel(item);
    const colonIndex = raw.indexOf(":");
    if (colonIndex !== -1) {
      return {
        code: raw.substring(0, colonIndex).trim(),
        name: raw.substring(colonIndex + 1).trim(),
      };
    }
    return {
      code: null,
      name: raw,
    };
  }
  return {
    code: null,
    name: normalizeText(item.name),
  };
}

export const formatFilterItemLabel = (
  item: FilterItem,
  itemLabel?: (item: FilterItem) => string,
  showCode = false,
) => {
  const { code, name } = parseItemCodeAndName(item, itemLabel);
  if (code) return `${code}: ${name}`;
  if (showCode && item.code) return `${normalizeText(item.code)}: ${normalizeText(item.name)}`;
  return name;
};

export function FilterItemDisplay({
  item,
  itemLabel,
  className,
}: {
  item: FilterItem;
  itemLabel?: (item: FilterItem) => string;
  className?: string;
}) {
  const { code, name } = parseItemCodeAndName(item, itemLabel);

  if (code) {
    return (
      <span
        className={cn(
          "inline-flex max-w-full min-w-0 items-baseline truncate text-left",
          className,
        )}
      >
        <span className="shrink-0 font-mono text-[11px] font-semibold tabular-nums">{code}:</span>
        <span className="ml-1.5 truncate">{name}</span>
      </span>
    );
  }

  return <span className={cn("block min-w-0 truncate text-left", className)}>{name}</span>;
}
