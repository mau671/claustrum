import {
  BubbleChatUserIcon,
  File01Icon,
  Logout01Icon,
  PaintBoardIcon,
  Shield01Icon,
  UserIcon,
} from "@hugeicons/core-free-icons";
import { Link, Outlet, useLocation, useNavigate } from "@tanstack/react-router";
import { useState } from "react";

import { FeedbackDialog } from "@/components/feedback-dialog";
import { Card, CardContent } from "@/components/ui/card";
import { Icon } from "@/components/ui/icon";
import { signOut } from "@/lib/auth/client";
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

import { useQueryClient } from "@tanstack/react-query";

import { resetSupabaseAuthTokenState } from "@/lib/supabase/browser-client";

export function SettingsLayout() {
  const location = useLocation();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [isFeedbackOpen, setIsFeedbackOpen] = useState(false);

  return (
    <div className="flex flex-1 flex-col px-4 py-4 lg:px-6 lg:py-6">
      <div className="flex flex-col gap-4 lg:flex-row lg:gap-6">
        <Card className="w-full shrink-0 self-start py-0 lg:w-64">
          <CardContent className="p-3">
            <nav className="flex flex-col gap-1">
              {navItems.map((item) => {
                const isActive = location.pathname === item.path;
                return (
                  <Link
                    key={item.path}
                    to={item.path}
                    className={cn(
                      "flex items-center gap-3 rounded-lg px-3 py-3 text-sm font-medium transition-colors",
                      isActive
                        ? "bg-accent text-accent-foreground"
                        : "text-muted-foreground hover:bg-accent hover:text-accent-foreground",
                    )}
                  >
                    <Icon icon={item.icon} size={16} className="size-4" />
                    {item.label}
                  </Link>
                );
              })}
              <div className="bg-border my-1 h-px lg:hidden" />
              <button
                type="button"
                onClick={() => setIsFeedbackOpen(true)}
                className="hover:bg-accent hover:text-accent-foreground text-muted-foreground flex items-center gap-3 rounded-lg px-3 py-3 text-left text-sm font-medium transition-colors lg:hidden"
              >
                <Icon icon={BubbleChatUserIcon} size={16} className="size-4" />
                Retroalimentación
              </button>
              <Link
                to="/policies"
                className="hover:bg-accent hover:text-accent-foreground text-muted-foreground flex items-center gap-3 rounded-lg px-3 py-3 text-left text-sm font-medium transition-colors lg:hidden"
              >
                <Icon icon={File01Icon} size={16} className="size-4" />
                Reglamento y políticas
              </Link>
              <div className="bg-border my-1 h-px lg:hidden" />
              <button
                type="button"
                onClick={async () => {
                  await signOut();
                  resetSupabaseAuthTokenState();
                  queryClient.clear();
                  void navigate({ to: "/auth/signin" });
                }}
                className="text-destructive hover:bg-destructive/10 flex items-center gap-3 rounded-lg px-3 py-3 text-left text-sm font-medium transition-colors lg:hidden"
              >
                <Icon icon={Logout01Icon} size={16} className="size-4" />
                Cerrar sesión
              </button>
            </nav>
          </CardContent>
        </Card>

        <Card className="flex-1 py-0">
          <CardContent className="p-6">
            <Outlet />
          </CardContent>
        </Card>
      </div>
      <FeedbackDialog open={isFeedbackOpen} onOpenChange={setIsFeedbackOpen} />
    </div>
  );
}
