import { createFileRoute } from "@tanstack/react-router";

import { buildSeoMeta, NOINDEX_ROBOTS } from "@/lib/seo";

import { ModerationLayout } from "./-moderation-layout";

export const Route = createFileRoute("/moderation")({
  head: () =>
    buildSeoMeta({
      title: "Moderación | Claustrum",
      robots: NOINDEX_ROBOTS,
    }),
  component: ModerationLayout,
});
