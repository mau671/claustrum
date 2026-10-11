"use client";

import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import * as React from "react";

import { useIsMobile } from "@/hooks/use-mobile";
import { cn } from "@/lib/utils";

export type StepperOrientation = "horizontal" | "vertical" | "responsive";
export type StepperStatus = "complete" | "current" | "upcoming" | "error";

export interface StepperStep {
  /** Stable key for step item. */
  id: string;
  /** Short label for the step (e.g. Sede, Carrera, Plan de estudios, Carnet). */
  label: string;
  /** Optional summary of chosen value when step is completed. */
  summary?: string;
  /** Optional error message when validation fails. */
  error?: string;
  /** Content/field rendered inside this step (combobox, input, etc.). */
  content?: React.ReactNode;
}

export interface StepperProps {
  steps: StepperStep[];
  /** Index of current step (0-based). */
  current: number;
  orientation?: StepperOrientation;
  /** Called when a completed step is clicked to navigate back to it. */
  onStepSelect?: (index: number) => void;
  label?: string;
  className?: string;
}

type GlyphKind = "number" | "check" | "error";

const motionTokens = {
  duration: {
    fast: 0.14,
    standard: 0.22,
  },
  ease: {
    standard: [0.2, 0, 0, 1] as const,
    enter: [0, 0, 0.2, 1] as const,
  },
  spring: {
    snappy: { type: "spring", stiffness: 480, damping: 32 } as const,
    smooth: { type: "spring", stiffness: 360, damping: 28 } as const,
  },
  stagger: {
    line: 0.08,
  },
} as const;

const still = { duration: 0 } as const;

/**
 * Animated glyph: numbers scale in, checkmark draws with stroke pathLength, and error alert pops in.
 */
function Glyph({
  kind,
  number,
  delay,
  reduced,
}: {
  kind: GlyphKind;
  number: number;
  delay: number;
  reduced: boolean;
}) {
  const pop = reduced
    ? still
    : {
        scale: { ...motionTokens.spring.snappy, delay },
        opacity: { duration: motionTokens.duration.fast, delay },
      };
  const exit = {
    opacity: 0,
    scale: 0.5,
    transition: reduced ? still : { duration: motionTokens.duration.fast, delay: 0 },
  };
  const draw = reduced
    ? still
    : {
        duration: motionTokens.duration.standard,
        ease: motionTokens.ease.enter,
        delay: delay + 0.04,
      };

  if (kind === "number") {
    return (
      <motion.span
        className="text-[11px] font-semibold tabular-nums select-none"
        initial={{ opacity: 0, scale: 0.5 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={exit}
        transition={pop}
      >
        {number}
      </motion.span>
    );
  }

  return (
    <motion.svg
      className="size-3 stroke-[2.5]"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeLinecap="round"
      strokeLinejoin="round"
      initial={{ opacity: 0, scale: 0.5 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={exit}
      transition={pop}
    >
      {kind === "check" ? (
        <motion.path
          d="M5.5 12.5l4.25 4.25L18.5 8"
          initial={{ pathLength: 0 }}
          animate={{ pathLength: 1 }}
          transition={draw}
        />
      ) : (
        <>
          <motion.path
            d="M12 6.75v6.5"
            initial={{ pathLength: 0 }}
            animate={{ pathLength: 1 }}
            transition={draw}
          />
          <motion.circle
            cx={12}
            cy={17.4}
            r={1.4}
            fill="currentColor"
            stroke="none"
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={reduced ? still : { ...motionTokens.spring.snappy, delay: delay + 0.16 }}
          />
        </>
      )}
    </motion.svg>
  );
}

function StaticGlyph({ kind, number }: { kind: GlyphKind; number: number }) {
  if (kind === "number") {
    return <span className="text-[11px] font-semibold tabular-nums select-none">{number}</span>;
  }

  return (
    <svg
      className="size-3 stroke-[2.5]"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      {kind === "check" ? (
        <path d="M5.5 12.5l4.25 4.25L18.5 8" />
      ) : (
        <>
          <path d="M12 6.75v6.5" />
          <circle cx={12} cy={17.4} r={1.4} fill="currentColor" stroke="none" />
        </>
      )}
    </svg>
  );
}

/**
 * Animated Marker with subtle, natural lighting glow.
 * When reduced motion is requested, it directly transitions colors via CSS without any layout thrash or pop.
 */
function Marker({
  number,
  kind,
  current,
  glyphDelay,
  ringDelay,
  reduced,
  isCompleted,
  hasError,
}: {
  number: number;
  kind: GlyphKind;
  current: boolean;
  glyphDelay: number;
  ringDelay: number;
  reduced: boolean;
  isCompleted: boolean;
  hasError: boolean;
}) {
  if (reduced) {
    return (
      <span
        className="relative flex size-7 shrink-0 items-center justify-center"
        aria-hidden="true"
      >
        {current ? (
          <span
            className={cn(
              "pointer-events-none absolute -inset-1 rounded-full transition-colors duration-150",
              hasError ? "bg-destructive/15" : "bg-primary/15",
            )}
          />
        ) : null}

        <span
          className={cn(
            "relative z-10 flex size-7 items-center justify-center rounded-full transition-colors duration-150",
            isCompleted && "bg-primary text-primary-foreground shadow-xs",
            current && !hasError && "bg-background text-primary border-primary border-2 shadow-xs",
            hasError && "bg-destructive/10 text-destructive border-destructive border-2",
            !isCompleted &&
              !current &&
              !hasError &&
              "border-border/80 bg-muted/50 text-muted-foreground border",
          )}
        >
          <StaticGlyph kind={kind} number={number} />
        </span>
      </span>
    );
  }

  return (
    <span className="relative flex size-7 shrink-0 items-center justify-center" aria-hidden="true">
      {/* Natural soft halo glow without harsh multi-rings */}
      <AnimatePresence initial={false}>
        {current ? (
          <motion.span
            key="halo"
            className={cn(
              "pointer-events-none absolute -inset-1 rounded-full",
              hasError ? "bg-destructive/15" : "bg-primary/15",
            )}
            initial={{ opacity: 0, scale: 0.6 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{
              opacity: 0,
              scale: 0.7,
              transition: { duration: 0.12, delay: 0 },
            }}
            transition={{
              scale: { ...motionTokens.spring.snappy, delay: ringDelay },
              opacity: { duration: motionTokens.duration.fast, delay: ringDelay },
            }}
          />
        ) : null}
      </AnimatePresence>

      <span
        className={cn(
          "relative z-10 flex size-7 items-center justify-center rounded-full transition-colors duration-200",
          isCompleted && "bg-primary text-primary-foreground shadow-xs",
          current && !hasError && "bg-background text-primary border-primary border-2 shadow-xs",
          hasError && "bg-destructive/10 text-destructive border-destructive border-2",
          !isCompleted &&
            !current &&
            !hasError &&
            "border-border/80 bg-muted/50 text-muted-foreground border",
        )}
      >
        <AnimatePresence initial={false} mode="wait">
          <Glyph key={kind} kind={kind} number={number} delay={glyphDelay} reduced={reduced} />
        </AnimatePresence>
      </span>
    </span>
  );
}

export function Stepper({
  steps,
  current,
  orientation = "responsive",
  onStepSelect,
  label = "Progreso",
  className,
}: StepperProps) {
  const reduced = useReducedMotion() ?? false;
  const isMobile = useIsMobile();
  const count = steps.length;
  const active = Math.min(Math.max(Math.round(current), 0), count);

  // Track previous active step cleanly without setState in render
  const prevActiveRef = React.useRef(active);
  const from = prevActiveRef.current;
  React.useEffect(() => {
    prevActiveRef.current = active;
  }, [active]);

  const gap = motionTokens.stagger.line;

  const delayAt = (index: number) => {
    if (reduced) return 0;
    if (active > from) return index >= from && index < active ? (index - from) * gap : 0;
    return 0;
  };

  // Only apply ringDelay when advancing forward across steps; immediate on backward navigation
  const ringDelay = reduced || active <= from ? 0 : Math.max(0, active - from - 1) * gap + 0.1;

  const effectiveOrientation =
    orientation === "responsive" ? (isMobile ? "vertical" : "horizontal") : orientation;

  const renderHorizontal = () => (
    <div className="w-full">
      <nav aria-label={label} className="w-full">
        <ol className="flex w-full items-center">
          {steps.map((step, index) => {
            const isCompleted = index < active;
            const isCurrent = index === active;
            const isUpcoming = index > active;
            const hasError = isCurrent && !!step.error;
            const isClickable = Boolean(onStepSelect && isCompleted);
            const kind: GlyphKind = hasError ? "error" : isCompleted ? "check" : "number";

            return (
              <li key={step.id} className="relative flex flex-1 items-center last:flex-none">
                {/* Step button / marker + label */}
                <button
                  type="button"
                  onClick={isClickable ? () => onStepSelect?.(index) : undefined}
                  disabled={!isClickable}
                  aria-current={isCurrent ? "step" : undefined}
                  className={cn(
                    "group flex items-center gap-2 outline-none select-none",
                    isClickable ? "cursor-pointer" : "cursor-default",
                  )}
                >
                  <Marker
                    number={index + 1}
                    kind={kind}
                    current={isCurrent}
                    glyphDelay={delayAt(index)}
                    ringDelay={ringDelay}
                    reduced={reduced}
                    isCompleted={isCompleted}
                    hasError={hasError}
                  />
                  <span
                    className={cn(
                      "text-xs tracking-tight whitespace-nowrap transition-colors",
                      isCurrent && "text-foreground font-semibold",
                      isCompleted && "text-foreground group-hover:text-primary font-medium",
                      isUpcoming && "text-muted-foreground font-normal",
                    )}
                  >
                    {step.label}
                  </span>
                </button>

                {/* Connector line leading to next step */}
                {index < count - 1 ? (
                  <div
                    aria-hidden="true"
                    className="bg-border relative mx-3 h-[2px] flex-1 overflow-hidden rounded-full"
                  >
                    <motion.span
                      className="bg-primary absolute inset-y-0 left-0 w-full origin-left"
                      initial={false}
                      animate={{ scaleX: index < active ? 1 : 0 }}
                      transition={
                        reduced ? still : { ...motionTokens.spring.smooth, delay: delayAt(index) }
                      }
                    />
                  </div>
                ) : null}
              </li>
            );
          })}
        </ol>
      </nav>

      {/* Content for the active step */}
      <div className="mt-6">
        {reduced ? (
          <div>{steps[active]?.content}</div>
        ) : (
          <AnimatePresence mode="wait" initial={false}>
            <motion.div
              key={steps[active]?.id ?? active}
              initial={{ opacity: 0, y: 6 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -6 }}
              transition={{ duration: 0.18 }}
            >
              {steps[active]?.content}
            </motion.div>
          </AnimatePresence>
        )}
      </div>
    </div>
  );

  const renderVertical = () => (
    <nav aria-label={label} className="w-full">
      <ol className="flex w-full flex-col">
        {steps.map((step, index) => {
          const isCompleted = index < active;
          const isCurrent = index === active;
          const isUpcoming = index > active;
          const hasError = isCurrent && !!step.error;
          const isClickable = Boolean(onStepSelect && isCompleted);
          const kind: GlyphKind = hasError ? "error" : isCompleted ? "check" : "number";
          const isLast = index === count - 1;

          return (
            <li key={step.id} className="relative flex items-start gap-3">
              {/* Left track: Marker + Vertical connector */}
              <div className="flex shrink-0 flex-col items-center self-stretch">
                <button
                  type="button"
                  onClick={isClickable ? () => onStepSelect?.(index) : undefined}
                  disabled={!isClickable}
                  aria-current={isCurrent ? "step" : undefined}
                  className={cn(
                    "rounded-full outline-none",
                    isClickable
                      ? "cursor-pointer transition-transform hover:scale-105"
                      : "cursor-default",
                  )}
                >
                  <Marker
                    number={index + 1}
                    kind={kind}
                    current={isCurrent}
                    glyphDelay={delayAt(index)}
                    ringDelay={ringDelay}
                    reduced={reduced}
                    isCompleted={isCompleted}
                    hasError={hasError}
                  />
                </button>

                {!isLast ? (
                  <div
                    aria-hidden="true"
                    className="bg-border relative my-1 min-h-[20px] w-[2px] flex-1 overflow-hidden rounded-full"
                  >
                    <motion.span
                      className="bg-primary absolute inset-x-0 top-0 h-full origin-top"
                      initial={false}
                      animate={{ scaleY: index < active ? 1 : 0 }}
                      transition={
                        reduced ? still : { ...motionTokens.spring.smooth, delay: delayAt(index) }
                      }
                    />
                  </div>
                ) : null}
              </div>

              {/* Right column: Step header on top, Combobox/Input below */}
              <div className={cn("min-w-0 flex-1 pt-0.5", !isLast && "pb-4")}>
                <div className="flex min-h-7 items-center justify-between gap-3">
                  <button
                    type="button"
                    onClick={isClickable ? () => onStepSelect?.(index) : undefined}
                    disabled={!isClickable}
                    className={cn(
                      "flex shrink-0 items-center text-left outline-none",
                      isClickable ? "group cursor-pointer" : "cursor-default",
                    )}
                  >
                    <span
                      className={cn(
                        "text-sm tracking-tight whitespace-nowrap transition-colors",
                        isCurrent && "text-foreground font-semibold",
                        isCompleted && "text-foreground group-hover:text-primary font-medium",
                        isUpcoming && "text-muted-foreground",
                      )}
                    >
                      {step.label}
                    </span>
                  </button>

                  {/* Summary of chosen value in completed step taking available space without premature truncation */}
                  {isCompleted && step.summary && !isCurrent ? (
                    <span className="text-muted-foreground min-w-0 flex-1 truncate text-right text-xs font-normal">
                      {step.summary}
                    </span>
                  ) : null}
                </div>

                {/* The input/combobox appears directly BELOW the field name */}
                {isCurrent && step.content ? (
                  <div className="animate-in fade-in-50 mt-2.5 w-full duration-150">
                    {step.content}
                  </div>
                ) : null}

                {isCurrent && step.error ? (
                  <p className="text-destructive animate-in fade-in-50 mt-1.5 text-xs font-medium duration-150">
                    {step.error}
                  </p>
                ) : null}
              </div>
            </li>
          );
        })}
      </ol>
    </nav>
  );

  return (
    <div className={className}>
      {effectiveOrientation === "vertical" ? renderVertical() : renderHorizontal()}
    </div>
  );
}
