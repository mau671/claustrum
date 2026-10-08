import { createFileRoute, notFound } from "@tanstack/react-router";
import browserCollections from "collections/browser";
import { DocsLayout } from "fumadocs-ui/layouts/docs";
import { Suspense } from "react";

import { DocsNavTitle } from "@/components/docs/nav-title";
import { DocPathProvider, DocsPageContent } from "@/components/docs/page-content";
import { docsTree } from "@/lib/docs/tree";

export const Route = createFileRoute("/docs/$")({
  component: DocsRoutePage,
  loader: async ({ params }) => {
    const slugs = params._splat?.split("/").filter((part) => part.length > 0) ?? ["index"];
    const path = resolveDocPath(slugs);

    await clientLoader.preload(path);

    return {
      path,
    };
  },
});

const clientLoader = browserCollections.docs.createClientLoader({
  component: DocsPageContent,
});

function resolveDocPath(slugs: string[]): string {
  const normalized = slugs.join("/");
  const candidates = [
    `${normalized}.mdx`,
    `${normalized}.md`,
    `${normalized}/index.mdx`,
    `${normalized}/index.md`,
  ];
  const available = new Set(
    Object.keys(browserCollections.docs.raw).map((entry) =>
      entry.startsWith("./") ? entry.slice(2) : entry,
    ),
  );

  for (const candidate of candidates) {
    if (available.has(candidate)) {
      return candidate;
    }
  }

  throw notFound();
}

function DocsRoutePage() {
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
