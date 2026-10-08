import { createLazyFileRoute } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

const SecurityPage = lazy(() =>
  import("./-security-page").then((module) => ({ default: module.SecurityPage })),
);

export const Route = createLazyFileRoute("/settings/security")({
  component: SecurityRoute,
});

function SecurityRoute() {
  return (
    <Suspense fallback={<div className="min-h-[240px]" />}>
      <SecurityPage />
    </Suspense>
  );
}
