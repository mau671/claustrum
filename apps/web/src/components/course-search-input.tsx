import { SearchIcon } from "lucide-react";
import { useEffect, useState } from "react";

import { Badge } from "@/components/ui/badge";
import { InputGroup, InputGroupAddon, InputGroupInput } from "@/components/ui/input-group";

interface CourseSearchInputProps {
  initialQuery: string;
  onSearchChange: (query: string) => void;
  totalCoursesSelected?: number;
  totalCredits?: number;
  availableCoursesCount: number;
  actionButtons?: React.ReactNode;
}

export function CourseSearchInput({
  initialQuery,
  onSearchChange,
  totalCoursesSelected,
  totalCredits,
  availableCoursesCount,
  actionButtons,
}: CourseSearchInputProps) {
  const [query, setQuery] = useState(initialQuery);

  useEffect(() => {
    if (initialQuery !== undefined) {
      setQuery(initialQuery);
    }
  }, [initialQuery]);

  useEffect(() => {
    const timer = setTimeout(() => {
      onSearchChange(query);
    }, 300);
    return () => clearTimeout(timer);
  }, [query, onSearchChange]);

  const selectedCount = totalCoursesSelected || 0;
  const creditsCount = totalCredits || 0;

  return (
    <div className="bg-background sticky top-0 z-10 flex shrink-0 flex-col gap-2.5 px-0.5 pt-0.5 pb-2">
      <div className="flex w-full items-center gap-2">
        <InputGroup className="h-9 flex-1 rounded-lg">
          <InputGroupAddon>
            <SearchIcon className="size-4" aria-hidden="true" />
          </InputGroupAddon>
          <InputGroupInput
            aria-label="Buscar curso por código o nombre"
            placeholder="Buscar por código o nombre..."
            type="search"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
          />
        </InputGroup>
        {actionButtons && <div className="flex shrink-0 items-center">{actionButtons}</div>}
      </div>
      <div className="flex items-center justify-between gap-2 px-0.5 text-xs">
        <Badge variant="secondary" className="text-muted-foreground py-0.5 text-xs font-normal">
          <span className="font-semibold tabular-nums">
            {selectedCount} / {availableCoursesCount}
          </span>{" "}
          seleccionado{selectedCount !== 1 ? "s" : ""}
        </Badge>
        <Badge variant="secondary" className="text-muted-foreground py-0.5 text-xs font-normal">
          <span className="font-semibold tabular-nums">{creditsCount}</span> crédito
          {creditsCount !== 1 ? "s" : ""}
        </Badge>
      </div>
    </div>
  );
}
