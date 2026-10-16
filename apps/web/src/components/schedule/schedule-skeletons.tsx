import { START_HOUR, END_HOUR } from "@/components/calendar/body/day/calendar-body-day-margin";
import { Card, CardPanel } from "@/components/ui/card";
import { Frame, FrameHeader } from "@/components/ui/frame";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";

export function CourseCardSkeleton() {
  return (
    <Frame className="w-full max-w-full p-1.5">
      <FrameHeader className="flex flex-row items-baseline justify-between gap-2 px-3 pt-2 pb-1.5">
        <div className="flex items-center gap-2">
          <Skeleton className="h-4 w-14" />
          <Skeleton className="h-4 w-36 sm:w-48" />
        </div>
        <Skeleton className="h-5 w-12 rounded-full" />
      </FrameHeader>

      <div className="w-full max-w-full overflow-hidden rounded-b-[calc(var(--radius-2xl)-0.375rem)]">
        <div className="flex items-stretch gap-1.5">
          <Card className="bg-card flex min-w-[210px] shrink-0 flex-col rounded-[calc(var(--radius-2xl)-0.375rem)] border">
            <CardPanel className="p-3">
              <div className="mb-2 flex items-center gap-2">
                <Skeleton className="h-5 w-12 rounded-md" />
                <Skeleton className="h-3.5 w-8" />
                <Skeleton className="ml-auto h-5 w-7 rounded-md" />
              </div>
              <Separator className="mb-2" />
              <div className="space-y-1.5">
                <div className="flex items-center gap-2">
                  <Skeleton className="size-3.5 shrink-0 rounded-full" />
                  <Skeleton className="h-3.5 w-28" />
                </div>
                <div className="flex items-center gap-2">
                  <Skeleton className="size-3.5 shrink-0 rounded-full" />
                  <Skeleton className="h-3.5 w-24" />
                  <Skeleton className="ml-auto h-3.5 w-8" />
                </div>
                <div className="flex items-center gap-2">
                  <Skeleton className="size-3.5 shrink-0 rounded-full" />
                  <Skeleton className="h-3.5 w-6" />
                </div>
              </div>
            </CardPanel>
          </Card>

          <Card className="bg-card flex min-w-[210px] shrink-0 flex-col rounded-[calc(var(--radius-2xl)-0.375rem)] border opacity-70">
            <CardPanel className="p-3">
              <div className="mb-2 flex items-center gap-2">
                <Skeleton className="h-5 w-12 rounded-md" />
                <Skeleton className="h-3.5 w-8" />
              </div>
              <Separator className="mb-2" />
              <div className="space-y-1.5">
                <div className="flex items-center gap-2">
                  <Skeleton className="size-3.5 shrink-0 rounded-full" />
                  <Skeleton className="h-3.5 w-24" />
                </div>
                <div className="flex items-center gap-2">
                  <Skeleton className="size-3.5 shrink-0 rounded-full" />
                  <Skeleton className="h-3.5 w-20" />
                  <Skeleton className="ml-auto h-3.5 w-8" />
                </div>
                <div className="flex items-center gap-2">
                  <Skeleton className="size-3.5 shrink-0 rounded-full" />
                  <Skeleton className="h-3.5 w-6" />
                </div>
              </div>
            </CardPanel>
          </Card>
        </div>
      </div>
    </Frame>
  );
}

export function CourseListSkeleton({ count = 5 }: { count?: number }) {
  return (
    <div className="flex flex-col gap-3 pt-2 pr-2.5">
      {Array.from({ length: count }).map((_, index) => (
        <CourseCardSkeleton key={index} />
      ))}
    </div>
  );
}

const WEEK_DAYS = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];

export function ScheduleCalendarSkeleton({ hourHeight = 64 }: { hourHeight?: number }) {
  const hours = Array.from({ length: END_HOUR - START_HOUR + 1 }, (_, i) => START_HOUR + i);

  return (
    <div className="flex h-full w-full flex-col overflow-hidden">
      {/* Calendar Header */}
      <div className="border-border/70 flex h-[33px] border-b">
        <div className="w-12 shrink-0 border-r" />
        {WEEK_DAYS.map((day) => (
          <div
            key={day}
            className="border-border/50 flex flex-1 items-center justify-center border-r px-2 last:border-r-0"
          >
            <span className="text-muted-foreground/60 text-xs font-medium">{day}</span>
          </div>
        ))}
      </div>

      {/* Calendar Body Grid */}
      <div className="relative flex-1 overflow-hidden">
        <div className="flex h-full">
          {/* Hour Labels Column */}
          <div className="w-12 shrink-0 border-r">
            {hours.map((hour) => (
              <div
                key={hour}
                className="text-muted-foreground/40 border-border/30 flex items-start justify-center border-b pt-1 font-mono text-[10px]"
                style={{ height: `${hourHeight}px` }}
              >
                {`${hour.toString().padStart(2, "0")}:00`}
              </div>
            ))}
          </div>

          {/* Days Columns */}
          {WEEK_DAYS.map((day, dayIndex) => (
            <div
              key={day}
              className="border-border/30 relative flex flex-1 flex-col border-r last:border-r-0"
            >
              {hours.map((hour) => (
                <div
                  key={hour}
                  className="border-border/20 border-b"
                  style={{ height: `${hourHeight}px` }}
                />
              ))}

              {/* Sample subtle event skeletons on some columns */}
              {dayIndex === 0 && (
                <div
                  className="bg-primary/5 border-primary/20 absolute right-1 left-1 rounded-md border p-2"
                  style={{
                    top: `${hourHeight * 1 + 4}px`,
                    height: `${hourHeight * 1.8 - 8}px`,
                  }}
                >
                  <Skeleton className="mb-1.5 h-3 w-3/4" />
                  <Skeleton className="h-2.5 w-1/2" />
                </div>
              )}
              {dayIndex === 2 && (
                <div
                  className="bg-primary/5 border-primary/20 absolute right-1 left-1 rounded-md border p-2"
                  style={{
                    top: `${hourHeight * 3 + 4}px`,
                    height: `${hourHeight * 2 - 8}px`,
                  }}
                >
                  <Skeleton className="mb-1.5 h-3 w-4/5" />
                  <Skeleton className="h-2.5 w-1/2" />
                </div>
              )}
              {dayIndex === 4 && (
                <div
                  className="bg-primary/5 border-primary/20 absolute right-1 left-1 rounded-md border p-2"
                  style={{
                    top: `${hourHeight * 2 + 4}px`,
                    height: `${hourHeight * 1.5 - 8}px`,
                  }}
                >
                  <Skeleton className="mb-1.5 h-3 w-2/3" />
                  <Skeleton className="h-2.5 w-1/3" />
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
