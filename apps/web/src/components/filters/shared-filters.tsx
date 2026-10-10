import { Search01Icon, UnfoldMoreIcon } from "@hugeicons/core-free-icons";
import { HugeiconsIcon } from "@hugeicons/react";
import { useRef } from "react";

import { Button } from "@/components/ui/button";
import {
  Combobox,
  ComboboxEmpty,
  ComboboxInput,
  ComboboxItem,
  ComboboxList,
  ComboboxPopup,
  ComboboxTrigger,
} from "@/components/ui/combobox";
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

export function FilterCombobox({
  label,
  value,
  placeholder,
  items,
  onChange,
  isVisible,
  showCode = false,
  itemLabel,
  triggerClassName,
  skipAnimation = false,
}: {
  label?: string;
  value: string;
  placeholder: string;
  items: FilterItem[];
  onChange: (val: string) => void;
  isVisible: boolean;
  showCode?: boolean;
  itemLabel?: (item: FilterItem) => string;
  triggerClassName?: string;
  skipAnimation?: boolean;
}) {
  const triggerRef = useRef<HTMLButtonElement | null>(null);

  if (!isVisible) return null;

  const selectedItem = items.find((item) => item.id.toString() === value) ?? null;
  const getItemLabel = (item: FilterItem) => {
    const { code, name } = parseItemCodeAndName(item, itemLabel);
    if (code) return `${code}: ${name}`;
    if (showCode && item.code) return `${normalizeText(item.code)}: ${normalizeText(item.name)}`;
    return name;
  };

  return (
    <div
      className={cn(
        "min-w-0 shrink-0",
        triggerClassName?.includes("w-full") && "w-full shrink",
        !skipAnimation && "animate-in fade-in-0 slide-in-from-left-2 duration-300",
      )}
    >
      <Combobox
        items={items}
        value={selectedItem}
        onValueChange={(item) => onChange(item ? String(item.id) : "")}
        itemToStringValue={(item) => getItemLabel(item)}
      >
        <ComboboxTrigger
          ref={triggerRef}
          render={
            <Button
              variant="outline"
              className={cn(
                "h-8 w-full min-w-0 justify-between rounded-lg text-xs font-normal sm:max-w-[360px] sm:min-w-[240px]",
                triggerClassName,
              )}
            />
          }
        >
          <span
            className={cn(
              "block min-w-0 flex-1 truncate text-left",
              !selectedItem && "text-muted-foreground",
            )}
          >
            {selectedItem ? getItemLabel(selectedItem) : placeholder}
          </span>
          <HugeiconsIcon icon={UnfoldMoreIcon} size={14} className="-me-1! shrink-0 opacity-60" />
        </ComboboxTrigger>
        <ComboboxPopup
          anchor={triggerRef}
          aria-label={label ?? placeholder}
          className="w-[var(--anchor-width)] max-w-[calc(var(--available-width)-1rem)] min-w-[var(--anchor-width)]"
        >
          <div className="border-b p-2">
            <ComboboxInput
              className="rounded-md before:rounded-[calc(var(--radius-md)-1px)]"
              placeholder={label ? `Buscar ${label.toLowerCase()}...` : "Buscar..."}
              showTrigger={false}
              startAddon={<HugeiconsIcon icon={Search01Icon} size={16} />}
            />
          </div>
          <ComboboxEmpty>No se encontraron resultados.</ComboboxEmpty>
          <ComboboxList className="max-h-56 scrollbar-none">
            {(item) => (
              <ComboboxItem
                key={item.id}
                value={item}
                onClick={() => {
                  if (selectedItem?.id === item.id) {
                    onChange("");
                  }
                }}
              >
                <FilterItemDisplay item={item} itemLabel={itemLabel} className="w-full text-xs" />
              </ComboboxItem>
            )}
          </ComboboxList>
        </ComboboxPopup>
      </Combobox>
    </div>
  );
}
