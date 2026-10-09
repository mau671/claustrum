import { ChevronsUpDownIcon, SearchIcon } from "lucide-react";
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
    if (itemLabel) return itemLabel(item);
    if (showCode && item.code) return `${normalizeText(item.code)} - ${normalizeText(item.name)}`;
    return normalizeText(item.name);
  };
  const selectedText = selectedItem ? getItemLabel(selectedItem) : null;

  return (
    <div
      className={cn(
        "min-w-0 shrink-0",
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
              !selectedText && "text-muted-foreground",
            )}
          >
            {selectedText ?? placeholder}
          </span>
          <ChevronsUpDownIcon className="-me-1! size-3.5 shrink-0 opacity-60" />
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
              startAddon={<SearchIcon />}
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
                <span className="block w-full min-w-0 truncate text-xs">{getItemLabel(item)}</span>
              </ComboboxItem>
            )}
          </ComboboxList>
        </ComboboxPopup>
      </Combobox>
    </div>
  );
}
