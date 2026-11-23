import { PaintBoardIcon, Shield01Icon, UserIcon } from "@hugeicons/core-free-icons";
import { Link, Outlet, useLocation } from "@tanstack/react-router";
import { useEffect, useLayoutEffect, useRef } from "react";

import { createFilledIcon, Icon } from "@/components/ui/icon";
import { ScrollArea } from "@/components/ui/scroll-area";
import { cn } from "@/lib/utils";

const TABS_SCROLL_KEY = "claustrum:settings-tabs-scroll-left";
const useIsomorphicLayoutEffect = typeof document === "undefined" ? useEffect : useLayoutEffect;

const navItems = [
  {
    label: "Perfil",
    path: "/settings/profile",
    icon: UserIcon,
    filledIcon: createFilledIcon(UserIcon, { fillKeys: ["0"] }),
  },
  {
    label: "Seguridad",
    path: "/settings/security",
    icon: Shield01Icon,
    filledIcon: createFilledIcon(Shield01Icon),
  },
  {
    label: "Apariencia",
    path: "/settings/appearance",
    icon: PaintBoardIcon,
    filledIcon: createFilledIcon(PaintBoardIcon, { invertKeys: ["1", "2", "3"] }),
  },
];

export function SettingsLayout() {
  const location = useLocation();
  const tabsViewportRef = useRef<HTMLDivElement>(null);

  useIsomorphicLayoutEffect(() => {
    const viewport = tabsViewportRef.current;
    if (!viewport) return;

    const stored = window.sessionStorage.getItem(TABS_SCROLL_KEY);
    if (stored !== null) {
      const scrollLeft = Number(stored);
      if (Number.isFinite(scrollLeft)) viewport.scrollLeft = scrollLeft;
    }

    const handleScroll = () => {
      window.sessionStorage.setItem(TABS_SCROLL_KEY, String(viewport.scrollLeft));
    };
    viewport.addEventListener("scroll", handleScroll, { passive: true });
    return () => viewport.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <div className="mx-auto flex w-full max-w-5xl flex-1 flex-col gap-4 px-4 py-4 lg:gap-6 lg:px-6 lg:py-6">
      {/* Tabs horizontales arriba en escritorio y móvil */}
      <div className="w-full">
        <ScrollArea fade="x" hideScrollbar viewportRef={tabsViewportRef} className="w-full">
          <nav className="border-border/60 bg-muted/40 flex w-max items-center gap-1.5 rounded-xl border p-1">
            {navItems.map((item) => {
              const isActive = location.pathname === item.path;
              return (
                <Link
                  key={item.path}
                  to={item.path}
                  className={cn(
                    "flex items-center gap-2 rounded-lg px-3.5 py-2 text-sm font-medium whitespace-nowrap transition-colors",
                    isActive
                      ? "bg-background text-foreground shadow-xs"
                      : "text-muted-foreground hover:bg-background/50 hover:text-foreground",
                  )}
                >
                  <Icon
                    icon={isActive ? item.filledIcon : item.icon}
                    size={16}
                    className="size-4 shrink-0"
                  />
                  {item.label}
                </Link>
              );
            })}
          </nav>
        </ScrollArea>
      </div>

      <Outlet />
    </div>
  );
}
