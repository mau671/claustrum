import { Fragment, type ReactNode } from "react";

function renderFormattedText(text: string): ReactNode {
  const regex = /(\*\*.*?\*\*|\*.*?\*|<u>.*?<\/u>)/g;
  const parts = text.split(regex);

  return parts.map((part, index) => {
    if (part.startsWith("**") && part.endsWith("**")) {
      return (
        <strong key={index} className="text-foreground font-semibold">
          {part.slice(2, -2)}
        </strong>
      );
    }
    if (part.startsWith("*") && part.endsWith("*")) {
      return (
        <em key={index} className="text-foreground italic">
          {part.slice(1, -1)}
        </em>
      );
    }
    if (part.startsWith("<u>") && part.endsWith("</u>")) {
      return (
        <span key={index} className="text-foreground underline underline-offset-2">
          {part.slice(3, -4)}
        </span>
      );
    }
    return <Fragment key={index}>{part}</Fragment>;
  });
}

export function FormattedSummary({ summary }: { summary: string }) {
  const paragraphs = summary.split(/\n\s*\n/).filter((p) => p.trim().length > 0);

  return (
    <div className="text-muted-foreground flex flex-col gap-2 text-sm leading-relaxed">
      {paragraphs.map((para, i) => (
        <p key={i}>{renderFormattedText(para)}</p>
      ))}
    </div>
  );
}
