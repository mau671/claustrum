import { Search } from "lucide-react";
import { useEffect, useState } from "react";

import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";

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
    <div className="bg-background border-border sticky top-0 z-10 flex shrink-0 flex-col gap-3 border-b p-3">
      <div className="flex w-full items-center gap-2">
        <div className="relative flex-1">
          <Search className="text-muted-foreground absolute top-2.5 left-2.5 size-4" />
          <Input
            placeholder="Buscar por código o nombre..."
            className="h-9 pl-9"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
          />
        </div>
        {actionButtons && <div className="flex shrink-0 items-center">{actionButtons}</div>}
      </div>
      <div className="flex items-center justify-between gap-2 px-1">
        <Badge variant="secondary" className="text-muted-foreground font-normal">
          <span className="font-semibold tabular-nums">
            {selectedCount} / {availableCoursesCount}
          </span>{" "}
          seleccionado{selectedCount !== 1 ? "s" : ""}
        </Badge>
        <Badge variant="secondary" className="text-muted-foreground font-normal">
          <span className="font-semibold tabular-nums">{creditsCount}</span> crédito
          {creditsCount !== 1 ? "s" : ""}
        </Badge>
      </div>
    </div>
  );
}
