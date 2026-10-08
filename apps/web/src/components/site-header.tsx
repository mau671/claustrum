import { useQueryClient } from "@tanstack/react-query";
import { Link, useLocation, useNavigate } from "@tanstack/react-router";
import {
  Bell,
  CalendarDays,
  ChevronRight,
  GraduationCap,
  Home,
  Moon,
  Palette,
  Search,
  Settings,
  Shield,
  Sun,
  User,
  Users,
} from "lucide-react";
import { useEffect, useMemo, useState } from "react";

import { useTheme } from "@/components/theme-provider";
import { Button } from "@/components/ui/button";
import {
  CommandDialog,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
  CommandSeparator,
} from "@/components/ui/command";
import { Kbd, KbdGroup } from "@/components/ui/kbd";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { ScrollArea } from "@/components/ui/scroll-area";
import { useModerationCounts } from "@/lib/hooks/use-moderation";
import { useNotifications, useMarkNotificationAsRead } from "@/lib/hooks/use-notifications";
import { useIsAdmin, useProfessorById } from "@/lib/hooks/use-professor-reviews";
import { useAuthUser, useStudyPlanDetail, useCoursesByIds } from "@/lib/hooks/use-queries";
import { cn } from "@/lib/utils";

type BreadcrumbItem = {
  label: string;
  to?: string;
  isLoading?: boolean;
};

const quickLinks = [
  { label: "Inicio", to: "/overview", icon: Home },
  { label: "Horarios", to: "/schedule", icon: CalendarDays },
  { label: "Plan de estudios", to: "/curriculum", icon: GraduationCap },
  { label: "Profesores", to: "/professors", icon: Users },
  { label: "Perfil", to: "/settings/profile", icon: User },
  { label: "Seguridad", to: "/settings/security", icon: Shield },
  { label: "Apariencia", to: "/settings/appearance", icon: Palette },
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

export function SiteHeader() {
  const { theme, setTheme } = useTheme();
  const { pathname } = useLocation();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [isCommandOpen, setIsCommandOpen] = useState(false);
  const { data: authUser } = useAuthUser();
  const { data: isAdmin } = useIsAdmin(authUser?.id ?? null);
  const { data: moderationCounts } = useModerationCounts(!!authUser && isAdmin === true);
  const totalPending = isAdmin
    ? (moderationCounts?.pendingReviews ?? 0) +
      (moderationCounts?.pendingEvaluations ?? 0) +
      (moderationCounts?.pendingReviewReports ?? 0) +
      (moderationCounts?.pendingFeedback ?? 0)
    : 0;

  const notificationsQuery = useNotifications(authUser?.id ?? null);
  const markAsRead = useMarkNotificationAsRead();
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

    return [{ label: pageTitles[pathname] ?? "" }];
  }, [
    courseLabel,
    isCourseDetail,
    isProfessorDetail,
    pathname,
    planDetailQuery.isLoading,
    coursesQuery.isLoading,
    professorName,
    professorQuery.isLoading,
  ]);

  return (
    <header className="bg-muted sticky top-0 z-40 hidden h-(--header-height) shrink-0 items-center px-4 md:flex lg:px-6">
      <div className="grid w-full grid-cols-[1fr_auto] items-center gap-3 lg:grid-cols-[1fr_minmax(20rem,40rem)_1fr]">
        <div className="flex min-w-0 items-center gap-2">
          {breadcrumbItems.map((item, index) => {
            const isLast = index === breadcrumbItems.length - 1;

            return (
              <div key={item.to ?? item.label} className="flex min-w-0 items-center gap-2">
                {index > 0 ? (
                  <ChevronRight className="text-muted-foreground size-4 shrink-0" />
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

        <button
          type="button"
          onClick={() => setIsCommandOpen(true)}
          className="bg-background text-muted-foreground ring-border/60 hover:text-foreground hover:ring-primary/30 focus-visible:ring-ring/50 hidden h-11 items-center gap-3 rounded-full px-5 shadow-sm ring-1 transition-colors focus-visible:ring-2 focus-visible:outline-none lg:flex"
        >
          <Search className="size-5 shrink-0" />
          <span className="min-w-0 flex-1 text-left text-sm">Buscar…</span>
          <KbdGroup>
            <Kbd>Ctrl</Kbd>
            <Kbd>K</Kbd>
          </KbdGroup>
        </button>

        <div className="ml-auto flex items-center gap-2">
          {isAdmin ? (
            <Button variant="ghost" size="icon" className="relative rounded-full" asChild>
              <Link to="/moderation" aria-label="Moderación" title="Moderación">
                <Shield className="size-[1.2rem]" />
                {totalPending > 0 && (
                  <span className="bg-foreground text-background ring-background absolute -top-0.5 -right-0.5 flex size-4 items-center justify-center rounded-full text-[8px] font-bold ring-2">
                    {totalPending > 9 ? "9+" : totalPending}
                  </span>
                )}
              </Link>
            </Button>
          ) : null}
          <Popover>
            <PopoverTrigger asChild>
              <Button
                variant="ghost"
                size="icon"
                aria-label="Notificaciones"
                title="Notificaciones"
                className="relative rounded-full"
              >
                <Bell className="size-[1.2rem]" />
                {unreadCount > 0 && (
                  <span className="bg-destructive ring-background absolute top-1 right-1 flex size-2 rounded-full ring-2" />
                )}
              </Button>
            </PopoverTrigger>
            <PopoverContent align="end" className="w-80 p-0">
              <div className="flex items-center justify-between border-b px-4 py-3">
                <h4 className="text-sm font-semibold">Notificaciones</h4>
                {unreadCount > 0 && (
                  <span className="text-muted-foreground text-xs">{unreadCount} sin leer</span>
                )}
              </div>
              <ScrollArea className="max-h-[300px]">
                {notificationsQuery.isLoading ? (
                  <div className="text-muted-foreground p-4 text-center text-sm">Cargando...</div>
                ) : notificationsQuery.data?.length === 0 ? (
                  <div className="text-muted-foreground p-4 text-center text-sm">
                    No tienes notificaciones.
                  </div>
                ) : (
                  <div className="flex flex-col">
                    {notificationsQuery.data?.map((n) => (
                      <div
                        key={n.id}
                        className={cn(
                          "hover:bg-muted/50 flex cursor-pointer flex-col gap-1 border-b px-4 py-3 text-sm transition-colors",
                          !n.is_read && "bg-muted/30",
                        )}
                        onClick={() => {
                          if (!n.is_read) markAsRead.mutate(n.id);
                        }}
                      >
                        <div className="flex items-start justify-between gap-2">
                          <span className="font-medium">{n.title}</span>
                          {!n.is_read && (
                            <span className="mt-1 flex size-2 shrink-0 rounded-full bg-blue-500" />
                          )}
                        </div>
                        <span className="text-muted-foreground text-xs">{n.message}</span>
                        <span className="text-muted-foreground text-[10px]">
                          {new Date(n.created_at).toLocaleString()}
                        </span>
                      </div>
                    ))}
                  </div>
                )}
              </ScrollArea>
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
            <Sun className="size-[1.2rem] scale-100 rotate-0 transition-all dark:scale-0 dark:-rotate-90" />
            <Moon className="absolute size-[1.2rem] scale-0 rotate-90 transition-all dark:scale-100 dark:rotate-0" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="hidden rounded-full sm:inline-flex"
            asChild
          >
            <Link to="/settings/appearance" aria-label="Configuración" title="Configuración">
              <Settings className="size-[1.2rem]" />
            </Link>
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
                  <item.icon />
                  <span>{item.label}</span>
                </CommandItem>
              ))}
            </CommandGroup>
            <CommandSeparator />
            <CommandGroup heading="Acciones">
              <CommandItem onSelect={() => runCommand(toggleTheme)}>
                {theme === "dark" ? <Sun /> : <Moon />}
                <span>{theme === "dark" ? "Cambiar a tema claro" : "Cambiar a tema oscuro"}</span>
              </CommandItem>
              <CommandItem
                onSelect={() => runCommand(() => void navigate({ to: "/settings/appearance" }))}
              >
                <Settings />
                <span>Abrir configuración</span>
              </CommandItem>
            </CommandGroup>
          </CommandList>
        </ScrollArea>
      </CommandDialog>
    </header>
  );
}
