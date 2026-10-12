"use client";

import { GraduationCapIcon } from "@hugeicons/core-free-icons";
import { Link } from "@tanstack/react-router";

import type { NextCourse } from "@/lib/types";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Icon } from "@/components/ui/icon";
import { ScrollArea } from "@/components/ui/scroll-area";

interface NextCoursesProps {
  courses: NextCourse[];
  universityId: number | null;
  campusId: number | null;
  academicUnitId: number | null;
  studyPlanId: number | null;
}

interface CourseCardProps {
  course: NextCourse;
  searchParams: Record<string, number> | null;
}

/** "SEMESTRE 3" -> "S3" for the narrow header slot; falls back to the full label. */
function shortLevelLabel(levelLabel: string): string {
  const match = levelLabel.match(/(\d+)\s*$/);
  return match ? `S${match[1]}` : levelLabel;
}

/** Same mini-card style as the equivalences grid on the course detail page. */
function CourseCard({ course, searchParams }: CourseCardProps) {
  const card = (
    <div className="border-border bg-card hover:border-primary/40 overflow-hidden rounded-lg border-2 shadow-sm transition-all duration-200">
      <div className="border-border bg-card border-b px-2 py-1.5">
        <div className="text-muted-foreground flex items-center justify-between font-mono text-xs">
          <span className="min-w-[3ch] text-right">{course.credits} cr</span>
          <span className="flex-1 truncate px-1.5 text-center font-semibold">{course.code}</span>
          <span className="min-w-[4ch] text-left" title={course.levelLabel}>
            {shortLevelLabel(course.levelLabel)}
          </span>
        </div>
      </div>
      <div className="bg-muted flex min-h-16 items-center justify-center px-2 py-2 text-center">
        <p
          className="text-foreground line-clamp-2 text-xs leading-tight font-semibold"
          title={course.name}
        >
          {course.name}
        </p>
      </div>
    </div>
  );

  if (searchParams) {
    return (
      <Link
        to="/curriculum"
        search={searchParams}
        className="focus-visible:ring-ring focus-visible:ring-offset-background block min-w-0 rounded-lg outline-none focus-visible:ring-2 focus-visible:ring-offset-2"
      >
        {card}
      </Link>
    );
  }
  return card;
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
    <Card className="flex h-full w-full flex-col overflow-hidden">
      <CardHeader className="shrink-0 pb-2">
        <CardTitle className="text-base font-semibold">Próximos cursos</CardTitle>
      </CardHeader>
      <CardContent className="flex min-h-0 flex-1 flex-col pt-0 pb-3">
        {courses.length === 0 ? (
          <div className="flex flex-1 flex-col items-center justify-center gap-1.5 p-4 text-center">
            <span className="bg-muted mb-1 rounded-full p-2.5">
              <Icon icon={GraduationCapIcon} className="text-muted-foreground size-5" />
            </span>
            <p className="text-sm font-medium">Sin próximos cursos</p>
            <p className="text-muted-foreground max-w-[26ch] text-xs">
              Aprobá más cursos para ver nuevas sugerencias.
            </p>
          </div>
        ) : (
          <ScrollArea className="size-full min-h-0" scrollFade>
            <div className="grid grid-cols-2 gap-2 pb-1">
              {courses.map((course) => (
                <CourseCard key={course.id} course={course} searchParams={searchParams} />
              ))}
            </div>
          </ScrollArea>
        )}
      </CardContent>
    </Card>
  );
}
