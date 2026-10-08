import type { ReactNode } from "react";

import { Separator } from "@/components/ui/separator";
import { cn } from "@/lib/utils";

interface SettingsPageProps {
  title: string;
  description: string;
  children: ReactNode;
}

interface SettingsSectionProps {
  title: string;
  description: string;
  children: ReactNode;
  className?: string;
}

function SettingsPage({ title, description, children }: SettingsPageProps) {
  return (
    <div className="space-y-8">
      <div className="space-y-2">
        <div className="space-y-1">
          <h2 className="text-2xl font-semibold tracking-tight">{title}</h2>
          <p className="text-muted-foreground text-sm">{description}</p>
        </div>
      </div>
      <Separator />
      <div className="divide-border divide-y">{children}</div>
    </div>
  );
}

function SettingsSection({ title, description, children, className }: SettingsSectionProps) {
  return (
    <section
      className={cn(
        "grid gap-4 py-8 first:pt-0 last:pb-0 md:grid-cols-[180px_minmax(0,1fr)] md:gap-10",
        className,
      )}
    >
      <div className="space-y-1.5">
        <h3 className="text-sm font-medium tracking-tight">{title}</h3>
        <p className="text-muted-foreground text-sm leading-6 md:max-w-40">{description}</p>
      </div>
      <div className="min-w-0 space-y-4">{children}</div>
    </section>
  );
}

export { SettingsPage, SettingsSection };
