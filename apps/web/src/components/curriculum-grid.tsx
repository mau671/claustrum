"use client";

import { Link01Icon, LockKeyholeIcon, LockKeyholeOpenIcon } from "@hugeicons/core-free-icons";
import { useNavigate } from "@tanstack/react-router";
import React, { useState, useCallback, useRef, useEffect } from "react";
import { flushSync } from "react-dom";

import type { StudyPlanDetail, CourseEffectiveStatus } from "@/lib/types";

import { Card, CardPanel } from "@/components/ui/card";
import {
  ContextMenu,
  ContextMenuContent,
  ContextMenuItem,
  ContextMenuTrigger,
} from "@/components/ui/context-menu";
import { Frame, FrameFooter, FrameHeader } from "@/components/ui/frame";
import { Icon } from "@/components/ui/icon";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
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
  const isGuest = !userId && !mockStatusMap;
  const { semesters, courseById } = useCurriculumViewModel(planDetail, statusMap, { isGuest });

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

  const headerScrollRef = useRef<HTMLDivElement>(null);
  const contentScrollRef = useRef<HTMLDivElement>(null);

  const handleContentScroll = useCallback(() => {
    const content = contentScrollRef.current;
    const header = headerScrollRef.current;
    if (!content || !header) return;

    if (Math.abs(header.scrollLeft - content.scrollLeft) > 0.5) {
      header.scrollLeft = content.scrollLeft;
    }
  }, []);

  const handleHeaderScroll = useCallback(() => {
    const content = contentScrollRef.current;
    const header = headerScrollRef.current;
    if (!content || !header) return;

    if (Math.abs(content.scrollLeft - header.scrollLeft) > 0.5) {
      content.scrollLeft = header.scrollLeft;
    }
  }, []);

  useEffect(() => {
    if (headerScrollRef.current && contentScrollRef.current) {
      headerScrollRef.current.scrollLeft = contentScrollRef.current.scrollLeft;
    }
  }, [zoom]);

  return (
    <Frame className="relative flex h-full min-h-0 w-full flex-col overflow-hidden">
      <FrameHeader className="shrink-0 p-0">
        <div
          ref={headerScrollRef}
          className="w-full scrollbar-none overflow-x-auto [&::-webkit-scrollbar]:hidden"
          onScroll={handleHeaderScroll}
        >
          <div className="flex w-max min-w-full gap-4 px-4 py-3" style={{ zoom }}>
            {semesters.map((semester) => {
              const totalCredits = semester.courses.reduce(
                (acc, course) => acc + (course.credits ?? 0),
                0,
              );
              const totalHours = semester.courses.reduce(
                (acc, course) => acc + (course.hours ?? 0),
                0,
              );

              return (
                <div
                  key={semester.levelNumber}
                  className="flex w-48 shrink-0 items-center justify-center text-center"
                >
                  <Popover>
                    <PopoverTrigger className="text-foreground decoration-foreground/70 inline-flex cursor-pointer items-center justify-center text-center text-base font-semibold underline-offset-4 transition hover:underline focus-visible:outline-none">
                      {semester.levelLabel}
                    </PopoverTrigger>
                    <PopoverContent
                      side="bottom"
                      align="center"
                      sideOffset={6}
                      className="w-auto min-w-36"
                      viewportClassName="p-2.5"
                    >
                      <div className="grid grid-cols-[auto_1fr] gap-x-4 gap-y-1 text-xs">
                        <span className="text-muted-foreground">Cursos</span>
                        <span className="text-right font-medium">{semester.courses.length}</span>
                        <span className="text-muted-foreground">Créditos</span>
                        <span className="text-right font-medium">{totalCredits}</span>
                        <span className="text-muted-foreground">Horas</span>
                        <span className="text-right font-medium">{totalHours}</span>
                      </div>
                    </PopoverContent>
                  </Popover>
                </div>
              );
            })}
          </div>
        </div>
      </FrameHeader>

      <Card className="bg-card min-h-0 flex-1 overflow-hidden rounded-xl border shadow-xs/5">
        <CardPanel
          ref={contentScrollRef}
          className={cn(
            "h-full min-h-0 flex-1 p-0",
            readOnly ? "overflow-hidden" : "overflow-x-auto overflow-y-auto",
          )}
          onScroll={handleContentScroll}
        >
          <div className="flex w-max min-w-full gap-4 p-4" style={{ zoom }}>
            {semesters.map((semester) => (
              <div key={semester.levelNumber} className="w-48 shrink-0">
                <div className="space-y-4">
                  {semester.courses.map((course) => (
                    <ContextMenu key={course.id}>
                      <ContextMenuTrigger
                        render={
                          <button
                            type="button"
                            className="block w-full text-left outline-none"
                            onMouseEnter={() => setHoveredCourse(course.id)}
                            onMouseLeave={() => setHoveredCourse(null)}
                            onClick={() => handleCourseClick(course.id)}
                            aria-label={course.name}
                          />
                        }
                      >
                        <CourseCard
                          id={`course-${course.id}`}
                          course={course}
                          transitionName={
                            selectedCourseId === course.id ? `course-name-${course.id}` : undefined
                          }
                          isHovered={hoveredCourse === course.id}
                          relationType={
                            hoveredCourse ? getRelationType(hoveredCourse, course.id) : null
                          }
                        />
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
        </CardPanel>
      </Card>

      {!readOnly && (
        <FrameFooter className="shrink-0 px-4 py-2.5 sm:px-5">
          <div className="flex flex-col gap-2.5 lg:flex-row lg:items-center lg:justify-between lg:gap-6">
            <div className="flex flex-wrap items-center gap-x-4 gap-y-1.5">
              <span className="text-muted-foreground text-xs font-semibold">Estados:</span>
              <div className="flex flex-wrap items-center gap-3">
                <div className="flex items-center gap-1.5">
                  <div className="size-3.5 rounded border-2 border-emerald-500/30 bg-emerald-500/20" />
                  <span className="text-muted-foreground text-xs">Aprobado</span>
                </div>
                <div className="flex items-center gap-1.5">
                  <div className="size-3.5 rounded border-2 border-blue-500/30 bg-blue-500/20" />
                  <span className="text-muted-foreground text-xs">En curso</span>
                </div>
                <div className="flex items-center gap-1.5">
                  <div className="size-3.5 rounded border-2 border-purple-500/30 bg-purple-500/20" />
                  <span className="text-muted-foreground text-xs">Disponible</span>
                </div>
                <div className="flex items-center gap-1.5">
                  <div className="bg-muted border-border size-3.5 rounded border-2" />
                  <span className="text-muted-foreground text-xs">No cursado</span>
                </div>
                <div className="flex items-center gap-1.5">
                  <div className="size-3.5 rounded border-2 border-red-500/30 bg-red-500/20" />
                  <span className="text-muted-foreground text-xs">Reprobado</span>
                </div>
                <div className="flex items-center gap-1.5">
                  <div className="size-3.5 rounded border-2 border-amber-500/30 bg-amber-500/20" />
                  <span className="text-muted-foreground text-xs">Retirado</span>
                </div>
              </div>
            </div>

            <div className="flex flex-wrap items-center gap-x-4 gap-y-1.5">
              <span className="text-muted-foreground text-xs font-semibold">Relaciones:</span>
              <div className="flex flex-wrap items-center gap-3">
                <div className="flex items-center gap-1.5">
                  <div className="bg-background flex size-4 shrink-0 items-center justify-center rounded-full border border-amber-500 text-amber-600 shadow-xs">
                    <Icon icon={LockKeyholeIcon} className="size-2.5 shrink-0" />
                  </div>
                  <span className="text-muted-foreground text-xs">Requisito</span>
                </div>
                <div className="flex items-center gap-1.5">
                  <div className="bg-background flex size-4 shrink-0 items-center justify-center rounded-full border border-blue-500 text-blue-600 shadow-xs">
                    <Icon icon={Link01Icon} className="size-2.5 shrink-0" />
                  </div>
                  <span className="text-muted-foreground text-xs">Correquisito</span>
                </div>
                <div className="flex items-center gap-1.5">
                  <div className="bg-background flex size-4 shrink-0 items-center justify-center rounded-full border border-emerald-500 text-emerald-600 shadow-xs">
                    <Icon icon={LockKeyholeOpenIcon} className="size-2.5 shrink-0" />
                  </div>
                  <span className="text-muted-foreground text-xs">Desbloquea</span>
                </div>
              </div>
            </div>
          </div>
        </FrameFooter>
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
    </Frame>
  );
}

export const MemoizedCurriculumGrid = React.memo(CurriculumGrid);
