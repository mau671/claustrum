import { createFileRoute } from "@tanstack/react-router";

import { buildSeoMeta, NOINDEX_ROBOTS } from "@/lib/seo";

export const Route = createFileRoute("/onboarding/")({
  head: () =>
    buildSeoMeta({
      title: "Onboarding | Claustrum",
      robots: NOINDEX_ROBOTS,
    }),
});
