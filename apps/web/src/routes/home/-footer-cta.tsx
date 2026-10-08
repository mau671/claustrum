import { Button } from "@/components/ui/button";

import { ArrowRight, GitHubIcon } from "./-icons";

export function FooterCTA() {
  return (
    <section className="overflow-hidden text-center">
      <div className="mx-auto max-w-[1100px] px-5 pt-[120px] pb-[80px] md:px-6 md:pt-[140px]">
        <h2 className="mb-4 text-[clamp(28px,4vw,40px)] leading-[1.15] font-semibold tracking-[-0.02em]">
          Empezá a usarlo hoy
        </h2>
        <p className="text-muted-foreground mx-auto mb-8 max-w-[440px] text-[16px]">
          Entrá con tu correo institucional, configurá tu carrera y empezá a planificar.
        </p>
        <div className="flex flex-col justify-center gap-3 sm:flex-row">
          <Button asChild>
            <a
              href="/overview"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center justify-center gap-2"
            >
              Abrir Claustrum <ArrowRight className="size-[15px]" />
            </a>
          </Button>
          <Button variant="outline" asChild>
            <a
              href="https://github.com/mau671/claustrum"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center justify-center gap-2"
            >
              <GitHubIcon className="size-[15px]" /> Ver en GitHub
            </a>
          </Button>
        </div>
      </div>
    </section>
  );
}
