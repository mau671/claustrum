interface ColorClasses {
  bg: string;
  hover: string;
  border: string;
  text: string;
}

export interface EventColorStyle {
  "--schedule-event-bg": string;
  "--schedule-event-hover": string;
  "--schedule-event-border": string;
  "--schedule-event-text": string;
  backgroundColor: string;
  borderColor: string;
  color: string;
}

const EVENT_COLOR_VALUES = {
  light: {
    blue: ["rgb(219 234 254)", "rgb(191 219 254)", "rgb(147 197 253)", "rgb(30 58 138)"],
    emerald: ["rgb(209 250 229)", "rgb(167 243 208)", "rgb(110 231 183)", "rgb(6 95 70)"],
    yellow: ["rgb(254 249 195)", "rgb(254 240 138)", "rgb(253 224 71)", "rgb(113 63 18)"],
    red: ["rgb(254 226 226)", "rgb(254 202 202)", "rgb(252 165 165)", "rgb(127 29 29)"],
    orange: ["rgb(255 237 213)", "rgb(254 215 170)", "rgb(253 186 116)", "rgb(124 45 18)"],
    fuchsia: ["rgb(250 232 255)", "rgb(245 208 254)", "rgb(240 171 252)", "rgb(112 26 117)"],
    violet: ["rgb(237 233 254)", "rgb(221 214 254)", "rgb(196 181 253)", "rgb(76 29 149)"],
    slate: ["rgb(241 245 249)", "rgb(226 232 240)", "rgb(203 213 225)", "rgb(15 23 42)"],
  },
  dark: {
    blue: ["rgb(23 37 84)", "rgb(30 58 138)", "rgb(29 78 216)", "rgb(219 234 254)"],
    emerald: ["rgb(2 44 34)", "rgb(6 78 59)", "rgb(4 120 87)", "rgb(209 250 229)"],
    yellow: ["rgb(66 32 6)", "rgb(113 63 18)", "rgb(161 98 7)", "rgb(254 249 195)"],
    red: ["rgb(69 10 10)", "rgb(127 29 29)", "rgb(185 28 28)", "rgb(254 226 226)"],
    orange: ["rgb(67 20 7)", "rgb(124 45 18)", "rgb(194 65 12)", "rgb(255 237 213)"],
    fuchsia: ["rgb(74 4 78)", "rgb(112 26 117)", "rgb(162 28 175)", "rgb(250 232 255)"],
    violet: ["rgb(46 16 101)", "rgb(76 29 149)", "rgb(109 40 217)", "rgb(237 233 254)"],
    slate: ["rgb(15 23 42)", "rgb(30 41 59)", "rgb(51 65 85)", "rgb(241 245 249)"],
  },
} as const;

export function getColorClasses(_color: string): ColorClasses {
  return {
    bg: "bg-[var(--schedule-event-bg)]",
    hover: "hover:bg-[var(--schedule-event-hover)]",
    border: "border-[var(--schedule-event-border)]",
    text: "text-[var(--schedule-event-text)]",
  };
}

export function getEventColorStyle(color: string, theme: "light" | "dark"): EventColorStyle {
  const values =
    EVENT_COLOR_VALUES[theme][color as keyof typeof EVENT_COLOR_VALUES.light] ??
    EVENT_COLOR_VALUES[theme].blue;
  const [bg, hover, border, text] = values;

  return {
    "--schedule-event-bg": bg,
    "--schedule-event-hover": hover,
    "--schedule-event-border": border,
    "--schedule-event-text": text,
    backgroundColor: bg,
    borderColor: border,
    color: text,
  };
}
