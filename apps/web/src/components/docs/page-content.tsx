import type { TOCItemType } from "fumadocs-core/toc";
import type { MDXComponents } from "mdx/types";

import { buttonVariants } from "fumadocs-ui/components/ui/button";
import { Popover, PopoverContent, PopoverTrigger } from "fumadocs-ui/components/ui/popover";
import { DocsBody, DocsDescription, DocsPage, DocsTitle } from "fumadocs-ui/layouts/docs/page";
import { useCopyButton } from "fumadocs-ui/utils/use-copy-button";
import { Check, ChevronDown, Copy, ExternalLinkIcon, TextIcon } from "lucide-react";
import { createContext, type ComponentType, type ReactNode, use } from "react";

import { cn } from "@/lib/utils";

import { useMDXComponents } from "./mdx";

const githubBaseUrl = "https://github.com/mau671/claustrum/blob/main";
const rawBaseUrl = "https://raw.githubusercontent.com/mau671/claustrum/main";
const markdownByImportPath = import.meta.glob("../../../content/docs/**/*.{md,mdx}", {
  query: "?raw",
  import: "default",
  eager: true,
}) as Record<string, string>;

const DocPathContext = createContext<string | null>(null);

interface DocsFrontmatter {
  title: string;
  description?: string;
  full?: boolean;
}

interface DocsPageContentProps {
  toc: TOCItemType[];
  frontmatter: DocsFrontmatter;
  default: ComponentType<{ components?: MDXComponents }>;
}

export function DocPathProvider({ path, children }: { path: string; children: ReactNode }) {
  return <DocPathContext value={path}>{children}</DocPathContext>;
}

export function DocsPageContent({ toc, frontmatter, default: MDX }: DocsPageContentProps) {
  const path = useDocPath();

  return (
    <DocsPage toc={toc} full={frontmatter.full} tableOfContent={{ style: "clerk" }}>
      <DocsTitle>{frontmatter.title}</DocsTitle>
      <DocsDescription className="mb-0">{frontmatter.description}</DocsDescription>
      <DocsPageActions path={path} />
      <DocsBody>
        <MDX components={useMDXComponents()} />
      </DocsBody>
    </DocsPage>
  );
}

function useDocPath() {
  const path = use(DocPathContext);

  if (!path) {
    throw new Error("DocsPageContent must be rendered inside DocPathProvider.");
  }

  return path;
}

function DocsPageActions({ path }: { path: string }) {
  const sourcePath = `content/docs/${path}`;
  const githubUrl = `${githubBaseUrl}/${sourcePath}`;
  const markdownUrl = `${rawBaseUrl}/${sourcePath}`;

  return (
    <>
      <div className="flex flex-wrap items-center gap-2">
        <CopyMarkdownButton path={path} />

        <Popover>
          <PopoverTrigger
            className={cn(
              buttonVariants({ color: "secondary", size: "sm" }),
              "data-[state=open]:bg-fd-accent data-[state=open]:text-fd-accent-foreground gap-2",
            )}
          >
            Abrir
            <ChevronDown className="text-fd-muted-foreground size-3.5" />
          </PopoverTrigger>
          <PopoverContent className="flex w-64 flex-col p-1" align="start">
            <a
              href={githubUrl}
              target="_blank"
              rel="noreferrer noopener"
              className="hover:bg-fd-accent hover:text-fd-accent-foreground inline-flex items-center gap-2 rounded-lg p-2 text-sm"
            >
              <GitHubIcon className="size-4" />
              Abrir en github
              <ExternalLinkIcon className="text-fd-muted-foreground ms-auto size-3.5" />
            </a>
            <a
              href={markdownUrl}
              target="_blank"
              rel="noreferrer noopener"
              className="hover:bg-fd-accent hover:text-fd-accent-foreground inline-flex items-start gap-2 rounded-lg p-2 text-sm"
            >
              <TextIcon className="size-4" />
              Ver como markdown
              <ExternalLinkIcon className="text-fd-muted-foreground ms-auto size-3.5" />
            </a>
          </PopoverContent>
        </Popover>
      </div>
      <div className="bg-fd-border h-px" />
    </>
  );
}

function CopyMarkdownButton({ path }: { path: string }) {
  const importPath = `../../../content/docs/${path}`;
  const markdown = markdownByImportPath[importPath] ?? "";
  const [checked, onClick] = useCopyButton(() => navigator.clipboard.writeText(markdown));

  return (
    <button
      type="button"
      onClick={onClick}
      disabled={!markdown}
      className={cn(
        buttonVariants({ color: "secondary", size: "sm" }),
        "[&_svg]:text-fd-muted-foreground gap-2 [&_svg]:size-3.5",
      )}
    >
      {checked ? <Check /> : <Copy />}
      Copiar como markdown
    </button>
  );
}

function GitHubIcon({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" className={className}>
      <path d="M12 0C5.374 0 0 5.373 0 12c0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z" />
    </svg>
  );
}
