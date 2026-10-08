import { cn } from "@/lib/utils";

function ClaustrumLogo({ className }: { className?: string }) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 256 256"
      aria-label="Claustrum logo"
      className={cn("text-orange-600 dark:text-orange-400", className)}
    >
      <path
        d="M190 48H78C61.431 48 48 61.431 48 78v100c0 16.569 13.431 30 30 30h112"
        fill="none"
        stroke="currentColor"
        strokeWidth="20"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <rect
        x="84"
        y="84"
        width="88"
        height="88"
        rx="18"
        fill="none"
        stroke="#C9A227"
        strokeWidth="14"
      />
    </svg>
  );
}

export function DocsNavTitle() {
  return (
    <span className="inline-flex items-center gap-2">
      <ClaustrumLogo className="size-5" />
      <span>Claustrum</span>
    </span>
  );
}
