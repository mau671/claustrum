import { createLazyFileRoute } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

const PoliciesPage = lazy(() =>
  import("./-policies-page").then((module) => ({ default: module.PoliciesPage })),
);

export const Route = createLazyFileRoute("/policies/")({
  component: PoliciesRoute,
});

function PoliciesRoute() {
  return (
    <Suspense fallback={<div className="bg-background flex-1" />}>
      <PoliciesPage />
    </Suspense>
  );
}
