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
        d="M 220.73 23.51 H 74.45 C 52.81 23.51 35.27 41.05 35.27 62.69 v 130.61 c 0 21.64 17.54 39.18 39.18 39.18 h 146.29"
        fill="none"
        stroke="currentColor"
        strokeWidth="26"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <rect
        x="82.3"
        y="70.5"
        width="115"
        height="115"
        rx="23.5"
        fill="none"
        stroke="#C9A227"
        strokeWidth="18"
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
