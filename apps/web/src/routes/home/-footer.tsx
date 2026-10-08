import { Logo, HeartIcon } from "./-icons";

export function HomeFooter() {
  return (
    <footer className="border-border bg-card border-t px-5 py-10 md:px-6">
      <div className="mx-auto flex max-w-[1100px] flex-col items-center justify-between gap-4 md:flex-row">
        <div className="text-muted-foreground flex items-center gap-[10px] font-mono text-[12px]">
          <Logo className="size-[18px] shrink-0" main="currentColor" accent="#A6841C" />
          <span>
            Hecho con <HeartIcon className="inline size-3 translate-y-[-1px] text-[#DC2626]" /> por{" "}
            <a
              href="https://maugp.com"
              target="_blank"
              rel="noopener noreferrer"
              className="whitespace-nowrap underline underline-offset-2"
            >
              Mauricio González Prendas
            </a>
          </span>
        </div>
        <div className="flex gap-7">
          <a
            href="https://github.com/mau671/claustrum"
            target="_blank"
            rel="noopener noreferrer"
            className="text-muted-foreground hover:text-foreground font-mono text-[12px] tracking-[0.02em] no-underline"
          >
            GitHub
          </a>
          <a
            href="/docs/"
            className="text-muted-foreground hover:text-foreground font-mono text-[12px] tracking-[0.02em] no-underline"
          >
            Documentación
          </a>
          <a
            href="https://github.com/mau671/claustrum/blob/main/LICENSE"
            target="_blank"
            rel="noopener noreferrer"
            className="text-muted-foreground hover:text-foreground font-mono text-[12px] tracking-[0.02em] no-underline"
          >
            Licencia MIT
          </a>
        </div>
      </div>
    </footer>
  );
}
