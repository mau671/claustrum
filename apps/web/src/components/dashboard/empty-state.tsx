"use client";

import { ArrowRight01Icon, GraduationCapIcon } from "@hugeicons/core-free-icons";

import { Button } from "@/components/ui/button";
import { Icon } from "@/components/ui/icon";

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
    <div className="flex flex-col items-center justify-center gap-3 rounded-xl border p-4">
      <div className="bg-muted-foreground/20 size-32 rounded-full" />
      <div className="flex flex-col items-center gap-1.5">
        <div className="bg-muted-foreground/20 h-4 w-28 rounded" />
        <div className="bg-muted-foreground/20 h-3 w-20 rounded" />
      </div>
    </div>
  );
}

function MetricSkeleton() {
  return (
    <div className="flex flex-col gap-2 rounded-xl border p-4">
      <div className="flex items-center justify-between">
        <div className="bg-muted-foreground/20 h-4 w-24 rounded" />
      </div>
      <div className="bg-muted-foreground/20 h-7 w-20 rounded" />
      <div className="bg-muted-foreground/20 h-3 w-28 rounded" />
    </div>
  );
}

export function CourseStatusChartSkeleton() {
  return (
    <div className="bg-card flex h-full flex-col rounded-xl border p-4">
      <div className="mb-3">
        <div className="bg-muted-foreground/20 h-5 w-40 rounded" />
      </div>
      <div className="flex flex-1 flex-col items-center justify-center gap-6 sm:flex-row">
        <div className="border-muted/50 relative flex size-[180px] shrink-0 items-center justify-center rounded-full border-[20px]">
          <div className="flex flex-col items-center gap-1.5">
            <div className="bg-muted-foreground/20 h-3 w-12 rounded" />
            <div className="bg-muted-foreground/20 h-6 w-10 rounded" />
            <div className="bg-muted-foreground/20 h-2.5 w-16 rounded" />
          </div>
        </div>
        <div className="flex w-full flex-1 flex-col gap-2">
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
    </div>
  );
}

export function DashboardStatsSkeleton() {
  return (
    <div className="grid grid-cols-1 gap-3 sm:grid-cols-3">
      <GaugeSkeleton />
      <GaugeSkeleton />
      <MetricSkeleton />
    </div>
  );
}

function TimelineSkeleton() {
  return (
    <div className="bg-card flex h-full flex-col rounded-xl border p-4">
      <div className="mb-4">
        <div className="bg-muted-foreground/20 h-5 w-44 rounded" />
      </div>
      <div className="flex flex-col">
        {Array.from({ length: 4 }).map((_, index) => (
          <div key={index} className="flex items-start gap-3 pb-5 last:pb-0">
            <div className="flex shrink-0 flex-col items-center self-stretch">
              <div className="bg-muted-foreground/20 size-7 shrink-0 rounded-full" />
              {index < 3 ? <div className="bg-muted my-1 w-0.5 flex-1 rounded-full" /> : null}
            </div>
            <div className="flex min-w-0 flex-1 flex-col gap-1.5 pt-1">
              <div className="bg-muted-foreground/20 h-4 w-32 rounded" />
              <div className="bg-muted h-1.5 w-full rounded-full" />
              <div className="flex items-center justify-between gap-2">
                <div className="bg-muted-foreground/20 h-3 w-16 rounded" />
                <div className="bg-muted-foreground/20 h-3 w-20 rounded" />
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export function DashboardSkeleton() {
  return (
    <div className="animate-pulse">
      {/* Stats cards - 6 cards in 2x3 grid */}
      <div className="px-4 lg:px-6">
        <DashboardStatsSkeleton />
      </div>

      {/* Distribution + Next courses row */}
      <div className="mt-4 px-4 lg:px-6">
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
          <div className="h-full lg:col-span-4">
            <CourseStatusChartSkeleton />
          </div>

          <div className="bg-card flex h-full flex-col rounded-xl border p-3 lg:col-span-3">
            <div className="bg-muted-foreground/20 mb-3 h-5 w-36 rounded" />
            <div className="grid flex-1 grid-cols-2 content-start gap-2">
              <div className="bg-muted h-24 rounded-lg" />
              <div className="bg-muted h-24 rounded-lg" />
              <div className="bg-muted h-24 rounded-lg" />
              <div className="bg-muted h-24 rounded-lg" />
            </div>
          </div>
        </div>
      </div>

      {/* Timeline */}
      <div className="mt-4 px-4 lg:px-6">
        <TimelineSkeleton />
      </div>
    </div>
  );
}
