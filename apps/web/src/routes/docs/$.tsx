import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/docs/$")({
  loader: async ({ params }) => {
    const slugs = params._splat?.split("/").filter((part) => part.length > 0) ?? ["index"];
    const { preloadDoc, resolveDocPath } = await import("./-docs-page");
    const path = resolveDocPath(slugs);
    await preloadDoc(path);
    return { path };
  },
});
