import { HugeiconsIcon, type HugeiconsProps, type IconSvgElement } from "@hugeicons/react";
import {
  MorphIcon as BaseMorphIcon,
  type IconInput,
  type MorphIconProps as BaseMorphIconProps,
} from "morphicons/react";
import * as React from "react";

export interface IconProps extends Omit<HugeiconsProps, "icon"> {
  icon: IconSvgElement;
}

export function Icon({ size = 20, className, ...props }: IconProps) {
  return <HugeiconsIcon size={size} className={className} {...props} />;
}

export interface MorphIconProps extends Omit<BaseMorphIconProps, "icon"> {
  icon?: IconInput | IconSvgElement;
  from?: IconInput | IconSvgElement;
  to?: IconInput | IconSvgElement;
}

export const MorphIcon = React.forwardRef<unknown, MorphIconProps>(function MorphIcon(
  { size = 20, spring = "smooth", icon, from, to, ...props },
  ref,
) {
  return (
    <BaseMorphIcon
      ref={ref as never}
      size={size}
      spring={spring}
      icon={icon as IconInput}
      from={from as IconInput}
      to={to as IconInput}
      {...props}
    />
  );
});

export function createFilledIcon(
  icon: IconSvgElement,
  invertKeys: string[] = [],
  invertColor: string = "var(--icon-cutout, var(--background))",
): IconSvgElement {
  const mapped = icon.map(([tag, attrs]) => {
    const isClosed = typeof attrs.d === "string" && attrs.d.includes("Z");
    const isInverted = invertKeys.includes(String(attrs.key));
    if (isInverted) {
      return {
        el: [
          tag,
          {
            ...attrs,
            stroke: invertColor,
            fill: isClosed ? invertColor : "none",
          },
        ] as IconSvgElement[number],
        isBase: false,
      };
    }
    if (isClosed) {
      return {
        el: [tag, { ...attrs, fill: "currentColor" }] as IconSvgElement[number],
        isBase: true,
      };
    }
    return { el: [tag, attrs] as IconSvgElement[number], isBase: false };
  });

  // Paint filled base shapes first so detail strokes/cutouts
  // stay visible on top instead of being covered by the fill.
  return [
    ...mapped.filter((entry) => entry.isBase).map((entry) => entry.el),
    ...mapped.filter((entry) => !entry.isBase).map((entry) => entry.el),
  ];
}

export { HugeiconsIcon };
export type { IconSvgElement, IconInput };
