import {
  BubbleChatUserIcon,
  Calendar03Icon,
  File01Icon,
  GraduationCapIcon,
  Home01Icon,
  Login01Icon,
  Logout01Icon,
  Settings01Icon,
  UserMultiple02Icon,
} from "@hugeicons/core-free-icons";
import { HugeiconsIcon } from "@hugeicons/react";
import { useQueryClient } from "@tanstack/react-query";
import { Link, useNavigate, useRouterState } from "@tanstack/react-router";
import { LayoutGroup, motion, useReducedMotion } from "motion/react";
import { useEffect, useState } from "react";

import { FeedbackDialog } from "@/components/feedback-dialog";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuLinkItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { createFilledIcon, Icon } from "@/components/ui/icon";
import { UserAvatar } from "@/components/ui/user-avatar";
import { useAppAuth } from "@/lib/auth/app-auth-context";
import { signOut } from "@/lib/auth/client";
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

const springTransition = {
  type: "spring",
  stiffness: 420,
  damping: 36,
  mass: 0.8,
} as const;

const instantTransition = {
  duration: 0,
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
  const shouldReduceMotion = useReducedMotion();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [isFeedbackOpen, setIsFeedbackOpen] = useState(false);
  const [isProfileMenuOpen, setIsProfileMenuOpen] = useState(false);

  const targetPath = useRouterState({
    select: (state) => state.location.pathname,
  });

  const isProfileActive = targetPath.startsWith("/settings");
  const matchingRoute =
    getMatchingMainRoute(targetPath) ?? (targetPath === "/" ? "/overview" : null);
  const currentRoute = isProfileActive ? null : matchingRoute;
  const [activeTab, setActiveTab] = useState<string | null>(currentRoute);

  useEffect(() => {
    if (currentRoute !== null) {
      setActiveTab(currentRoute);
    } else if (isProfileActive) {
      setActiveTab(null);
    }
  }, [currentRoute, isProfileActive]);

  const transition = shouldReduceMotion ? instantTransition : springTransition;

  return (
    <div className="pointer-events-none fixed inset-x-0 bottom-[max(1rem,env(safe-area-inset-bottom))] z-50 flex items-center justify-center gap-2.5 px-3 md:hidden">
      <LayoutGroup id="mobile-nav">
        <nav
          className={cn(
            "pointer-events-auto flex items-center gap-1 rounded-full p-1.5",
            "border-border/80 bg-background/85 text-muted-foreground border shadow-xl shadow-black/10 backdrop-blur-xl",
            "dark:border-border/60 dark:bg-card/90 dark:text-muted-foreground dark:shadow-black/40",
          )}
          aria-label="Navegación principal"
        >
          {mainNavItems.map((item) => {
            const isCurrent = activeTab === item.url;

            return (
              <motion.div
                key={item.url}
                layout={!shouldReduceMotion}
                transition={transition}
                className="relative flex items-center"
              >
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
                  className="relative flex h-11 items-center justify-start overflow-hidden rounded-full select-none"
                >
                  {/* Pill sutil como el sidebar de escritorio */}
                  {isCurrent && (
                    <motion.div
                      layoutId={shouldReduceMotion ? undefined : "mobile-nav-pill"}
                      className="bg-background text-foreground border-border/60 dark:bg-accent/80 dark:border-border/40 absolute inset-0 rounded-full border shadow-xs"
                      transition={transition}
                    />
                  )}

                  <div className="relative z-10 flex items-center">
                    {/* Ranura fija de icono (44px): el icono nunca salta ni se desplaza al expandir */}
                    <div className="flex size-11 shrink-0 items-center justify-center">
                      <HugeiconsIcon
                        icon={item.icon}
                        altIcon={item.filledIcon}
                        showAlt={isCurrent}
                        size={20}
                        className={cn(
                          "size-5 transition-colors duration-150",
                          isCurrent
                            ? "text-foreground"
                            : "text-muted-foreground hover:text-foreground",
                        )}
                      />
                    </div>

                    {/* Texto: se expande a la derecha fluidamente en el mismo resorte */}
                    <motion.div
                      initial={false}
                      animate={{
                        width: isCurrent ? "auto" : 0,
                        opacity: isCurrent ? 1 : 0,
                      }}
                      transition={transition}
                      className="overflow-hidden"
                    >
                      <span className="text-foreground block pr-3.5 text-xs font-semibold tracking-tight whitespace-nowrap">
                        {item.title}
                      </span>
                    </motion.div>
                  </div>
                </Link>
              </motion.div>
            );
          })}
        </nav>

        {/* Contenedor del Avatar con el mismo fondo, estilo y altura que la barra principal */}
        <div
          className={cn(
            "pointer-events-auto flex items-center rounded-full p-1.5",
            "border-border/80 bg-background/85 text-muted-foreground border shadow-xl shadow-black/10 backdrop-blur-xl",
            "dark:border-border/60 dark:bg-card/90 dark:text-muted-foreground dark:shadow-black/40",
          )}
        >
          <motion.div
            layout={!shouldReduceMotion}
            transition={transition}
            className="relative flex items-center"
          >
            {authUser ? (
              <DropdownMenu open={isProfileMenuOpen} onOpenChange={setIsProfileMenuOpen}>
                <DropdownMenuTrigger
                  render={
                    <button
                      type="button"
                      aria-label="Menú de perfil"
                      aria-current={isProfileActive ? "page" : undefined}
                      className="relative flex h-11 cursor-pointer items-center justify-start overflow-hidden rounded-full outline-none select-none"
                    />
                  }
                >
                  {/* Pill idéntico al de las otras pestañas */}
                  {isProfileActive && (
                    <motion.div
                      layoutId={shouldReduceMotion ? undefined : "mobile-nav-pill"}
                      className="bg-background text-foreground border-border/60 dark:bg-accent/80 dark:border-border/40 absolute inset-0 rounded-full border shadow-xs"
                      transition={transition}
                    />
                  )}

                  <div className="relative z-10 flex items-center">
                    {/* Ranura fija de avatar de 44px (size-11) */}
                    <div className="flex size-11 shrink-0 items-center justify-center">
                      <div className="flex size-8 shrink-0 items-center justify-center overflow-hidden rounded-full">
                        <UserAvatar
                          id={authUser.id}
                          name={authUser.user_metadata?.full_name}
                          email={authUser.email}
                          className="size-8"
                        />
                      </div>
                    </div>

                    {/* Texto: se expande a la derecha cuando está activo en Perfil */}
                    <motion.div
                      initial={false}
                      animate={{
                        width: isProfileActive ? "auto" : 0,
                        opacity: isProfileActive ? 1 : 0,
                      }}
                      transition={transition}
                      className="overflow-hidden"
                    >
                      <span className="text-foreground block pr-3.5 text-xs font-semibold tracking-tight whitespace-nowrap">
                        Perfil
                      </span>
                    </motion.div>
                  </div>
                </DropdownMenuTrigger>

                <DropdownMenuContent
                  side="top"
                  align="end"
                  sideOffset={14}
                  className="mb-1 w-60 rounded-2xl p-1.5 shadow-2xl"
                >
                  <DropdownMenuGroup>
                    <DropdownMenuLabel className="p-0 font-normal">
                      <div className="flex flex-col gap-0.5 px-3 py-2 text-left">
                        <span className="text-foreground truncate text-sm font-medium">
                          {authUser.user_metadata?.full_name ?? authUser.email ?? "Usuario"}
                        </span>
                        {authUser.email && (
                          <span className="text-muted-foreground truncate text-xs">
                            {authUser.email}
                          </span>
                        )}
                      </div>
                    </DropdownMenuLabel>
                  </DropdownMenuGroup>

                  <DropdownMenuSeparator />

                  <DropdownMenuGroup>
                    <DropdownMenuLinkItem render={<Link to="/settings/profile" />}>
                      <Icon icon={Settings01Icon} size={16} className="size-4" />
                      Configuración
                    </DropdownMenuLinkItem>
                    <DropdownMenuLinkItem render={<Link to="/policies" />}>
                      <Icon icon={File01Icon} size={16} className="size-4" />
                      Reglamento y políticas
                    </DropdownMenuLinkItem>
                    <DropdownMenuItem onClick={() => setIsFeedbackOpen(true)}>
                      <Icon icon={BubbleChatUserIcon} size={16} className="size-4" />
                      Retroalimentación
                    </DropdownMenuItem>
                  </DropdownMenuGroup>

                  <DropdownMenuSeparator />

                  <DropdownMenuItem
                    onClick={async () => {
                      await signOut();
                      queryClient.clear();
                      void navigate({ to: "/auth/signin" });
                    }}
                    className="text-destructive focus:text-destructive"
                  >
                    <Icon icon={Logout01Icon} size={16} className="size-4" />
                    Cerrar sesión
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            ) : (
              <Link
                to="/auth/signin"
                aria-label="Iniciar sesión"
                aria-current={isProfileActive ? "page" : undefined}
                className="relative flex h-11 items-center justify-start overflow-hidden rounded-full select-none"
              >
                <div className="relative z-10 flex items-center">
                  <div className="flex size-11 shrink-0 items-center justify-center">
                    <div className="flex size-8 shrink-0 items-center justify-center overflow-hidden rounded-full">
                      <Icon
                        icon={Login01Icon}
                        size={20}
                        className={cn(
                          "size-5 transition-colors duration-150",
                          isProfileActive
                            ? "text-foreground"
                            : "text-muted-foreground hover:text-foreground",
                        )}
                        strokeWidth={2}
                      />
                    </div>
                  </div>
                </div>
              </Link>
            )}
          </motion.div>
        </div>
      </LayoutGroup>

      <FeedbackDialog open={isFeedbackOpen} onOpenChange={setIsFeedbackOpen} />
    </div>
  );
}
