export type ReviewTextSegment =
  | { type: "text"; value: string }
  | { type: "link"; href: string; host: string };

const URL_PATTERN = /(?:https?:\/\/|www\.)[^\s<>"'`]+/gi;

const TRAILING_PUNCTUATION = new Set([".", ",", ";", ":", "!", "?", "»", "”", "’", "…"]);

function splitTrailingPunctuation(raw: string): { url: string; trailing: string } {
  let end = raw.length;

  while (end > 0) {
    const char = raw[end - 1];

    if (char === ")") {
      const slice = raw.slice(0, end);
      const openCount = slice.split("(").length - 1;
      const closeCount = slice.split(")").length - 1;
      if (closeCount <= openCount) break;
      end -= 1;
      continue;
    }

    if (char !== undefined && TRAILING_PUNCTUATION.has(char)) {
      end -= 1;
      continue;
    }

    break;
  }

  return { url: raw.slice(0, end), trailing: raw.slice(end) };
}

function toLink(url: string): { href: string; host: string } | null {
  const candidate = url.startsWith("www.") ? `https://${url}` : url;

  try {
    const parsed = new URL(candidate);
    if (parsed.protocol !== "http:" && parsed.protocol !== "https:") return null;
    return { href: candidate, host: parsed.hostname.replace(/^www\./, "") };
  } catch {
    return null;
  }
}

export function parseReviewText(text: string): ReviewTextSegment[] {
  const segments: ReviewTextSegment[] = [];
  let cursor = 0;

  for (const match of text.matchAll(URL_PATTERN)) {
    const start = match.index ?? 0;
    const { url, trailing } = splitTrailingPunctuation(match[0]);
    if (url.length === 0) continue;

    const link = toLink(url);
    if (!link) continue;

    if (start > cursor) {
      segments.push({ type: "text", value: text.slice(cursor, start) });
    }

    segments.push({ type: "link", href: link.href, host: link.host });
    cursor = start + url.length;

    if (trailing.length > 0) {
      segments.push({ type: "text", value: trailing });
      cursor += trailing.length;
    }
  }

  if (cursor < text.length) {
    segments.push({ type: "text", value: text.slice(cursor) });
  }

  return segments;
}

export type ReviewLinkProvider =
  | "drive"
  | "sheets"
  | "slides"
  | "docs"
  | "notion"
  | "dropbox"
  | "figma"
  | "youtube"
  | "github"
  | "onedrive"
  | "generic";

const PROVIDER_LABELS: Record<ReviewLinkProvider, string> = {
  drive: "Google Drive",
  sheets: "Google Sheets",
  slides: "Google Slides",
  docs: "Google Docs",
  notion: "Notion",
  dropbox: "Dropbox",
  figma: "Figma",
  youtube: "YouTube",
  github: "GitHub",
  onedrive: "OneDrive",
  generic: "Enlace",
};

export function resolveReviewLinkProvider(href: string, host: string): ReviewLinkProvider {
  const pathname = href.split("?")[0]?.split("#")[0] ?? "";

  if (host === "drive.google.com") return "drive";

  if (host === "docs.google.com") {
    if (pathname.includes("/spreadsheets")) return "sheets";
    if (pathname.includes("/presentation")) return "slides";
    if (pathname.includes("/document")) return "docs";
    return "drive";
  }

  if (host === "notion.so" || host.endsWith(".notion.site") || host === "notion.site") {
    return "notion";
  }

  if (host === "dropbox.com" || host.endsWith(".dropbox.com")) return "dropbox";
  if (host === "figma.com" || host.endsWith(".figma.com")) return "figma";
  if (host === "youtube.com" || host === "youtu.be" || host === "m.youtube.com") return "youtube";
  if (host === "github.com" || host === "gist.github.com") return "github";
  if (host === "onedrive.live.com" || host === "1drv.ms") return "onedrive";

  return "generic";
}

export function getReviewLinkLabel(provider: ReviewLinkProvider, host: string): string {
  return provider === "generic" ? host : PROVIDER_LABELS[provider];
}
