import type React from "react";

import { Loading02Icon } from "@hugeicons/core-free-icons";

import { Icon, type IconProps } from "@/components/ui/icon";
import { cn } from "@/lib/utils";

export function Spinner({
  className,
  size = 16,
  ...props
}: Omit<IconProps, "icon">): React.ReactElement {
  return (
    <Icon
      icon={Loading02Icon}
      aria-label="Loading"
      className={cn("animate-spin", className)}
      role="status"
      size={size}
      {...props}
    />
  );
}
