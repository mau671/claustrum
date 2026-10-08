"use client";

import { useNavigate } from "@tanstack/react-router";
import { Lock, Unlock, Link } from "lucide-react";
import React, { useState, useCallback } from "react";
import { flushSync } from "react-dom";

import type { StudyPlanDetail, CourseEffectiveStatus } from "@/lib/types";

import {
  ContextMenu,
  ContextMenuContent,
  ContextMenuItem,
  ContextMenuTrigger,
} from "@/components/ui/context-menu";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { useStudentCourseStatuses } from "@/lib/hooks/use-queries";
import { useCurriculumViewModel } from "@/lib/hooks/useCurriculumViewModel";
import { cn } from "@/lib/utils";

import { CourseCard, type RelationType } from "./course-card";
import { QuickRegisterDialog } from "./curriculum/quick-register-dialog";

interface CurriculumGridProps {
  planDetail: StudyPlanDetail;
  userId?: string;
  studyPlanId?: number;
  zoom?: number;
  readOnly?: boolean;
  mockStatusMap?: Map<number, CourseEffectiveStatus>;
}

function CurriculumGrid({
  planDetail,
  userId,
  studyPlanId,
  zoom = 1,
  readOnly,
  mockStatusMap,
}: CurriculumGridProps) {
  const [hoveredCourse, setHoveredCourse] = useState<string | null>(null);
  const [selectedCourseId, setSelectedCourseId] = useState<string | null>(null);
  const [quickRegisterCourseId, setQuickRegisterCourseId] = useState<string | null>(null);
  const navigate = useNavigate();

  const { data: fetchedStatusMap } = useStudentCourseStatuses(userId ?? null, studyPlanId ?? null);
  const statusMap = mockStatusMap ?? fetchedStatusMap;
  const { semesters, courseById } = useCurriculumViewModel(planDetail, statusMap);

  const getRelationType = useCallback(
    (targetId: string, courseId: string): RelationType => {
      const target = courseById.get(targetId);
      const course = courseById.get(courseId);
      if (!target || !course) return null;

      if (target.prerequisites?.includes(courseId)) return "prerequisite";
      if (target.corequisites?.includes(courseId)) return "corequisite";
      if (course.prerequisites?.includes(targetId)) return "postrequisite";

      return null;
    },
    [courseById],
  );

  const handleCourseClick = useCallback(
    (courseId: string) => {
      flushSync(() => {
        setSelectedCourseId(courseId);
      });

      void navigate({
        to: "/curriculum/$planId/$courseId",
        params: { planId: String(studyPlanId ?? planDetail.plan.id), courseId },
        search: (prev) => ({ action: prev.action, filters: prev.filters }), // keep only action and filters if any
        viewTransition: {
          types: ["course-open"],
        },
      });
    },
    [navigate, studyPlanId, planDetail.plan.id],
  );

  const handleRegisterProgressClick = useCallback((courseId: string) => {
    setQuickRegisterCourseId(courseId);
  }, []);

  return (
    <div className="flex h-full min-w-0 flex-col">
      <div
        className={cn(
          "relative z-0 min-h-0 flex-1",
          readOnly ? "overflow-hidden" : "overflow-x-auto overflow-y-auto",
        )}
      >
        <div className="px-4" style={{ zoom }}>
          <div className="flex gap-4 py-4">
            {semesters.map((semester) => (
              <div key={semester.levelNumber} className="w-48 flex-shrink-0">
                <div className="border-border mb-4 border-b pb-2">
                  <Tooltip>
                    <TooltipTrigger asChild>
                      <h2 className="text-foreground decoration-foreground/70 inline-block cursor-pointer text-lg font-semibold underline-offset-4 transition hover:underline">
                        {semester.levelLabel}
                      </h2>
                    </TooltipTrigger>
                    <TooltipContent side="top" align="start">
                      <div className="grid grid-cols-[auto_1fr] gap-x-3 gap-y-1 text-sm">
                        <span className="font-semibold">Cursos</span>
                        <span className="text-right">{semester.courses.length}</span>
                        <span className="font-semibold">Creditos</span>
                        <span className="text-right">
                          {semester.courses.reduce((acc, course) => acc + (course.credits ?? 0), 0)}
                        </span>
                        <span className="font-semibold">Horas</span>
                        <span className="text-right">
                          {semester.courses.reduce((acc, course) => acc + (course.hours ?? 0), 0)}
                        </span>
                      </div>
                    </TooltipContent>
                  </Tooltip>
                </div>
                <div className="space-y-4">
                  {semester.courses.map((course) => (
                    <ContextMenu key={course.id}>
                      <ContextMenuTrigger asChild>
                        <button
                          type="button"
                          className="block w-full text-left outline-none"
                          onMouseEnter={() => setHoveredCourse(course.id)}
                          onMouseLeave={() => setHoveredCourse(null)}
                          onClick={() => handleCourseClick(course.id)}
                        >
                          <CourseCard
                            id={`course-${course.id}`}
                            course={course}
                            transitionName={
                              selectedCourseId === course.id
                                ? `course-name-${course.id}`
                                : undefined
                            }
                            isHovered={hoveredCourse === course.id}
                            relationType={
                              hoveredCourse ? getRelationType(hoveredCourse, course.id) : null
                            }
                          />
                        </button>
                      </ContextMenuTrigger>
                      <ContextMenuContent>
                        <ContextMenuItem onClick={() => handleRegisterProgressClick(course.id)}>
                          Registrar progreso
                        </ContextMenuItem>
                      </ContextMenuContent>
                    </ContextMenu>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {!readOnly && (
        <div className="border-border shrink-0 border-t px-4 pt-1 pb-2">
          <div className="flex flex-row gap-8">
            <div>
              <h3 className="text-foreground mb-3 text-sm font-semibold">Leyenda de estados</h3>
              <div className="flex flex-wrap gap-4">
                <div className="flex items-center gap-2">
                  <div className="size-6 rounded border-2 border-emerald-500/30 bg-emerald-500/20" />
                  <span className="text-muted-foreground text-sm">Aprobado</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="size-6 rounded border-2 border-blue-500/30 bg-blue-500/20" />
                  <span className="text-muted-foreground text-sm">En curso</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="size-6 rounded border-2 border-purple-500/30 bg-purple-500/20" />
                  <span className="text-muted-foreground text-sm">Disponible</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="bg-muted border-border size-6 rounded border-2" />
                  <span className="text-muted-foreground text-sm">No cursado</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="size-6 rounded border-2 border-red-500/30 bg-red-500/20" />
                  <span className="text-muted-foreground text-sm">Reprobado</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="size-6 rounded border-2 border-amber-500/30 bg-amber-500/20" />
                  <span className="text-muted-foreground text-sm">Retirado</span>
                </div>
              </div>
            </div>

            <div>
              <h3 className="text-foreground mb-3 text-sm font-semibold">Relaciones</h3>
              <div className="flex flex-wrap gap-4">
                <div className="flex items-center gap-2">
                  <div className="bg-background flex size-6 shrink-0 items-center justify-center rounded-full border-2 border-amber-500 text-amber-600 shadow-sm">
                    <Lock className="size-3 shrink-0" />
                  </div>
                  <span className="text-muted-foreground text-sm">Requisito</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="bg-background flex size-6 shrink-0 items-center justify-center rounded-full border-2 border-blue-500 text-blue-600 shadow-sm">
                    <Link className="size-3 shrink-0" />
                  </div>
                  <span className="text-muted-foreground text-sm">Correquisito</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="bg-background flex size-6 shrink-0 items-center justify-center rounded-full border-2 border-emerald-500 text-emerald-600 shadow-sm">
                    <Unlock className="size-3 shrink-0" />
                  </div>
                  <span className="text-muted-foreground text-sm">Desbloquea</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
      <QuickRegisterDialog
        course={quickRegisterCourseId ? (courseById.get(quickRegisterCourseId) ?? null) : null}
        userId={userId}
        studyPlanId={studyPlanId}
        isOpen={quickRegisterCourseId !== null}
        onOpenChange={(open) => {
          if (!open) setQuickRegisterCourseId(null);
        }}
      />
    </div>
  );
}

export const MemoizedCurriculumGrid = React.memo(CurriculumGrid);
