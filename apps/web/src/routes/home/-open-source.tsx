export function OpenSourceSection() {
  return (
    <section id="opensource">
      <div className="mx-auto max-w-[1100px] px-5 py-[80px] md:px-6 md:py-[120px]">
        <div className="border-border bg-card min-w-0 border px-5 py-8 md:px-10 md:py-12">
          <div className="grid min-w-0 gap-8 md:grid-cols-[minmax(0,1fr)_430px] md:items-start">
            <div className="min-w-0">
              <h2 className="mb-4 max-w-[640px] text-[clamp(24px,3.5vw,34px)] leading-[1.12] font-semibold tracking-[-0.03em]">
                Código abierto para estudiantes que quieran mejorarlo
              </h2>
              <p className="text-muted-foreground max-w-[680px] text-[16px] leading-[1.6]">
                El código está publicado en GitHub, junto con la documentación y el modelo de datos,
                para que cualquiera pueda auditarlo, mejorarlo y corregirlo, bajo licencia MIT.
              </p>
            </div>

            <div className="min-w-0 space-y-4 md:w-[430px]">
              <div className="border-border bg-background/70 w-full min-w-0 scrollbar-thin [scrollbar-color:color-mix(in_oklab,var(--foreground)_22%,transparent)_transparent] overflow-x-auto border p-4 font-mono text-[12px] leading-relaxed">
                <div className="space-y-1">
                  <div className="whitespace-nowrap">
                    <span className="text-[#A6841C]">$</span> git clone{" "}
                    https://github.com/mau671/claustrum.git
                  </div>
                  <div>
                    <span className="text-[#A6841C]">$</span> pnpm install
                  </div>
                  <div>
                    <span className="text-[#A6841C]">$</span> pnpm run dev
                  </div>
                </div>
              </div>

              <div className="grid gap-3 sm:grid-cols-2">
                <a
                  href="https://github.com/mau671/claustrum"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="border-border hover:bg-accent inline-flex h-10 min-w-0 items-center justify-center border px-4 text-center font-mono text-[12px] no-underline transition-colors"
                >
                  Ver repositorio
                </a>
                <a
                  href="/docs/"
                  className="bg-foreground text-background inline-flex h-10 min-w-0 items-center justify-center px-4 text-center font-mono text-[12px] no-underline transition-opacity hover:opacity-90"
                >
                  Leer documentación
                </a>
              </div>
            </div>
          </div>
        </div>

        <p className="text-muted-foreground/80 mx-auto mt-12 max-w-[700px] text-center font-mono text-[12px] leading-[1.5]">
          Este proyecto no está afiliado, respaldado ni representa oficialmente al Instituto
          Tecnológico de <span className="whitespace-nowrap">Costa Rica.</span>
        </p>
      </div>
    </section>
  );
}
