import { createFileRoute } from "@tanstack/react-router";

import { buildSeoMeta } from "@/lib/seo";

export const Route = createFileRoute("/docs/")({
  head: () =>
    buildSeoMeta({
      title: "Documentación | Claustrum",
      description: "Guía técnica y documentación de la arquitectura de Claustrum.",
      breadcrumbName: "Documentación",
      urlPath: "/docs",
    }),
  loader: async () => {
    const path = "index.mdx";
    const { preloadDoc } = await import("./-docs-page");
    await preloadDoc(path);
    return { path };
  },
});
