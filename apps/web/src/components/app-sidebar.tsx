import { Link } from "@tanstack/react-router";
import {
  CalendarClock,
  EllipsisVertical,
  FileText,
  GraduationCap,
  LayoutDashboard,
  Loader2,
  LogIn,
  MessageCircle,
  Users,
} from "lucide-react";
import { useState } from "react";

import { FeedbackDialog } from "@/components/feedback-dialog";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { UserMenuDropdown } from "@/components/user-menu-dropdown";
import { useAppAuth } from "@/lib/auth/app-auth-context";
import { useActiveStudyPlan } from "@/lib/hooks/use-active-study-plan";
import { cn } from "@/lib/utils";

const data = {
  navMain: [
    {
      title: "Inicio",
      url: "/overview",
      icon: LayoutDashboard,
    },
    {
      title: "Horarios",
      url: "/schedule",
      icon: CalendarClock,
    },
    {
      title: "Plan de estudios",
      url: "/curriculum",
      icon: GraduationCap,
    },
    {
      title: "Profesores",
      url: "/professors",
      icon: Users,
    },
  ],
  navSecondary: [
    {
      title: "Reglamento y políticas",
      url: "/policies",
      icon: FileText,
    },
  ],
};

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

export function AppSidebar() {
  const { authUser, isAuthLoading } = useAppAuth();
  const { activePlan } = useActiveStudyPlan();
  const [isUserMenuOpen, setIsUserMenuOpen] = useState(false);
  const [isFeedbackOpen, setIsFeedbackOpen] = useState(false);

  const user = authUser
    ? {
        name: authUser.user_metadata?.full_name ?? authUser.email ?? "Guest",
        email: authUser.email ?? "",
        avatar: authUser.user_metadata?.avatar_url ?? "",
      }
    : null;
  const userInitial = user?.name.charAt(0).toUpperCase() ?? "M";

  return (
    <aside
      data-user-menu={isUserMenuOpen ? "open" : "closed"}
      className="peer/sidebar group/sidebar bg-muted text-muted-foreground fixed inset-y-0 left-0 z-50 hidden w-20 flex-col px-4 pt-1 pb-4 transition-[width] duration-200 ease-out hover:w-72 data-[user-menu=open]:w-72 md:flex"
    >
      <Link
        to="/overview"
        preload="intent"
        aria-label="Claustrum"
        className="text-foreground hover:bg-background/70 flex h-12 items-center gap-3 rounded-full transition-colors"
      >
        <span className="flex size-12 shrink-0 items-center justify-center">
          <span className="flex size-9 items-center justify-center rounded-full">
            <ClaustrumLogo className="size-8" />
          </span>
        </span>
        <span className="truncate text-sm font-semibold opacity-0 transition-opacity duration-150 group-hover/sidebar:opacity-100 group-data-[user-menu=open]/sidebar:opacity-100">
          Claustrum
        </span>
      </Link>

      <nav className="flex flex-1 flex-col justify-center gap-2 py-8">
        {data.navMain.map((item) => {
          return (
            <Link
              key={item.title}
              to={item.url}
              preload="intent"
              activeOptions={{
                exact: true,
                includeSearch: false,
                includeHash: false,
              }}
              search={
                (item.url === "/schedule" || item.url === "/curriculum") && activePlan
                  ? {
                      university: activePlan.universityId ?? undefined,
                      campus: activePlan.campusId ?? undefined,
                      career: activePlan.academicUnitId ?? undefined,
                      plan: activePlan.studyPlanId ?? undefined,
                      ...(item.url === "/schedule" ? { term: activePlan.termId ?? undefined } : {}),
                    }
                  : undefined
              }
              aria-label={item.title}
              className={cn(
                "group/nav-item hover:bg-background/70 hover:text-foreground flex h-12 items-center gap-3 rounded-full text-sm font-medium transition-colors",
                "data-[status=active]:text-foreground data-[status=active]:group-hover/sidebar:bg-background data-[status=active]:group-data-[user-menu=open]/sidebar:bg-background",
                "data-[status=active]:group-hover/sidebar:shadow-sm data-[status=active]:group-data-[user-menu=open]/sidebar:shadow-sm",
                "data-[status=pending]:text-muted-foreground data-[status=pending]:bg-transparent data-[status=pending]:shadow-none",
              )}
            >
              <span
                className={cn(
                  "flex size-12 shrink-0 items-center justify-center rounded-full transition-colors group-hover/sidebar:bg-transparent group-hover/sidebar:shadow-none group-data-[user-menu=open]/sidebar:bg-transparent group-data-[user-menu=open]/sidebar:shadow-none",
                  "group-data-[status=active]/nav-item:bg-background group-data-[status=active]/nav-item:shadow-sm",
                  "group-data-[status=pending]/nav-item:bg-transparent group-data-[status=pending]/nav-item:shadow-none",
                )}
              >
                <item.icon className="size-5" />
              </span>
              <span className="truncate opacity-0 transition-opacity duration-150 group-hover/sidebar:opacity-100 group-data-[user-menu=open]/sidebar:opacity-100">
                {item.title}
              </span>
            </Link>
          );
        })}
      </nav>

      <div className="flex flex-col gap-3">
        <button
          onClick={() => setIsFeedbackOpen(true)}
          aria-label="Retroalimentación"
          className={cn(
            "group/nav-item hover:bg-background/70 hover:text-foreground focus-visible:ring-ring flex h-12 w-full cursor-pointer items-center gap-3 rounded-full text-sm font-medium transition-colors outline-none focus-visible:ring-2",
          )}
        >
          <span
            className={cn(
              "flex size-12 shrink-0 items-center justify-center rounded-full transition-colors group-hover/sidebar:bg-transparent group-hover/sidebar:shadow-none group-data-[user-menu=open]/sidebar:bg-transparent group-data-[user-menu=open]/sidebar:shadow-none",
            )}
          >
            <MessageCircle className="size-5" />
          </span>
          <span className="truncate opacity-0 transition-opacity duration-150 group-hover/sidebar:opacity-100 group-data-[user-menu=open]/sidebar:opacity-100">
            Retroalimentación
          </span>
        </button>

        {data.navSecondary.map((item) => {
          return (
            <Link
              key={item.title}
              to={item.url}
              preload="intent"
              activeOptions={{
                exact: true,
                includeSearch: false,
                includeHash: false,
              }}
              aria-label={item.title}
              className={cn(
                "group/nav-item hover:bg-background/70 hover:text-foreground flex h-12 items-center gap-3 rounded-full text-sm font-medium transition-colors",
                "data-[status=active]:text-foreground data-[status=active]:group-hover/sidebar:bg-background data-[status=active]:group-data-[user-menu=open]/sidebar:bg-background",
                "data-[status=active]:group-hover/sidebar:shadow-sm data-[status=active]:group-data-[user-menu=open]/sidebar:shadow-sm",
                "data-[status=pending]:text-muted-foreground data-[status=pending]:bg-transparent data-[status=pending]:shadow-none",
              )}
            >
              <span
                className={cn(
                  "flex size-12 shrink-0 items-center justify-center rounded-full transition-colors group-hover/sidebar:bg-transparent group-hover/sidebar:shadow-none group-data-[user-menu=open]/sidebar:bg-transparent group-data-[user-menu=open]/sidebar:shadow-none",
                  "group-data-[status=active]/nav-item:bg-background group-data-[status=active]/nav-item:shadow-sm",
                  "group-data-[status=pending]/nav-item:bg-transparent group-data-[status=pending]/nav-item:shadow-none",
                )}
              >
                <item.icon className="size-5" />
              </span>
              <span className="truncate opacity-0 transition-opacity duration-150 group-hover/sidebar:opacity-100 group-data-[user-menu=open]/sidebar:opacity-100">
                {item.title}
              </span>
            </Link>
          );
        })}

        {user ? (
          <UserMenuDropdown
            user={user}
            open={isUserMenuOpen}
            onOpenChange={setIsUserMenuOpen}
            trigger={
              <Button
                type="button"
                variant="ghost"
                className="hover:bg-background/80 hover:text-foreground !h-12 w-full justify-start gap-3 rounded-full !p-0 text-left"
              >
                <span className="flex size-12 shrink-0 items-center justify-center">
                  <Avatar className="border-muted-foreground/35 bg-background size-8 rounded-full border">
                    <AvatarImage src={user.avatar} alt={user.name} />
                    <AvatarFallback className="bg-muted text-foreground text-xs font-medium">
                      {userInitial}
                    </AvatarFallback>
                  </Avatar>
                </span>
                <span className="grid min-w-0 flex-1 opacity-0 transition-opacity duration-150 group-hover/sidebar:opacity-100 group-data-[user-menu=open]/sidebar:opacity-100">
                  <span className="truncate text-sm font-medium">{user.name}</span>
                  <span className="text-muted-foreground truncate text-xs">{user.email}</span>
                </span>
                <EllipsisVertical className="ml-auto size-4 shrink-0 opacity-0 transition-opacity duration-150 group-hover/sidebar:opacity-100 group-data-[user-menu=open]/sidebar:opacity-100" />
              </Button>
            }
            align="start"
            side="right"
            sideOffset={8}
            contentClass="w-56 rounded-lg"
          />
        ) : isAuthLoading ? (
          <Button
            variant="ghost"
            disabled
            className="hover:bg-background/80 hover:text-foreground !h-12 w-full justify-start gap-3 rounded-full !p-0 text-left"
          >
            <span className="flex size-12 shrink-0 items-center justify-center">
              <Loader2 className="size-5 animate-spin" />
            </span>
            <span className="truncate opacity-0 transition-opacity duration-150 group-hover/sidebar:opacity-100 group-data-[user-menu=open]/sidebar:opacity-100">
              Cargando sesión
            </span>
          </Button>
        ) : (
          <Button
            variant="ghost"
            className="hover:bg-background/80 hover:text-foreground !h-12 w-full justify-start gap-3 rounded-full !p-0 text-left"
            asChild
          >
            <Link to="/auth/signin">
              <span className="flex size-12 shrink-0 items-center justify-center">
                <LogIn className="size-5" />
              </span>
              <span className="truncate opacity-0 transition-opacity duration-150 group-hover/sidebar:opacity-100 group-data-[user-menu=open]/sidebar:opacity-100">
                Iniciar sesión
              </span>
            </Link>
          </Button>
        )}
      </div>

      <FeedbackDialog open={isFeedbackOpen} onOpenChange={setIsFeedbackOpen} />
    </aside>
  );
}
