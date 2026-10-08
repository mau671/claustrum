import type { ReactNode } from "react";

import { Moon, Sun } from "lucide-react";

import { AuthLeftPanel, AuthPageBackdrop } from "@/components/inset-auth";
import { useTheme } from "@/components/theme-provider";

export function AuthShell({ children }: { children: ReactNode }) {
  const { theme, setTheme } = useTheme();

  return (
    <div className="bg-background text-foreground relative h-screen overflow-hidden">
      <AuthPageBackdrop />

      <button
        type="button"
        onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
        className="text-muted-foreground hover:bg-accent hover:text-accent-foreground focus-visible:ring-ring absolute top-6 right-6 z-50 rounded-full p-2 transition-colors focus-visible:ring-2 focus-visible:outline-none"
        aria-label="Cambiar tema"
      >
        {theme === "dark" ? <Sun className="size-5" /> : <Moon className="size-5" />}
      </button>

      <div className="relative grid h-screen w-full grid-cols-1 lg:grid-cols-[1fr_minmax(440px,560px)]">
        <AuthLeftPanel />
        <div className="bg-card text-foreground relative flex h-full flex-col overflow-y-auto">
          <div className="mx-auto flex w-full max-w-md flex-1 flex-col justify-center px-6 py-8 lg:py-10">
            {children}
          </div>
        </div>
      </div>
    </div>
  );
}
