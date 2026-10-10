import { Moon02Icon, Sun03Icon } from "@hugeicons/core-free-icons";

import { useTheme } from "@/components/theme-provider";
import { Button } from "@/components/ui/button";
import { MorphIcon } from "@/components/ui/icon";

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  const isDark = theme === "dark";

  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={() => setTheme(isDark ? "light" : "dark")}
      aria-label="Alternar tema"
      title="Alternar tema"
    >
      <MorphIcon icon={isDark ? Moon02Icon : Sun03Icon} size={isDark ? 20 : 22} />
      <span className="sr-only">Alternar tema</span>
    </Button>
  );
}
