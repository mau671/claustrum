"use client";

import {
  AnimatePresence,
  animate,
  cancelFrame,
  frame,
  motion,
  motionValue,
  useInView,
  useReducedMotion,
  type MotionValue,
  type Transition,
} from "motion/react";
import * as React from "react";

import { cn } from "@/lib/utils";

export interface DonutChartDatum {
  /** Stable identity. A segment whose key survives a data change keeps its place and color. */
  key: string;
  label: string;
  value: number;
  /** Any CSS color or variable (e.g. var(--color-emerald-500)). Defaults to chart color tokens. */
  color?: string;
}

export interface DonutChartProps {
  data: DonutChartDatum[];
  /** Label for assistive tech and announcements (e.g. "Distribución de cursos"). */
  label: string;
  /** Unit placed after values (e.g. "cursos"). */
  unit?: string;
  /** Optional custom formatter for numbers. */
  formatValue?: (value: number) => string;
  /** Center label at rest, above the total. Default "Total". */
  totalLabel?: string;
  /** Diameter in pixels. Defaults to 190. */
  size?: number;
  /** Ring thickness in pixels. Defaults to 22. */
  thickness?: number;
  /** Slices below this share of the total join "Other". Pass 0 to disable grouping. */
  groupBelow?: number;
  /** The most segments drawn. Slices beyond this are grouped if groupBelow > 0. */
  maxSegments?: number;
  /** Label for the grouped segment. Default "Otros". */
  otherLabel?: string;
  /** Whether to exclude items with value <= 0 from the chart and legend. Default false. */
  hideZero?: boolean;
  /** Controlled active segment key. */
  activeKey?: string | null;
  /** Initial active segment key when uncontrolled. */
  defaultActiveKey?: string | null;
  /** Callback when active segment changes. */
  onActiveChange?: (key: string | null) => void;
  /** Controlled hidden segment keys. */
  hiddenKeys?: string[];
  /** Initial hidden segment keys when uncontrolled. */
  defaultHiddenKeys?: string[];
  /** Callback when hidden segments change. */
  onHiddenKeysChange?: (keys: string[]) => void;
  /** Legend click behavior: "toggle" hides/shows segment; "select" pins it. Default "toggle". */
  legendAction?: "toggle" | "select";
  /** Whether to render the synced legend. Default true. */
  legend?: boolean;
  /** Center label when total is 0. Default "Sin datos". */
  emptyLabel?: string;
  className?: string;
}

type Slice = {
  key: string;
  label: string;
  value: number;
  color?: string;
  members?: DonutChartDatum[];
};

type Arc = { start: number; end: number };
type Segment = {
  start: MotionValue<number>;
  end: MotionValue<number>;
  lift: MotionValue<number>;
  off: () => void;
};

const OTHER = "__other";
const TAU = Math.PI * 2;
const LIFT = 4;
const GROW = 2;
const MARGIN = 7;
const GAP = 3;
const CORNER = 4;

const motionTokens = {
  duration: {
    fast: 0.16,
    standard: 0.24,
    considered: 0.48,
  },
  ease: {
    enter: [0.16, 1, 0.3, 1] as const,
    standard: [0.22, 1, 0.36, 1] as const,
  },
  spring: {
    snappy: { type: "spring", visualDuration: 0.26, bounce: 0.12 } as const,
    smooth: { type: "spring", visualDuration: 0.4, bounce: 0 } as const,
  },
  stagger: {
    item: 0.035,
  },
} as const;

const physical = (
  { visualDuration, bounce }: { visualDuration: number; bounce: number },
  restDelta = 0.0005,
) => {
  const root = (2 * Math.PI) / (visualDuration * 1.2);
  return {
    type: "spring" as const,
    stiffness: root * root,
    damping: 2 * (1 - bounce) * root,
    restDelta,
    restSpeed: restDelta * 2,
  };
};

const reveal = physical({ visualDuration: 0.72, bounce: 0 });
const settle = physical({ visualDuration: 0.5, bounce: 0 });
const pop = physical(motionTokens.spring.snappy, 0.002);

const DEFAULT_SERIES = [
  "var(--color-chart-1)",
  "var(--color-chart-2)",
  "var(--color-chart-3)",
  "var(--color-chart-4)",
  "var(--color-chart-5)",
];

const OTHER_COLOR = "color-mix(in srgb, var(--foreground) 30%, transparent)";

const defaultFormatNumber = (value: number) => {
  if (Number.isInteger(value)) return String(value);
  return value.toFixed(1);
};
const shareText = (share: number) => {
  if (share <= 0) return "0%";
  if (share < 0.01) return "<1%";
  return `${Math.round(share * 100)}%`;
};

const n2 = (value: number) => (Math.round(value * 100) / 100).toString();

/**
 * Groups slices below threshold into "Other" if at least 2 qualify.
 */
function sliceData(
  data: DonutChartDatum[],
  groupBelow: number,
  maxSegments: number,
  otherLabel: string,
  hideZero: boolean,
): Slice[] {
  const parts = hideZero
    ? data.filter((item) => item.value > 0)
    : data.filter((item) => item.value >= 0);
  const total = parts.reduce((sum, item) => sum + item.value, 0);
  if (!parts.length) return [];
  if (groupBelow <= 0 || parts.length <= maxSegments) {
    return parts.map((item) => ({ ...item }));
  }

  const ranked = [...parts].sort((a, b) => b.value - a.value);
  const keep = new Set(
    ranked
      .filter(
        (item, rank) =>
          (total > 0 ? item.value / total >= groupBelow : true) && rank < maxSegments - 1,
      )
      .map((item) => item.key),
  );
  const rest = parts.filter((item) => !keep.has(item.key));
  if (rest.length < 2) return parts.map((item) => ({ ...item }));

  return [
    ...parts.filter((item) => keep.has(item.key)).map((item) => ({ ...item })),
    {
      key: OTHER,
      label: otherLabel,
      value: rest.reduce((sum, item) => sum + item.value, 0),
      members: rest,
    },
  ];
}

/** Turns of the ring for each slice in data order. */
function layout(slices: Slice[], hidden: Set<string>) {
  const total = slices.reduce((sum, item) => sum + (hidden.has(item.key) ? 0 : item.value), 0) || 1;
  let at = 0;
  return new Map(
    slices.map((item) => {
      const arc = {
        start: at,
        end: at + (hidden.has(item.key) ? 0 : item.value / total),
      };
      at = arc.end;
      return [item.key, arc];
    }),
  );
}

function breadth(R: number, t0: number, t1: number, gap: number) {
  const turns = t1 - t0;
  if (turns >= 1 - 1e-6) return Infinity;
  return (
    Math.sin(Math.min(turns * Math.PI, Math.PI / 2)) * R -
    Math.min(gap / 2, ((1 - turns) * TAU * R) / 2)
  );
}

/**
 * Generates SVG path for an annular sector with rounded corners and uniform radial gap.
 */
function sector(
  c: number,
  R: number,
  r: number,
  t0: number,
  t1: number,
  gap: number,
  corner: number,
) {
  const turns = t1 - t0;
  if (turns <= 1e-6) return "";
  const at = (radius: number, angle: number) =>
    `${n2(c + radius * Math.cos(angle))} ${n2(c + radius * Math.sin(angle))}`;

  if (turns >= 1 - 1e-6) {
    return `M${at(R, -Math.PI / 2)}A${n2(R)} ${n2(R)} 0 1 1 ${at(R, Math.PI / 2)}A${n2(R)} ${n2(R)} 0 1 1 ${at(R, -Math.PI / 2)}ZM${at(r, -Math.PI / 2)}A${n2(r)} ${n2(r)} 0 1 0 ${at(r, Math.PI / 2)}A${n2(r)} ${n2(r)} 0 1 0 ${at(r, -Math.PI / 2)}Z`;
  }

  const p = Math.min(gap / 2, ((1 - turns) * TAU * R) / 2);
  const a0 = t0 * TAU - Math.PI / 2;
  const a1 = t1 * TAU - Math.PI / 2;
  const half = (a1 - a0) / 2;
  const s = Math.sin(Math.min(half, Math.PI / 2));
  if (s * R <= p + 1e-6) return "";

  const side = (t: number, angle: number, sign: number) =>
    `${n2(c + t * Math.cos(angle) - sign * p * Math.sin(angle))} ${n2(c + t * Math.sin(angle) + sign * p * Math.cos(angle))}`;
  const band = (R - r) / 2;
  const ro = Math.max(0, Math.min(corner, band, s >= 0.9999 ? Infinity : (s * R - p) / (1 + s)));
  const dO = Math.asin(Math.min(1, (p + ro) / (R - ro)));
  const tO = Math.sqrt(Math.max(0, (R - ro) ** 2 - (p + ro) ** 2));
  const bigO = a1 - a0 - 2 * dO > Math.PI ? 1 : 0;
  let d = `M${side(tO, a0, 1)}`;
  if (ro > 0.01) d += `A${n2(ro)} ${n2(ro)} 0 0 1 ${at(R, a0 + dO)}`;
  d += `A${n2(R)} ${n2(R)} 0 ${bigO} 1 ${at(R, a1 - dO)}`;
  if (ro > 0.01) d += `A${n2(ro)} ${n2(ro)} 0 0 1 ${side(tO, a1, -1)}`;

  if (s * r > p + 1e-6 || s >= 0.9999) {
    const ri = Math.max(0, Math.min(corner, band, s >= 0.9999 ? Infinity : (s * r - p) / (1 - s)));
    const dI = Math.asin(Math.min(1, (p + ri) / (r + ri)));
    const tI = Math.sqrt(Math.max(0, (r + ri) ** 2 - (p + ri) ** 2));
    const bigI = a1 - a0 - 2 * dI > Math.PI ? 1 : 0;
    d += `L${side(tI, a1, -1)}`;
    if (ri > 0.01) d += `A${n2(ri)} ${n2(ri)} 0 0 1 ${at(r, a1 - dI)}`;
    d += `A${n2(r)} ${n2(r)} 0 ${bigI} 0 ${at(r, a0 + dI)}`;
    if (ri > 0.01) d += `A${n2(ri)} ${n2(ri)} 0 0 1 ${side(tI, a0, 1)}`;
  } else {
    d += `L${at(p / s, (a0 + a1) / 2)}`;
  }
  return `${d}Z`;
}

/**
 * Animated number counter with direct DOM writes to avoid frame re-renders.
 */
function Count({
  value,
  format,
  reduced,
}: {
  value: number;
  format: (value: number) => string;
  reduced: boolean;
}) {
  const node = React.useRef<HTMLSpanElement>(null);
  const [initial] = React.useState(() => format(value));
  const live = React.useRef<{
    mv: MotionValue<number>;
    format: (value: number) => string;
    target: number;
  } | null>(null);

  React.useLayoutEffect(() => {
    const el = node.current;
    if (!el) return;
    if (!live.current) {
      const state = { mv: motionValue(value), format, target: value };
      state.mv.on("change", (now) => {
        el.textContent = state.format(Number.isInteger(state.target) ? Math.round(now) : now);
      });
      live.current = state;
    }
    const state = live.current;
    state.format = format;
    if (state.target === value && !reduced) {
      if (!state.mv.isAnimating()) el.textContent = format(value);
      return;
    }
    state.target = value;
    if (reduced) {
      state.mv.jump(value);
      el.textContent = format(value);
      return;
    }
    animate(
      state.mv,
      value,
      physical(
        { visualDuration: 0.4, bounce: 0 },
        Math.max(Math.abs(value - state.mv.get()) * 0.001, 1e-6),
      ),
    );
  }, [value, format, reduced]);

  React.useEffect(() => {
    return () => {
      live.current?.mv.destroy();
      live.current = null;
    };
  }, []);

  return <span ref={node}>{initial}</span>;
}

const drum = (
  place: number,
  reduced: boolean,
): { animate: { opacity: number; y: string }; transition: Transition } => ({
  animate: { opacity: place === 0 ? 1 : 0, y: `${0.45 * Math.sign(place)}em` },
  transition: reduced
    ? { duration: 0 }
    : place === 0
      ? { duration: motionTokens.duration.standard, ease: [...motionTokens.ease.enter] }
      : { duration: motionTokens.duration.fast, ease: [...motionTokens.ease.standard] },
});

export function DonutChart({
  data,
  label,
  unit = "",
  formatValue = (value) => defaultFormatNumber(value),
  totalLabel = "Total",
  size = 190,
  thickness = 22,
  groupBelow = 0,
  maxSegments = 6,
  otherLabel = "Otros",
  hideZero = false,
  activeKey,
  defaultActiveKey = null,
  onActiveChange,
  hiddenKeys,
  defaultHiddenKeys,
  onHiddenKeysChange,
  legendAction = "toggle",
  legend = true,
  emptyLabel = "Sin datos",
  className,
}: DonutChartProps) {
  const [mounted, setMounted] = React.useState(false);
  React.useEffect(() => {
    setMounted(true);
  }, []);

  const reducedMotion = useReducedMotion();
  const reduced = mounted && !!reducedMotion;
  const figure = React.useRef<HTMLElement>(null);
  const inView = useInView(figure, { once: true, amount: 0.35 });
  const legendId = React.useId();
  const slices = sliceData(data, groupBelow, maxSegments, otherLabel, hideZero);

  const [ownHidden, setOwnHidden] = React.useState<string[]>(defaultHiddenKeys ?? []);
  const hiddenList = hiddenKeys ?? ownHidden;
  const hidden = React.useMemo(
    () => new Set(hiddenList.filter((key) => slices.some((item) => item.key === key))),
    [hiddenList, slices],
  );
  const visible = slices.filter((item) => !hidden.has(item.key));
  const total = visible.reduce((sum, item) => sum + item.value, 0);
  const signature = `${slices.map((item) => `${item.key}:${item.value}${hidden.has(item.key) ? "h" : ""}`).join("|")}`;
  const suffix = unit ? ` ${unit}` : "";

  // Assign stable default palette
  const [palette, setPalette] = React.useState(
    () => new Map(data.map((item, index) => [item.key, index])),
  );
  if (data.some((item) => !palette.has(item.key))) {
    const next = new Map(palette);
    for (const item of data) {
      if (!next.has(item.key)) next.set(item.key, next.size);
    }
    setPalette(next);
  }

  const colorFor = (item: Slice) => {
    if (item.color) return item.color;
    if (item.key === OTHER) return OTHER_COLOR;
    const index = palette.get(item.key) ?? 0;
    return DEFAULT_SERIES[index % DEFAULT_SERIES.length];
  };

  const [drawn, setDrawn] = React.useState<Slice[]>(slices);
  const [seenSignature, setSeenSignature] = React.useState(signature);
  if (seenSignature !== signature) {
    setSeenSignature(signature);
    const next = [...slices];
    drawn.forEach((item, index) => {
      if (next.some((slice) => slice.key === item.key)) return;
      const before = drawn
        .slice(0, index)
        .reverse()
        .find((prior) => next.some((slice) => slice.key === prior.key));
      next.splice(before ? next.findIndex((slice) => slice.key === before.key) + 1 : 0, 0, {
        ...item,
        value: 0,
      });
    });
    setDrawn(next);
  }

  const [ownActive, setOwnActive] = React.useState<string | null>(defaultActiveKey);
  const selected = activeKey !== undefined ? activeKey : ownActive;
  const [preview, setPreview] = React.useState<string | null>(null);
  const select = (key: string | null) => {
    if (activeKey === undefined) setOwnActive(key);
    onActiveChange?.(key);
  };

  const current =
    [preview, selected].find((key) => key && visible.some((item) => item.key === key)) ?? null;
  const activeSlice = visible.find((item) => item.key === current) ?? null;

  const [announcement, setAnnouncement] = React.useState("");
  const setHidden = (key: string) => {
    const isHidden = hidden.has(key);
    if (!isHidden && visible.length <= 1) return;
    const next = isHidden ? hiddenList.filter((item) => item !== key) : [...hiddenList, key];
    if (hiddenKeys === undefined) setOwnHidden(next);
    onHiddenKeysChange?.(next);
    const item = slices.find((slice) => slice.key === key);
    const nextTotal = slices.reduce(
      (sum, slice) => sum + (next.includes(slice.key) ? 0 : slice.value),
      0,
    );
    if (item) {
      setAnnouncement(
        `${item.label} ${isHidden ? "mostrado" : "oculto"}. ${totalLabel} ${formatValue(nextTotal)}${suffix}.`,
      );
    }
  };

  const c = size / 2;
  const outer = c - MARGIN;
  const inner = Math.max(8, outer - thickness);
  const corner = Math.min(CORNER, thickness / 4);

  const geometry = React.useRef({ c, outer, inner, corner });
  const segments = React.useRef(new Map<string, Segment>());
  const paths = React.useRef(new Map<string, SVGPathElement>());

  const registerPath = React.useCallback((node: SVGPathElement | null) => {
    const key = node?.dataset.key;
    if (!node || !key) return;
    paths.current.set(key, node);
    return () => {
      if (paths.current.get(key) === node) paths.current.delete(key);
    };
  }, []);

  const paint = React.useCallback(() => {
    const { c, outer, inner, corner } = geometry.current;
    for (const [key, node] of paths.current) {
      const segment = segments.current.get(key);
      if (!segment) {
        node.setAttribute("d", "");
        continue;
      }
      const start = segment.start.get();
      const end = segment.end.get();
      const lift = Math.max(0, segment.lift.get());
      const R = outer + lift * GROW;
      node.setAttribute("d", sector(c, R, inner - lift * GROW * 0.5, start, end, GAP, corner));
      node.setAttribute(
        "fill-opacity",
        n2(Math.min(1, Math.max(0, (breadth(R, start, end, GAP) - 1) / 3))),
      );
      const middle = ((start + end) / 2) * TAU - Math.PI / 2;
      const distance = lift * LIFT;
      node.setAttribute(
        "transform",
        `translate(${n2(Math.cos(middle) * distance)} ${n2(Math.sin(middle) * distance)})`,
      );
    }
  }, []);

  const schedule = React.useCallback(() => {
    frame.render(paint);
  }, [paint]);

  React.useLayoutEffect(() => {
    geometry.current = { c, outer, inner, corner };
    paint();
  });

  React.useEffect(() => {
    const segs = segments.current;
    return () => {
      cancelFrame(paint);
      for (const segment of segs.values()) segment.off();
      segs.clear();
    };
  }, [paint]);

  const targets = React.useRef(new Map<string, Arc>());
  const latest = React.useRef({ drawn, slices });
  React.useLayoutEffect(() => {
    latest.current = { drawn, slices };
  });

  const shown = mounted && (inView || reduced);
  React.useEffect(() => {
    if (!shown) return;
    const { drawn: order, slices: now } = latest.current;
    const goal = layout(now, hidden);
    targets.current = goal;
    const first = segments.current.size === 0;
    const place = (index: number) => {
      const before = order
        .slice(0, index)
        .reverse()
        .find((item) => goal.has(item.key));
      return before ? goal.get(before.key)!.end : 0;
    };
    const drop = (key: string) => {
      if (latest.current.slices.some((item) => item.key === key)) return;
      segments.current.get(key)?.off();
      segments.current.delete(key);
      setDrawn((list) => list.filter((item) => item.key !== key));
    };

    order.forEach((item, index) => {
      const leaving = !goal.has(item.key);
      const to = goal.get(item.key) ?? { start: place(index), end: place(index) };
      let segment = segments.current.get(item.key);
      if (!segment) {
        const prior = order
          .slice(0, index)
          .reverse()
          .map((entry) => segments.current.get(entry.key))
          .find(Boolean);
        const from = first ? 0 : prior ? prior.end.get() : 0;
        const start = motionValue(from);
        const end = motionValue(from);
        const lift = motionValue(0);
        const offs = [
          start.on("change", schedule),
          end.on("change", schedule),
          lift.on("change", schedule),
        ];
        segment = {
          start,
          end,
          lift,
          off: () => {
            offs.forEach((off) => off());
            start.destroy();
            end.destroy();
            lift.destroy();
          },
        };
        segments.current.set(item.key, segment);
      }
      if (reduced) {
        segment.start.jump(to.start);
        segment.end.jump(to.end);
        if (leaving) drop(item.key);
        return;
      }
      if (first) {
        animate(segment.start, to.start, reveal);
        animate(segment.end, to.end, {
          ...reveal,
          delay: 0.04 + index * motionTokens.stagger.item,
        });
        return;
      }
      animate(segment.start, to.start, settle);
      animate(segment.end, to.end, {
        ...settle,
        onComplete: leaving ? () => drop(item.key) : undefined,
      });
    });
    schedule();
  }, [shown, signature, reduced, schedule, hidden]);

  React.useEffect(() => {
    for (const [key, segment] of segments.current) {
      const to = key === current ? 1 : 0;
      if (reduced) segment.lift.jump(to);
      else if (segment.lift.get() !== to || segment.lift.isAnimating()) {
        animate(segment.lift, to, pop);
      }
    }
  }, [current, reduced, drawn, shown]);

  const svg = React.useRef<SVGSVGElement>(null);
  const hit = (event: { clientX: number; clientY: number }) => {
    const box = svg.current?.getBoundingClientRect();
    if (!box || !box.width) return undefined;
    const scale = size / box.width;
    const x = (event.clientX - box.left) * scale - c;
    const y = (event.clientY - box.top) * scale - c;
    const radius = Math.hypot(x, y);
    if (radius < inner - 6 || radius > c) return null;
    let turn = (Math.atan2(y, x) + Math.PI / 2) / TAU;
    if (turn < 0) turn += 1;
    for (const [key, arc] of targets.current) {
      if (
        arc.end > arc.start &&
        turn >= arc.start &&
        turn < arc.end &&
        visible.some((item) => item.key === key)
      ) {
        return key;
      }
    }
    return undefined;
  };

  const onRingMove = (event: React.PointerEvent<SVGSVGElement>) => {
    if (event.pointerType !== "mouse") return;
    const key = hit(event);
    if (key !== undefined && key !== preview) setPreview(key);
  };

  const onRingClick = (event: React.MouseEvent<SVGSVGElement>) => {
    const key = hit(event);
    if (key) select(selected === key ? null : key);
  };

  const format = (value: number) => `${formatValue(value)}${suffix}`;
  const describe = (item: Slice) =>
    `${item.label}, ${format(item.value)}, ${shareText(item.value / (total || 1))}${
      item.members ? `. Incluye ${item.members.map((member) => member.label).join(", ")}` : ""
    }`;

  const rows = React.useRef<(HTMLButtonElement | null)[]>([]);
  const step = (key: string, index: number, count: number) =>
    ({
      ArrowDown: index + 1,
      ArrowRight: index + 1,
      ArrowUp: index - 1,
      ArrowLeft: index - 1,
      Home: 0,
      End: count - 1,
    })[key];

  const onLegendKey = (event: React.KeyboardEvent<HTMLButtonElement>, index: number) => {
    if (event.key === "Escape" && selected) {
      event.preventDefault();
      select(null);
      return;
    }
    const next = step(event.key, index, slices.length);
    if (next === undefined) return;
    event.preventDefault();
    rows.current[(next + slices.length) % slices.length]?.focus();
  };

  const onLegendBlur = (event: React.FocusEvent<HTMLButtonElement>) => {
    if (
      !(
        event.relatedTarget instanceof Node &&
        event.currentTarget.closest("ul")?.contains(event.relatedTarget)
      )
    ) {
      setPreview(null);
    }
  };

  const identity = activeSlice ? activeSlice.key : total ? "__total" : "__empty";
  const readouts = [
    {
      key: "__total",
      label: total ? totalLabel : emptyLabel,
      value: total,
      meta: null as Slice | null,
    },
    ...slices.map((item) => ({
      key: item.key,
      label: item.label,
      value: item.value,
      meta: item as Slice | null,
    })),
  ];
  const activeIndex = Math.max(
    0,
    readouts.findIndex((item) => item.key === (identity === "__empty" ? "__total" : identity)),
  );

  const summary = total
    ? `${label}. ${totalLabel} ${format(total)}. ${visible.map(describe).join(". ")}.`
    : `${label}. ${emptyLabel}.`;
  const members = (item: Slice) =>
    item.members
      ? item.members.length > 2
        ? `${item.members
            .slice(0, 2)
            .map((member) => member.label)
            .join(", ")} y ${item.members.length - 2} más`
        : item.members.map((member) => member.label).join(" y ")
      : null;

  const innerDiameterPercent = ((inner * 2) / size) * 100;

  return (
    <figure
      ref={figure}
      className={cn(
        "text-foreground m-0 grid min-w-0",
        legend &&
          "grid-cols-1 justify-items-center gap-5 sm:grid-cols-[auto_minmax(0,1fr)] sm:items-center sm:gap-6",
        className,
      )}
      aria-label={label}
    >
      {/* Donut Ring */}
      <div
        className="relative aspect-square max-w-full shrink-0 justify-self-center select-none"
        style={{ width: size }}
      >
        <svg
          ref={svg}
          className={cn(
            "block size-full overflow-visible",
            current !== null ? "cursor-pointer" : "cursor-default",
          )}
          viewBox={`0 0 ${size} ${size}`}
          aria-hidden="true"
          focusable="false"
          onPointerMove={onRingMove}
          onPointerLeave={() => setPreview(null)}
          onClick={onRingClick}
        >
          {/* Subtle background track */}
          <circle
            cx={c}
            cy={c}
            r={(outer + inner) / 2}
            strokeWidth={outer - inner}
            className={cn(
              "stroke-muted/40 fill-none transition-opacity duration-300",
              !mounted || !shown || !total ? "opacity-100" : "opacity-0",
            )}
          />

          {/* Arcs */}
          {drawn.map((item) => {
            const isDimmed = current !== null && item.key !== current;
            return (
              <path
                key={item.key}
                ref={registerPath}
                data-key={item.key}
                style={{ fill: colorFor(item) }}
                className={cn(
                  "shape-geometric-precision transition-opacity duration-200",
                  isDimmed && "opacity-40",
                )}
              />
            );
          })}
        </svg>

        {/* Center Readout with Drum Roll */}
        <div
          className="pointer-events-none absolute top-1/2 left-1/2 grid -translate-x-1/2 -translate-y-1/2 text-center"
          style={{ width: `calc(${innerDiameterPercent}% - 14px)` }}
          aria-hidden="true"
        >
          {readouts.map((item, index) => (
            <motion.span
              key={item.key}
              className="grid min-w-0 justify-items-center gap-0.5 text-center [grid-area:1/1]"
              initial={false}
              {...drum(index - activeIndex, reduced)}
            >
              <span className="text-muted-foreground block w-full truncate text-xs font-medium">
                {item.label}
              </span>
              <span className="block max-w-full truncate font-sans text-2xl font-bold tracking-tight tabular-nums">
                {item.value || item.meta ? (
                  <Count value={item.value} format={formatValue} reduced={reduced} />
                ) : (
                  "0"
                )}
              </span>
              <span className="text-muted-foreground block w-full truncate text-[11px] font-normal tabular-nums">
                {item.meta ? (
                  <>
                    <Count
                      value={total && !hidden.has(item.key) ? item.value / total : 0}
                      format={shareText}
                      reduced={reduced}
                    />{" "}
                    de {totalLabel.toLowerCase()}
                  </>
                ) : (
                  unit || " "
                )}
              </span>
            </motion.span>
          ))}
        </div>
      </div>

      {/* Synced Interactive Legend */}
      {legend && slices.length > 0 && (
        <ul
          className="m-0 grid w-full list-none gap-1 p-0"
          aria-label={`${label}, segmentos${
            legendAction === "toggle" ? ". Haz clic en un segmento para mostrar u ocultar" : ""
          }`}
          id={legendId}
          onPointerLeave={() => setPreview(null)}
        >
          <AnimatePresence initial={false}>
            {slices.map((item, index) => {
              const off = hidden.has(item.key);
              const isActive = item.key === current;
              const isPinned = selected === item.key;
              const sliceColor = colorFor(item);

              return (
                <motion.li
                  key={item.key}
                  className="overflow-hidden"
                  initial={{ height: 0, opacity: 0 }}
                  animate={{ height: "auto", opacity: 1 }}
                  exit={{ height: 0, opacity: 0 }}
                  transition={reduced ? { duration: 0 } : motionTokens.spring.smooth}
                >
                  <button
                    ref={(node) => {
                      if (node) rows.current[index] = node;
                    }}
                    type="button"
                    className={cn(
                      "grid min-h-8.5 w-full grid-cols-[10px_minmax(0,1fr)_auto_3.25em] items-center gap-2 rounded-lg px-2 py-1 text-left text-sm transition-colors duration-150 select-none",
                      "hover:bg-muted/60 active:scale-[0.985]",
                      (isActive || isPinned) && "bg-muted/80 font-medium",
                      off && "text-muted-foreground/60 opacity-60",
                    )}
                    aria-pressed={legendAction === "toggle" ? !off : selected === item.key}
                    aria-label={off ? `${item.label}, oculto` : describe(item)}
                    onClick={() =>
                      legendAction === "toggle"
                        ? setHidden(item.key)
                        : select(selected === item.key ? null : item.key)
                    }
                    onPointerEnter={(event) => {
                      if (event.pointerType === "mouse") setPreview(off ? null : item.key);
                    }}
                    onFocus={(event) => {
                      if (event.currentTarget.matches(":focus-visible"))
                        setPreview(off ? null : item.key);
                    }}
                    onBlur={onLegendBlur}
                    onKeyDown={(event) => onLegendKey(event, index)}
                  >
                    {/* Color dot indicator */}
                    <span
                      className="size-2.5 rounded-full transition-all duration-200"
                      style={{
                        backgroundColor: off ? "transparent" : sliceColor,
                        boxShadow: `inset 0 0 0 1.5px ${sliceColor}`,
                      }}
                      aria-hidden="true"
                    />

                    {/* Label and members */}
                    <span className="grid min-w-0">
                      <span
                        className={cn(
                          "truncate text-sm",
                          off ? "text-muted-foreground" : "text-foreground",
                        )}
                      >
                        {item.label}
                      </span>
                      {item.members && (
                        <span className="text-muted-foreground truncate text-xs">
                          {members(item)}
                        </span>
                      )}
                    </span>

                    {/* Absolute count */}
                    <span
                      className={cn(
                        "justify-self-end text-sm font-medium tabular-nums",
                        off ? "text-muted-foreground/50" : "text-muted-foreground",
                      )}
                      aria-hidden="true"
                    >
                      <Count value={item.value} format={formatValue} reduced={reduced} />
                    </span>

                    {/* Percentage share */}
                    <span
                      className={cn(
                        "justify-self-end text-sm font-semibold tabular-nums",
                        off ? "text-muted-foreground/40" : "text-foreground",
                      )}
                      aria-hidden="true"
                    >
                      <Count
                        value={off || !total ? 0 : item.value / total}
                        format={shareText}
                        reduced={reduced}
                      />
                    </span>
                  </button>
                </motion.li>
              );
            })}
          </AnimatePresence>
        </ul>
      )}

      {/* Screen Reader Announcements & Summary */}
      <p className="sr-only">{summary}</p>
      <p className="sr-only" aria-live="polite">
        {announcement}
      </p>
      {total > 0 && (
        <div className="sr-only">
          <table>
            <caption>{label}</caption>
            <thead>
              <tr>
                <th scope="col">Segmento</th>
                <th scope="col">Cantidad</th>
                <th scope="col">Porcentaje</th>
              </tr>
            </thead>
            <tbody>
              {visible
                .flatMap((item) =>
                  item.members
                    ? item.members.map((member) => ({
                        key: member.key,
                        label: `${member.label} (${otherLabel})`,
                        value: member.value,
                      }))
                    : [item],
                )
                .map((item) => (
                  <tr key={item.key}>
                    <th scope="row">{item.label}</th>
                    <td>{format(item.value)}</td>
                    <td>{shareText(item.value / total)}</td>
                  </tr>
                ))}
            </tbody>
          </table>
        </div>
      )}
    </figure>
  );
}

export default DonutChart;
