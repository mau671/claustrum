import {
  Calendar03Icon,
  GraduationCapIcon,
  Home01Icon,
  Login01Icon,
  UserMultiple02Icon,
} from "@hugeicons/core-free-icons";
import { Link, useRouterState } from "@tanstack/react-router";
import { LayoutGroup, motion } from "motion/react";
import { useEffect, useState } from "react";

import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { createFilledIcon, Icon } from "@/components/ui/icon";
import { useAppAuth } from "@/lib/auth/app-auth-context";
import { useActiveStudyPlan } from "@/lib/hooks/use-active-study-plan";
import { cn } from "@/lib/utils";

const mainNavItems = [
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
    title: "Plan",
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
];

const pillTransition = {
  type: "spring",
  stiffness: 380,
  damping: 32,
  mass: 0.8,
} as const;

function getMatchingMainRoute(pathname: string): string | null {
  if (pathname === "/overview") return "/overview";
  if (pathname.startsWith("/schedule")) return "/schedule";
  if (pathname.startsWith("/curriculum")) return "/curriculum";
  if (pathname.startsWith("/professors")) return "/professors";
  return null;
}

export function MobileBottomNav() {
  const { authUser } = useAppAuth();
  const { activePlan } = useActiveStudyPlan();
  const userName = authUser?.user_metadata?.full_name ?? authUser?.email ?? "Perfil";
  const userInitial = userName.charAt(0).toUpperCase();
  const profileUrl = authUser ? "/settings/profile" : "/auth/signin";

  const targetPath = useRouterState({
    select: (state) => state.location.pathname,
  });

  const currentRoute = getMatchingMainRoute(targetPath) ?? "/overview";
  const [activeTab, setActiveTab] = useState<string>(currentRoute);

  useEffect(() => {
    setActiveTab(currentRoute);
  }, [currentRoute]);

  return (
    <div className="pointer-events-none fixed inset-x-0 bottom-[max(1rem,env(safe-area-inset-bottom))] z-50 flex items-center justify-center gap-2.5 px-3 md:hidden">
      <nav
        className={cn(
          "pointer-events-auto flex items-center gap-1 rounded-full p-1.5",
          "border border-neutral-800/90 bg-neutral-900/95 text-neutral-400 shadow-2xl shadow-black/50 backdrop-blur-xl",
          "dark:border-white/10 dark:bg-neutral-900/90 dark:text-neutral-400",
        )}
        aria-label="Navegación principal"
      >
        <LayoutGroup id="mobile-nav">
          {mainNavItems.map((item) => {
            const isCurrent = activeTab === item.url;

            return (
              <div key={item.url} className="relative flex items-center">
                <Link
                  to={item.url}
                  search={
                    (item.url === "/schedule" || item.url === "/curriculum") && activePlan
                      ? {
                          university: activePlan.universityId ?? undefined,
                          campus: activePlan.campusId ?? undefined,
                          career: activePlan.academicUnitId ?? undefined,
                          plan: activePlan.studyPlanId ?? undefined,
                          ...(item.url === "/schedule"
                            ? { term: activePlan.termId ?? undefined }
                            : {}),
                        }
                      : undefined
                  }
                  preload="intent"
                  aria-current={isCurrent ? "page" : undefined}
                  onClick={() => setActiveTab(item.url)}
                  className="relative flex h-11 items-center justify-center rounded-full px-3 select-none"
                >
                  {/* Pill blanco animado */}
                  {isCurrent && (
                    <motion.div
                      layoutId="mobile-nav-pill"
                      className="absolute inset-0 rounded-full bg-white shadow-sm"
                      transition={pillTransition}
                    />
                  )}

                  <span className="relative z-10 flex items-center">
                    {/* Iconos: El outline se muestra mientras el pill viaja. El filled negro solo aparece cuando el pill ya llegó. */}
                    <span className="relative flex size-5 shrink-0 items-center justify-center">
                      <Icon
                        icon={item.icon}
                        size={20}
                        strokeWidth={2}
                        className={cn(
                          "absolute inset-0 size-5 text-neutral-400 transition-opacity duration-150 ease-out",
                          isCurrent ? "opacity-0 delay-150" : "opacity-100 delay-0",
                        )}
                      />
                      <Icon
                        icon={item.filledIcon}
                        size={20}
                        strokeWidth={2.4}
                        className={cn(
                          "absolute inset-0 size-5 text-neutral-950 transition-opacity duration-150 ease-out",
                          isCurrent ? "opacity-100 delay-150" : "opacity-0 delay-0",
                        )}
                      />
                    </span>

                    {/* Texto: Se oculta de inmediato al salir, y solo se despliega y revela cuando el pill ya aterrizó */}
                    <motion.span
                      initial={false}
                      animate={{
                        width: isCurrent ? "auto" : 0,
                        opacity: isCurrent ? 1 : 0,
                        marginLeft: isCurrent ? 6 : 0,
                      }}
                      transition={{
                        width: {
                          type: "spring",
                          stiffness: 380,
                          damping: 32,
                          delay: isCurrent ? 0.14 : 0,
                        },
                        opacity: {
                          duration: 0.12,
                          delay: isCurrent ? 0.16 : 0,
                        },
                        marginLeft: {
                          duration: 0.1,
                          delay: isCurrent ? 0.14 : 0,
                        },
                      }}
                      className="overflow-hidden text-xs font-semibold tracking-tight whitespace-nowrap text-neutral-950"
                    >
                      {item.title}
                    </motion.span>
                  </span>
                </Link>
              </div>
            );
          })}
        </LayoutGroup>
      </nav>

      {/* Botón separado de Perfil / Iniciar sesión */}
      <Link
        to={profileUrl}
        aria-label={authUser ? "Perfil" : "Iniciar sesión"}
        className={cn(
          "pointer-events-auto relative flex size-14 shrink-0 items-center justify-center rounded-full transition-transform duration-200 select-none",
          "border border-neutral-800/90 bg-neutral-900/95 text-neutral-400 shadow-2xl shadow-black/50 backdrop-blur-xl",
          "dark:border-white/10 dark:bg-neutral-900/90 dark:text-neutral-400",
          "hover:text-neutral-200 active:scale-95",
        )}
      >
        {authUser ? (
          <Avatar className="size-9 border border-white/20">
            <AvatarImage src={authUser.user_metadata?.avatar_url} alt={userName} />
            <AvatarFallback className="bg-neutral-800 text-xs font-semibold text-white">
              {userInitial}
            </AvatarFallback>
          </Avatar>
        ) : (
          <Icon
            icon={Login01Icon}
            size={20}
            className="size-5 shrink-0 text-neutral-300"
            strokeWidth={2}
          />
        )}
      </Link>
    </div>
  );
}
