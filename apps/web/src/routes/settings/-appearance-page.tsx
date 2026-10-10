import { ComputerIcon, Moon02Icon, Sun03Icon } from "@hugeicons/core-free-icons";

import { SettingsPage, SettingsSection } from "@/components/settings/settings-section";
import { useTheme } from "@/components/theme-provider";
import { MorphIcon } from "@/components/ui/icon";
import { cn } from "@/lib/utils";

const themes = [
  {
    value: "light",
    label: "Claro",
    icon: Sun03Icon,
  },
  {
    value: "dark",
    label: "Oscuro",
    icon: Moon02Icon,
  },
  {
    value: "system",
    label: "Sistema",
    icon: ComputerIcon,
  },
];

export function AppearancePage() {
  const { theme, setTheme } = useTheme();

  return (
    <SettingsPage title="Apariencia" description="Ajusta cómo se ve Claustrum en este dispositivo.">
      <SettingsSection
        title="Tema"
        description="Define la superficie visual principal de la aplicación."
      >
        <div className="space-y-6">
          <div className="grid gap-3 sm:grid-cols-3">
            {themes.map((themeOption) => {
              const isActive = theme === themeOption.value;

              return (
                <button
                  key={themeOption.value}
                  type="button"
                  onClick={() => setTheme(themeOption.value)}
                  aria-pressed={isActive}
                  aria-label={`${themeOption.label}${isActive ? ", activo" : ""}`}
                  className={cn(
                    "hover:border-primary/50 hover:bg-accent/50 flex flex-col items-center gap-3 rounded-lg border p-4 text-center transition-colors",
                    isActive ? "border-primary bg-primary/5" : "border-border bg-background",
                  )}
                >
                  <div
                    className={cn(
                      "flex size-12 items-center justify-center rounded-full",
                      isActive ? "bg-primary text-primary-foreground" : "bg-muted",
                    )}
                  >
                    <MorphIcon icon={themeOption.icon} size={24} />
                  </div>
                  <div className="text-sm font-medium">{themeOption.label}</div>
                </button>
              );
            })}
          </div>
        </div>
      </SettingsSection>
    </SettingsPage>
  );
}
