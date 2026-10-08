import type { CourseStatus } from "@/lib/types";

export const STATUS_CONFIG = {
  approved: { label: "Aprobado", color: "bg-green-500", borderColor: "border-green-500" },
  failed: { label: "Reprobado", color: "bg-red-500", borderColor: "border-red-500" },
  not_taken: { label: "No cursado", color: "bg-gray-300", borderColor: "border-gray-300" },
  withdrawn: { label: "Retirado", color: "bg-orange-500", borderColor: "border-orange-500" },
  in_progress: { label: "En curso", color: "bg-blue-500", borderColor: "border-blue-500" },
} as const;

export const RELATION_CONFIG = {
  PREREQUISITE: {
    label: "Requisito (necesario)",
    icon: "➡️",
    color: "text-blue-500",
  },
  COREQUISITE: {
    label: "Correquisito (simultáneo)",
    icon: "⟷",
    color: "text-purple-500",
  },
  EQUIVALENT: {
    label: "Equivalente",
    icon: "✅",
    color: "text-green-500",
  },
} as const;

export function getStatusConfig(status: CourseStatus) {
  return STATUS_CONFIG[status];
}
