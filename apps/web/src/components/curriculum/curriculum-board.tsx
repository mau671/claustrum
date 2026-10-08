import { ZoomIn, ZoomOut, RotateCcw } from "lucide-react";
import React, { useState, useEffect, useMemo, useRef } from "react";

import type { StudyPlanDetail } from "@/lib/types";
import type { CourseEffectiveStatus } from "@/lib/types";

import { MemoizedCurriculumGrid } from "@/components/curriculum-grid";
import { useAppAuth } from "@/lib/auth/app-auth-context";

interface CurriculumBoardProps {
  planDetail: StudyPlanDetail;
  userId?: string;
  studyPlanId?: number;
  readOnly?: boolean;
  zoom?: number;
  mockStatusMap?: Map<number, CourseEffectiveStatus>;
}

const ZOOM_MIN = 0.7;
const ZOOM_MAX = 1.0;
const ZOOM_STEP = 0.05;
const CURRICULUM_ZOOM_STORAGE_KEY = "curriculum-board-zoom";
const ZOOM_DEFAULT = 0.75;

function getInitialZoom(): number {
  if (typeof window === "undefined") return ZOOM_DEFAULT;
  const stored = localStorage.getItem(CURRICULUM_ZOOM_STORAGE_KEY);
  if (stored) {
    const zoom = parseFloat(stored);
    if (!isNaN(zoom) && zoom >= ZOOM_MIN && zoom <= ZOOM_MAX) {
      return zoom;
    }
  }
  return ZOOM_DEFAULT;
}

function CurriculumBoard({
  planDetail,
  userId: propUserId,
  studyPlanId: propStudyPlanId,
  readOnly,
  zoom: propZoom,
  mockStatusMap,
}: CurriculumBoardProps) {
  const { authUser } = useAppAuth();
  const userId = useMemo(() => propUserId ?? authUser?.id ?? undefined, [propUserId, authUser?.id]);
  const studyPlanId = useMemo(
    () => propStudyPlanId ?? planDetail.plan?.id ?? undefined,
    [propStudyPlanId, planDetail.plan?.id],
  );

  const [zoom, setZoom] = useState<number>(() => propZoom ?? getInitialZoom());
  const zoomRef = useRef(zoom);
  useEffect(() => {
    zoomRef.current = zoom;
  }, [zoom]);

  const boardRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const el = boardRef.current;
    if (!el) return;

    const handleWheel = (e: WheelEvent) => {
      if (e.ctrlKey) {
        e.preventDefault();
        setZoom((prev) => {
          const zoomChange = e.deltaY * -0.002;
          const newZoom = Math.min(Math.max(prev + zoomChange, ZOOM_MIN), ZOOM_MAX);
          localStorage.setItem(CURRICULUM_ZOOM_STORAGE_KEY, newZoom.toString());
          return newZoom;
        });
      }
    };

    let initialPinchDistance: number | null = null;
    let initialZoomForPinch = ZOOM_DEFAULT;

    const getDistance = (touches: TouchList) => {
      if (touches.length < 2) return 0;
      const dx = touches[0].clientX - touches[1].clientX;
      const dy = touches[0].clientY - touches[1].clientY;
      return Math.sqrt(dx * dx + dy * dy);
    };

    const handleTouchStart = (e: TouchEvent) => {
      if (e.touches.length === 2) {
        initialPinchDistance = getDistance(e.touches);
        initialZoomForPinch = zoomRef.current;
      }
    };

    const handleTouchMove = (e: TouchEvent) => {
      if (e.touches.length === 2 && initialPinchDistance !== null && initialPinchDistance > 0) {
        if (e.cancelable) e.preventDefault();

        const currentDistance = getDistance(e.touches);
        const scale = currentDistance / initialPinchDistance;

        const newZoom = Math.min(Math.max(initialZoomForPinch * scale, ZOOM_MIN), ZOOM_MAX);
        setZoom(newZoom);
        localStorage.setItem(CURRICULUM_ZOOM_STORAGE_KEY, newZoom.toString());
      }
    };

    const handleTouchEnd = (e: TouchEvent) => {
      if (e.touches.length < 2) {
        initialPinchDistance = null;
      }
    };

    el.addEventListener("wheel", handleWheel, { passive: false });
    el.addEventListener("touchstart", handleTouchStart, { passive: false });
    el.addEventListener("touchmove", handleTouchMove, { passive: false });
    el.addEventListener("touchend", handleTouchEnd);
    el.addEventListener("touchcancel", handleTouchEnd);

    return () => {
      el.removeEventListener("wheel", handleWheel);
      el.removeEventListener("touchstart", handleTouchStart);
      el.removeEventListener("touchmove", handleTouchMove);
      el.removeEventListener("touchend", handleTouchEnd);
      el.removeEventListener("touchcancel", handleTouchEnd);
    };
  }, []);

  const handleZoomIn = () => {
    setZoom((prev) => {
      const newZoom = Math.min(prev + ZOOM_STEP, ZOOM_MAX);
      localStorage.setItem(CURRICULUM_ZOOM_STORAGE_KEY, newZoom.toString());
      return newZoom;
    });
  };

  const handleZoomOut = () => {
    setZoom((prev) => {
      const newZoom = Math.max(prev - ZOOM_STEP, ZOOM_MIN);
      localStorage.setItem(CURRICULUM_ZOOM_STORAGE_KEY, newZoom.toString());
      return newZoom;
    });
  };

  const handleReset = () => {
    setZoom(ZOOM_DEFAULT);
    localStorage.setItem(CURRICULUM_ZOOM_STORAGE_KEY, ZOOM_DEFAULT.toString());
  };

  const canZoomIn = zoom >= ZOOM_MAX;
  const canZoomOut = zoom <= ZOOM_MIN;

  return (
    <div ref={boardRef} className="relative flex h-full flex-col">
      {!readOnly && (
        <div className="absolute top-4 right-4 z-10">
          <div className="bg-background/95 supports-[backdrop-filter]:bg-background/60 flex items-center gap-1 rounded-full border px-2 py-1.5 shadow-sm backdrop-blur">
            <button
              onClick={handleZoomOut}
              disabled={canZoomOut}
              className="hover:bg-muted rounded-full p-1.5 transition-colors disabled:cursor-not-allowed disabled:opacity-40"
              title="Alejar"
            >
              <ZoomOut className="size-4" />
            </button>

            <span className="min-w-[3.5rem] cursor-default px-2 py-1 text-center text-xs font-medium">
              {Math.round(zoom * 100)}%
            </span>

            <button
              onClick={handleZoomIn}
              disabled={canZoomIn}
              className="hover:bg-muted rounded-full p-1.5 transition-colors disabled:cursor-not-allowed disabled:opacity-40"
              title="Acercar"
            >
              <ZoomIn className="size-4" />
            </button>

            <div className="bg-border mx-0.5 h-4 w-px" />

            <button
              onClick={handleReset}
              disabled={zoom === ZOOM_DEFAULT}
              className="hover:bg-muted rounded-full p-1.5 transition-colors disabled:cursor-not-allowed disabled:opacity-40"
              title="Restablecer tamaño"
            >
              <RotateCcw className="size-4" />
            </button>
          </div>
        </div>
      )}
      <div className="min-h-0 flex-1">
        <MemoizedCurriculumGrid
          planDetail={planDetail}
          userId={userId}
          studyPlanId={studyPlanId}
          zoom={zoom}
          readOnly={readOnly}
          mockStatusMap={mockStatusMap}
        />
      </div>
    </div>
  );
}

export const MemoizedCurriculumBoard = React.memo(CurriculumBoard);
