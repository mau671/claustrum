import { createLazyFileRoute } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

const CourseDetailPage = lazy(() =>
  import("../-course-detail-page").then((module) => ({ default: module.CourseDetailPage })),
);

export const Route = createLazyFileRoute("/curriculum/$planId/$courseId")({
  component: CourseDetailRoute,
});

function CourseDetailRoute() {
  return (
    <Suspense fallback={<div className="bg-background flex-1" />}>
      <CourseDetailPage />
    </Suspense>
  );
}
