import { format } from "date-fns";
import { es } from "date-fns/locale";
import { Building2, Clock, Layers, MapPin, User, Users, X, GraduationCap } from "lucide-react";
import { memo } from "react";

import type { CalendarEvent as CalendarEventType } from "@/lib/types";

import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { getColorClasses, getEventColorStyle } from "@/lib/color-utils";
import { cn } from "@/lib/utils";

import { useCalendarContext } from "../calendar-context";

interface EventPosition {
  left: string;
  width: string;
  top: string;
  height: string;
}

interface CalendarEventProps {
  event: CalendarEventType;
  position?: EventPosition;
  month?: boolean;
  className?: string;
}

const CalendarEvent = memo(function CalendarEvent({
  event,
  position,
  month = false,
  className,
}: CalendarEventProps) {
  const { onRemoveEvent, exportTheme } = useCalendarContext();

  const eventColorStyle = exportTheme ? getEventColorStyle(event.color, exportTheme) : undefined;
  const style = {
    ...(month ? {} : (position ?? {})),
    ...eventColorStyle,
  };

  const colorClasses = getColorClasses(event.color);

  const classroomLabel = event.classroom?.trim();
  const showClassroom = classroomLabel && !classroomLabel.toLowerCase().includes("no disponible");
  const professors = event.professors ?? [];
  const professorNames = professors.length ? professors.map((p) => p.name) : ["Sin asignar"];
  const modalityLabel = event.groupType ?? "Sin modalidad";
  const campusLabel = event.campusName;
  const heightValue = month ? null : position?.height ? parseFloat(position.height) : null;
  const eventHeight = heightValue;
  const isCompact = eventHeight !== null && eventHeight < 72;
  const professorLineCount =
    eventHeight === null || eventHeight < 84 ? 1 : eventHeight < 108 ? 2 : 3;

  return (
    <Tooltip>
      <TooltipTrigger asChild>
        <div
          className={cn(
            "group relative cursor-pointer rounded-md border px-1 py-0.5 transition-all duration-200 sm:px-2 sm:py-1",
            colorClasses.bg,
            colorClasses.hover,
            colorClasses.border,
            !month && "absolute overflow-hidden",
            className,
          )}
          data-schedule-event-color={event.color}
          style={style}
        >
          {!month && onRemoveEvent && (
            <button
              type="button"
              className={cn(
                "absolute top-1 right-1 z-10 flex cursor-pointer items-center justify-center rounded-sm p-0.5 opacity-0 transition-all group-hover:opacity-100 hover:bg-black/10 dark:hover:bg-white/10",
                colorClasses.text,
              )}
              onClick={(eventClick) => {
                eventClick.stopPropagation();
                onRemoveEvent(event);
              }}
              aria-label="Quitar grupo"
            >
              <X className="size-3.5" />
            </button>
          )}

          <div className={cn("flex w-full flex-col gap-0.5", colorClasses.text)}>
            <p
              className={cn(
                "line-clamp-2 pr-5 text-[11px] leading-tight font-semibold sm:text-[13px]",
                isCompact && "text-[9px] sm:text-[10px]",
              )}
            >
              {event.courseName}
            </p>

            {!isCompact && showClassroom && (
              <div className="flex items-center gap-2 text-[10px] opacity-90 sm:text-xs">
                <span className="flex size-3 shrink-0 items-center justify-center sm:size-4">
                  <MapPin className="size-3 sm:size-4" />
                </span>
                <span className="leading-tight">{classroomLabel}</span>
              </div>
            )}
            {!isCompact && (
              <div className="flex items-center gap-2 text-[10px] opacity-85 sm:text-xs">
                <span className="flex size-3 shrink-0 items-center justify-center sm:size-4">
                  <Layers className="size-3 sm:size-4" />
                </span>
                <span className="leading-tight">{modalityLabel}</span>
              </div>
            )}
            <div
              className={cn(
                "flex items-center gap-2 text-[10px] opacity-85 sm:text-xs",
                isCompact && "hidden",
              )}
            >
              <span className="flex size-3 shrink-0 items-center justify-center sm:size-4">
                <User className="size-3 sm:size-4" />
              </span>
              <div className="flex min-w-0 flex-1 flex-col justify-center">
                {professorNames.map((name, i) => {
                  const allowedLines = Math.max(
                    1,
                    Math.floor(professorLineCount / professorNames.length),
                  );
                  return (
                    <span
                      key={`${name}-${i}`}
                      className={cn(
                        "min-w-0 leading-tight",
                        allowedLines === 1 && "truncate whitespace-nowrap",
                        allowedLines === 2 && "line-clamp-2 break-words whitespace-normal",
                        allowedLines >= 3 && "line-clamp-3 break-words whitespace-normal",
                      )}
                    >
                      {name}
                    </span>
                  );
                })}
              </div>
            </div>
            {isCompact && (
              <p className="text-[9px] opacity-80 sm:text-[10px]">
                {format(event.start, "h:mm a", { locale: es })}
              </p>
            )}
          </div>
        </div>
      </TooltipTrigger>
      <TooltipContent className="max-w-xs text-wrap">
        <div className="space-y-1">
          <p className="leading-tight font-semibold break-words">
            {event.courseCode}: {event.courseName}
          </p>
          <p className="flex items-center gap-2 text-sm">
            <span className="flex size-4 shrink-0 items-center justify-center">
              <Users className="size-4" />
            </span>
            <span>GRUPO {event.groupCode}</span>
          </p>
          <p className="flex items-center gap-2 text-sm">
            <span className="flex size-4 shrink-0 items-center justify-center">
              <GraduationCap className="size-4" />
            </span>
            <span>
              {event.credits} {event.credits === 1 ? "CRÉDITO" : "CRÉDITOS"}
            </span>
          </p>
          <p className="flex items-center gap-2 text-sm">
            <span className="flex size-4 shrink-0 items-center justify-center">
              <Clock className="size-4" />
            </span>
            <span>
              {format(event.start, "h:mm a", { locale: es })} -{" "}
              {format(event.end, "h:mm a", { locale: es })}
            </span>
          </p>
          {campusLabel && (
            <p className="flex items-center gap-2 text-sm">
              <span className="flex size-4 shrink-0 items-center justify-center">
                <Building2 className="size-4" />
              </span>
              <span className="min-w-0 flex-1 truncate">{campusLabel}</span>
            </p>
          )}
          {showClassroom && (
            <p className="flex items-center gap-2 text-sm">
              <span className="flex size-4 shrink-0 items-center justify-center">
                <MapPin className="size-4" />
              </span>
              <span>{classroomLabel}</span>
            </p>
          )}
          <p className="flex items-center gap-2 text-sm">
            <span className="flex size-4 shrink-0 items-center justify-center">
              <Layers className="size-4" />
            </span>
            <span>{modalityLabel}</span>
          </p>
          <div className="flex items-center gap-2 text-sm">
            <span className="flex size-4 shrink-0 items-center justify-center">
              <User className="size-4" />
            </span>
            <div className="flex min-w-0 flex-1 flex-col justify-center">
              {professorNames.map((professorName, i) => (
                <span
                  key={`${professorName}-${i}`}
                  className="max-w-full truncate whitespace-nowrap"
                >
                  {professorName}
                </span>
              ))}
            </div>
          </div>
        </div>
      </TooltipContent>
    </Tooltip>
  );
});

export default CalendarEvent;
