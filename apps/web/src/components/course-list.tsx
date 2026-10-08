import { User, Clock, MapPin, Users, ChevronDown } from "lucide-react";
import { useMemo, useCallback, memo, useEffect, useRef, useState } from "react";

import type { ScheduleCourse, ScheduleGroup } from "@/lib/types";

import { colorOptions } from "@/components/calendar/calendar-tailwind-classes";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import { ScrollArea, ScrollBar } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { getGroupId } from "@/lib/calendar-utils";
import { cn } from "@/lib/utils";

type SelectedGroups = Set<string>;

const WEEKDAYS = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];
const WEEKDAYS_SHORT = ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"];

function normalizeSearchText(text: string): string {
  return text
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase();
}

const TruncatableText = ({ text }: { text: string }) => {
  const textRef = useRef<HTMLDivElement>(null);
  const [isTruncated, setIsTruncated] = useState(false);
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    const el = textRef.current;
    if (!el) return;

    const checkTruncation = () => {
      setIsTruncated(el.scrollWidth > el.clientWidth);
    };

    checkTruncation();
    const observer = new ResizeObserver(checkTruncation);
    observer.observe(el);
    return () => observer.disconnect();
  }, [text]);

  return (
    <Tooltip open={isOpen && isTruncated} onOpenChange={setIsOpen}>
      <TooltipTrigger asChild>
        <div ref={textRef} className={cn("w-full truncate", isTruncated && "cursor-help")}>
          {text}
        </div>
      </TooltipTrigger>
      <TooltipContent side="top" align="start">
        {text}
      </TooltipContent>
    </Tooltip>
  );
};

const formatWeekday = (weekday: number): string => WEEKDAYS[weekday] || "";
const formatWeekdayShort = (weekday: number): string => WEEKDAYS_SHORT[weekday] || "";

const formatTime = (time: string): string => {
  const [hours, minutes] = time.split(":");
  return `${hours.padStart(2, "0")}:${minutes}`;
};

const formatClassroom = (classroom: string | null | undefined): string | null => {
  if (!classroom) return null;
  const normalized = classroom.trim();
  if (!normalized) return null;
  if (normalized.toLowerCase().includes("no disponible")) return null;
  return normalized;
};

const COLOR_STYLE_MAP: Record<string, { bg: string; border: string; text: string }> = {
  blue: {
    bg: "bg-blue-100 dark:bg-blue-900/30",
    border: "border-blue-200 dark:border-blue-800",
    text: "text-blue-500",
  },
  emerald: {
    bg: "bg-emerald-100 dark:bg-emerald-900/30",
    border: "border-emerald-200 dark:border-emerald-800",
    text: "text-emerald-500",
  },
  yellow: {
    bg: "bg-yellow-100 dark:bg-yellow-900/30",
    border: "border-yellow-200 dark:border-yellow-800",
    text: "text-yellow-500",
  },
  red: {
    bg: "bg-red-100 dark:bg-red-900/30",
    border: "border-red-200 dark:border-red-800",
    text: "text-red-500",
  },
  orange: {
    bg: "bg-orange-100 dark:bg-orange-900/30",
    border: "border-orange-200 dark:border-orange-800",
    text: "text-orange-500",
  },
  fuchsia: {
    bg: "bg-fuchsia-100 dark:bg-fuchsia-900/30",
    border: "border-fuchsia-200 dark:border-fuchsia-800",
    text: "text-fuchsia-500",
  },
  violet: {
    bg: "bg-violet-100 dark:bg-violet-900/30",
    border: "border-violet-200 dark:border-violet-800",
    text: "text-violet-500",
  },
  slate: {
    bg: "bg-slate-100 dark:bg-slate-800/50",
    border: "border-slate-200 dark:border-slate-700",
    text: "text-slate-500",
  },
};

const getColorStyles = (color: string) => COLOR_STYLE_MAP[color] || COLOR_STYLE_MAP.blue;

interface CourseListProps {
  courses: ScheduleCourse[];
  selectedGroups: SelectedGroups;
  onSelectionChange: (selectedGroups: SelectedGroups) => void;
  campusById?: Map<number, { code: string; name: string }>;
  showCampus?: boolean;
  viewMode?: "card" | "table";
  courseColors?: Map<string, string>;
  searchQuery?: string;
}

interface GroupView {
  group: ScheduleGroup;
  groupId: string;
  campusCode: string | null;
  campusName: string | null;
  meetingViews: Array<{ id: string; label: string; shortLabel: string; classroom: string | null }>;
  sharedClassroom: string | null;
  professors: Array<{ id: number | null; name: string }>;
}

interface CourseViewData {
  course: ScheduleCourse;
  groupViews: GroupView[];
}

function createGroupView(
  course: ScheduleCourse,
  group: ScheduleGroup,
  showCampus: boolean,
  campusById?: Map<number, { code: string; name: string }>,
): GroupView {
  const campusId = group.campus_id ?? course.campus_id ?? null;
  const groupId = getGroupId(course.course_code, group.group_code);
  const campusData = showCampus && campusId ? campusById?.get(campusId) : null;
  const campusCode = campusData
    ? campusData.code
    : showCampus && campusId
      ? `Sede ${campusId}`
      : null;
  const campusName = campusData ? campusData.name : null;

  const meetings = group.meetings ?? [];
  const professors = group.professors?.length
    ? group.professors
    : [{ id: null, name: "Sin asignar" }];
  const meetingViews = meetings.map((session, idx) => {
    const classroom = formatClassroom(session.classroom);
    const label = `${formatWeekday(session.weekday)} ${formatTime(session.starts_at)}-${formatTime(session.ends_at)}`;
    return {
      id: `${groupId}-${idx}`,
      label,
      shortLabel: `${formatWeekdayShort(session.weekday)} ${formatTime(session.starts_at)}-${formatTime(session.ends_at)}`,
      classroom,
    };
  });

  const classrooms = meetingViews.map((meeting) => meeting.classroom);
  const sharedClassroom =
    meetings.length > 1 &&
    classrooms.every((classroom): classroom is string => classroom !== null) &&
    classrooms.every((classroom) => classroom === classrooms[0])
      ? classrooms[0]
      : null;

  return {
    group,
    groupId,
    campusCode,
    campusName,
    meetingViews,
    sharedClassroom,
    professors,
  };
}

function createCourseViewData(
  course: ScheduleCourse,
  showCampus: boolean,
  campusBy?: Map<number, { code: string; name: string }>,
): CourseViewData {
  const uniqueGroups = new Map<string, ScheduleGroup>();
  for (const group of course.groups ?? []) {
    const groupKey = getGroupId(course.course_code, group.group_code);
    if (!uniqueGroups.has(groupKey)) {
      uniqueGroups.set(groupKey, group);
    }
  }

  const groupViews = Array.from(uniqueGroups.values()).map((g) =>
    createGroupView(course, g, showCampus, campusBy),
  );
  return { course, groupViews };
}

function calculateConflictMap(courses: ScheduleCourse[]): Map<string, Set<string>> {
  const map = new Map<string, Set<string>>();
  const allGroupsList: Array<{ course: ScheduleCourse; group: ScheduleGroup }> = [];

  courses.forEach((course) => {
    if (!course.groups) return;
    course.groups.forEach((group) => {
      allGroupsList.push({ course, group });
    });
  });

  const length = allGroupsList.length;
  for (let i = 0; i < length; i++) {
    const { course: course1, group: group1 } = allGroupsList[i];
    const id1 = getGroupId(course1.course_code, group1.group_code);
    const meetings1 = group1.meetings;

    if (!meetings1) continue;

    for (let j = i + 1; j < length; j++) {
      const { course: course2, group: group2 } = allGroupsList[j];
      const meetings2 = group2.meetings;

      if (!meetings2) continue;

      const id2 = getGroupId(course2.course_code, group2.group_code);

      for (const s1 of meetings1) {
        for (const s2 of meetings2) {
          if (s1.weekday !== s2.weekday) continue;
          if (s1.starts_at < s2.ends_at && s1.ends_at > s2.starts_at) {
            if (!map.has(id1)) map.set(id1, new Set());
            if (!map.has(id2)) map.set(id2, new Set());
            map.get(id1)!.add(id2);
            map.get(id2)!.add(id1);
            break;
          }
        }
      }
    }
  }

  return map;
}

export interface ConflictReason {
  courseCode: string;
  courseName: string;
  groupCode: string;
  campusLabel: string | null;
}

function createGroupLabelMap(
  courses: ScheduleCourse[],
  showCampus: boolean,
  campusById?: Map<number, { code: string; name: string }>,
): Map<string, ConflictReason> {
  const map = new Map<string, ConflictReason>();

  courses.forEach((course) => {
    course.groups?.forEach((group) => {
      const groupId = getGroupId(course.course_code, group.group_code);
      const campusId = group.campus_id ?? course.campus_id ?? null;
      const campusData = showCampus && campusId ? campusById?.get(campusId) : null;
      const campusLabel = campusData
        ? campusData.name
        : showCampus && campusId
          ? `Sede ${campusId}`
          : null;

      map.set(groupId, {
        courseCode: course.course_code,
        courseName: course.course_name,
        groupCode: group.group_code,
        campusLabel,
      });
    });
  });

  return map;
}

function createConflictReasons(
  selectedGroups: SelectedGroups,
  conflictMap: Map<string, Set<string>>,
  courses: ScheduleCourse[],
  showCampus: boolean,
  campusById?: Map<number, { code: string; name: string }>,
): { conflictReasons: Map<string, ConflictReason[]>; disabledSet: Set<string> } {
  const conflictReasons = new Map<string, ConflictReason[]>();
  const disabledSet = new Set<string>();
  const groupLabelsById = createGroupLabelMap(courses, showCampus, campusById);

  selectedGroups.forEach((selectedId) => {
    const conflicts = conflictMap.get(selectedId);
    if (!conflicts) return;

    const label = groupLabelsById.get(selectedId);
    if (!label) return;

    conflicts.forEach((conflictId) => {
      if (selectedGroups.has(conflictId)) return;
      disabledSet.add(conflictId);

      const existing = conflictReasons.get(conflictId) ?? [];
      conflictReasons.set(conflictId, [...existing, label]);
    });
  });

  return { conflictReasons, disabledSet };
}

export default function CourseList({
  courses,
  selectedGroups,
  onSelectionChange,
  campusById,
  showCampus = false,
  viewMode = "card",
  courseColors: courseColorsProp,
  searchQuery = "",
}: CourseListProps) {
  const scrollAreaRootRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    const viewport = scrollAreaRootRef.current?.querySelector<HTMLElement>(
      '[data-slot="scroll-area-viewport"]',
    );
    const wrapper = viewport?.firstElementChild as HTMLElement | null;
    if (!wrapper) return;

    wrapper.style.display = "block";
    wrapper.style.width = "100%";

    return () => {
      wrapper.style.display = "";
      wrapper.style.width = "";
    };
  }, []);

  const courseColors = useMemo(() => {
    if (courseColorsProp) return courseColorsProp;
    const map = new Map<string, string>();
    courses.forEach((course, index) => {
      const color = colorOptions[index % colorOptions.length].value;
      map.set(course.course_code, color);
    });
    return map;
  }, [courses, courseColorsProp]);

  const courseColorStyles = useMemo(() => {
    const map = new Map<string, { bg: string; border: string; text: string }>();
    courses.forEach((course) => {
      const color = courseColors.get(course.course_code) || "blue";
      map.set(course.course_code, getColorStyles(color));
    });
    return map;
  }, [courses, courseColors]);

  const viewData = useMemo(() => {
    return courses.map((course) => createCourseViewData(course, showCampus, campusById));
  }, [courses, showCampus, campusById]);

  const filteredViewData = useMemo(() => {
    if (!searchQuery.trim()) return viewData;
    const query = normalizeSearchText(searchQuery);
    return viewData.filter((data) => {
      return (
        normalizeSearchText(data.course.course_code).includes(query) ||
        normalizeSearchText(data.course.course_name).includes(query)
      );
    });
  }, [viewData, searchQuery]);

  const conflictMap = useMemo(() => {
    return calculateConflictMap(courses);
  }, [courses]);

  const { conflictReasons, disabledSet } = useMemo(() => {
    return createConflictReasons(selectedGroups, conflictMap, courses, showCampus, campusById);
  }, [selectedGroups, conflictMap, courses, showCampus, campusById]);

  const handleGroupToggle = useCallback(
    (courseCode: string, groupCode: string) => {
      const groupId = getGroupId(courseCode, groupCode);
      const newSelection = new Set(selectedGroups);

      if (newSelection.has(groupId)) {
        newSelection.delete(groupId);
      } else {
        newSelection.forEach((selectedId) => {
          const [selectedCourseCode] = selectedId.split("-");
          if (selectedCourseCode === courseCode) {
            newSelection.delete(selectedId);
          }
        });
        newSelection.add(groupId);
      }

      onSelectionChange(newSelection);
    },
    [onSelectionChange, selectedGroups],
  );

  return (
    <div className="flex h-full flex-col overflow-hidden">
      <div ref={scrollAreaRootRef} className="flex-1 overflow-hidden">
        <ScrollArea className="h-full w-full [&_[data-slot=scroll-area-viewport]>div]:!block [&_[data-slot=scroll-area-viewport]>div]:!w-full">
          <div className={cn("w-full", viewMode === "card" ? "space-y-4 p-4" : "")}>
            {viewMode === "table" ? (
              <div className="flex flex-col rounded-md border">
                {filteredViewData.map((courseData) => (
                  <CourseTableItem
                    key={courseData.course.offering_id}
                    course={courseData.course}
                    groupViews={courseData.groupViews}
                    colorStyles={
                      courseColorStyles.get(courseData.course.course_code) ?? getColorStyles("blue")
                    }
                    selectedGroupIds={selectedGroups}
                    disabledGroupIdSet={disabledSet}
                    conflictReasonsByGroupId={conflictReasons}
                    onGroupToggle={handleGroupToggle}
                    showCampus={showCampus}
                  />
                ))}
              </div>
            ) : (
              filteredViewData.map((courseData) => {
                const course = courseData.course;
                const colorStyles =
                  courseColorStyles.get(course.course_code) ?? getColorStyles("blue");

                return (
                  <CourseCard
                    key={course.offering_id}
                    course={courseData.course}
                    groupViews={courseData.groupViews}
                    colorStyles={colorStyles}
                    selectedGroupIds={selectedGroups}
                    disabledGroupIdSet={disabledSet}
                    conflictReasonsByGroupId={conflictReasons}
                    onGroupToggle={handleGroupToggle}
                  />
                );
              })
            )}
          </div>
        </ScrollArea>
      </div>
    </div>
  );
}

const CourseCard = memo(function CourseCard({
  course,
  groupViews,
  colorStyles,
  selectedGroupIds,
  disabledGroupIdSet,
  conflictReasonsByGroupId,
  onGroupToggle,
}: {
  course: ScheduleCourse;
  groupViews: GroupView[];
  colorStyles: { bg: string; border: string; text: string };
  selectedGroupIds: SelectedGroups;
  disabledGroupIdSet: Set<string>;
  conflictReasonsByGroupId: Map<string, ConflictReason[]>;
  onGroupToggle: (courseCode: string, groupCode: string) => void;
}) {
  const [hoveredGroupId, setHoveredGroupId] = useState<string | null>(null);

  return (
    <Card
      className="w-full max-w-full gap-2"
      style={{ contentVisibility: "auto", containIntrinsicSize: "0 280px" }}
    >
      <CardHeader className="gap-1 px-4">
        <CardTitle className="text-base leading-tight">
          <div className="flex items-start justify-between gap-2">
            <span>
              {course.course_code}: {course.course_name}
            </span>
            <span className="bg-muted text-muted-foreground mt-0.5 shrink-0 rounded-md px-1.5 py-0.5 text-xs leading-none font-normal">
              {course.credits} créditos
            </span>
          </div>
        </CardTitle>
      </CardHeader>
      <CardContent className="max-w-full px-4">
        <ScrollArea className="w-full max-w-full">
          <div className="flex snap-x snap-mandatory items-start gap-3 pt-1 pb-2">
            {groupViews.map((groupView) => {
              const isSelected = selectedGroupIds.has(groupView.groupId);
              const disabled = disabledGroupIdSet.has(groupView.groupId);
              const reasons = conflictReasonsByGroupId.get(groupView.groupId) ?? [];

              return (
                <Tooltip
                  key={groupView.groupId}
                  open={disabled && hoveredGroupId === groupView.groupId}
                >
                  <TooltipTrigger asChild>
                    <button
                      type="button"
                      disabled={disabled}
                      className={cn(
                        "relative flex w-64 shrink-0 cursor-pointer snap-start flex-col rounded-lg border-2 p-3 text-left transition-all duration-200",
                        "hover:-translate-y-0.5 hover:shadow-md active:translate-y-0 active:shadow-sm",
                        disabled &&
                          "cursor-not-allowed opacity-50 hover:translate-y-0 hover:shadow-none",
                        !disabled && !isSelected && "hover:bg-muted/50 border-border",
                        isSelected && "-translate-y-0.5 shadow-md",
                        isSelected && colorStyles.bg,
                        isSelected && colorStyles.border,
                      )}
                      onClick={() =>
                        !disabled && onGroupToggle(course.course_code, groupView.group.group_code)
                      }
                      onPointerEnter={() => setHoveredGroupId(groupView.groupId)}
                      onPointerLeave={() =>
                        setHoveredGroupId((current) =>
                          current === groupView.groupId ? null : current,
                        )
                      }
                    >
                      <div className="mb-2 flex items-center gap-2">
                        <Badge
                          variant="secondary"
                          className={cn(
                            "text-xs whitespace-nowrap",
                            isSelected && "border",
                            isSelected && "bg-background/50",
                            isSelected && colorStyles.border,
                          )}
                        >
                          <span className="sm:hidden">GR</span>
                          <span className="hidden sm:inline">Grupo</span>{" "}
                          {groupView.group.group_code}
                        </Badge>
                        <span
                          className={cn(
                            "text-foreground text-xs whitespace-nowrap",
                            isSelected && "opacity-80",
                          )}
                        >
                          {groupView.group.group_type}
                        </span>
                        {groupView.campusCode && (
                          <Tooltip>
                            <TooltipTrigger asChild>
                              <Badge
                                variant="outline"
                                className={cn(
                                  "ml-auto h-5 cursor-help px-1.5 text-[10px]",
                                  isSelected
                                    ? "border-foreground/20 bg-background/50 text-inherit"
                                    : "bg-muted text-muted-foreground",
                                )}
                              >
                                {groupView.campusCode}
                              </Badge>
                            </TooltipTrigger>
                            <TooltipContent>
                              {groupView.campusName || groupView.campusCode}
                            </TooltipContent>
                          </Tooltip>
                        )}
                      </div>

                      <Separator
                        className={cn("mb-2 transition-colors", isSelected && "bg-foreground/20")}
                      />

                      <div className="space-y-1.5">
                        <div className="flex items-center gap-2">
                          <User
                            className={cn(
                              "h-3.5 w-3.5 shrink-0 self-center",
                              isSelected ? "text-foreground opacity-70" : "text-muted-foreground",
                            )}
                          />
                          <div className="flex flex-col justify-center gap-1">
                            {groupView.professors.map((professor, i) => (
                              <span
                                key={`${professor.id}-${i}`}
                                className={cn(
                                  "text-foreground text-xs leading-tight",
                                  isSelected && "opacity-80",
                                )}
                              >
                                {professor.name}
                              </span>
                            ))}
                          </div>
                        </div>

                        <div className={cn("relative", groupView.sharedClassroom && "pr-16")}>
                          <div className="flex items-start gap-2">
                            <Clock
                              className={cn(
                                "h-3.5 w-3.5 shrink-0 self-center",
                                isSelected ? "text-foreground opacity-70" : "text-muted-foreground",
                              )}
                            />
                            <div className="flex min-w-0 flex-1 flex-col justify-center gap-1">
                              {groupView.meetingViews.map((meeting) => (
                                <div
                                  key={meeting.id}
                                  className="grid min-w-0 grid-cols-[minmax(0,1fr)_auto] items-center gap-2"
                                >
                                  <span
                                    className={cn(
                                      "min-w-0 text-xs leading-tight whitespace-nowrap",
                                      isSelected ? "text-foreground opacity-80" : "text-foreground",
                                    )}
                                    title={meeting.label}
                                  >
                                    {meeting.shortLabel}
                                  </span>
                                  {!groupView.sharedClassroom && meeting.classroom && (
                                    <span
                                      className={cn(
                                        "text-muted-foreground flex items-center gap-1 justify-self-end text-xs whitespace-nowrap",
                                        isSelected && "opacity-80",
                                      )}
                                    >
                                      <MapPin className="h-3.5 w-3.5 shrink-0" />
                                      <span>{meeting.classroom}</span>
                                    </span>
                                  )}
                                </div>
                              ))}
                            </div>
                          </div>

                          {groupView.sharedClassroom && (
                            <div
                              className={cn(
                                "text-muted-foreground absolute top-1/2 right-0 flex -translate-y-1/2 items-center gap-1 text-xs whitespace-nowrap",
                                isSelected && "opacity-80",
                              )}
                            >
                              <MapPin className="h-3.5 w-3.5 shrink-0" />
                              <span>{groupView.sharedClassroom}</span>
                            </div>
                          )}
                        </div>

                        <div className="flex items-start gap-2">
                          <Users
                            className={cn(
                              "mt-0.5 h-3.5 w-3.5 shrink-0",
                              isSelected ? "text-foreground opacity-70" : "text-muted-foreground",
                            )}
                          />
                          <span
                            className={cn(
                              "text-foreground text-xs whitespace-nowrap",
                              isSelected && "opacity-70",
                            )}
                          >
                            {groupView.group.capacity} cupos
                          </span>
                        </div>
                      </div>
                    </button>
                  </TooltipTrigger>
                  {disabled && reasons.length > 0 && (
                    <TooltipContent className="bg-destructive max-w-xs text-white">
                      <div className="space-y-1.5">
                        <p className="text-sm font-semibold">Este grupo choca con:</p>
                        <ul className="space-y-2">
                          {reasons.map((r, idx) => (
                            <li key={idx} className="flex flex-col gap-0.5">
                              <span className="text-xs font-semibold">
                                {r.courseCode}: {r.courseName}
                              </span>
                              <div className="ml-1 flex flex-col pl-2 text-xs opacity-90">
                                <span>Grupo {r.groupCode}</span>
                                {r.campusLabel && <span>{r.campusLabel}</span>}
                              </div>
                            </li>
                          ))}
                        </ul>
                      </div>
                    </TooltipContent>
                  )}
                </Tooltip>
              );
            })}
          </div>
          <ScrollBar orientation="horizontal" />
        </ScrollArea>
      </CardContent>
    </Card>
  );
});

const CourseTableItem = memo(function CourseTableItem({
  course,
  groupViews,
  colorStyles,
  selectedGroupIds,
  disabledGroupIdSet,
  conflictReasonsByGroupId,
  onGroupToggle,
  showCampus,
}: {
  course: ScheduleCourse;
  groupViews: GroupView[];
  colorStyles: { bg: string; border: string; text: string };
  selectedGroupIds: SelectedGroups;
  disabledGroupIdSet: Set<string>;
  conflictReasonsByGroupId: Map<string, ConflictReason[]>;
  onGroupToggle: (courseCode: string, groupCode: string) => void;
  showCampus: boolean;
}) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <Collapsible
      open={isOpen}
      onOpenChange={setIsOpen}
      className="bg-card border-border w-full border-b last:border-b-0"
    >
      <CollapsibleTrigger asChild>
        <div className="hover:bg-muted/30 flex cursor-pointer items-center justify-between p-4 transition-colors">
          <div className="flex min-w-0 flex-1 items-start justify-between gap-2 pr-4">
            <span className="text-base leading-tight font-semibold">
              {course.course_code}: {course.course_name}
            </span>
            <span className="bg-muted text-muted-foreground mt-0.5 shrink-0 rounded-md px-1.5 py-0.5 text-xs leading-none font-normal">
              {course.credits} créditos
            </span>
          </div>
          <ChevronDown
            className={cn(
              "text-muted-foreground size-5 transition-transform duration-200",
              isOpen && "rotate-180",
            )}
          />
        </div>
      </CollapsibleTrigger>
      <CollapsibleContent>
        <div className="bg-muted/10 border-t">
          <Table>
            <TableHeader className="bg-muted/30">
              <TableRow>
                <TableHead className="w-[1%] pl-4 text-center whitespace-nowrap">Grupo</TableHead>
                <TableHead className="w-[1%] whitespace-nowrap">Tipo</TableHead>
                {showCampus && (
                  <TableHead className="w-[1%] text-center whitespace-nowrap">Sede</TableHead>
                )}
                <TableHead className="w-auto min-w-[120px]">Profesor</TableHead>
                <TableHead className="w-[1%] whitespace-nowrap">Horario</TableHead>
                <TableHead className="w-[1%] text-center whitespace-nowrap">Aula</TableHead>
                <TableHead className="w-[1%] pr-4 text-center whitespace-nowrap">Cupos</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {groupViews.map((groupView) => {
                const isSelected = selectedGroupIds.has(groupView.groupId);
                const disabled = disabledGroupIdSet.has(groupView.groupId);
                const reasons = conflictReasonsByGroupId.get(groupView.groupId) ?? [];

                return (
                  <Tooltip key={groupView.groupId} open={disabled ? undefined : false}>
                    <TooltipTrigger asChild>
                      <TableRow
                        onClick={() =>
                          !disabled && onGroupToggle(course.course_code, groupView.group.group_code)
                        }
                        className={cn(
                          "cursor-pointer transition-colors",
                          isSelected && "hover:bg-muted/90",
                          isSelected && !disabled && colorStyles.bg,
                          !isSelected && !disabled && "hover:bg-muted/50",
                          disabled && "cursor-not-allowed opacity-50 hover:bg-transparent",
                        )}
                      >
                        <TableCell className="pl-4 text-center">
                          <Badge
                            variant="secondary"
                            className={cn(
                              isSelected && "bg-background/50 text-foreground border",
                              isSelected && colorStyles.border,
                            )}
                          >
                            {groupView.group.group_code}
                          </Badge>
                        </TableCell>
                        <TableCell className="text-muted-foreground text-xs">
                          {groupView.group.group_type}
                        </TableCell>
                        {showCampus && (
                          <TableCell className="text-muted-foreground text-center text-xs">
                            {groupView.campusName ? (
                              <Tooltip>
                                <TooltipTrigger asChild>
                                  <span className="border-muted-foreground/50 cursor-help border-b border-dotted">
                                    {groupView.campusCode}
                                  </span>
                                </TooltipTrigger>
                                <TooltipContent>{groupView.campusName}</TooltipContent>
                              </Tooltip>
                            ) : (
                              groupView.campusCode
                            )}
                          </TableCell>
                        )}
                        <TableCell className="w-full max-w-[0] min-w-[120px]">
                          <div className="flex w-full flex-col gap-1 text-xs">
                            {groupView.professors.map((prof, i) => (
                              <TruncatableText key={`${prof.id ?? "nop"}-${i}`} text={prof.name} />
                            ))}
                          </div>
                        </TableCell>
                        <TableCell>
                          <div className="flex flex-col gap-1 text-xs whitespace-nowrap">
                            {groupView.meetingViews.map((meeting) => (
                              <span key={meeting.id} title={meeting.label}>
                                {meeting.shortLabel}
                              </span>
                            ))}
                          </div>
                        </TableCell>
                        <TableCell className="text-center">
                          <div className="text-muted-foreground flex flex-col items-center gap-1 text-xs whitespace-nowrap">
                            {groupView.sharedClassroom ? (
                              <span>{groupView.sharedClassroom}</span>
                            ) : (
                              groupView.meetingViews.map((meeting) => (
                                <span key={meeting.id}>{meeting.classroom || "-"}</span>
                              ))
                            )}
                          </div>
                        </TableCell>
                        <TableCell className="pr-4 text-center text-xs">
                          <span className="text-muted-foreground">{groupView.group.capacity}</span>
                        </TableCell>
                      </TableRow>
                    </TooltipTrigger>
                    {disabled && reasons.length > 0 && (
                      <TooltipContent className="bg-destructive max-w-xs text-white">
                        <div className="space-y-1.5">
                          <p className="text-sm font-semibold">Este grupo choca con:</p>
                          <ul className="space-y-2">
                            {reasons.map((r, idx) => (
                              <li key={idx} className="flex flex-col gap-0.5">
                                <span className="text-xs font-semibold">
                                  {r.courseCode}: {r.courseName}
                                </span>
                                <div className="ml-1 flex flex-col pl-2 text-xs opacity-90">
                                  <span>Grupo {r.groupCode}</span>
                                  {r.campusLabel && <span>{r.campusLabel}</span>}
                                </div>
                              </li>
                            ))}
                          </ul>
                        </div>
                      </TooltipContent>
                    )}
                  </Tooltip>
                );
              })}
            </TableBody>
          </Table>
        </div>
      </CollapsibleContent>
    </Collapsible>
  );
});
