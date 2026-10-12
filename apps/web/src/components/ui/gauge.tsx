/* oxlint-disable prefer-tag-over-role -- role="meter" on a div is intentional: a native <meter> element cannot host the custom SVG ring */
"use client";

import {
  AnimatePresence,
  animate,
  motion,
  useInView,
  useMotionValue,
  useMotionValueEvent,
  useReducedMotion,
  useTransform,
  type Variants,
} from "motion/react";
import * as React from "react";

import { cn } from "@/lib/utils";

export type GaugeTone = "accent" | "success" | "warning" | "danger";

/** A band starting at `from`: the highest band reached sets the tone and names the state. */
export interface GaugeThreshold {
  from: number;
  tone: GaugeTone;
  label: string;
}

export interface GaugeProps {
  value: number;
  min?: number;
  max?: number;
  label: string;
  detail?: string;
  tone?: GaugeTone;
  thresholds?: GaugeThreshold[];
  className?: string;
}

const motionTokens = {
  duration: { instant: 0.12, fast: 0.16, standard: 0.24, considered: 0.48 },
  ease: {
    enter: [0.16, 1, 0.3, 1] as const,
    standard: [0.22, 1, 0.36, 1] as const,
  },
  spring: {
    snappy: { type: "spring", visualDuration: 0.26, bounce: 0.12 } as const,
    smooth: { type: "spring", visualDuration: 0.4, bounce: 0 } as const,
    morph: { type: "spring", visualDuration: 0.42, bounce: 0.16 } as const,
  },
  blur: { subtle: 2, soft: 4 },
} as const;

const TONE_STROKE: Record<GaugeTone, string> = {
  accent: "stroke-primary",
  success: "stroke-status-success",
  warning: "stroke-status-warning",
  danger: "stroke-status-danger",
};

const TONE_TEXT: Record<GaugeTone, string> = {
  accent: "text-primary",
  success: "text-status-success",
  warning: "text-status-warning",
  danger: "text-status-danger",
};

/** Copy enters from the side the value moved toward. */
const rise: Variants = {
  hidden: (direction: number) => ({
    opacity: 0,
    y: `${0.3 * direction}em`,
    filter: `blur(${motionTokens.blur.soft}px)`,
  }),
  shown: {
    opacity: 1,
    y: 0,
    filter: "blur(0px)",
    transition: { duration: motionTokens.duration.standard, ease: [...motionTokens.ease.enter] },
  },
  gone: (direction: number) => ({
    opacity: 0,
    y: `${-0.3 * direction}em`,
    filter: `blur(${motionTokens.blur.subtle}px)`,
    transition: { duration: motionTokens.duration.fast, ease: [...motionTokens.ease.standard] },
  }),
};

const fade: Variants = {
  hidden: { opacity: 0, y: 0, filter: "blur(0px)" },
  shown: {
    opacity: 1,
    y: 0,
    filter: "blur(0px)",
    transition: { duration: motionTokens.duration.instant },
  },
  gone: {
    opacity: 0,
    y: 0,
    filter: "blur(0px)",
    transition: { duration: motionTokens.duration.instant },
  },
};

/** The first fill is slower and never overshoots. */
const reveal = {
  ...motionTokens.spring.smooth,
  visualDuration: motionTokens.duration.considered * 1.6,
};

/** New copy rises in while the old copy leaves. */
function Swap({ text, direction = 1 }: { text: string; direction?: number }) {
  const reduceMotion = !!useReducedMotion();
  return (
    <span className="relative block">
      <AnimatePresence mode="popLayout" initial={false} custom={direction}>
        <motion.span
          key={text}
          className="inline-block"
          custom={direction}
          variants={reduceMotion ? fade : rise}
          initial="hidden"
          animate="shown"
          exit="gone"
        >
          {text}
        </motion.span>
      </AnimatePresence>
    </span>
  );
}

/** A 270 degree ring open at the bottom, drawn clockwise from its lower left end. */
const radius = 42;
const start = -135;
const span = 270;

function arcFor(sweep: number) {
  const end = start + span * Math.min(1, Math.max(0, sweep));
  const at = (angle: number) =>
    `${(50 + radius * Math.sin((angle * Math.PI) / 180)).toFixed(3)} ${(50 - radius * Math.cos((angle * Math.PI) / 180)).toFixed(3)}`;
  return `M ${at(start)} A ${radius} ${radius} 0 ${end - start > 180 ? 1 : 0} 1 ${at(end)}`;
}

const track = arcFor(1);

export function Gauge({
  value,
  min = 0,
  max = 100,
  label,
  detail,
  tone = "accent",
  thresholds,
  className,
}: GaugeProps) {
  const safeMax = max > min ? max : min + 1;
  const percentage = Math.min(1, Math.max(0, (value - min) / (safeMax - min)));
  const displayValue = Math.round(percentage * 100);
  const bands = [...(thresholds ?? [])].sort((a, b) => a.from - b.from);
  const bandAt = (at: number) => bands.filter((threshold) => at >= threshold.from - 1e-6).pop();
  const band = bandAt(value);

  const ref = React.useRef<HTMLElement>(null);
  const inView = useInView(ref, { once: true, amount: 0.5 });
  const reduceMotion = !!useReducedMotion();
  const sweep = useMotionValue(0);
  const count = useMotionValue(0);
  const [filled, setFilled] = React.useState(false);
  const [live, setLive] = React.useState(band);
  const path = useTransform(sweep, arcFor);
  const arcOpacity = useTransform(sweep, (current) => Math.min(1, Math.max(0, current / 0.02)));
  const digits = useTransform(count, (current) =>
    String(Math.round(Math.min(100, Math.max(0, current)))),
  );
  const [moved, setMoved] = React.useState({ value: displayValue, direction: 1 });
  if (moved.value !== displayValue) {
    setMoved({ value: displayValue, direction: displayValue < moved.value ? -1 : 1 });
  }

  // The ring fills once seen, then springs to each new value; the count follows.
  React.useEffect(() => {
    if (reduceMotion) {
      sweep.jump(percentage);
      count.jump(percentage * 100);
      const frame = requestAnimationFrame(() => setFilled(true));
      return () => cancelAnimationFrame(frame);
    }
    if (!inView) return;
    const arc = animate(sweep, percentage, filled ? motionTokens.spring.morph : reveal);
    const number = animate(count, percentage * 100, {
      ...(filled ? motionTokens.spring.smooth : reveal),
      onComplete: () => setFilled(true),
    });
    return () => {
      arc.stop();
      number.stop();
    };
  }, [count, filled, inView, percentage, reduceMotion, sweep]);

  // The band follows the number on screen, so color and label change as the count crosses a threshold.
  useMotionValueEvent(count, "change", (current) => {
    const next = bandAt(min + (current / 100) * (safeMax - min));
    const changed = next?.from !== live?.from || next?.label !== live?.label;
    if (filled) {
      if (changed) setLive(next);
    } else if (inView && Math.abs(current - percentage * 100) < 1) {
      if (changed) setLive(next);
      setFilled(true);
    }
  });

  const shown = reduceMotion || !filled ? band : live;
  const activeTone = shown?.tone ?? tone;

  return (
    <figure
      ref={ref}
      className={cn("grid min-w-0 justify-items-center gap-2 text-center", className)}
      aria-label={`${label}: ${value} of ${safeMax}${band ? `, ${band.label}` : ""}`}
    >
      <div
        className="relative aspect-[100/90] w-full max-w-[176px]"
        role="meter"
        aria-label={label}
        aria-valuemin={min}
        aria-valuemax={safeMax}
        aria-valuenow={Math.min(safeMax, Math.max(min, value))}
        aria-valuetext={`${displayValue}%${band ? `, ${band.label}` : ""}`}
      >
        <svg
          viewBox="0 0 100 90"
          aria-hidden="true"
          focusable="false"
          className="block h-full w-full overflow-visible"
        >
          <path
            d={track}
            className="stroke-muted/40 fill-none"
            strokeWidth={9}
            strokeLinecap="round"
          />
          <motion.path
            d={path}
            className={cn("fill-none", TONE_STROKE[activeTone])}
            strokeWidth={9}
            strokeLinecap="round"
            style={{ opacity: arcOpacity }}
          />
        </svg>
        <div
          className="pointer-events-none absolute top-0 left-0 grid aspect-square w-full place-content-center justify-items-center gap-1"
          aria-hidden="true"
        >
          <span className="inline-flex items-baseline text-3xl font-semibold tabular-nums">
            <motion.span>{digits}</motion.span>
            <span className="text-muted-foreground ml-px text-base font-normal">%</span>
          </span>
          {thresholds ? (
            <span
              className={cn(
                "min-h-[1.4em] min-w-[100px] text-xs font-medium",
                TONE_TEXT[activeTone],
              )}
            >
              <Swap text={filled ? (shown?.label ?? "") : ""} direction={moved.direction} />
            </span>
          ) : null}
        </div>
      </div>
      <figcaption className="grid min-w-0 gap-0.5">
        <strong className="text-sm font-medium">
          <Swap text={label} />
        </strong>
        {detail ? (
          <span className="text-muted-foreground block text-xs tabular-nums">
            <Swap text={detail} direction={moved.direction} />
          </span>
        ) : null}
      </figcaption>
    </figure>
  );
}

export default Gauge;
