import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function getCampusCodeFromName(name: string | null): string | null {
  if (!name) return null;
  const n = name.toLowerCase();
  if (n.includes("cartago")) return "CA";
  if (n.includes("san josé") || n.includes("san jose")) return "SJ";
  if (n.includes("san carlos")) return "SC";
  if (n.includes("alajuela")) return "AL";
  if (n.includes("limón") || n.includes("limon")) return "LI";
  return null;
}
