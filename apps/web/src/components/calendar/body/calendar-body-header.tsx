import { format } from "date-fns";
import { es } from "date-fns/locale";

import { cn } from "@/lib/utils";

export default function CalendarBodyHeader({
  date,
  onlyDay = false,
  className,
}: {
  date: Date;
  onlyDay?: boolean;
  className?: string;
}) {
  return (
    <div
      className={cn(
        "bg-background sticky top-0 z-10 flex h-[33px] w-full items-center justify-center gap-1 border-b",
        className,
      )}
    >
      <span className="text-muted-foreground text-xs font-medium capitalize">
        {format(date, "EEE", { locale: es })}
      </span>
      {!onlyDay && (
        <span className="text-foreground text-xs font-medium">{format(date, "dd")}</span>
      )}
    </div>
  );
}
