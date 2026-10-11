import { createLazyFileRoute } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

import {
  EmptyDashboard,
  DashboardSkeleton,
  DashboardStatsSkeleton,
  CourseStatusChartSkeleton,
} from "@/components/dashboard/empty-state";
import { NextCourses } from "@/components/dashboard/next-courses";
import { ProgressTimeline } from "@/components/dashboard/progress-timeline";
import { useAuthUser, useDashboardStats, useUserStudyPlan } from "@/lib/hooks/use-queries";

const DashboardStatsCards = lazy(() =>
  import("@/components/dashboard/dashboard-stats").then((module) => ({
    default: module.DashboardStatsCards,
  })),
);

const CourseStatusChart = lazy(() =>
  import("@/components/dashboard/dashboard-stats").then((module) => ({
    default: module.CourseStatusChart,
  })),
);

export const Route = createLazyFileRoute("/overview/")({
  component: DashboardPage,
});

function DashboardPage() {
  const { data: authUser, isLoading: isAuthLoading } = useAuthUser();
  const { data: userStudyPlan, isLoading: isLoadingUserPlan } = useUserStudyPlan(
    authUser?.id ?? null,
  );
  const { data: dashboardData, isLoading: isLoadingStats } = useDashboardStats(
    userStudyPlan?.userId ?? null,
    userStudyPlan?.studyPlanId ?? null,
  );

  const isAuthenticated = !!authUser;
  const hasProfile = !!userStudyPlan?.studyPlanId;
  const isDataLoading = isAuthenticated && (isLoadingUserPlan || isLoadingStats);

  return (
    <div className="flex flex-1 flex-col">
      <div className="@container/main flex flex-1 flex-col gap-2">
        <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
          {isAuthLoading ? (
            <div className="px-4 py-6 lg:px-6" />
          ) : isDataLoading ? (
            <DashboardSkeleton />
          ) : !isAuthenticated || !dashboardData?.stats ? (
            <EmptyDashboard isAuthenticated={isAuthenticated} hasProfile={hasProfile} />
          ) : (
            <>
              <div className="px-4 lg:px-6">
                <Suspense fallback={<DashboardStatsSkeleton />}>
                  <DashboardStatsCards stats={dashboardData.stats} />
                </Suspense>
              </div>

              <div className="grid gap-4 px-4 md:grid-cols-2 lg:grid-cols-7 lg:px-6">
                <div className="w-full min-w-0 lg:col-span-4">
                  <Suspense fallback={<CourseStatusChartSkeleton />}>
                    <CourseStatusChart stats={dashboardData.stats} />
                  </Suspense>
                </div>
                <div className="h-[310px] w-full min-w-0 lg:col-span-3">
                  <NextCourses
                    courses={dashboardData.nextCourses}
                    universityId={userStudyPlan?.universityId ?? null}
                    campusId={userStudyPlan?.campusId ?? null}
                    academicUnitId={userStudyPlan?.academicUnitId ?? null}
                    studyPlanId={userStudyPlan?.studyPlanId ?? null}
                  />
                </div>
              </div>

              <div className="px-4 lg:px-6">
                <ProgressTimeline semesters={dashboardData.semesters} />
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
