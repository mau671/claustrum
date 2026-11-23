"use client";

import type { ComponentProps, ReactNode } from "react";

import { Search01Icon, UnfoldMoreIcon } from "@hugeicons/core-free-icons";
import { useRef } from "react";

import { Button } from "@/components/ui/button";
import {
  Combobox,
  ComboboxChips,
  ComboboxChipsInput,
  ComboboxChip,
  ComboboxContent,
  ComboboxEmpty,
  ComboboxInput,
  ComboboxItem,
  ComboboxList,
  ComboboxTrigger,
  ComboboxTriggerClear,
} from "@/components/ui/combobox";
import { Icon } from "@/components/ui/icon";
import { cn } from "@/lib/utils";

export const COMBOBOX_SEARCH_THRESHOLD = 6;

type ComboboxItemShape = object;

type SharedProps<T extends ComboboxItemShape> = {
  items: T[];
  itemToString: (item: T) => string;
  /** How the selected value is displayed in the trigger. Defaults to `itemToString`. */
  valueToString?: (value: T) => string;
  label?: string;
  ariaLabel?: string;
  placeholder?: string;
  loading?: boolean;
  disabled?: boolean;
  clearable?: boolean;
  /** Overrides the automatic threshold decision. */
  showSearch?: boolean;
  searchThreshold?: number;
  triggerClassName?: string;
  contentClassName?: string;
  listClassName?: string;
  id?: string;
  container?: ComponentProps<typeof ComboboxContent>["container"];
  renderItem?: (item: T) => ReactNode;
  onItemClick?: (item: T) => void;
  /** Replaces the default flat list, e.g. for grouped items. */
  children?: ReactNode | ((item: T, index: number) => ReactNode);
  emptyText?: string;
};

export type SearchableComboboxProps<T extends ComboboxItemShape> = SharedProps<T> &
  (
    | { multiple?: false; value: T | null; onValueChange: (item: T | null) => void }
    | { multiple: true; value: T[]; onValueChange: (items: T[]) => void }
  );

/**
 * App-level combobox: composes the base primitives with the standard trigger,
 * popup, conditional search and automatic single/multiple behavior.
 *
 * Domain-specific formatting (code: name, plan prefixes, term groups, etc.)
 * stays at the call site through `itemToString` / `renderItem` / `children`.
 */
export function SearchableCombobox<T extends ComboboxItemShape>(props: SearchableComboboxProps<T>) {
  const {
    items,
    itemToString,
    valueToString = itemToString,
    label = "",
    id,
    ariaLabel,
    placeholder,
    loading = false,
    disabled = false,
    clearable = false,
    showSearch,
    searchThreshold = COMBOBOX_SEARCH_THRESHOLD,
    triggerClassName,
    contentClassName,
    listClassName,
    container,
    renderItem,
    onItemClick,
    children,
    emptyText = "No se encontraron resultados.",
  } = props;

  const triggerRef = useRef<HTMLButtonElement | null>(null);
  const isMultiple = props.multiple === true;
  const hasValue = isMultiple ? props.value.length > 0 : props.value !== null;
  const shouldShowSearch = showSearch ?? (isMultiple ? false : items.length >= searchThreshold);

  const triggerText = loading
    ? `Cargando ${label.toLowerCase()}...`
    : !isMultiple && props.value
      ? valueToString(props.value)
      : (placeholder ?? (label ? `Selecciona ${label.toLowerCase()}` : "Seleccionar"));

  return (
    <Combobox
      items={items}
      multiple={isMultiple}
      value={props.value}
      onValueChange={props.onValueChange as (value: T | T[] | null) => void}
      itemToStringValue={itemToString}
      disabled={disabled}
    >
      {isMultiple ? (
        <ComboboxChips>
          {props.value.map((item) => (
            <ComboboxChip key={itemToString(item)}>{itemToString(item)}</ComboboxChip>
          ))}
          <ComboboxChipsInput
            placeholder={placeholder ?? `Seleccionar ${label.toLowerCase()}...`}
          />
        </ComboboxChips>
      ) : (
        <>
          <ComboboxTrigger
            ref={triggerRef}
            id={id}
            aria-label={ariaLabel ?? (label || undefined)}
            render={
              <Button
                variant="outline"
                className={cn(
                  "h-8 w-full min-w-0 justify-between text-xs font-normal",
                  triggerClassName,
                )}
              />
            }
          >
            <span
              className={cn(
                "block min-w-0 flex-1 truncate text-left",
                !hasValue && "text-muted-foreground",
              )}
            >
              {triggerText}
            </span>
            <Icon icon={UnfoldMoreIcon} size={14} className="-me-1! size-3.5 shrink-0 opacity-60" />
          </ComboboxTrigger>
          {clearable && hasValue && (
            <ComboboxTriggerClear aria-label={`Limpiar ${label.toLowerCase()}`} />
          )}
        </>
      )}

      <ComboboxContent
        anchor={isMultiple ? undefined : triggerRef}
        container={container}
        aria-label={label || undefined}
        className={cn("w-[var(--anchor-width)] min-w-[var(--anchor-width)]", contentClassName)}
      >
        {shouldShowSearch && (
          <div className="border-b p-2">
            <ComboboxInput
              className="rounded-md before:rounded-[calc(var(--radius-md)-1px)]"
              placeholder={`Buscar ${label.toLowerCase()}...`}
              showTrigger={false}
              startAddon={<Icon icon={Search01Icon} size={16} />}
            />
          </div>
        )}
        <ComboboxEmpty>{emptyText}</ComboboxEmpty>
        <ComboboxList className={cn("max-h-56 scrollbar-none", listClassName)}>
          {children ??
            ((item: T) => (
              <ComboboxItem
                key={itemToString(item)}
                value={item}
                onClick={onItemClick ? () => onItemClick(item) : undefined}
              >
                {renderItem ? (
                  renderItem(item)
                ) : (
                  <span className="block w-full min-w-0 truncate">{itemToString(item)}</span>
                )}
              </ComboboxItem>
            ))}
        </ComboboxList>
      </ComboboxContent>
    </Combobox>
  );
}
