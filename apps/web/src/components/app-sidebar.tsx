import {
  BubbleChatUserIcon,
  Calendar03Icon,
  File01Icon,
  GraduationCapIcon,
  Home01Icon,
  Loading02Icon,
  Login01Icon,
  MoreVerticalIcon,
  UserMultiple02Icon,
} from "@hugeicons/core-free-icons";
import { HugeiconsIcon, type IconSvgElement } from "@hugeicons/react";
import { Link } from "@tanstack/react-router";
import { useCallback, useEffect, useRef, useState } from "react";

import { FeedbackDialog } from "@/components/feedback-dialog";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { UserMenuDropdown } from "@/components/user-menu-dropdown";
import { useAppAuth } from "@/lib/auth/app-auth-context";
import { useActiveStudyPlan } from "@/lib/hooks/use-active-study-plan";
import { cn } from "@/lib/utils";

function createFilledIcon(icon: IconSvgElement, invertKeys: string[] = []): IconSvgElement {
  return icon.map(([tag, attrs]) => {
    const isClosed = typeof attrs.d === "string" && attrs.d.includes("Z");
    const isInverted = invertKeys.includes(String(attrs.key));
    if (isInverted) {
      return [
        tag,
        {
          ...attrs,
          stroke: "var(--background)",
          fill: isClosed ? "var(--background)" : "none",
        },
      ];
    }
    if (isClosed) {
      return [
        tag,
        {
          ...attrs,
          fill: "currentColor",
        },
      ];
    }
    return [tag, attrs];
  });
}

const data = {
  navMain: [
    {
      title: "Inicio",
      url: "/overview",
      icon: Home01Icon,
      filledIcon: createFilledIcon(Home01Icon),
    },
    {
      title: "Horarios",
      url: "/schedule",
      icon: Calendar03Icon,
      filledIcon: createFilledIcon(Calendar03Icon, ["2", "3"]),
    },
    {
      title: "Plan de estudios",
      url: "/curriculum",
      icon: GraduationCapIcon,
      filledIcon: createFilledIcon(GraduationCapIcon),
    },
    {
      title: "Profesores",
      url: "/professors",
      icon: UserMultiple02Icon,
      filledIcon: createFilledIcon(UserMultiple02Icon),
    },
  ],
  navSecondary: [
    {
      title: "Reglamento y políticas",
      url: "/policies",
      icon: File01Icon,
      filledIcon: createFilledIcon(File01Icon, ["0", "1"]),
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
  const [isHovered, setIsHovered] = useState(false);

  const enterTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const leaveTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const handleMouseEnter = useCallback(() => {
    if (leaveTimerRef.current) {
      clearTimeout(leaveTimerRef.current);
      leaveTimerRef.current = null;
    }
    enterTimerRef.current = setTimeout(() => {
      setIsHovered(true);
      enterTimerRef.current = null;
    }, 160);
  }, []);

  const handleMouseLeave = useCallback(() => {
    if (enterTimerRef.current) {
      clearTimeout(enterTimerRef.current);
      enterTimerRef.current = null;
    }
    leaveTimerRef.current = setTimeout(() => {
      setIsHovered(false);
      leaveTimerRef.current = null;
    }, 120);
  }, []);

  useEffect(() => {
    return () => {
      if (enterTimerRef.current) clearTimeout(enterTimerRef.current);
      if (leaveTimerRef.current) clearTimeout(leaveTimerRef.current);
    };
  }, []);

  const isExpanded = isHovered || isUserMenuOpen;

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
      data-state={isExpanded ? "expanded" : "collapsed"}
      data-user-menu={isUserMenuOpen ? "open" : "closed"}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
      className="peer/sidebar group/sidebar text-sidebar-foreground fixed inset-y-0 left-0 z-50 hidden w-20 flex-col overflow-hidden bg-transparent px-4 pt-1 pb-4 transition-[width] duration-200 ease-out data-[state=expanded]:w-72 md:flex"
    >
      <Link
        to="/overview"
        preload="intent"
        aria-label="Claustrum"
        className="text-foreground hover:bg-background/70 flex h-12 items-center gap-3 overflow-hidden rounded-full whitespace-nowrap transition-colors"
      >
        <span className="flex size-12 shrink-0 items-center justify-center">
          <span className="flex size-9 items-center justify-center rounded-full">
            <ClaustrumLogo className="size-8" />
          </span>
        </span>
        <span className="truncate text-sm font-semibold opacity-0 transition-opacity duration-200 ease-in group-data-[state=expanded]/sidebar:opacity-100 group-data-[state=expanded]/sidebar:ease-out">
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
                exact: false,
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
                "group/nav-item hover:bg-background/70 hover:text-foreground flex h-12 items-center gap-3 overflow-hidden rounded-full text-sm font-medium whitespace-nowrap transition-colors",
                "data-[status=active]:bg-background data-[status=active]:text-foreground data-[status=active]:shadow-sm",
                "data-[status=pending]:text-muted-foreground data-[status=pending]:bg-transparent data-[status=pending]:shadow-none",
              )}
            >
              {({ isActive }) => (
                <>
                  <span className="flex size-12 shrink-0 items-center justify-center">
                    <HugeiconsIcon
                      icon={item.icon}
                      altIcon={item.filledIcon}
                      showAlt={isActive}
                      size={20}
                    />
                  </span>
                  <span className="truncate opacity-0 transition-opacity duration-200 ease-in group-data-[state=expanded]/sidebar:opacity-100 group-data-[state=expanded]/sidebar:ease-out">
                    {item.title}
                  </span>
                </>
              )}
            </Link>
          );
        })}
      </nav>

      <div className="flex flex-col gap-3">
        <button
          onClick={() => setIsFeedbackOpen(true)}
          aria-label="Retroalimentación"
          className={cn(
            "group/nav-item hover:bg-background/70 hover:text-foreground focus-visible:ring-ring flex h-12 w-full cursor-pointer items-center gap-3 overflow-hidden rounded-full text-sm font-medium whitespace-nowrap transition-colors outline-none focus-visible:ring-2",
          )}
        >
          <span className="flex size-12 shrink-0 items-center justify-center">
            <HugeiconsIcon icon={BubbleChatUserIcon} size={20} />
          </span>
          <span className="truncate opacity-0 transition-opacity duration-200 ease-in group-data-[state=expanded]/sidebar:opacity-100 group-data-[state=expanded]/sidebar:ease-out">
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
                exact: false,
                includeSearch: false,
                includeHash: false,
              }}
              aria-label={item.title}
              className={cn(
                "group/nav-item hover:bg-background/70 hover:text-foreground flex h-12 items-center gap-3 overflow-hidden rounded-full text-sm font-medium whitespace-nowrap transition-colors",
                "data-[status=active]:bg-background data-[status=active]:text-foreground data-[status=active]:shadow-sm",
                "data-[status=pending]:text-muted-foreground data-[status=pending]:bg-transparent data-[status=pending]:shadow-none",
              )}
            >
              {({ isActive }) => (
                <>
                  <span className="flex size-12 shrink-0 items-center justify-center">
                    <HugeiconsIcon
                      icon={item.icon}
                      altIcon={item.filledIcon}
                      showAlt={isActive}
                      size={20}
                    />
                  </span>
                  <span className="truncate opacity-0 transition-opacity duration-200 ease-in group-data-[state=expanded]/sidebar:opacity-100 group-data-[state=expanded]/sidebar:ease-out">
                    {item.title}
                  </span>
                </>
              )}
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
                className="hover:bg-background/80 hover:text-foreground !h-12 w-full justify-start gap-3 overflow-hidden rounded-full !p-0 text-left whitespace-nowrap"
              >
                <span className="flex size-12 shrink-0 items-center justify-center">
                  <Avatar className="border-muted-foreground/35 bg-background size-8 rounded-full border">
                    <AvatarImage src={user.avatar} alt={user.name} />
                    <AvatarFallback className="bg-muted text-foreground text-xs font-medium">
                      {userInitial}
                    </AvatarFallback>
                  </Avatar>
                </span>
                <span className="grid min-w-0 flex-1 opacity-0 transition-opacity duration-200 ease-in group-data-[state=expanded]/sidebar:opacity-100 group-data-[state=expanded]/sidebar:ease-out">
                  <span className="truncate text-sm font-medium">{user.name}</span>
                  <span className="text-muted-foreground truncate text-xs">{user.email}</span>
                </span>
                <HugeiconsIcon
                  icon={MoreVerticalIcon}
                  size={16}
                  className="ml-auto shrink-0 opacity-0 transition-opacity duration-200 ease-in group-data-[state=expanded]/sidebar:opacity-100 group-data-[state=expanded]/sidebar:ease-out"
                />
              </Button>
            }
            align="start"
            side="right"
            sideOffset={8}
            contentClass="w-56 rounded-lg"
          />
        ) : isAuthLoading ? (
          <div className="text-muted-foreground flex h-12 w-full items-center gap-3 overflow-hidden rounded-full text-sm font-medium whitespace-nowrap">
            <span className="flex size-12 shrink-0 items-center justify-center">
              <HugeiconsIcon
                icon={Loading02Icon}
                size={20}
                className="size-5 shrink-0 animate-spin"
              />
            </span>
            <span className="truncate opacity-0 transition-opacity duration-200 ease-in group-data-[state=expanded]/sidebar:opacity-100 group-data-[state=expanded]/sidebar:ease-out">
              Cargando sesión
            </span>
          </div>
        ) : (
          <Link
            to="/auth/signin"
            aria-label="Iniciar sesión"
            className={cn(
              "group/nav-item hover:bg-background/70 hover:text-foreground flex h-12 items-center gap-3 overflow-hidden rounded-full text-sm font-medium whitespace-nowrap transition-colors",
            )}
          >
            <span className="flex size-12 shrink-0 items-center justify-center">
              <HugeiconsIcon icon={Login01Icon} size={20} className="size-5 shrink-0" />
            </span>
            <span className="truncate opacity-0 transition-opacity duration-200 ease-in group-data-[state=expanded]/sidebar:opacity-100 group-data-[state=expanded]/sidebar:ease-out">
              Iniciar sesión
            </span>
          </Link>
        )}
      </div>

      <FeedbackDialog open={isFeedbackOpen} onOpenChange={setIsFeedbackOpen} />
    </aside>
  );
}
