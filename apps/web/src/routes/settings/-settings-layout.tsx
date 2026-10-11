import { PaintBoardIcon, Shield01Icon, UserIcon } from "@hugeicons/core-free-icons";
import { Link, Outlet, useLocation } from "@tanstack/react-router";

import { Card, CardContent } from "@/components/ui/card";
import { Icon } from "@/components/ui/icon";
import { cn } from "@/lib/utils";

const navItems = [
  {
    label: "Perfil",
    path: "/settings/profile",
    icon: UserIcon,
  },
  {
    label: "Seguridad",
    path: "/settings/security",
    icon: Shield01Icon,
  },
  {
    label: "Apariencia",
    path: "/settings/appearance",
    icon: PaintBoardIcon,
  },
];

export function SettingsLayout() {
  const location = useLocation();

  return (
    <div className="mx-auto flex w-full max-w-5xl flex-1 flex-col gap-4 px-4 py-4 lg:gap-6 lg:px-6 lg:py-6">
      {/* Tabs horizontales arriba en escritorio y móvil */}
      <div className="w-full">
        <nav className="border-border/60 bg-muted/40 flex w-fit scrollbar-none items-center gap-1.5 overflow-x-auto rounded-xl border p-1">
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
                <Icon icon={item.icon} size={16} className="size-4 shrink-0" />
                {item.label}
              </Link>
            );
          })}
        </nav>
      </div>

      <Card className="w-full py-0">
        <CardContent className="p-4 sm:p-6">
          <Outlet />
        </CardContent>
      </Card>
    </div>
  );
}
