import { createFileRoute } from "@tanstack/react-router";

import { buildSeoMeta } from "@/lib/seo";

export const Route = createFileRoute("/docs/$")({
  head: ({ params }) => {
    const rawName = params._splat?.split("/").filter(Boolean).pop();
    const title = rawName
      ? `${rawName.replace(/[-_]/g, " ").replace(/\b\w/g, (c) => c.toUpperCase())} | Documentación | Claustrum`
      : "Documentación | Claustrum";

    return buildSeoMeta({
      title,
      description: "Guía técnica y documentación de la arquitectura de Claustrum.",
      breadcrumbName: "Documentación",
      urlPath: `/docs/${params._splat ?? ""}`,
    });
  },
  loader: async ({ params }) => {
    const slugs = params._splat?.split("/").filter((part) => part.length > 0) ?? ["index"];
    const { preloadDoc, resolveDocPath } = await import("./-docs-page");
    const path = resolveDocPath(slugs);
    await preloadDoc(path);
    return { path };
  },
});
