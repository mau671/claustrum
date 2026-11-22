import { Moon02Icon, Sun03Icon } from "@hugeicons/core-free-icons";
import { type ReactNode } from "react";

import { AuthLeftPanel, AuthPageBackdrop } from "@/components/inset-auth";
import { useTheme } from "@/components/theme-provider";
import { MorphIcon } from "@/components/ui/icon";
import { useMounted } from "@/lib/hooks/use-mounted";

export function AuthShell({ children }: { children: ReactNode }) {
  const { theme, setTheme } = useTheme();
  const mounted = useMounted();

  return (
    <div className="bg-background text-foreground relative h-dvh overflow-hidden">
      <AuthPageBackdrop />

      <div className="relative grid h-full w-full grid-cols-1 lg:grid-cols-[1fr_minmax(440px,560px)]">
        <AuthLeftPanel />
        <main className="bg-card text-foreground relative flex h-full flex-col overflow-y-auto overscroll-contain">
          <div className="mx-auto flex min-h-full w-full max-w-md flex-1 flex-col px-6 pt-[max(1.5rem,env(safe-area-inset-top))] pb-[max(2rem,env(safe-area-inset-bottom))] lg:py-10">
            <div className="flex shrink-0 justify-end">
              <button
                type="button"
                onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
                className="text-muted-foreground hover:bg-accent hover:text-accent-foreground focus-visible:ring-ring rounded-full p-2 transition-colors focus-visible:ring-2 focus-visible:outline-none"
                aria-label="Cambiar tema"
              >
                {mounted ? (
                  <MorphIcon
                    icon={theme === "dark" ? Sun03Icon : Moon02Icon}
                    size={theme === "dark" ? 22 : 20}
                  />
                ) : (
                  <span className="block size-5" aria-hidden="true" />
                )}
              </button>
            </div>

            <div className="mt-4 flex w-full flex-col lg:my-auto">{children}</div>
          </div>
        </main>
      </div>
    </div>
  );
}
