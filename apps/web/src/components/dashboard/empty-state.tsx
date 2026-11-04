"use client";

import {
  ArrowRight01Icon,
  Book02Icon,
  Calendar03Icon,
  GraduationCapIcon,
  UserGroupIcon,
} from "@hugeicons/core-free-icons";
import { Link } from "@tanstack/react-router";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Icon } from "@/components/ui/icon";
import { ScrollArea } from "@/components/ui/scroll-area";

interface EmptyDashboardProps {
  isAuthenticated: boolean;
  hasProfile: boolean;
}

export function EmptyDashboard({ isAuthenticated, hasProfile }: EmptyDashboardProps) {
  const title = !isAuthenticated
    ? "Tu espacio académico en un solo lugar"
    : hasProfile
      ? "Comenzá a registrar tu avance"
      : "Configurá tu carrera y plan de estudios";

  const description = !isAuthenticated
    ? "Organizá tu carrera universitaria: calculá tu promedio ponderado, planificá tus horarios sin choques y descubrí opiniones de profesores."
    : hasProfile
      ? "Tu plan de estudios está listo. Ingresá a la malla curricular y marcá tus cursos aprobados o en curso para activar tus estadísticas y proyecciones."
      : "Seleccioná tu universidad, sede, carrera y plan de estudios para desbloquear tu dashboard personalizado, estadísticas y sugerencias de matrícula.";

  const actionTo = hasProfile ? "/curriculum" : "/onboarding";
  const actionLabel = hasProfile ? "Ir al Plan de Estudios" : "Completar perfil académico";

  return (
    <div className="flex min-h-[calc(100svh-var(--header-height)-6rem)] flex-col items-center justify-center px-4 py-12 text-center md:min-h-[calc(100svh-var(--header-height)-3rem)]">
      <div className="bg-primary/10 text-primary ring-primary/20 mb-4 flex size-16 items-center justify-center rounded-3xl ring-1">
        <Icon icon={GraduationCapIcon} className="size-8" />
      </div>

      <h1 className="text-foreground text-xl font-semibold tracking-tight md:text-2xl">{title}</h1>
      <p className="text-muted-foreground mt-2 max-w-md text-sm leading-relaxed md:text-base">
        {description}
      </p>

      {isAuthenticated ? (
        <div className="mt-6 flex flex-col items-center gap-3">
          <Link to={actionTo}>
            <Button size="lg" className="gap-2 font-medium shadow-xs">
              <span>{actionLabel}</span>
              <Icon icon={ArrowRight01Icon} className="size-4" />
            </Button>
          </Link>

          <p className="text-muted-foreground/80 text-xs">
            {hasProfile
              ? "💡 Tip: Podés marcar materias aprobadas directamente haciendo clic en los cursos del plan."
              : "Solo toma 1 minuto configurar tu carrera y plan de estudios."}
          </p>
        </div>
      ) : (
        <div className="mt-6 flex flex-col items-center gap-6">
          <div className="flex flex-wrap justify-center gap-3">
            <Link to="/auth/signin">
              <Button size="default" className="font-medium shadow-xs">
                Iniciar sesión
              </Button>
            </Link>
            <Link to="/auth/signup">
              <Button variant="outline" size="default" className="font-medium">
                Registrarse
              </Button>
            </Link>
          </div>

          <div className="flex flex-col items-center gap-2 pt-2">
            <span className="text-muted-foreground text-xs font-medium tracking-wider uppercase">
              O explorá libremente como invitado
            </span>
            <nav aria-label="Explorar Claustrum" className="flex flex-wrap justify-center gap-2">
              <Link
                to="/schedule"
                className="bg-muted/60 hover:bg-muted hover:text-foreground text-muted-foreground inline-flex items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
              >
                <Icon icon={Calendar03Icon} className="size-3.5" />
                <span>Horarios</span>
              </Link>
              <Link
                to="/curriculum"
                className="bg-muted/60 hover:bg-muted hover:text-foreground text-muted-foreground inline-flex items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
              >
                <Icon icon={Book02Icon} className="size-3.5" />
                <span>Plan de estudios</span>
              </Link>
              <Link
                to="/professors"
                className="bg-muted/60 hover:bg-muted hover:text-foreground text-muted-foreground inline-flex items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
              >
                <Icon icon={UserGroupIcon} className="size-3.5" />
                <span>Profesores</span>
              </Link>
            </nav>
          </div>
        </div>
      )}
    </div>
  );
}

function GaugeSkeleton() {
  return (
    <Card className="flex flex-col">
      <CardContent className="flex flex-1 items-center justify-center p-4">
        <div className="grid w-full min-w-0 justify-items-center gap-2 text-center">
          <div className="relative aspect-[100/90] w-full max-w-[176px]">
            <svg
              viewBox="0 0 100 90"
              aria-hidden="true"
              focusable="false"
              className="block h-full w-full overflow-visible"
            >
              <path
                d="M 20.298 79.699 A 42 42 0 1 1 79.702 79.699"
                className="stroke-muted/40 fill-none"
                strokeWidth={9}
                strokeLinecap="round"
              />
            </svg>
            <div className="pointer-events-none absolute top-0 left-0 grid aspect-square w-full place-content-center justify-items-center gap-1">
              <div className="flex items-baseline gap-1">
                <div className="bg-muted-foreground/20 h-9 w-12 rounded" />
                <span className="text-muted-foreground/30 text-base font-normal">%</span>
              </div>
            </div>
          </div>
          <div className="grid min-w-0 justify-items-center gap-0.5 text-center">
            <div className="bg-muted-foreground/20 h-5 w-28 rounded" />
            <div className="bg-muted-foreground/20 h-4 w-24 rounded" />
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

export function CourseStatusChartSkeleton() {
  return (
    <Card className="flex h-full w-full flex-col">
      <CardHeader className="pb-1">
        <div className="bg-muted-foreground/20 h-6 w-40 rounded" />
      </CardHeader>
      <CardContent className="flex flex-1 items-center justify-center p-3 pt-1">
        <div className="m-0 grid w-full min-w-0 grid-cols-1 justify-items-center gap-5 sm:grid-cols-[auto_minmax(0,1fr)] sm:items-center sm:gap-6">
          <div
            className="relative aspect-square max-w-full shrink-0 justify-self-center select-none"
            style={{ width: 180 }}
          >
            <svg viewBox="0 0 180 180" className="block size-full overflow-visible">
              <circle
                cx={90}
                cy={90}
                r={73}
                strokeWidth={20}
                className="stroke-muted/40 fill-none"
              />
            </svg>
            <div
              className="pointer-events-none absolute top-1/2 left-1/2 grid -translate-x-1/2 -translate-y-1/2 text-center"
              style={{ width: "calc(70% - 14px)" }}
            >
              <div className="grid min-w-0 justify-items-center gap-0.5 text-center">
                <div className="bg-muted-foreground/20 h-4 w-10 rounded" />
                <div className="bg-muted-foreground/20 h-8 w-12 rounded" />
                <div className="bg-muted-foreground/20 h-4 w-12 rounded" />
              </div>
            </div>
          </div>
          <div className="m-0 grid w-full list-none gap-1 p-0">
            {Array.from({ length: 5 }).map((_, index) => (
              <div
                key={index}
                className="grid min-h-8.5 w-full grid-cols-[10px_minmax(0,1fr)_auto_3.25em] items-center gap-2 rounded-lg px-2 py-1"
              >
                <div className="bg-muted-foreground/20 size-2.5 rounded-full" />
                <div className="bg-muted-foreground/20 h-4 w-20 rounded" />
                <div className="bg-muted-foreground/20 h-4 w-5 justify-self-end rounded" />
                <div className="bg-muted-foreground/20 h-4 w-8 justify-self-end rounded" />
              </div>
            ))}
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

export function NextCoursesSkeleton() {
  return (
    <Card className="flex h-full w-full flex-col overflow-hidden">
      <CardHeader className="shrink-0 pb-2">
        <div className="bg-muted-foreground/20 h-6 w-36 rounded" />
      </CardHeader>
      <CardContent className="flex min-h-0 flex-1 flex-col pt-0 pb-3">
        <ScrollArea className="size-full min-h-0" scrollFade>
          <div className="grid grid-cols-2 gap-2 pb-1">
            {Array.from({ length: 4 }).map((_, index) => (
              <div
                key={index}
                className="border-border bg-card overflow-hidden rounded-lg border-2 shadow-sm transition-all duration-200"
              >
                <div className="border-border bg-card border-b px-2 py-1.5">
                  <div className="flex items-center justify-between font-mono text-xs">
                    <div className="bg-muted-foreground/20 h-4 w-7 rounded" />
                    <div className="bg-muted-foreground/20 h-4 w-14 rounded" />
                    <div className="bg-muted-foreground/20 h-4 w-6 rounded" />
                  </div>
                </div>
                <div className="bg-muted flex min-h-16 flex-col items-center justify-center gap-1 px-2 py-2">
                  <div className="bg-muted-foreground/20 h-3.5 w-5/6 rounded" />
                  <div className="bg-muted-foreground/20 h-3.5 w-3/5 rounded" />
                </div>
              </div>
            ))}
          </div>
        </ScrollArea>
      </CardContent>
    </Card>
  );
}

export function DashboardStatsSkeleton() {
  return (
    <div className="grid grid-cols-1 gap-3 sm:grid-cols-3">
      <GaugeSkeleton />
      <GaugeSkeleton />
      <GaugeSkeleton />
    </div>
  );
}

export function TimelineSkeleton() {
  return (
    <Card>
      <CardHeader>
        <div className="bg-muted-foreground/20 h-6 w-44 rounded" />
      </CardHeader>
      <CardContent>
        <div className="flex flex-col">
          {Array.from({ length: 5 }).map((_, index) => (
            <div key={index} className="flex items-start gap-3 pb-4 last:pb-0">
              <div className="flex shrink-0 flex-col items-center self-stretch">
                <div className="bg-muted-foreground/20 size-7 shrink-0 rounded-full" />
                {index < 4 ? (
                  <div className="bg-border my-1 min-h-[20px] w-[2px] flex-1 rounded-full" />
                ) : null}
              </div>
              <div className="min-w-0 flex-1 pt-0.5">
                <div className="flex min-h-7 items-center justify-between gap-3">
                  <div className="bg-muted-foreground/20 h-4 w-28 rounded" />
                </div>
                <div className="mt-1.5 w-full pt-1">
                  <div className="bg-muted h-2 w-full rounded-full" />
                </div>
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}

export function DashboardSkeleton() {
  return (
    <div className="flex animate-pulse flex-col gap-4 md:gap-6">
      {/* Stats cards - 3 gauge cards */}
      <div className="px-4 lg:px-6">
        <DashboardStatsSkeleton />
      </div>

      {/* Distribution + Next courses row */}
      <div className="grid gap-4 px-4 md:grid-cols-2 lg:grid-cols-7 lg:px-6">
        <div className="w-full min-w-0 lg:col-span-4">
          <CourseStatusChartSkeleton />
        </div>

        <div className="h-[310px] w-full min-w-0 lg:col-span-3">
          <NextCoursesSkeleton />
        </div>
      </div>

      {/* Timeline */}
      <div className="px-4 lg:px-6">
        <TimelineSkeleton />
      </div>
    </div>
  );
}
