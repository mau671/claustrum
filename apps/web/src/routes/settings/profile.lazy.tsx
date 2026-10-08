import { createLazyFileRoute } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

const ProfilePageRoute = lazy(() =>
  import("./-profile-page").then((module) => ({ default: module.ProfilePageRoute })),
);

export const Route = createLazyFileRoute("/settings/profile")({
  component: ProfileRoute,
});

function ProfileRoute() {
  return (
    <Suspense fallback={<div className="min-h-[240px]" />}>
      <ProfilePageRoute />
    </Suspense>
  );
}
