"use client";

import { AnimatedCounter } from "@/components/ui/animated-counter";
import { Card, CardContent } from "@/components/ui/card";
import { cn } from "@/lib/utils";

export interface MetricCardProps {
  label: string;
  value: number;
  suffix?: string;
  decimals?: number;
  context: string;
  change?: string;
  className?: string;
}

export function MetricCard({
  label,
  value,
  suffix,
  decimals = 0,
  context,
  change,
  className,
}: MetricCardProps) {
  const trend = change
    ? /^[+]/.test(change)
      ? "up"
      : /^[-−]/.test(change)
        ? "down"
        : undefined
    : undefined;

  return (
    <Card className={className}>
      <CardContent className="flex flex-col gap-1 p-4">
        <div className="flex items-center justify-between gap-2">
          <span className="text-muted-foreground truncate text-sm font-medium">{label}</span>
          {change ? (
            <span
              className={cn(
                "shrink-0 rounded-full border px-2 py-0.5 text-xs tabular-nums",
                trend === "up" &&
                  "border-transparent bg-emerald-500/10 text-emerald-600 dark:text-emerald-400",
                trend === "down" &&
                  "border-transparent bg-red-500/10 text-red-600 dark:text-red-400",
                !trend && "text-muted-foreground",
              )}
            >
              {change}
            </span>
          ) : null}
        </div>
        <div className="text-2xl font-bold tracking-tight">
          <AnimatedCounter value={value} suffix={suffix} decimals={decimals} animateOnView />
        </div>
        <span className="text-muted-foreground text-xs">{context}</span>
      </CardContent>
    </Card>
  );
}

export default MetricCard;
