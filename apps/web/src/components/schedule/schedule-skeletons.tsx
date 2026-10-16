import { Clock01Icon, UserIcon, UserMultiple02Icon } from "@hugeicons/core-free-icons";
import { HugeiconsIcon } from "@hugeicons/react";

import { Badge } from "@/components/ui/badge";
import { Card, CardPanel } from "@/components/ui/card";
import { Frame, FrameHeader, FrameTitle } from "@/components/ui/frame";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";

export function CourseCardSkeleton() {
  return (
    <Frame className="w-full max-w-full p-1.5 transition-[border-color,box-shadow,background-color] duration-150">
      <FrameHeader className="flex flex-row items-baseline justify-between gap-2 px-3 pt-2 pb-1.5">
        <div className="min-w-0 flex-1">
          <FrameTitle className="flex items-center gap-1.5 leading-snug">
            <Skeleton className="h-3.5 w-14" />
            <Skeleton className="h-4 w-36 sm:w-48" />
          </FrameTitle>
        </div>
        <Badge
          variant="secondary"
          className="text-muted-foreground shrink-0 py-0.5 text-xs font-normal tabular-nums"
        >
          <Skeleton className="h-3 w-7" />
        </Badge>
      </FrameHeader>

      <div className="w-full max-w-full [scrollbar-width:none] scrollbar-none overflow-x-auto rounded-b-[calc(var(--radius-2xl)-0.375rem)] [&::-webkit-scrollbar]:hidden">
        <div className="flex snap-x snap-mandatory items-stretch gap-1.5">
          {/* Simulated Group 1 */}
          <Card className="bg-card relative flex w-auto min-w-fit shrink-0 flex-col rounded-[calc(var(--radius-2xl)-0.375rem)] border text-left">
            <CardPanel className="p-3">
              <div className="mb-2 flex items-center gap-2">
                <Badge variant="secondary" className="text-xs whitespace-nowrap">
                  GR <Skeleton className="ml-1 inline-block h-3 w-3.5" />
                </Badge>
                <Skeleton className="h-3.5 w-8" />
                <Badge
                  variant="outline"
                  className="bg-muted text-muted-foreground ml-auto h-5 px-1.5 text-[10px]"
                >
                  <Skeleton className="h-2.5 w-4" />
                </Badge>
              </div>

              <Separator className="mb-2" />

              <div className="space-y-1.5">
                <div className="flex items-center gap-2">
                  <HugeiconsIcon
                    icon={UserIcon}
                    size={14}
                    className="text-muted-foreground shrink-0 self-center"
                  />
                  <Skeleton className="h-3.5 w-28" />
                </div>

                <div className="flex items-center gap-2">
                  <HugeiconsIcon
                    icon={Clock01Icon}
                    size={14}
                    className="text-muted-foreground shrink-0 self-center"
                  />
                  <div className="flex items-center gap-2">
                    <Skeleton className="h-3.5 w-24" />
                    <Skeleton className="ml-auto h-3.5 w-9" />
                  </div>
                </div>

                <div className="flex items-center gap-2">
                  <HugeiconsIcon
                    icon={UserMultiple02Icon}
                    size={14}
                    className="text-muted-foreground shrink-0"
                  />
                  <Skeleton className="h-3.5 w-6" />
                </div>
              </div>
            </CardPanel>
          </Card>

          {/* Simulated Group 2 */}
          <Card className="bg-card relative flex w-auto min-w-fit shrink-0 flex-col rounded-[calc(var(--radius-2xl)-0.375rem)] border text-left opacity-75">
            <CardPanel className="p-3">
              <div className="mb-2 flex items-center gap-2">
                <Badge variant="secondary" className="text-xs whitespace-nowrap">
                  GR <Skeleton className="ml-1 inline-block h-3 w-3.5" />
                </Badge>
                <Skeleton className="h-3.5 w-8" />
              </div>

              <Separator className="mb-2" />

              <div className="space-y-1.5">
                <div className="flex items-center gap-2">
                  <HugeiconsIcon
                    icon={UserIcon}
                    size={14}
                    className="text-muted-foreground shrink-0 self-center"
                  />
                  <Skeleton className="h-3.5 w-24" />
                </div>

                <div className="flex items-center gap-2">
                  <HugeiconsIcon
                    icon={Clock01Icon}
                    size={14}
                    className="text-muted-foreground shrink-0 self-center"
                  />
                  <div className="flex items-center gap-2">
                    <Skeleton className="h-3.5 w-20" />
                    <Skeleton className="ml-auto h-3.5 w-8" />
                  </div>
                </div>

                <div className="flex items-center gap-2">
                  <HugeiconsIcon
                    icon={UserMultiple02Icon}
                    size={14}
                    className="text-muted-foreground shrink-0"
                  />
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
    <div className="flex flex-col gap-3 pt-2">
      {Array.from({ length: count }).map((_, index) => (
        <CourseCardSkeleton key={index} />
      ))}
    </div>
  );
}
