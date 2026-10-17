import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/docs/")({
  loader: async () => {
    const path = "index.mdx";
    const { preloadDoc } = await import("./-docs-page");
    await preloadDoc(path);
    return { path };
  },
});
