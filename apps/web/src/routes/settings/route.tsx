import { createFileRoute } from "@tanstack/react-router";
import { Suspense, lazy } from "react";

import { buildSeoMeta, NOINDEX_ROBOTS } from "@/lib/seo";

const SettingsLayout = lazy(() =>
  import("./-settings-layout").then((module) => ({ default: module.SettingsLayout })),
);

export const Route = createFileRoute("/settings")({
  head: () =>
    buildSeoMeta({
      title: "Configuración | Claustrum",
      robots: NOINDEX_ROBOTS,
    }),
  component: SettingsRoute,
});

function SettingsRoute() {
  return (
    <Suspense fallback={<div className="bg-background flex-1" />}>
      <SettingsLayout />
    </Suspense>
  );
}
