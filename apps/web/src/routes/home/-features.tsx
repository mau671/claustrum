import type { ReactNode } from "react";

import { startOfWeek } from "date-fns";
import { Suspense, lazy, useState } from "react";

import type { Mode } from "@/components/calendar/calendar-types";

import { ProfessorReviewsList } from "../professors/-professor-reviews-list";
import {
  demoCalendarEvents,
  demoRelationCourse,
  demoPrerequisites,
  demoCorequisites,
  demoDependents,
  demoReviewRows,
} from "./-data";

const Calendar = lazy(() => import("@/components/calendar/calendar"));
const CourseRelationFlow = lazy(() =>
  import("@/components/course-relation-flow").then((module) => ({
    default: module.CourseRelationFlow,
  })),
);

function ScheduleDemo() {
  const [events] = useState(demoCalendarEvents);
  const [mode] = useState<Mode>("week");
  const [date] = useState(() => startOfWeek(new Date(2026, 4, 4), { weekStartsOn: 1 }));
  const [hourHeight, setHourHeight] = useState(64);

  return (
    <div className="schedule-demo-calendar flex h-full flex-col">
      <Suspense fallback={<div className="bg-background flex-1" />}>
        <Calendar
          events={events}
          setEvents={() => {}}
          mode={mode}
          setMode={() => {}}
          date={date}
          setDate={() => {}}
          hourHeight={hourHeight}
          setHourHeight={setHourHeight}
          dayWidth={150}
          setDayWidth={() => {}}
        />
      </Suspense>
    </div>
  );
}

function MallaDemo() {
  return (
    <div className="h-full w-full">
      <Suspense fallback={<div className="bg-background flex-1" />}>
        <CourseRelationFlow
          course={demoRelationCourse}
          prerequisites={demoPrerequisites}
          corequisites={demoCorequisites}
          dependents={demoDependents}
          showLegends={false}
          frameless
        />
      </Suspense>
    </div>
  );
}

function ReviewsDemo() {
  const [page, setPage] = useState(0);
  const [pageSize, setPageSize] = useState(10);

  return (
    <div className="w-full">
      <ProfessorReviewsList
        reviewRows={demoReviewRows}
        isLoading={false}
        isFetching={false}
        page={page}
        pageSize={pageSize}
        totalCount={demoReviewRows.length}
        totalPages={1}
        hasMore={false}
        firstRow={1}
        lastRow={demoReviewRows.length}
        onPageChange={setPage}
        onPageSizeChange={setPageSize}
        showPagination={false}
        frameless
        readOnly
      />
    </div>
  );
}

interface FeatureProps {
  watermark: string;
  label: string;
  title: string;
  desc: string;
  bullets: string[];
  reverse: boolean;
  visual: ReactNode;
  visualClassName?: string;
  gridClassName?: string;
  className?: string;
}

function Feature({
  watermark,
  label,
  title,
  desc,
  bullets,
  reverse,
  visual,
  visualClassName,
  gridClassName,
  className,
}: FeatureProps) {
  return (
    <div className={`relative ${className ?? ""} ${reverse ? "md:[direction:rtl]" : ""}`}>
      <div
        className={`pointer-events-none absolute font-mono text-[clamp(100px,14vw,160px)] leading-none font-light select-none ${reverse ? "-top-10 -right-[10px] md:-top-10 md:-right-[10px]" : "-top-10 -left-[10px] md:-top-10 md:-left-[10px]"} ${reverse ? "text-foreground/[0.025]" : "text-foreground/[0.025]"}`}
      >
        {watermark}
      </div>
      <div
        className={`grid grid-cols-1 items-center gap-10 md:gap-20 ${gridClassName ?? "md:grid-cols-2"}`}
      >
        <div
          className={`relative pl-4 md:pl-6 ${reverse ? "md:[direction:ltr]" : ""} before:bg-border before:absolute before:top-1 before:bottom-1 before:left-0 before:w-px after:absolute after:top-1 after:left-[-2px] after:size-[5px] after:rounded-full after:bg-[#C9A227]`}
        >
          <div className="mb-[14px] font-mono text-[11px] tracking-[0.08em] text-[#A6841C] uppercase">
            {label}
          </div>
          <h3 className="mb-[18px] text-[30px] leading-[1.15] font-semibold tracking-[-0.02em]">
            {title}
          </h3>
          <p className="text-muted-foreground text-[15px] leading-[1.6]">{desc}</p>
          <ul className="text-muted-foreground mt-[14px] list-none pl-0 text-[15px] leading-[1.6]">
            {bullets.map((item) => (
              <li
                key={item}
                className="relative mb-2 pl-4 before:absolute before:left-0 before:font-mono before:text-[11px] before:text-[#C9A227] before:content-['—']"
              >
                {item}
              </li>
            ))}
          </ul>
        </div>

        <div
          className={`relative ${visualClassName ?? "aspect-[16/10] overflow-hidden"} border-border bg-background border ${reverse ? "md:[direction:ltr]" : ""}`}
        >
          {visual}
        </div>
      </div>
    </div>
  );
}

export function FeaturesSection() {
  return (
    <section id="funciones">
      <div className="mx-auto max-w-[1100px] px-5 pt-[80px] md:px-6 md:pt-[120px]">
        <div className="mb-14">
          <h2 className="mb-3 text-[clamp(24px,3.5vw,32px)] leading-[1.2] font-semibold tracking-[-0.02em]">
            Diseñado para estudiantes del TEC
          </h2>
          <p className="text-muted-foreground max-w-[520px] text-[16px] leading-[1.55]">
            Cada función resuelve un problema real del día a día en el TEC. Sin funciones de más,
            sin distracciones.
          </p>
        </div>
      </div>

      <div className="mx-auto max-w-[1440px] px-5 md:px-6">
        <Feature
          watermark="01"
          label="Horarios"
          title="Armá tu horario en minutos"
          desc="Buscá cursos por nombre o código, filtrá por campus y grupo, y arrastrá directamente al calendario. El sistema detecta superposiciones automáticamente."
          bullets={[
            "Vista semanal con bloques de clase",
            "Filtros por carrera, campus y periodo",
            "Exportá como imagen o a tu app de calendario preferida",
          ]}
          reverse={false}
          visual={<ScheduleDemo />}
          visualClassName="h-[641px] overflow-hidden"
          gridClassName="md:grid-cols-[380px_1fr] md:gap-10"
        />
      </div>

      <div className="mx-auto mt-20 max-w-[1440px] px-5 md:mt-[120px] md:px-6">
        <Feature
          watermark="02"
          label="Malla curricular"
          title="Visualizá tu progreso académico"
          desc="La malla se muestra como un grafo interactivo donde podés ver qué cursos ya cursaste, cuáles podés matricular ahora y cuáles faltan."
          bullets={[
            "Grafo de requisitos y correquisitos",
            "Detalle de cada curso con descripción",
            "Seguimiento de progreso por plan",
          ]}
          reverse
          visual={<MallaDemo />}
          gridClassName="md:grid-cols-[380px_1fr] md:gap-10"
        />
      </div>

      <div className="mx-auto mt-20 max-w-[1440px] px-5 pb-[80px] md:mt-[120px] md:px-6 md:pb-[120px]">
        <Feature
          watermark="03"
          label="Comunidad"
          title="Evaluaciones y reseñas de profesores"
          desc="Subí evaluaciones de cursos en PDF de forma anónima. Leé reseñas de otros estudiantes para decidir con quién matricular."
          bullets={[
            "Subida anónima de evaluaciones PDF",
            "Reseñas con moderación automática",
            "Búsqueda por profesor y curso",
          ]}
          reverse={false}
          visual={<ReviewsDemo />}
          visualClassName="min-h-[320px] md:min-h-0"
          gridClassName="md:grid-cols-[380px_1fr] md:gap-10"
        />
      </div>
    </section>
  );
}
