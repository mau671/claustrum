import { LucideIcon } from "lucide-react";

import { cn } from "@/lib/utils";

export interface EmptyStateProps {
  title: string;
  description: string;
  icon: LucideIcon;
  variant?: "default" | "error";
  className?: string;
}

export function EmptyState({
  title,
  description,
  icon: Icon,
  variant = "default",
  className,
}: EmptyStateProps) {
  return (
    <div className={cn("flex flex-1", className)}>
      <div className="bg-card flex min-h-[45svh] w-full items-center justify-center rounded-lg border p-6 text-center md:min-h-96">
        <div className="flex max-w-sm flex-col items-center gap-3">
          <div
            className={cn(
              "flex size-12 items-center justify-center rounded-full",
              variant === "error"
                ? "bg-destructive/10 text-destructive"
                : "bg-muted text-muted-foreground",
            )}
          >
            <Icon className="size-6" />
          </div>
          <div className="space-y-1.5">
            <h2 className="text-lg font-semibold tracking-tight md:text-xl">{title}</h2>
            <p className="text-muted-foreground text-sm md:text-base">{description}</p>
          </div>
        </div>
      </div>
    </div>
  );
}
