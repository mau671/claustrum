import { useEffect } from "react";

import { AppSidebar } from "@/components/app-sidebar";
import { MobileBottomNav } from "@/components/mobile-bottom-nav";
import { SiteHeader } from "@/components/site-header";
import { hydrateLocalStudyPlan } from "@/lib/store/local-study-plan";

export function AppLayoutWrapper({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    hydrateLocalStudyPlan();
  }, []);
  return (
    <div
      className="bg-sidebar text-foreground fixed inset-0 flex overflow-hidden"
      style={
        {
          "--header-height": "calc(var(--spacing) * 14)",
        } as React.CSSProperties
      }
    >
      <AppSidebar />
      <main className="flex min-w-0 flex-1 flex-col bg-transparent transition-[margin] duration-200 ease-out md:ml-20 md:peer-data-[state=expanded]/sidebar:ml-72">
        <SiteHeader />
        <div className="bg-background min-h-0 min-w-0 flex-1 overflow-hidden md:rounded-tl-2xl">
          <div className="h-full min-h-0 min-w-0 scrollbar-thin [scrollbar-color:color-mix(in_oklab,var(--foreground)_22%,transparent)_transparent] [scrollbar-gutter:stable] overflow-y-auto overscroll-y-contain">
            <div className="flex min-h-full min-w-0 flex-col pb-28 md:pb-0">{children}</div>
          </div>
        </div>
      </main>
      <MobileBottomNav />
    </div>
  );
}
