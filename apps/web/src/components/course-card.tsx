import { Lock, Unlock, Link } from "lucide-react";

import type { Course, CourseStatus } from "@/lib/types";

import { cn } from "@/lib/utils";

export type RelationType = "prerequisite" | "corequisite" | "postrequisite" | null;

interface CourseCardProps {
  course: Course;
  isHovered: boolean;
  relationType?: RelationType;
  id?: string;
  solidStatusBackground?: boolean;
  transitionName?: string;
}

const statusConfig: Record<
  CourseStatus,
  { label: string; bgClassName: string; solidBgClassName: string; borderClassName: string }
> = {
  approved: {
    label: "Aprobado",
    bgClassName: "bg-emerald-500/20",
    solidBgClassName: "bg-emerald-50 dark:bg-emerald-950",
    borderClassName: "border-emerald-500/30 hover:border-emerald-500/50",
  },
  failed: {
    label: "Reprobado",
    bgClassName: "bg-red-500/20",
    solidBgClassName: "bg-red-50 dark:bg-red-950",
    borderClassName: "border-red-500/30 hover:border-red-500/50",
  },
  not_taken: {
    label: "No cursado",
    bgClassName: "bg-muted",
    solidBgClassName: "bg-muted",
    borderClassName: "border-border hover:border-muted-foreground/30",
  },
  withdrawn: {
    label: "Retirado",
    bgClassName: "bg-amber-500/20",
    solidBgClassName: "bg-amber-50 dark:bg-amber-950",
    borderClassName: "border-amber-500/30 hover:border-amber-500/50",
  },
  in_progress: {
    label: "En curso",
    bgClassName: "bg-blue-500/20",
    solidBgClassName: "bg-blue-50 dark:bg-blue-950",
    borderClassName: "border-blue-500/30 hover:border-blue-500/50",
  },
};

const relationConfig: Record<string, { ringClass: string; icon: React.ReactNode; label: string }> =
  {
    prerequisite: {
      ringClass: "ring-2 ring-amber-500 shadow-md",
      icon: <Lock className="size-3 text-amber-600" />,
      label: "Requisito",
    },
    corequisite: {
      ringClass: "ring-2 ring-blue-500 shadow-md",
      icon: <Link className="size-3 text-blue-600" />,
      label: "Correquisito",
    },
    postrequisite: {
      ringClass: "ring-2 ring-emerald-500 shadow-md",
      icon: <Unlock className="size-3 text-emerald-600" />,
      label: "Desbloquea",
    },
  };

export function CourseCard({
  course,
  isHovered,
  relationType,
  id,
  solidStatusBackground,
  transitionName,
}: CourseCardProps) {
  const config = statusConfig[course.status];
  const relation = relationType ? relationConfig[relationType] : null;

  return (
    <div
      id={id}
      className={cn(
        "relative cursor-pointer overflow-hidden rounded-lg border-2 shadow-sm transition-all duration-200",
        course.isAvailable
          ? "border-purple-500/30 hover:border-purple-500/50"
          : config.borderClassName,
        isHovered && "ring-primary z-10 scale-105 shadow-lg ring-2",
        relation?.ringClass,
        !isHovered && !relationType && "hover:border-primary/50",
      )}
    >
      {relation && (
        <div className="bg-background border-border absolute -top-1 -right-1 z-20 rounded-full border p-1 shadow-sm">
          {relation.icon}
        </div>
      )}

      <div className="bg-card border-border border-b px-3 py-2">
        <div className="text-muted-foreground flex items-center justify-between font-mono text-xs">
          <span className="min-w-[3ch] text-right">{course.credits} cr</span>
          <span className="flex-1 px-2 text-center font-semibold">{course.code}</span>
          <span className="min-w-[4ch] text-left">{course.hours} h</span>
        </div>
      </div>

      <div
        className={cn(
          "relative flex min-h-16 items-center justify-center px-3 py-2 text-center",
          solidStatusBackground
            ? course.isAvailable
              ? "bg-purple-50 dark:bg-purple-950"
              : config.solidBgClassName
            : course.isAvailable
              ? "bg-purple-500/20"
              : config.bgClassName,
        )}
      >
        <h3
          className="text-foreground line-clamp-2 w-full text-xs leading-tight font-semibold"
          style={transitionName ? { viewTransitionName: transitionName } : undefined}
        >
          {course.name}
        </h3>

        {relation && (
          <div className="absolute right-2 bottom-1 text-[10px] font-medium opacity-80">
            {/* Optional: Show label if needed, or just rely on color/icon */}
          </div>
        )}
      </div>
    </div>
  );
}
