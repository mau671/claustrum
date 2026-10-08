import { remarkMdxMermaid } from "fumadocs-core/mdx-plugins/remark-mdx-mermaid";
import { defineConfig } from "fumadocs-mdx/config";
import { defineDocs } from "fumadocs-mdx/config";

export default defineConfig({
  mdxOptions: {
    remarkPlugins: [remarkMdxMermaid],
  },
});

export const docs = defineDocs({
  dir: "content/docs",
});
