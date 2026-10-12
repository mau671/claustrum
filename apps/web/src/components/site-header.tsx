import {
  ArrowRight01Icon,
  Calendar03Icon,
  GraduationCapIcon,
  Home01Icon,
  Moon02Icon,
  Notification03Icon,
  PaintBoardIcon,
  Search01Icon,
  Settings01Icon,
  Shield01Icon,
  Sun03Icon,
  TickDouble01Icon,
  UserIcon,
  UserMultiple02Icon,
} from "@hugeicons/core-free-icons";
import { HugeiconsIcon } from "@hugeicons/react";
import { useQueryClient } from "@tanstack/react-query";
import { Link, useLocation, useNavigate } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";

import { useTheme } from "@/components/theme-provider";
import { Button } from "@/components/ui/button";
import { Card, CardPanel } from "@/components/ui/card";
import {
  CommandDialog,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
  CommandSeparator,
} from "@/components/ui/command";
import { FrameHeader, FrameTitle } from "@/components/ui/frame";
import { MorphIcon } from "@/components/ui/icon";
import { Kbd, KbdGroup } from "@/components/ui/kbd";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { useModerationCounts } from "@/lib/hooks/use-moderation";
import {
  useNotifications,
  useMarkNotificationAsRead,
  useMarkAllNotificationsAsRead,
} from "@/lib/hooks/use-notifications";
import { useProfessorById } from "@/lib/hooks/use-professor-reviews";
import { useAuthUser, useStudyPlanDetail, useCoursesByIds } from "@/lib/hooks/use-queries";
import { useCanModerate } from "@/lib/hooks/use-roles";
import { cn } from "@/lib/utils";

type BreadcrumbItem = {
  label: string;
  to?: string;
  isLoading?: boolean;
};

const quickLinks = [
  { label: "Inicio", to: "/overview", icon: Home01Icon },
  { label: "Horarios", to: "/schedule", icon: Calendar03Icon },
  { label: "Plan de estudios", to: "/curriculum", icon: GraduationCapIcon },
  { label: "Profesores", to: "/professors", icon: UserMultiple02Icon },
  { label: "Perfil", to: "/settings/profile", icon: UserIcon },
  { label: "Seguridad", to: "/settings/security", icon: Shield01Icon },
  { label: "Apariencia", to: "/settings/appearance", icon: PaintBoardIcon },
] as const;

const pageTitles: Record<string, string> = {
  "/overview": "Inicio",
  "/schedule": "Horarios",
  "/curriculum": "Plan de estudios",
  "/professors": "Profesores",
  "/policies": "Reglamento y políticas",
  "/moderation": "Moderación",
  "/settings/profile": "Perfil",
  "/settings/security": "Seguridad",
  "/settings/appearance": "Apariencia",
};

function getNumericPathSegment(pathname: string, prefix: string) {
  if (!pathname.startsWith(prefix)) return null;
  const raw = pathname.slice(prefix.length).split("/")[0];
  const value = Number(raw);
  return Number.isFinite(value) && value > 0 ? value : null;
}

// Temporary flag to hide header search until the improved version is ready
const SHOW_HEADER_SEARCH = false;

export function SiteHeader() {
  const { theme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);
  const { pathname, search } = useLocation();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [isCommandOpen, setIsCommandOpen] = useState(false);
  const { data: authUser } = useAuthUser();
  const canModerate = useCanModerate();
  const { data: moderationCounts } = useModerationCounts(!!authUser && canModerate);
  const totalPending = canModerate
    ? (moderationCounts?.pendingReviews ?? 0) +
      (moderationCounts?.pendingEvaluations ?? 0) +
      (moderationCounts?.pendingReviewReports ?? 0) +
      (moderationCounts?.pendingFeedback ?? 0)
    : 0;

  const notificationsQuery = useNotifications(authUser?.id ?? null);
  const markAsRead = useMarkNotificationAsRead();
  const markAllAsRead = useMarkAllNotificationsAsRead();
  const unreadCount = notificationsQuery.data?.filter((n) => !n.is_read).length ?? 0;

  const professorId = getNumericPathSegment(pathname, "/professors/");
  const isProfessorDetail = professorId !== null;
  const professorIdText = isProfessorDetail
    ? (pathname.split("/professors/")[1]?.split("/")[0] ?? null)
    : null;
  const normalizedProfessorIdText = /^\d+$/.test(professorIdText ?? "") ? professorIdText : null;
  const professorQuery = useProfessorById(normalizedProfessorIdText);
  const cachedProfessor = normalizedProfessorIdText
    ? queryClient.getQueryData<{ id: number; full_name: string }>([
        "professorById",
        normalizedProfessorIdText,
      ])
    : null;
  const professorName = professorQuery.data?.full_name ?? cachedProfessor?.full_name ?? null;

  const curriculumMatch = pathname.match(/^\/curriculum\/(\d+)\/(\d+)/);
  const isCourseDetail = curriculumMatch !== null;
  const selectedPlanId = curriculumMatch ? Number(curriculumMatch[1]) : null;
  const courseId = curriculumMatch ? Number(curriculumMatch[2]) : null;

  const courseIdArr = useMemo(() => (courseId !== null ? [courseId] : null), [courseId]);
  const coursesQuery = useCoursesByIds(courseIdArr);

  const planDetailQuery = useStudyPlanDetail(selectedPlanId, undefined);
  const courseLabel = useMemo(() => {
    if (!courseId) return null;

    // 1. Try to find it in the queried course
    if (coursesQuery.data?.[0]) {
      return `${coursesQuery.data[0].code}: ${coursesQuery.data[0].name}`;
    }

    // 2. Fallback to plan details
    for (const period of planDetailQuery.data?.periods ?? []) {
      const course = period.courses.find((item) => item.courseId === courseId);
      if (course) return `${course.courseCode}: ${course.courseName}`;
    }

    return null;
  }, [courseId, coursesQuery.data, planDetailQuery.data]);

  useEffect(() => {
    setMounted(true);
  }, []);

  const toggleTheme = () => {
    const newTheme = theme === "dark" ? "light" : "dark";
    setTheme(newTheme);
  };

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === "k") {
        event.preventDefault();
        setIsCommandOpen((open) => !open);
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, []);

  function runCommand(callback: () => void) {
    setIsCommandOpen(false);
    callback();
  }

  const breadcrumbItems = useMemo<BreadcrumbItem[]>(() => {
    if (isCourseDetail) {
      const isLoading = !courseLabel && (planDetailQuery.isLoading || coursesQuery.isLoading);
      return [
        { label: "Plan de estudios", to: "/curriculum" },
        { label: courseLabel ?? "", isLoading },
      ];
    }

    if (isProfessorDetail) {
      return [
        { label: "Profesores", to: "/professors" },
        { label: professorName ?? "", isLoading: !professorName && professorQuery.isLoading },
      ];
    }

    if (pathname.startsWith("/settings/")) {
      return [
        { label: "Configuración", to: "/settings/profile" },
        { label: pageTitles[pathname] ?? "" },
      ];
    }

    if (pathname.startsWith("/moderation")) {
      const items: BreadcrumbItem[] = [{ label: "Moderación", to: "/moderation/reviews" }];
      if (pathname.startsWith("/moderation/reviews")) {
        const searchStatus = (search as { status?: string })?.status ?? "pending";
        const statusMap: Record<string, string> = {
          pending: "Pendientes",
          approved: "Aprobadas",
          rejected: "Rechazadas",
        };
        items.push({ label: "Reseñas", to: "/moderation/reviews" });
        items.push({ label: statusMap[searchStatus] ?? "Pendientes" });
      } else if (pathname.startsWith("/moderation/evaluations")) {
        items.push({ label: "Evaluaciones" });
      } else if (pathname.startsWith("/moderation/reports")) {
        items.push({ label: "Reportes" });
      } else if (pathname.startsWith("/moderation/feedback")) {
        items.push({ label: "Retroalimentación" });
      }
      return items;
    }

    return [{ label: pageTitles[pathname] ?? "" }];
  }, [
    courseLabel,
    isCourseDetail,
    isProfessorDetail,
    pathname,
    search,
    planDetailQuery.isLoading,
    coursesQuery.isLoading,
    professorName,
    professorQuery.isLoading,
  ]);

  return (
    <header className="sticky top-0 z-40 hidden h-(--header-height) shrink-0 items-center bg-transparent px-4 md:flex lg:px-6">
      <div
        className={cn(
          "w-full items-center gap-3",
          SHOW_HEADER_SEARCH
            ? "grid grid-cols-[1fr_auto] lg:grid-cols-[1fr_minmax(20rem,40rem)_1fr]"
            : "flex justify-between",
        )}
      >
        <div className="flex min-w-0 items-center gap-2">
          {breadcrumbItems.map((item, index) => {
            const isLast = index === breadcrumbItems.length - 1;

            return (
              <div
                key={`${item.to ?? item.label}-${index}`}
                className="flex min-w-0 items-center gap-2"
              >
                {index > 0 ? (
                  <HugeiconsIcon
                    icon={ArrowRight01Icon}
                    size={16}
                    className="text-muted-foreground shrink-0"
                  />
                ) : null}
                {item.isLoading ? (
                  <span className="bg-muted-foreground/20 h-4 w-40 animate-pulse rounded" />
                ) : item.to && !isLast ? (
                  <Link
                    to={item.to}
                    className="text-foreground hover:text-primary truncate text-sm font-medium transition-colors"
                  >
                    {item.label}
                  </Link>
                ) : (
                  <span className="text-muted-foreground truncate text-sm font-medium">
                    {item.label}
                  </span>
                )}
              </div>
            );
          })}
        </div>

        {SHOW_HEADER_SEARCH && (
          <button
            type="button"
            onClick={() => setIsCommandOpen(true)}
            className="bg-background text-muted-foreground ring-border/60 hover:text-foreground hover:ring-primary/30 focus-visible:ring-ring/50 hidden h-11 items-center gap-3 rounded-full px-5 shadow-sm ring-1 transition-colors focus-visible:ring-2 focus-visible:outline-none lg:flex"
          >
            <HugeiconsIcon icon={Search01Icon} size={20} className="shrink-0" />
            <span className="min-w-0 flex-1 text-left text-sm">Buscar…</span>
            <KbdGroup>
              <Kbd>Ctrl</Kbd>
              <Kbd>K</Kbd>
            </KbdGroup>
          </button>
        )}

        <div className="ml-auto flex items-center gap-2">
          {canModerate ? (
            <Button
              variant="ghost"
              size="icon"
              className="relative rounded-full"
              render={<Link to="/moderation" aria-label="Moderación" title="Moderación" />}
            >
              <HugeiconsIcon icon={Shield01Icon} size={20} />
              {totalPending > 0 && (
                <span className="bg-foreground text-background ring-background absolute -top-0.5 -right-0.5 flex size-4 items-center justify-center rounded-full text-[8px] font-bold ring-2">
                  {totalPending > 9 ? "9+" : totalPending}
                </span>
              )}
            </Button>
          ) : null}
          <Popover>
            <PopoverTrigger
              render={
                <Button
                  variant="ghost"
                  size="icon"
                  aria-label="Notificaciones"
                  title="Notificaciones"
                  className="relative rounded-full"
                />
              }
            >
              <HugeiconsIcon icon={Notification03Icon} size={20} />
              {unreadCount > 0 && (
                <span className="bg-destructive ring-background absolute top-1 right-1 flex size-2 rounded-full ring-2" />
              )}
            </PopoverTrigger>
            <PopoverContent
              align="end"
              side="bottom"
              sideOffset={8}
              className="border-border bg-muted/90 dark:bg-muted/50 w-88 rounded-2xl border p-1 shadow-xl backdrop-blur-xl before:hidden sm:w-96"
              viewportClassName="p-0 overflow-visible not-data-transitioning:overflow-visible"
            >
              <FrameHeader className="flex flex-row items-center justify-between gap-2 px-3.5 py-2.5">
                <div className="flex items-center gap-2">
                  <FrameTitle className="text-sm font-semibold">Notificaciones</FrameTitle>
                  {unreadCount > 0 && (
                    <span className="bg-primary/10 text-primary rounded-full px-1.5 py-0.5 text-[11px] font-medium">
                      {unreadCount}
                    </span>
                  )}
                </div>
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  onClick={() => {
                    if (authUser?.id && unreadCount > 0) {
                      markAllAsRead.mutate(authUser.id);
                    }
                  }}
                  disabled={!authUser?.id || unreadCount === 0 || markAllAsRead.isPending}
                  className="text-muted-foreground hover:text-foreground !h-7 gap-1.5 px-2 text-xs font-medium"
                >
                  <HugeiconsIcon icon={TickDouble01Icon} size={15} className="size-3.5" />
                  <span>Marcar todos como leído</span>
                </Button>
              </FrameHeader>

              <Card className="border-border/60 bg-background overflow-hidden rounded-xl border shadow-xs">
                <CardPanel className="p-0">
                  <ScrollArea className="max-h-[360px]">
                    {notificationsQuery.isLoading ? (
                      <div className="text-muted-foreground p-6 text-center text-sm">
                        Cargando...
                      </div>
                    ) : !notificationsQuery.data || notificationsQuery.data.length === 0 ? (
                      <div className="text-muted-foreground p-6 text-center text-sm">
                        No tienes notificaciones.
                      </div>
                    ) : (
                      <div className="flex flex-col">
                        {notificationsQuery.data.map((n, idx) => (
                          <div key={n.id} className="w-full">
                            {idx > 0 && <Separator className="w-full" />}
                            <button
                              type="button"
                              className={cn(
                                "hover:bg-muted/50 focus-visible:bg-muted/50 flex w-full cursor-pointer items-start gap-3 px-4 py-3 text-left transition-colors focus-visible:outline-none",
                                !n.is_read && "bg-muted/25",
                              )}
                              onClick={() => {
                                if (!n.is_read) markAsRead.mutate(n.id);
                              }}
                            >
                              {/* Icono a la izquierda */}
                              <div
                                className={cn(
                                  "mt-0.5 flex size-8 shrink-0 items-center justify-center rounded-full",
                                  !n.is_read
                                    ? "bg-primary/10 text-primary"
                                    : "bg-muted text-muted-foreground",
                                )}
                              >
                                <HugeiconsIcon
                                  icon={Notification03Icon}
                                  size={16}
                                  className="size-4"
                                />
                              </div>

                              {/* Título y descripción a la derecha */}
                              <div className="flex min-w-0 flex-1 flex-col gap-0.5">
                                <div className="flex items-center justify-between gap-2">
                                  <span
                                    className={cn(
                                      "truncate text-sm tracking-tight",
                                      !n.is_read
                                        ? "text-foreground font-semibold"
                                        : "text-foreground/80 font-medium",
                                    )}
                                  >
                                    {n.title}
                                  </span>
                                  {!n.is_read && (
                                    <span className="bg-primary size-2 shrink-0 rounded-full" />
                                  )}
                                </div>
                                <p className="text-muted-foreground line-clamp-2 text-xs leading-relaxed">
                                  {n.message}
                                </p>
                                <span className="text-muted-foreground/75 mt-0.5 text-[10px]">
                                  {new Date(n.created_at).toLocaleString()}
                                </span>
                              </div>
                            </button>
                          </div>
                        ))}
                      </div>
                    )}
                  </ScrollArea>
                </CardPanel>
              </Card>
            </PopoverContent>
          </Popover>
          <Button
            variant="ghost"
            size="icon"
            onClick={toggleTheme}
            aria-label="Alternar tema"
            title="Alternar tema"
            className="rounded-full"
          >
            {mounted ? (
              <MorphIcon
                icon={theme === "dark" ? Moon02Icon : Sun03Icon}
                size={theme === "dark" ? 20 : 22}
              />
            ) : (
              <span className="size-5" aria-hidden="true" />
            )}
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="hidden rounded-full sm:inline-flex"
            render={
              <Link to="/settings/appearance" aria-label="Configuración" title="Configuración" />
            }
          >
            <HugeiconsIcon icon={Settings01Icon} size={20} />
          </Button>
        </div>
      </div>
      <CommandDialog
        open={isCommandOpen}
        onOpenChange={setIsCommandOpen}
        title="Buscar en Claustrum"
        description="Busca rutas y acciones rápidas."
      >
        <CommandInput placeholder="Buscar rutas o acciones..." />
        <ScrollArea className="max-h-[300px]">
          <CommandList className="max-h-none overflow-visible">
            <CommandEmpty>No se encontraron resultados.</CommandEmpty>
            <CommandGroup heading="Navegación">
              {quickLinks.map((item) => (
                <CommandItem
                  key={item.to}
                  value={`${item.label} ${item.to}`}
                  onSelect={() => runCommand(() => void navigate({ to: item.to }))}
                >
                  <HugeiconsIcon icon={item.icon} size={16} />
                  <span>{item.label}</span>
                </CommandItem>
              ))}
            </CommandGroup>
            <CommandSeparator />
            <CommandGroup heading="Acciones">
              <CommandItem onSelect={() => runCommand(toggleTheme)}>
                {theme === "dark" ? (
                  <HugeiconsIcon icon={Sun03Icon} size={16} />
                ) : (
                  <HugeiconsIcon icon={Moon02Icon} size={16} />
                )}
                <span>{theme === "dark" ? "Cambiar a tema claro" : "Cambiar a tema oscuro"}</span>
              </CommandItem>
              <CommandItem
                onSelect={() => runCommand(() => void navigate({ to: "/settings/appearance" }))}
              >
                <HugeiconsIcon icon={Settings01Icon} size={16} />
                <span>Abrir configuración</span>
              </CommandItem>
            </CommandGroup>
          </CommandList>
        </ScrollArea>
      </CommandDialog>
    </header>
  );
}
