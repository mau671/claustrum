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
    <div className="flex flex-col gap-3 pt-2">
      {Array.from({ length: count }).map((_, index) => (
        <CourseCardSkeleton key={index} />
      ))}
    </div>
  );
}
