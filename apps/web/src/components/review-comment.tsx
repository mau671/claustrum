import { Link01Icon } from "@hugeicons/core-free-icons";

import type { ReviewLinkProvider } from "@/lib/review-links";

import { Badge } from "@/components/ui/badge";
import { Icon } from "@/components/ui/icon";
import { Drive } from "@/components/ui/svgs/drive";
import { Dropbox } from "@/components/ui/svgs/dropbox";
import { Figma } from "@/components/ui/svgs/figma";
import { GithubDark } from "@/components/ui/svgs/githubDark";
import { GithubLight } from "@/components/ui/svgs/githubLight";
import { GoogleDocs } from "@/components/ui/svgs/googleDocs";
import { GoogleSheets } from "@/components/ui/svgs/googleSheets";
import { GoogleSlides } from "@/components/ui/svgs/googleSlides";
import { MicrosoftOnedrive } from "@/components/ui/svgs/microsoftOnedrive";
import { Notion } from "@/components/ui/svgs/notion";
import { Youtube } from "@/components/ui/svgs/youtube";
import { getReviewLinkLabel, parseReviewText, resolveReviewLinkProvider } from "@/lib/review-links";

function ReviewLinkIcon({ provider }: { provider: ReviewLinkProvider }) {
  switch (provider) {
    case "drive":
      return <Drive className="size-3.5" aria-hidden="true" />;
    case "docs":
      return <GoogleDocs className="size-3.5" aria-hidden="true" />;
    case "sheets":
      return <GoogleSheets className="size-3.5" aria-hidden="true" />;
    case "slides":
      return <GoogleSlides className="size-3.5" aria-hidden="true" />;
    case "onedrive":
      return <MicrosoftOnedrive className="size-3.5" aria-hidden="true" />;
    case "figma":
      return <Figma className="size-3.5" aria-hidden="true" />;
    case "dropbox":
      return <Dropbox className="size-3.5" aria-hidden="true" />;
    case "youtube":
      return <Youtube className="h-3.5 w-auto" aria-hidden="true" />;
    case "github":
      return (
        <>
          <GithubLight className="size-3.5 dark:hidden" aria-hidden="true" />
          <GithubDark className="hidden size-3.5 dark:block" aria-hidden="true" />
        </>
      );
    case "notion":
      return (
        <span className="ring-border/60 flex size-3.5 items-center justify-center rounded-[.1875rem] bg-white ring-1">
          <Notion className="size-3" aria-hidden="true" />
        </span>
      );
    default:
      return <Icon icon={Link01Icon} className="size-3.5" aria-hidden="true" />;
  }
}

export function ReviewComment({ comment }: { comment: string }) {
  const segments = parseReviewText(comment);

  if (segments.every((segment) => segment.type === "text")) {
    return <span className="whitespace-pre-wrap">{comment}</span>;
  }

  return (
    <span className="whitespace-pre-wrap">
      {segments.map((segment, index) => {
        if (segment.type === "text") {
          return <span key={`text-${index}`}>{segment.value}</span>;
        }

        const provider = resolveReviewLinkProvider(segment.href, segment.host);
        const label = getReviewLinkLabel(provider, segment.host);

        return (
          <Badge
            key={`link-${index}-${segment.href}`}
            variant="outline"
            className="mx-0.5 h-5 max-w-full align-middle text-xs leading-none sm:text-xs"
            render={
              <a
                href={segment.href}
                target="_blank"
                rel="noopener noreferrer nofollow ugc"
                title={segment.href}
                aria-label={`${label} (abre en una pestaña nueva)`}
              />
            }
          >
            <ReviewLinkIcon provider={provider} />
            <span className="min-w-0 truncate">{label}</span>
          </Badge>
        );
      })}
    </span>
  );
}
