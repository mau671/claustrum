"use client";

import { ArrowRight01Icon, GraduationCapIcon } from "@hugeicons/core-free-icons";

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
    ? "Bienvenido a Claustrum"
    : hasProfile
      ? "Aún no tienes un plan de estudios configurado"
      : "Completa tu perfil académico";

  const description = !isAuthenticated
    ? "Explora el creador de horarios TEC, planes de estudio y reseñas de profes antes de iniciar sesión."
    : hasProfile
      ? "Selecciona tu universidad, sede, carrera y plan de estudios para ver tu progreso académico."
      : "Agrega tu universidad, sede, carrera y plan para que podamos armar tu dashboard.";

  const actionHref = hasProfile ? "/curriculum" : "/onboarding";
  const actionLabel = hasProfile ? "Ir al Plan de Estudios" : "Completar perfil académico";
  return (
    <div className="flex min-h-[calc(100svh-var(--header-height)-6rem)] flex-col items-center justify-center px-4 py-12 md:min-h-[calc(100svh-var(--header-height)-3rem)]">
      <div className="bg-primary/10 mb-4 rounded-full p-4">
        <Icon icon={GraduationCapIcon} className="text-primary size-12" />
      </div>
      <h1 className="mb-2 text-xl font-semibold">{title}</h1>
      <p className="text-muted-foreground mb-6 max-w-md text-center">{description}</p>
      {isAuthenticated ? (
        <a href={actionHref}>
          <Button>
            {actionLabel}
            <Icon icon={ArrowRight01Icon} className="ml-2 size-4" />
          </Button>
        </a>
      ) : (
        <div className="flex flex-col items-center gap-4">
          <div className="flex gap-3">
            <a href="/auth/signin">
              <Button>Iniciar sesión</Button>
            </a>
            <a href="/auth/signup">
              <Button variant="outline">Registrarse</Button>
            </a>
          </div>
          <nav
            aria-label="Explorar Claustrum"
            className="flex flex-wrap justify-center gap-3 text-sm"
          >
            <a
              className="text-muted-foreground hover:text-foreground underline-offset-4 hover:underline"
              href="/schedule/"
            >
              Creador de horarios TEC
            </a>
            <a
              className="text-muted-foreground hover:text-foreground underline-offset-4 hover:underline"
              href="/curriculum/"
            >
              Plan de estudios TEC
            </a>
            <a
              className="text-muted-foreground hover:text-foreground underline-offset-4 hover:underline"
              href="/professors/"
            >
              Reseñas de profes TEC
            </a>
          </nav>
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
        <div className="flex w-full flex-col items-center justify-center gap-5 sm:flex-row sm:gap-6">
          <div className="border-muted/40 relative flex size-[180px] shrink-0 items-center justify-center rounded-full border-[20px]">
            <div className="flex flex-col items-center gap-1">
              <div className="bg-muted-foreground/20 h-3 w-10 rounded" />
              <div className="bg-muted-foreground/20 h-6 w-12 rounded" />
              <div className="bg-muted-foreground/20 h-2.5 w-14 rounded" />
            </div>
          </div>
          <div className="flex w-full flex-1 flex-col gap-1.5">
            {Array.from({ length: 5 }).map((_, index) => (
              <div key={index} className="flex items-center justify-between gap-3 px-2 py-1.5">
                <div className="flex items-center gap-2">
                  <div className="bg-muted-foreground/20 size-2.5 rounded-full" />
                  <div className="bg-muted-foreground/20 h-3.5 w-20 rounded" />
                </div>
                <div className="flex items-center gap-2">
                  <div className="bg-muted-foreground/20 h-3.5 w-6 rounded" />
                  <div className="bg-muted-foreground/20 h-3.5 w-8 rounded" />
                </div>
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
        <div className="bg-muted-foreground/20 h-5 w-44 rounded" />
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
                <div className="mt-1.5 flex flex-col gap-1.5">
                  <div className="bg-muted h-1.5 w-full rounded-full" />
                  <div className="flex items-center justify-between gap-2">
                    <div className="bg-muted-foreground/20 h-3 w-16 rounded" />
                    <div className="bg-muted-foreground/20 h-3 w-20 rounded" />
                  </div>
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
