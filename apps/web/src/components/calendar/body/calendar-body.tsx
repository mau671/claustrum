import { useCallback, useRef, useEffect } from "react";

import { useCalendarContext } from "../calendar-context";
import { MIN_HOUR_HEIGHT, MAX_HOUR_HEIGHT, MIN_DAY_WIDTH, MAX_DAY_WIDTH } from "../calendar-types";
import CalendarBodyDay from "./day/calendar-body-day";
import CalendarBodyMonth from "./month/calendar-body-month";
import CalendarBodyWeek from "./week/calendar-body-week";

const ZOOM_STEP = 16;

export default function CalendarBody() {
  const { mode, hourHeight, setHourHeight, dayWidth, setDayWidth } = useCalendarContext();
  const containerRef = useRef<HTMLDivElement>(null);
  const pinchStartDistanceRef = useRef<number | null>(null);
  const pinchStartHeightRef = useRef<number | null>(null);
  const pinchStartWidthRef = useRef<number | null>(null);

  const handleWheel = useCallback(
    (e: WheelEvent) => {
      if (!e.ctrlKey || mode === "month") return;

      e.preventDefault();

      const delta = e.deltaY > 0 ? -ZOOM_STEP : ZOOM_STEP;
      const newHeight = Math.max(MIN_HOUR_HEIGHT, Math.min(MAX_HOUR_HEIGHT, hourHeight + delta));
      setHourHeight(newHeight);
    },
    [hourHeight, setHourHeight, mode],
  );

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;

    container.addEventListener("wheel", handleWheel, { passive: false });
    return () => container.removeEventListener("wheel", handleWheel);
  }, [handleWheel]);

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;

    const getDistance = (touches: TouchList) => {
      const [first, second] = [touches[0], touches[1]];
      if (!first || !second) return null;
      const dx = second.clientX - first.clientX;
      const dy = second.clientY - first.clientY;
      return Math.hypot(dx, dy);
    };

    const handleTouchStart = (event: TouchEvent) => {
      if (mode === "month") return;
      if (event.touches.length !== 2) return;
      pinchStartDistanceRef.current = getDistance(event.touches);
      pinchStartHeightRef.current = hourHeight;
      pinchStartWidthRef.current = dayWidth;
    };

    const handleTouchMove = (event: TouchEvent) => {
      if (mode === "month") return;
      if (event.touches.length !== 2) return;
      const startDistance = pinchStartDistanceRef.current;
      const startHeight = pinchStartHeightRef.current;
      const startWidth = pinchStartWidthRef.current;
      const currentDistance = getDistance(event.touches);
      if (!startDistance || !startHeight || !startWidth || !currentDistance) return;

      event.preventDefault();

      const scale = currentDistance / startDistance;
      const nextHeight = Math.max(MIN_HOUR_HEIGHT, Math.min(MAX_HOUR_HEIGHT, startHeight * scale));
      const nextWidth = Math.max(MIN_DAY_WIDTH, Math.min(MAX_DAY_WIDTH, startWidth * scale));
      setHourHeight(nextHeight);
      setDayWidth(nextWidth);
    };

    const handleTouchEnd = () => {
      pinchStartDistanceRef.current = null;
      pinchStartHeightRef.current = null;
      pinchStartWidthRef.current = null;
    };

    container.addEventListener("touchstart", handleTouchStart, { passive: true });
    container.addEventListener("touchmove", handleTouchMove, { passive: false });
    container.addEventListener("touchend", handleTouchEnd, { passive: true });
    container.addEventListener("touchcancel", handleTouchEnd, { passive: true });

    return () => {
      container.removeEventListener("touchstart", handleTouchStart);
      container.removeEventListener("touchmove", handleTouchMove);
      container.removeEventListener("touchend", handleTouchEnd);
      container.removeEventListener("touchcancel", handleTouchEnd);
    };
  }, [dayWidth, hourHeight, mode, setDayWidth, setHourHeight]);

  return (
    <div ref={containerRef} className="flex flex-1 touch-pan-x touch-pan-y flex-col">
      {mode === "day" && <CalendarBodyDay />}
      {mode === "week" && <CalendarBodyWeek />}
      {mode === "month" && <CalendarBodyMonth />}
    </div>
  );
}
