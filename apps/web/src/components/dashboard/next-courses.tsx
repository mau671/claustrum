"use client";

import { Link } from "@tanstack/react-router";

import type { NextCourse } from "@/lib/types";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ScrollArea } from "@/components/ui/scroll-area";

interface NextCoursesProps {
  courses: NextCourse[];
  universityId: number | null;
  campusId: number | null;
  academicUnitId: number | null;
  studyPlanId: number | null;
}

interface CourseLinkProps {
  course: NextCourse;
  searchParams: Record<string, number> | null;
}

function CourseLink({ course, searchParams }: CourseLinkProps) {
  if (searchParams) {
    return (
      <Link
        to="/curriculum"
        search={searchParams}
        className="block w-full max-w-full min-w-0 cursor-pointer overflow-hidden"
      >
        <div className="bg-muted/50 hover:bg-muted flex w-full max-w-full cursor-pointer items-center rounded-lg p-2 transition-colors">
          <div className="w-full min-w-0 flex-1 overflow-hidden">
            <div className="flex items-center gap-2">
              <span className="text-muted-foreground font-mono text-xs">{course.code}</span>
              <span className="bg-primary/10 text-primary rounded px-1.5 py-0.5 text-xs">
                {course.levelLabel}
              </span>
            </div>
            <p className="mt-0.5 w-full truncate text-sm font-medium">{course.name}</p>
            <p className="text-muted-foreground text-xs">{course.credits} créditos</p>
          </div>
        </div>
      </Link>
    );
  }
  return (
    <div className="bg-muted/50 flex w-full max-w-full min-w-0 items-center overflow-hidden rounded-lg p-2">
      <div className="w-full min-w-0 flex-1">
        <div className="flex items-center gap-2">
          <span className="text-muted-foreground font-mono text-xs">{course.code}</span>
          <span className="bg-primary/10 text-primary rounded px-1.5 py-0.5 text-xs">
            {course.levelLabel}
          </span>
        </div>
        <p className="mt-0.5 w-full truncate text-sm font-medium">{course.name}</p>
        <p className="text-muted-foreground text-xs">{course.credits} créditos</p>
      </div>
    </div>
  );
}

export function NextCourses({
  courses,
  universityId,
  campusId,
  academicUnitId,
  studyPlanId,
}: NextCoursesProps) {
  const searchParams =
    studyPlanId && universityId && campusId && academicUnitId
      ? { university: universityId, campus: campusId, career: academicUnitId, plan: studyPlanId }
      : null;

  return (
    <Card className="flex h-full w-full flex-col gap-1 overflow-hidden">
      <CardHeader className="shrink-0 pb-1">
        <CardTitle className="text-base">Próximos cursos</CardTitle>
      </CardHeader>
      <CardContent className="flex min-h-0 flex-1 flex-col pt-0">
        {courses.length === 0 ? (
          <p className="text-muted-foreground text-sm">No hay cursos disponibles para mostrar.</p>
        ) : (
          <ScrollArea className="min-h-0 flex-1">
            <div className="w-0 max-w-full min-w-full space-y-2 pr-3">
              {courses.map((course) => (
                <CourseLink key={course.id} course={course} searchParams={searchParams} />
              ))}
            </div>
          </ScrollArea>
        )}
      </CardContent>
    </Card>
  );
}
