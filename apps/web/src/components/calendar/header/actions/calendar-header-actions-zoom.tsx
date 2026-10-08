import { ZoomIn, ZoomOut } from "lucide-react";

import { Button } from "@/components/ui/button";

import { useCalendarContext } from "../../calendar-context";
import { MIN_HOUR_HEIGHT, MAX_HOUR_HEIGHT } from "../../calendar-types";

const ZOOM_STEP = 24;

export default function CalendarHeaderActionsZoom() {
  const { hourHeight, setHourHeight, mode } = useCalendarContext();

  // Solo mostrar controles de zoom en vista de día o semana
  if (mode === "month") return null;

  function handleZoomIn() {
    setHourHeight(Math.min(hourHeight + ZOOM_STEP, MAX_HOUR_HEIGHT));
  }

  function handleZoomOut() {
    setHourHeight(Math.max(hourHeight - ZOOM_STEP, MIN_HOUR_HEIGHT));
  }

  const canZoomIn = hourHeight < MAX_HOUR_HEIGHT;
  const canZoomOut = hourHeight > MIN_HOUR_HEIGHT;

  return (
    <div className="flex items-center gap-1">
      <Button
        variant="outline"
        size="icon"
        className="size-8"
        onClick={handleZoomOut}
        disabled={!canZoomOut}
        title="Reducir zoom (Ctrl + rueda del ratón)"
      >
        <ZoomOut className="size-4" />
      </Button>
      <Button
        variant="outline"
        size="icon"
        className="size-8"
        onClick={handleZoomIn}
        disabled={!canZoomIn}
        title="Aumentar zoom (Ctrl + rueda del ratón)"
      >
        <ZoomIn className="size-4" />
      </Button>
    </div>
  );
}
