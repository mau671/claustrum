import { BetterAuthIcon, CloudflareIcon, ReactIcon, SupabaseIcon, TailwindCSSIcon } from "./-icons";

const STACK_ITEMS = [
  { name: "React 19", role: "Interfaz", icon: ReactIcon },
  { name: "Tailwind CSS v4", role: "Estilos", icon: TailwindCSSIcon },
  { name: "Cloudflare", role: "Hosting y API", icon: CloudflareIcon },
  { name: "Supabase", role: "Base de datos", icon: SupabaseIcon },
  { name: "Better Auth", role: "Autenticación", icon: BetterAuthIcon },
];

export function StackSection() {
  return (
    <section id="stack" className="bg-[#0F172A] text-white">
      <div className="mx-auto max-w-[1100px] px-5 py-[80px] md:px-6 md:py-[120px]">
        <h2 className="mb-3 text-[clamp(24px,3.5vw,32px)] leading-[1.2] font-semibold tracking-[-0.02em]">
          Construido con herramientas modernas
        </h2>
        <p className="max-w-[620px] text-[16px] leading-[1.55] text-white/70">
          El frontend corre en Cloudflare Pages, la API en Cloudflare Workers y la base de datos en
          Supabase.
        </p>

        <div className="mt-12 grid gap-6 md:grid-cols-2">
          {STACK_ITEMS.map((item) => {
            const Icon = item.icon;
            return (
              <div key={item.name} className="flex items-start gap-3 border-b border-white/15 pb-4">
                <Icon className="mt-0.5 size-5 text-[#C9A227]" strokeWidth={1.8} />
                <div>
                  <div className="text-[15px] font-semibold">{item.name}</div>
                  <div className="text-[13px] text-white/70">{item.role}</div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
