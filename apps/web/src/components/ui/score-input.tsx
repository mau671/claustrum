import { Minus, Plus } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export function ScoreInput({
  label,
  value,
  onChange,
  max = 10,
  step = 0.1,
  regex = /^\d{0,2}(\.\d?)?$/,
  placeholder = "0-10",
}: {
  label: string;
  value: string;
  onChange: (nextValue: string) => void;
  max?: number;
  step?: number;
  regex?: RegExp;
  placeholder?: string;
}) {
  const handleValueChange = (nextValue: string) => {
    if (nextValue === "") {
      onChange("");
      return;
    }

    if (!regex.test(nextValue)) {
      return;
    }

    const parsed = Number(nextValue);
    if (Number.isNaN(parsed)) return;

    onChange(String(Math.min(max, Math.max(0, parsed))));
  };

  const handleStep = (delta: number) => {
    const currentValue = value.trim() === "" ? 0 : Number(value);
    if (Number.isNaN(currentValue)) {
      onChange("0");
      return;
    }

    const nextValue = Math.min(max, Math.max(0, Math.round((currentValue + delta) * 10) / 10));
    onChange(String(nextValue));
  };

  const parsedValue = Number(value);
  const currentValue = Number.isNaN(parsedValue) ? 0 : Math.min(max, Math.max(0, parsedValue));
  const isAtMin = currentValue <= 0;
  const isAtMax = currentValue >= max;

  return (
    <div className="space-y-2">
      <Label>{label}</Label>
      <div className="border-input focus-within:border-ring focus-within:ring-ring/50 flex h-9 w-full items-center overflow-hidden rounded-md border bg-transparent transition-[color,box-shadow] focus-within:ring-[3px]">
        <Input
          className="h-full w-full rounded-none border-0 bg-transparent px-2 text-center tabular-nums shadow-none focus-visible:ring-0"
          type="text"
          inputMode="decimal"
          value={value}
          onChange={(event) => handleValueChange(event.target.value)}
          placeholder={placeholder}
        />
        <Button
          type="button"
          variant="ghost"
          className="border-input text-muted-foreground hover:text-foreground h-full w-8 cursor-pointer rounded-none border-l p-0"
          onClick={() => handleStep(-step)}
          disabled={isAtMin}
          aria-label={`Disminuir ${label.toLowerCase()}`}
        >
          <Minus className="size-3.5" />
        </Button>
        <Button
          type="button"
          variant="ghost"
          className="border-input text-muted-foreground hover:text-foreground h-full w-8 cursor-pointer rounded-none border-l p-0"
          onClick={() => handleStep(step)}
          disabled={isAtMax}
          aria-label={`Aumentar ${label.toLowerCase()}`}
        >
          <Plus className="size-3.5" />
        </Button>
      </div>
    </div>
  );
}
