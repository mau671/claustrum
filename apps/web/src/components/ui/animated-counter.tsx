/* oxlint-disable no-misused-spread -- integer/fraction parts use latn numbering (ASCII digits only), so spreading is safe */
"use client";

import {
  AnimatePresence,
  animate,
  motion,
  useInView,
  useMotionValue,
  useReducedMotion,
  useTransform,
  type MotionValue,
  type Variants,
} from "motion/react";
import * as React from "react";

import { cn } from "@/lib/utils";

export interface AnimatedCounterProps {
  value: number;
  label?: string;
  prefix?: string;
  suffix?: string;
  decimals?: number;
  /** Rolls every digit up from zero the first time it scrolls into view. */
  animateOnView?: boolean;
  /** Fixed locale so server and client render the same digits. */
  locale?: string;
  className?: string;
}

type Part = { key: string; digit: number; order: number } | { key: string; text: string };

const DIGITS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

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
  stagger: { item: 0.035 },
  blur: { subtle: 2, soft: 4 },
} as const;

const rise: Variants = {
  hidden: { opacity: 0, y: "0.3em", filter: `blur(${motionTokens.blur.soft}px)` },
  shown: {
    opacity: 1,
    y: 0,
    filter: "blur(0px)",
    transition: { duration: motionTokens.duration.standard, ease: [...motionTokens.ease.enter] },
  },
  gone: {
    opacity: 0,
    y: "-0.3em",
    filter: `blur(${motionTokens.blur.subtle}px)`,
    transition: { duration: motionTokens.duration.fast, ease: [...motionTokens.ease.standard] },
  },
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

const reveal = { ...motionTokens.spring.smooth, visualDuration: motionTokens.duration.considered };

/** Split a formatted number into columns keyed by place value. */
function partsFor(value: number, decimals: number, locale: string): Part[] {
  const parts = new Intl.NumberFormat(locale, {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
    numberingSystem: "latn",
  }).formatToParts(value);
  let place = parts.reduce(
    (count, part) => count + (part.type === "integer" ? part.value.length : 0),
    0,
  );
  let fraction = 0;
  let order = 0;
  return parts.flatMap((part, index): Part[] => {
    if (part.type === "integer") {
      return [...part.value].map((char) => ({
        key: `i${--place}`,
        digit: Number(char),
        order: order++,
      }));
    }
    if (part.type === "fraction") {
      return [...part.value].map((char) => ({
        key: `f${fraction++}`,
        digit: Number(char),
        order: order++,
      }));
    }
    return [
      {
        key:
          part.type === "group"
            ? `g${place}`
            : part.type === "decimal"
              ? "d"
              : `${part.type}${index}`,
        text: part.value,
      },
    ];
  });
}

/** One digit on the wheel. */
function Glyph({ position, digit }: { position: MotionValue<number>; digit: number }) {
  const offset = useTransform(position, (current) => ((((digit - current) % 10) + 15) % 10) - 5);
  const y = useTransform(offset, (current) => `${current}em`);
  const opacity = useTransform(offset, (current) => Math.max(0, 1 - Math.abs(current)));
  const visibility = useTransform(offset, (current) =>
    Math.abs(current) >= 1 ? "hidden" : "visible",
  );
  const filter = useTransform(offset, (current) =>
    Math.abs(current) < 0.02 || Math.abs(current) >= 1
      ? "none"
      : `blur(${(Math.abs(current) * motionTokens.blur.subtle).toFixed(2)}px)`,
  );
  return (
    <motion.span
      className="absolute inset-0 text-center"
      style={{ y, opacity, filter, visibility }}
    >
      {digit}
    </motion.span>
  );
}

const presence = {
  initial: { width: 0, opacity: 0 },
  animate: { width: "auto", opacity: 1 },
  exit: { width: 0, opacity: 0 },
};

/** A digit wheel that turns in the direction the whole number moved. */
function Column({
  digit,
  direction,
  armed,
  delay,
  reduceMotion,
}: {
  digit: number;
  direction: number;
  armed: boolean;
  delay: number;
  reduceMotion: boolean;
}) {
  const position = useMotionValue(armed ? 0 : digit);
  const wheel = React.useRef({
    digit: armed ? 0 : digit,
    target: armed ? 0 : digit,
    revealed: !armed,
  });

  React.useEffect(() => {
    const state = wheel.current;
    if (armed || state.digit === digit) {
      if (!armed) state.revealed = true;
      return;
    }
    state.target +=
      direction < 0 && state.revealed
        ? -((state.digit - digit + 10) % 10)
        : (digit - state.digit + 10) % 10;
    state.digit = digit;
    if (reduceMotion) position.jump(state.target);
    else
      animate(
        position,
        state.target,
        state.revealed ? motionTokens.spring.smooth : { ...reveal, delay },
      );
    state.revealed = true;
  }, [armed, delay, digit, direction, position, reduceMotion]);

  return (
    <motion.span
      className="relative inline-block overflow-hidden"
      style={{
        marginBlock: "-0.16em",
        paddingBlock: "0.16em",
        maskImage: "linear-gradient(to bottom, transparent, #000 24%, #000 76%, transparent)",
      }}
      {...presence}
      transition={reduceMotion ? { duration: 0 } : motionTokens.spring.morph}
    >
      <span className="invisible">0</span>
      {DIGITS.map((item) => (
        <Glyph key={item} position={position} digit={item} />
      ))}
    </motion.span>
  );
}

export function AnimatedCounter({
  value,
  label,
  prefix = "",
  suffix = "",
  decimals = 0,
  animateOnView = false,
  locale = "en-US",
  className,
}: AnimatedCounterProps) {
  const ref = React.useRef<HTMLSpanElement>(null);
  const inView = useInView(ref, { once: true, amount: 0.6 });
  const reduceMotion = !!useReducedMotion();
  const [previous, setPrevious] = React.useState(value);
  const [direction, setDirection] = React.useState(1);
  if (value !== previous) {
    setPrevious(value);
    setDirection(value > previous ? 1 : -1);
  }
  const parts = partsFor(value, decimals, locale);
  const text = `${prefix}${parts.map((part) => ("text" in part ? part.text : part.digit)).join("")}${suffix}`;
  const armed = animateOnView && !inView;

  return (
    <span ref={ref} className={cn("relative inline-flex flex-col tabular-nums", className)}>
      {label ? (
        <span className="text-muted-foreground mb-0.5 text-xs">
          <span className="relative block">
            <AnimatePresence mode="popLayout" initial={false}>
              <motion.span
                key={label}
                className="inline-block"
                variants={reduceMotion ? fade : rise}
                initial="hidden"
                animate="shown"
                exit="gone"
              >
                {label}
              </motion.span>
            </AnimatePresence>
          </span>
        </span>
      ) : null}
      <span className="sr-only">{text}</span>
      <span className="inline-flex items-start whitespace-nowrap select-none" aria-hidden="true">
        {prefix ? <span>{prefix}</span> : null}
        <AnimatePresence initial={false}>
          {parts.map((part) =>
            "digit" in part ? (
              <Column
                key={part.key}
                digit={part.digit}
                direction={direction}
                armed={armed}
                delay={Math.min(part.order * motionTokens.stagger.item, 0.25)}
                reduceMotion={reduceMotion}
              />
            ) : (
              <motion.span
                key={part.key}
                className="inline-block overflow-x-clip"
                {...presence}
                transition={reduceMotion ? { duration: 0 } : motionTokens.spring.morph}
              >
                {part.text}
              </motion.span>
            ),
          )}
        </AnimatePresence>
        {suffix ? <span>{suffix}</span> : null}
      </span>
    </span>
  );
}

export default AnimatedCounter;
