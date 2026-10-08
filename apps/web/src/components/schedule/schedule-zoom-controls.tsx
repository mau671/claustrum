import { ZoomIn, ZoomOut, RotateCcw, ChevronDown, ChevronUp } from "lucide-react";
import React from "react";

import {
  DEFAULT_HOUR_HEIGHT,
  MIN_HOUR_HEIGHT,
  MAX_HOUR_HEIGHT,
} from "@/components/calendar/calendar-types";
import { cn } from "@/lib/utils";

interface ScheduleZoomControlsProps {
  hourHeight: number;
  setHourHeight: (height: number) => void;
  className?: string;
  isFloating?: boolean;
}

const ZOOM_STEP = 16;
const ZOOM_STORAGE_KEY = "schedule-hour-height";
const DEFAULT_ZOOM_RATIO = 0.5;
export const SCHEDULE_DEFAULT_HOUR_HEIGHT = Math.round(DEFAULT_HOUR_HEIGHT * DEFAULT_ZOOM_RATIO);

export function ScheduleZoomControls({
  hourHeight,
  setHourHeight,
  className,
  isFloating = true,
}: ScheduleZoomControlsProps) {
  const [isPanelOpen, setIsPanelOpen] = React.useState(false);

  const handleZoomIn = () => {
    const newHeight = Math.min(hourHeight + ZOOM_STEP, MAX_HOUR_HEIGHT);
    setHourHeight(newHeight);
    localStorage.setItem(ZOOM_STORAGE_KEY, newHeight.toString());
  };

  const handleZoomOut = () => {
    const newHeight = Math.max(hourHeight - ZOOM_STEP, MIN_HOUR_HEIGHT);
    setHourHeight(newHeight);
    localStorage.setItem(ZOOM_STORAGE_KEY, newHeight.toString());
  };

  const handleReset = () => {
    setHourHeight(SCHEDULE_DEFAULT_HOUR_HEIGHT);
    localStorage.setItem(ZOOM_STORAGE_KEY, SCHEDULE_DEFAULT_HOUR_HEIGHT.toString());
  };

  const canZoomIn = hourHeight >= MAX_HOUR_HEIGHT;
  const canZoomOut = hourHeight <= MIN_HOUR_HEIGHT;
  const zoomPercentage = Math.round((hourHeight / DEFAULT_HOUR_HEIGHT) * 100);

  return (
    <div className={cn(isFloating ? "absolute top-4 right-4 z-50" : "relative", className)}>
      <button
        onClick={() => setIsPanelOpen(!isPanelOpen)}
        className="bg-background/95 supports-[backdrop-filter]:bg-background/60 hover:bg-muted flex items-center gap-2 rounded-lg border p-1.5 shadow-sm backdrop-blur transition-colors"
        title={isPanelOpen ? "Ocultar controles" : "Mostrar controles"}
      >
        <span className="text-sm font-medium">{zoomPercentage}%</span>
        {isPanelOpen ? <ChevronUp className="size-4" /> : <ChevronDown className="size-4" />}
      </button>

      {isPanelOpen && (
        <div className="bg-background/95 supports-[backdrop-filter]:bg-background/60 absolute top-full right-0 z-50 mt-2 min-w-[220px] rounded-lg border p-3 shadow-lg backdrop-blur">
          <div className="mb-3 flex items-center gap-1">
            <button
              onClick={handleZoomOut}
              disabled={canZoomOut}
              className="hover:bg-muted rounded-md p-2 transition-colors disabled:cursor-not-allowed disabled:opacity-40"
              title="Alejar"
            >
              <ZoomOut className="size-4" />
            </button>
            <button
              onClick={handleZoomIn}
              disabled={canZoomIn}
              className="hover:bg-muted rounded-md p-2 transition-colors disabled:cursor-not-allowed disabled:opacity-40"
              title="Acercar"
            >
              <ZoomIn className="size-4" />
            </button>
            <div className="bg-border mx-1 h-5 w-px" />
            <button
              onClick={handleReset}
              className="hover:bg-muted rounded-md p-2 transition-colors"
              title="Restablecer tamaño"
            >
              <RotateCcw className="size-4" />
            </button>
          </div>

          <div className="border-border mt-2 space-y-2 border-t pt-2">
            <div className="text-muted-foreground flex items-center justify-between text-sm">
              <span>Altura de hora:</span>
              <span className="text-foreground font-medium">{hourHeight}px</span>
            </div>
            <div className="text-muted-foreground flex items-center justify-between text-sm">
              <span>Zoom:</span>
              <span className="text-foreground font-medium">{zoomPercentage}%</span>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
