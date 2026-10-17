import { createLazyFileRoute } from "@tanstack/react-router";

import { DocsPageShell } from "./-docs-page";

export const Route = createLazyFileRoute("/docs/$")({
  component: DocsRoutePage,
});

function DocsRoutePage() {
  const { path } = Route.useLoaderData() as { path: string };

  return <DocsPageShell path={path} />;
}
