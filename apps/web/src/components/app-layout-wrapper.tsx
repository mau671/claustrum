import { useEffect } from "react";

import { AppSidebar } from "@/components/app-sidebar";
import { MobileBottomNav } from "@/components/mobile-bottom-nav";
import { SiteHeader } from "@/components/site-header";
import { AppAuthProvider } from "@/lib/auth/app-auth-context";
import { hydrateLocalStudyPlan } from "@/lib/store/local-study-plan";

export function AppLayoutWrapper({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    hydrateLocalStudyPlan();
  }, []);
  return (
    <AppAuthProvider>
      <div
        className="bg-muted text-foreground flex h-svh overflow-hidden"
        style={
          {
            "--header-height": "calc(var(--spacing) * 14)",
          } as React.CSSProperties
        }
      >
        <AppSidebar />
        <main className="bg-muted flex min-w-0 flex-1 flex-col transition-[margin] duration-200 ease-out md:ml-20 md:peer-hover/sidebar:ml-72 md:peer-data-[user-menu=open]/sidebar:ml-72">
          <SiteHeader />
          <div className="bg-background min-h-0 min-w-0 flex-1 overflow-hidden md:rounded-tl-2xl">
            <div className="flex h-full min-h-0 min-w-0 scrollbar-thin [scrollbar-color:color-mix(in_oklab,var(--foreground)_22%,transparent)_transparent] [scrollbar-gutter:stable] flex-col overflow-y-auto pb-24 md:pb-0">
              {children}
            </div>
          </div>
        </main>
        <MobileBottomNav />
      </div>
    </AppAuthProvider>
  );
}
