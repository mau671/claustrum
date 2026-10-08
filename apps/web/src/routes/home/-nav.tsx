import { Moon, Sun } from "lucide-react";

import { useTheme } from "@/components/theme-provider";
import { Button } from "@/components/ui/button";

import { GitHubIcon, Logo, StarIcon } from "./-icons";

export function HomeNav({ starCount }: { starCount: number | null }) {
  const { theme, setTheme } = useTheme();
  const isDark = theme === "dark";

  const handleSectionClick = (e: React.MouseEvent<HTMLAnchorElement>) => {
    const href = e.currentTarget.getAttribute("href");
    if (!href?.startsWith("#")) return;
    const section = document.querySelector(href);
    if (!section) return;
    e.preventDefault();
    section.scrollIntoView({ behavior: "smooth", block: "start" });
  };

  return (
    <nav className="border-border bg-background/95 fixed inset-x-0 top-0 z-[100] border-b backdrop-blur-[12px]">
      <div className="mx-auto flex h-14 max-w-[1100px] items-center justify-between px-5 md:h-16 md:px-6">
        <a
          href="/"
          onClick={(e) => {
            e.preventDefault();
            window.scrollTo({ top: 0, behavior: "smooth" });
          }}
          className="flex items-center gap-[10px] text-[15px] font-semibold tracking-[-0.01em] no-underline"
        >
          <Logo className="h-[26px] w-[26px] shrink-0" main="currentColor" accent="#C9A227" />
          Claustrum
        </a>

        <ul className="hidden list-none gap-8 md:flex">
          {["funciones", "stack", "opensource"].map((id) => (
            <li key={id}>
              <a
                href={`#${id}`}
                onClick={handleSectionClick}
                className="text-muted-foreground hover:text-foreground relative font-mono text-[13px] font-[450] tracking-[0.02em] no-underline transition-colors after:absolute after:inset-x-0 after:-bottom-1 after:h-px after:origin-left after:scale-x-0 after:bg-[#C9A227] after:transition-transform after:duration-200 hover:after:scale-x-100"
              >
                {id === "funciones"
                  ? "Funciones"
                  : id === "stack"
                    ? "Tecnología"
                    : "Código abierto"}
              </a>
            </li>
          ))}
        </ul>

        <div className="flex items-center gap-2">
          <Button
            variant="ghost"
            size="icon-sm"
            aria-label={isDark ? "Activar modo claro" : "Activar modo oscuro"}
            onClick={() => setTheme(isDark ? "light" : "dark")}
          >
            {isDark ? <Sun className="size-4" /> : <Moon className="size-4" />}
          </Button>

          <Button variant="outline" size="sm" asChild>
            <a href="/overview">Abrir</a>
          </Button>

          <Button size="sm" asChild>
            <a
              href="https://github.com/mau671/claustrum"
              target="_blank"
              rel="noopener noreferrer"
              aria-label="Ver repositorio en GitHub"
            >
              <GitHubIcon className="size-[15px]" />
              <span className="hidden sm:inline">GitHub</span>
              <span className="bg-primary-foreground/15 text-primary-foreground hidden items-center gap-1 rounded-full px-1.5 py-0.5 text-[10px] sm:inline-flex">
                <StarIcon className="size-2.5" />
                <span className="leading-none">{starCount ?? "-"}</span>
              </span>
            </a>
          </Button>
        </div>
      </div>
    </nav>
  );
}
