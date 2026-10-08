import { Button } from "@/components/ui/button";

import { ArrowRight, GitHubIcon, StarIcon } from "./-icons";

export function HeroSection({ starCount }: { starCount: number | null }) {
  return (
    <section className="overflow-hidden">
      <div className="mx-auto max-w-[1100px] px-5 pt-[140px] pb-[60px] md:px-6 md:pt-[180px] md:pb-[100px]">
        <h1 className="font-display mb-7 max-w-[680px] text-[clamp(42px,6.5vw,72px)] leading-[1.05] font-semibold tracking-[-0.03em]">
          Planifica tu carrera sin perder tiempo en{" "}
          <span className="text-[#A6841C]">hojas de cálculo</span>.
        </h1>
        <p className="text-muted-foreground mb-10 max-w-[480px] text-[17px] leading-[1.6]">
          Claustrum centraliza todo lo que necesitás como estudiante del TEC: horarios, malla
          curricular, evaluaciones de cursos y reseñas de profesores. Sin anuncios. Sin fricción.
        </p>
        <div className="flex flex-col gap-3 sm:flex-row sm:flex-wrap">
          <Button asChild>
            <a
              href="/overview"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex w-full items-center justify-center gap-2 sm:w-auto"
            >
              Probar la app <ArrowRight className="size-[15px]" />
            </a>
          </Button>
          <Button variant="outline" asChild>
            <a
              href="https://github.com/mau671/claustrum"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex w-full items-center justify-center gap-2 sm:w-auto"
            >
              <GitHubIcon className="size-[15px]" />
              <span>Ver código fuente</span>
              <span className="bg-muted ml-1 inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-[10px]">
                <StarIcon className="size-2.5" />
                <span className="leading-none">{starCount ?? "-"}</span>
              </span>
            </a>
          </Button>
        </div>
      </div>
    </section>
  );
}
