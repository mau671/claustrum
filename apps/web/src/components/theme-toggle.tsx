import { Moon02Icon, Sun03Icon } from "@hugeicons/core-free-icons";
import { useEffect, useState } from "react";

import { useTheme } from "@/components/theme-provider";
import { Button } from "@/components/ui/button";
import { MorphIcon } from "@/components/ui/icon";

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  const isDark = theme === "dark";

  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={() => setTheme(isDark ? "light" : "dark")}
      aria-label="Alternar tema"
      title="Alternar tema"
    >
      {mounted ? (
        <MorphIcon icon={isDark ? Moon02Icon : Sun03Icon} size={isDark ? 20 : 22} />
      ) : (
        <span className="size-5" aria-hidden="true" />
      )}
      <span className="sr-only">Alternar tema</span>
    </Button>
  );
}
