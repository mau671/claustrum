import { createFileRoute } from "@tanstack/react-router";
import browserCollections from "collections/browser";
import { DocsLayout } from "fumadocs-ui/layouts/docs";
import { Suspense } from "react";

import { DocsNavTitle } from "@/components/docs/nav-title";
import { DocPathProvider, DocsPageContent } from "@/components/docs/page-content";
import { docsTree } from "@/lib/docs/tree";

export const Route = createFileRoute("/docs/")({
  component: DocsIndexPage,
  loader: async () => {
    const path = "index.mdx";
    await clientLoader.preload(path);
    return { path };
  },
});

const clientLoader = browserCollections.docs.createClientLoader({
  component: DocsPageContent,
});

function DocsIndexPage() {
  const data = Route.useLoaderData();

  return (
    <DocsLayout
      tree={docsTree}
      nav={{ title: <DocsNavTitle /> }}
      githubUrl="https://github.com/mau671/claustrum"
      containerProps={{
        className: "bg-fd-background text-fd-foreground",
        style: { scrollbarGutter: "stable" },
      }}
    >
      <DocPathProvider path={data.path}>
        <Suspense>{clientLoader.useContent(data.path)}</Suspense>
      </DocPathProvider>
    </DocsLayout>
  );
}
