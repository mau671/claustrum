import { createFileRoute } from "@tanstack/react-router";

import { buildSeoMeta } from "@/lib/seo";

export const Route = createFileRoute("/policies/")({
  head: () =>
    buildSeoMeta({
      title: "Políticas | Claustrum",
      description: "Políticas de privacidad y términos de servicio de Claustrum.",
      breadcrumbName: "Políticas",
      urlPath: "/policies",
    }),
});
