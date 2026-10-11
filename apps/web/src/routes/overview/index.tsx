import { createFileRoute } from "@tanstack/react-router";

import { buildSeoMeta, NOINDEX_ROBOTS } from "@/lib/seo";

export const Route = createFileRoute("/overview/")({
  head: () =>
    buildSeoMeta({
      title: "Inicio | Claustrum",
      robots: NOINDEX_ROBOTS,
    }),
});
