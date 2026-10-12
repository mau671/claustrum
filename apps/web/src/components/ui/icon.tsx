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

export type CreateFilledIconOptions = {
  invertKeys?: string[];
  invertColor?: string;
  fillKeys?: string[];
};

export function createFilledIcon(
  icon: IconSvgElement,
  invertKeysOrOptions: string[] | CreateFilledIconOptions = [],
  invertColorArg: string = "var(--icon-cutout, var(--background))",
  fillKeysArg: string[] = [],
): IconSvgElement {
  const isOptions = !Array.isArray(invertKeysOrOptions);
  const invertKeys = isOptions ? (invertKeysOrOptions.invertKeys ?? []) : invertKeysOrOptions;
  const invertColor = isOptions
    ? (invertKeysOrOptions.invertColor ?? "var(--icon-cutout, var(--background))")
    : invertColorArg;
  const fillKeys = isOptions ? (invertKeysOrOptions.fillKeys ?? []) : fillKeysArg;

  const mapped = icon.map(([tag, attrs]) => {
    const isForceFilled = fillKeys.includes(String(attrs.key));
    const isClosed = (typeof attrs.d === "string" && attrs.d.includes("Z")) || isForceFilled;
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
      const d =
        isForceFilled && typeof attrs.d === "string" && !attrs.d.includes("Z")
          ? `${attrs.d}Z`
          : attrs.d;
      return {
        el: [tag, { ...attrs, d, fill: "currentColor" }] as IconSvgElement[number],
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
