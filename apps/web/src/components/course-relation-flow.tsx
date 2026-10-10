"use client";

import { Link01Icon, LockIcon, LockOpenIcon } from "@hugeicons/core-free-icons";
import {
  BaseEdge,
  ReactFlow,
  Background,
  Handle,
  Position,
  MarkerType,
  getSmoothStepPath,
  type Node,
  type Edge,
  type EdgeProps,
  type ReactFlowInstance,
} from "@xyflow/react";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import "@xyflow/react/dist/style.css";

import type { Course } from "@/lib/types";

import { CourseCard } from "@/components/course-card";
import { Icon } from "@/components/ui/icon";
import { cn } from "@/lib/utils";

/* ------------------------------------------------------------------ */
/*  Node types                                                          */
/* ------------------------------------------------------------------ */

type CourseNodeData = {
  course: Course;
  isCentral?: boolean;
  showLeftHandle?: boolean;
  showLeftSourceHandle?: boolean;
  showRightHandle?: boolean;
  showTopHandle?: boolean;
  showBottomHandle?: boolean;
  showTopSourceHandle?: boolean;
  showRightTargetHandle?: boolean;
  sourceBottomHandles?: string[];
  targetTopHandles?: string[];
};

type RelationBusHandle = {
  id: string;
  side: "left" | "right" | "top" | "bottom";
  position: number;
  hidden?: boolean;
};

type RelationBusNodeData = {
  height: number;
  width?: number;
  orientation?: "vertical" | "horizontal";
  colorClass?: string;
  targetHandles?: RelationBusHandle[];
  sourceHandles?: RelationBusHandle[];
  sourceSide?: "bottom" | "right";
  sourcePosition?: number;
};

type FlowNodeData = CourseNodeData | RelationBusNodeData;

type RelationType = "prerequisite" | "corequisite" | "postrequisite";
type RelationEdgeData = {
  relation: RelationType;
  layout?: "horizontal" | "vertical";
};

const NODE_WIDTH = 192;
const NODE_HEIGHT = 101;
const MOBILE_STEP_Y = NODE_HEIGHT + 92;
const MOBILE_MIN_HEIGHT = 340;
const MOBILE_PREREQUISITE_BUS_THRESHOLD = 6;
const MOBILE_OUTGOING_BUS_THRESHOLD = 4;
const DESKTOP_PREREQUISITE_BUS_THRESHOLD = 6;
const BUS_WIDTH = 10;
const VERTICAL_GAP = 28;
const COREQUISITE_VERTICAL_GAP = 56;
const HORIZONTAL_GAP = 132;
const DENSE_DESKTOP_COLUMN_GAP = 8;
const DENSE_DESKTOP_ROW_GAP = 64;

const RELATION_COLORS: Record<RelationType, string> = {
  prerequisite: "#f59e0b",
  corequisite: "#3b82f6",
  postrequisite: "#10b981",
};

const RELATION_LABELS: Record<RelationType, string> = {
  prerequisite: "Requisito",
  corequisite: "Correquisito",
  postrequisite: "Desbloquea",
};

const RELATION_LEGEND = [
  {
    relation: "prerequisite",
    icon: LockIcon,
    className: "border-amber-500 text-amber-600",
  },
  {
    relation: "corequisite",
    icon: Link01Icon,
    className: "border-blue-500 text-blue-600",
  },
  {
    relation: "postrequisite",
    icon: LockOpenIcon,
    className: "border-emerald-500 text-emerald-600",
  },
] satisfies Array<{
  relation: RelationType;
  icon: typeof LockIcon;
  className: string;
}>;

function CourseFlowNode({ data }: { data: CourseNodeData }) {
  const {
    course,
    isCentral,
    showLeftHandle,
    showLeftSourceHandle,
    showRightHandle,
    showTopHandle,
    showBottomHandle,
    showTopSourceHandle,
    showRightTargetHandle,
    sourceBottomHandles,
    targetTopHandles,
  } = data;

  const topHandles = targetTopHandles?.length ? targetTopHandles : ["top"];
  const topHandlePositions =
    topHandles.length === 1
      ? [50]
      : topHandles.length === 2
        ? [38, 62]
        : topHandles.length === 3
          ? [30, 50, 70]
          : topHandles.map((_, index) => 26 + (index * 48) / Math.max(topHandles.length - 1, 1));

  const bottomHandles = sourceBottomHandles?.length ? sourceBottomHandles : ["bottom"];
  const bottomHandlePositions =
    bottomHandles.length === 1
      ? [50]
      : bottomHandles.length === 2
        ? [38, 62]
        : bottomHandles.length === 3
          ? [30, 50, 70]
          : bottomHandles.map(
              (_, index) => 26 + (index * 48) / Math.max(bottomHandles.length - 1, 1),
            );

  return (
    <div className={cn("relative w-48", isCentral && "z-10")}>
      {showLeftHandle ? (
        <Handle
          type="target"
          position={Position.Left}
          className="!bg-border !size-2.5 !border-none"
          id="left"
        />
      ) : null}
      {showRightHandle ? (
        <Handle
          type="source"
          position={Position.Right}
          className="!bg-border !size-2.5 !border-none"
          id="right"
        />
      ) : null}
      {showRightTargetHandle ? (
        <Handle
          type="target"
          position={Position.Right}
          className="!bg-border !size-2.5 !border-none"
          id="right-target"
        />
      ) : null}
      {showLeftSourceHandle ? (
        <Handle
          type="source"
          position={Position.Left}
          className="!bg-border !size-2.5 !border-none"
          id="left-source"
        />
      ) : null}
      {showTopHandle
        ? topHandles.map((handleId, index) => (
            <Handle
              key={handleId}
              type="target"
              position={Position.Top}
              className="!bg-border !size-2.5 !border-none"
              id={handleId}
              style={{ left: `${topHandlePositions[index]}%` }}
            />
          ))
        : null}
      {showTopSourceHandle ? (
        <Handle
          type="source"
          position={Position.Top}
          className="!bg-border !size-2.5 !border-none"
          id="top-source"
        />
      ) : null}
      {showBottomHandle
        ? bottomHandles.map((handleId, index) => (
            <Handle
              key={handleId}
              type="source"
              position={Position.Bottom}
              className="!bg-border !size-2.5 !border-none"
              id={handleId}
              style={{ left: `${bottomHandlePositions[index]}%` }}
            />
          ))
        : null}

      <CourseCard course={course} isHovered={false} solidStatusBackground />
    </div>
  );
}

function RelationBusNode({ data }: { data: RelationBusNodeData }) {
  const orientation = data.orientation ?? "vertical";
  const color = data.colorClass ?? "bg-amber-500";
  const sourceSide = data.sourceSide ?? "bottom";

  const getRelevantPositions = () => {
    const positions: number[] = [];
    const checkHandle = (h: RelationBusHandle) => {
      if (orientation === "vertical") {
        if (h.side === "left" || h.side === "right") positions.push(h.position);
        else if (h.side === "top") positions.push(0);
        else if (h.side === "bottom") positions.push(100);
      } else {
        if (h.side === "top" || h.side === "bottom") positions.push(h.position);
        else if (h.side === "left") positions.push(0);
        else if (h.side === "right") positions.push(100);
      }
    };
    data.targetHandles?.forEach(checkHandle);
    data.sourceHandles?.forEach(checkHandle);

    // Prereq bus legacy support
    if (!data.sourceHandles || data.sourceHandles.length === 0 || data.sourceSide) {
      if (orientation === "vertical") {
        if (sourceSide === "right") positions.push(data.sourcePosition ?? 96);
        else if (sourceSide === "bottom") positions.push(100);
      } else {
        if (sourceSide === "bottom") positions.push(data.sourcePosition ?? 96);
        else if (sourceSide === "right") positions.push(100);
      }
    }
    return positions;
  };

  const allPositions = getRelevantPositions();
  const lineStart = allPositions.length > 0 ? Math.min(...allPositions) : 0;
  const lineEnd = allPositions.length > 0 ? Math.max(...allPositions) : 100;

  const getPositionEnum = (side: string) => {
    switch (side) {
      case "left":
        return Position.Left;
      case "right":
        return Position.Right;
      case "top":
        return Position.Top;
      default:
        return Position.Bottom;
    }
  };

  const getInlineStyle = (side: string, position: number) => {
    if (orientation === "horizontal") {
      return side === "left" || side === "right"
        ? { top: `${position}%`, left: "50%" }
        : { left: `${position}%`, top: "50%" };
    }
    return side === "top" || side === "bottom"
      ? { left: `${position}%`, top: "50%" }
      : { top: `${position}%`, left: "50%" };
  };

  if (orientation === "horizontal") {
    return (
      <div className="relative" style={{ width: data.width ?? BUS_WIDTH, height: data.height }}>
        <div
          className={cn("absolute top-1/2 -translate-y-1/2 rounded-full", color)}
          style={{ left: `${lineStart}%`, width: `${lineEnd - lineStart}%`, height: "2.5px" }}
        />
        {data.targetHandles?.map((handle) => (
          <Handle
            key={handle.id}
            type="target"
            position={getPositionEnum(handle.side)}
            id={handle.id}
            className={cn(
              handle.hidden ? "!size-0 !border-none opacity-0" : cn("!size-2 !border-none", color),
            )}
            style={getInlineStyle(handle.side, handle.position)}
          />
        ))}
        {data.sourceHandles?.map((handle) => (
          <Handle
            key={handle.id}
            type="source"
            position={getPositionEnum(handle.side)}
            id={handle.id}
            className={cn(
              handle.hidden ? "!size-0 !border-none opacity-0" : cn("!size-2 !border-none", color),
            )}
            style={getInlineStyle(handle.side, handle.position)}
          />
        ))}
        {(!data.sourceHandles || data.sourceHandles.length === 0 || data.sourceSide) && (
          <Handle
            type="source"
            position={sourceSide === "bottom" ? Position.Bottom : Position.Right}
            id={sourceSide}
            className={cn("!size-2.5 !border-none", color)}
            style={
              sourceSide === "bottom"
                ? { left: `${data.sourcePosition ?? 96}%` }
                : { top: "50%", left: `${data.sourcePosition ?? 96}%` }
            }
          />
        )}
      </div>
    );
  }

  return (
    <div className="relative" style={{ width: BUS_WIDTH, height: data.height }}>
      <div
        className={cn("absolute left-1/2 -translate-x-1/2 rounded-full", color)}
        style={{ top: `${lineStart}%`, height: `${lineEnd - lineStart}%`, width: "2.5px" }}
      />
      {data.targetHandles?.map((handle) => (
        <Handle
          key={handle.id}
          type="target"
          position={getPositionEnum(handle.side)}
          id={handle.id}
          className={cn(
            handle.hidden ? "!size-0 !border-none opacity-0" : cn("!size-2 !border-none", color),
          )}
          style={getInlineStyle(handle.side, handle.position)}
        />
      ))}
      {data.sourceHandles?.map((handle) => (
        <Handle
          key={handle.id}
          type="source"
          position={getPositionEnum(handle.side)}
          id={handle.id}
          className={cn(
            handle.hidden ? "!size-0 !border-none opacity-0" : cn("!size-2 !border-none", color),
          )}
          style={getInlineStyle(handle.side, handle.position)}
        />
      ))}
      {(!data.sourceHandles || data.sourceHandles.length === 0 || data.sourceSide) && (
        <Handle
          type="source"
          position={sourceSide === "right" ? Position.Right : Position.Bottom}
          id={sourceSide}
          className={cn("!size-2.5 !border-none", color)}
          style={
            sourceSide === "right"
              ? { top: `${data.sourcePosition ?? 96}%` }
              : { left: "50%", top: `${data.sourcePosition ?? 96}%` }
          }
        />
      )}
    </div>
  );
}

function RelationEdge({
  id,
  sourceX,
  sourceY,
  targetX,
  targetY,
  sourcePosition,
  targetPosition,
  data,
  markerEnd,
}: EdgeProps<Edge<RelationEdgeData>>) {
  const relation = data?.relation ?? "prerequisite";
  const layout = data?.layout ?? "horizontal";
  const color = RELATION_COLORS[relation];
  const [path] =
    layout === "vertical"
      ? (() => {
          const dx = targetX - sourceX;
          if (Math.abs(dx) < 1) {
            return [`M ${sourceX} ${sourceY} L ${targetX} ${targetY}`] as const;
          }

          const direction = dx > 0 ? 1 : -1;
          const dy = Math.max(targetY - sourceY, 1);
          const radius = Math.min(24, Math.max(12, Math.floor(dy * 0.2)));
          const laneY = Math.min(
            targetY - radius - 2,
            sourceY + Math.max(28, Math.floor(dy * 0.45)),
          );
          const startCurveY = laneY - radius;
          const endCurveX = targetX - direction * radius;
          const startCurveX = sourceX + direction * radius;

          return [
            `M ${sourceX} ${sourceY}` +
              ` L ${sourceX} ${startCurveY}` +
              ` Q ${sourceX} ${laneY} ${startCurveX} ${laneY}` +
              ` L ${endCurveX} ${laneY}` +
              ` Q ${targetX} ${laneY} ${targetX} ${laneY + radius}` +
              ` L ${targetX} ${targetY}`,
          ] as const;
        })()
      : getSmoothStepPath({
          sourceX,
          sourceY,
          targetX,
          targetY,
          sourcePosition,
          targetPosition,
          borderRadius: 14,
          offset: 20,
        });

  return (
    <BaseEdge
      id={id}
      path={path}
      markerEnd={markerEnd}
      style={{
        stroke: color,
        strokeWidth: 2.5,
      }}
    />
  );
}

const nodeTypes = {
  course: CourseFlowNode,
  bus: RelationBusNode,
};

const STATUS_LEGEND = [
  {
    status: "approved",
    label: "Aprobado",
    className: "border-emerald-500/30 bg-emerald-500/20",
  },
  {
    status: "in_progress",
    label: "En curso",
    className: "border-blue-500/30 bg-blue-500/20",
  },
  {
    status: "available",
    label: "Disponible",
    className: "border-purple-500/30 bg-purple-500/20",
  },
  {
    status: "not_taken",
    label: "No cursado",
    className: "border-border bg-muted",
  },
  {
    status: "failed",
    label: "Reprobado",
    className: "border-red-500/30 bg-red-500/20",
  },
  {
    status: "withdrawn",
    label: "Retirado",
    className: "border-amber-500/30 bg-amber-500/20",
  },
] as const;

const edgeTypes = {
  relation: RelationEdge,
};

/* ------------------------------------------------------------------ */
/*  Main component                                                      */
/* ------------------------------------------------------------------ */

interface CourseRelationFlowProps {
  course: Course;
  prerequisites: Course[];
  corequisites: Course[];
  dependents: Course[];
  showLegends?: boolean;
  frameless?: boolean;
}

export function CourseRelationFlow({
  course,
  prerequisites,
  corequisites,
  dependents,
  showLegends = true,
  frameless = false,
}: CourseRelationFlowProps) {
  const containerRef = useRef<HTMLDivElement | null>(null);
  const suppressResizeRef = useRef(false);
  const lastViewportRef = useRef<{ x: number; y: number; zoom: number } | null>(null);
  const flowInstanceRef = useRef<ReactFlowInstance<
    Node<FlowNodeData>,
    Edge<RelationEdgeData>
  > | null>(null);
  const [containerWidth, setContainerWidth] = useState(0);
  const [mobileCardHeight, setMobileCardHeight] = useState(MOBILE_MIN_HEIGHT);
  const isVerticalLayout = containerWidth > 0 && containerWidth < 640;

  const fitFlow = useCallback(() => {
    const instance = flowInstanceRef.current;
    const container = containerRef.current;
    if (!instance) return;

    requestAnimationFrame(() => {
      if (frameless) {
        void instance.fitView({ padding: 0.12, minZoom: 0.1 });
        return;
      }

      if (isVerticalLayout && container) {
        const flowNodes = instance.getNodes();
        if (flowNodes.length === 0) return;

        const bounds = flowNodes.reduce(
          (acc, node) => {
            const x = node.position.x;
            const y = node.position.y;
            const width = node.measured?.width ?? (node.type === "bus" ? BUS_WIDTH : NODE_WIDTH);
            const height =
              node.measured?.height ??
              (node.type === "bus" && "height" in node.data ? node.data.height : NODE_HEIGHT);
            return {
              minX: Math.min(acc.minX, x),
              minY: Math.min(acc.minY, y),
              maxX: Math.max(acc.maxX, x + width),
              maxY: Math.max(acc.maxY, y + height),
            };
          },
          {
            minX: Number.POSITIVE_INFINITY,
            minY: Number.POSITIVE_INFINITY,
            maxX: Number.NEGATIVE_INFINITY,
            maxY: Number.NEGATIVE_INFINITY,
          },
        );

        const contentWidth = Math.max(bounds.maxX - bounds.minX, 1);
        const contentHeight = Math.max(bounds.maxY - bounds.minY, 1);
        const centerX = bounds.minX + contentWidth / 2;
        const centerY = bounds.minY + contentHeight / 2;

        const minGap = 16;
        const availableWidth = Math.max(container.clientWidth - minGap * 2, 1);
        const zoom = Math.min(1, availableWidth / contentWidth);
        const scaledHeight = contentHeight * zoom;
        const verticalPadding = 32;
        const targetHeight = Math.max(
          MOBILE_MIN_HEIGHT,
          Math.round((scaledHeight + verticalPadding) / 2) * 2,
        );

        const shouldResize = Math.abs(mobileCardHeight - targetHeight) > 2;
        if (shouldResize) {
          suppressResizeRef.current = true;
          setMobileCardHeight(targetHeight);
          requestAnimationFrame(() => {
            suppressResizeRef.current = false;
          });
        }

        const nextViewport = {
          x: container.clientWidth / 2 - centerX * zoom,
          y: targetHeight / 2 - centerY * zoom,
          zoom,
        };
        const lastViewport = lastViewportRef.current;
        const viewportChanged =
          !lastViewport ||
          Math.abs(lastViewport.x - nextViewport.x) > 0.5 ||
          Math.abs(lastViewport.y - nextViewport.y) > 0.5 ||
          Math.abs(lastViewport.zoom - nextViewport.zoom) > 0.001;

        if (viewportChanged) {
          lastViewportRef.current = nextViewport;
          void instance.setViewport(nextViewport);

          requestAnimationFrame(() => {
            const flowEl = container.querySelector<HTMLElement>(".react-flow");
            const nodeEls = Array.from(
              container.querySelectorAll<HTMLElement>(".react-flow__node"),
            );
            if (!flowEl || nodeEls.length === 0) return;

            const flowRect = flowEl.getBoundingClientRect();
            const minTop = Math.min(...nodeEls.map((nodeEl) => nodeEl.getBoundingClientRect().top));
            const maxBottom = Math.max(
              ...nodeEls.map((nodeEl) => nodeEl.getBoundingClientRect().bottom),
            );
            const topGap = minTop - flowRect.top;
            const bottomGap = flowRect.bottom - maxBottom;
            const delta = topGap - bottomGap;

            if (Math.abs(delta) <= 0.1) return;

            const viewport = instance.getViewport();
            const corrected = {
              x: viewport.x,
              y: viewport.y - delta / 2,
              zoom: viewport.zoom,
            };
            lastViewportRef.current = corrected;
            void instance.setViewport(corrected);
          });
        }
        return;
      }

      void instance.fitView({ padding: 0.12, minZoom: 0.1 });
    });
  }, [isVerticalLayout, mobileCardHeight, frameless]);

  const { nodes, edges } = useMemo(() => {
    const nodeList: Node<FlowNodeData>[] = [];
    const edgeList: Edge<RelationEdgeData>[] = [];
    const stepY = NODE_HEIGHT + VERTICAL_GAP;
    const corequisiteStepY = NODE_HEIGHT + COREQUISITE_VERTICAL_GAP;
    const columnStep = NODE_WIDTH + HORIZONTAL_GAP;
    const leftX = 0;
    const middleX = columnStep;
    const rightX = columnStep * 2;

    const mainRows = Math.max(prerequisites.length, dependents.length, 1);
    const centralRow = Math.floor((mainRows - 1) / 2);
    const centralY = 0;

    const getArrow = (relation: RelationType) => ({
      type: MarkerType.ArrowClosed,
      color: RELATION_COLORS[relation],
      width: 16,
      height: 16,
    });

    if (isVerticalLayout) {
      const compactStepY = MOBILE_STEP_Y;
      const centerX = 0;
      const prereqColumns = Math.min(2, Math.max(prerequisites.length, 1));
      const prereqRows = Math.ceil(prerequisites.length / prereqColumns);
      const prereqOffsetX = prerequisites.length > 1 ? 124 : 0;
      const centralY = prereqRows * compactStepY;
      const lowerStartY = centralY + compactStepY;
      const usePrerequisiteBus = prerequisites.length >= MOBILE_PREREQUISITE_BUS_THRESHOLD;
      const outgoingNodes = [
        ...corequisites.map((c) => ({
          id: `coreq-${c.id}`,
          course: c,
          relation: "corequisite" as const,
        })),
        ...dependents.map((d) => ({
          id: `dep-${d.id}`,
          course: d,
          relation: "postrequisite" as const,
        })),
      ];
      const useOutgoingBus = outgoingNodes.length >= MOBILE_OUTGOING_BUS_THRESHOLD;
      const outColumns = useOutgoingBus ? 2 : Math.min(2, Math.max(outgoingNodes.length, 1));
      const outOffsetX = outgoingNodes.length > 1 ? 124 : 0;

      const laneForX = (x: number): "bottom-left" | "bottom-center" | "bottom-right" => {
        if (x < centerX) return "bottom-left";
        if (x > centerX) return "bottom-right";
        return "bottom-center";
      };

      const getX = (index: number) => {
        const row = Math.floor(index / outColumns);
        const itemsInRow = Math.min(outColumns, outgoingNodes.length - row * outColumns);
        const col = index % outColumns;
        return itemsInRow === 1 ? centerX : col === 0 ? centerX - outOffsetX : centerX + outOffsetX;
      };

      const targetLanes = outgoingNodes.map((_, index) => laneForX(getX(index)));

      const incomingPrereqLanes = prerequisites.map((_, index) => {
        const col = index % prereqColumns;
        const x =
          prereqColumns === 1
            ? centerX
            : col === 0
              ? centerX - prereqOffsetX
              : centerX + prereqOffsetX;
        return laneForX(x);
      });

      const incomingTopHandles: string[] = usePrerequisiteBus
        ? ["top"]
        : incomingPrereqLanes.length <= 1
          ? ["top"]
          : ["top-left", "top-center", "top-right"].filter((lane) =>
              incomingPrereqLanes.includes(
                lane.replace("top", "bottom") as "bottom-left" | "bottom-center" | "bottom-right",
              ),
            );

      const outgoingHandles: string[] = useOutgoingBus
        ? ["bottom"]
        : targetLanes.length <= 1
          ? ["bottom"]
          : ["bottom-left", "bottom-center", "bottom-right"].filter((lane) =>
              targetLanes.includes(lane as "bottom-left" | "bottom-center" | "bottom-right"),
            );

      const resolveSourceHandle = (lane: "bottom-left" | "bottom-center" | "bottom-right") =>
        outgoingHandles.includes(lane) ? lane : outgoingHandles[0];

      const resolveTargetTopHandle = (lane: "bottom-left" | "bottom-center" | "bottom-right") => {
        const topLane = lane.replace("bottom", "top");
        return incomingTopHandles.includes(topLane) ? topLane : incomingTopHandles[0];
      };

      const busTargetHandles: RelationBusNodeData["targetHandles"] = [];

      prerequisites.forEach((prereq, index) => {
        const id = `prereq-${prereq.id}`;
        const row = Math.floor(index / prereqColumns);
        const col = index % prereqColumns;
        const x =
          prereqColumns === 1
            ? centerX
            : col === 0
              ? centerX - prereqOffsetX
              : centerX + prereqOffsetX;
        const y = row * compactStepY;
        const busHandleId = `in-${index}`;

        nodeList.push({
          id,
          type: "course",
          position: { x, y },
          data: {
            course: prereq,
            showBottomHandle: !usePrerequisiteBus,
            showRightHandle: usePrerequisiteBus && x < centerX,
            showLeftSourceHandle: usePrerequisiteBus && x > centerX,
          },
        });

        if (usePrerequisiteBus) {
          busTargetHandles.push({
            id: busHandleId,
            side: x < centerX ? "left" : "right",
            position: Math.min(96, Math.max(4, ((y + NODE_HEIGHT / 2) / centralY) * 100)),
            hidden: true,
          });
        }

        edgeList.push({
          id: usePrerequisiteBus ? `e-${id}-prereq-bus` : `e-${id}-central`,
          source: id,
          target: usePrerequisiteBus ? "prereq-bus" : "central",
          sourceHandle: usePrerequisiteBus ? (x < centerX ? "right" : "left-source") : "bottom",
          targetHandle: usePrerequisiteBus ? busHandleId : resolveTargetTopHandle(laneForX(x)),
          type: "relation",
          data: {
            relation: "prerequisite",
            layout: usePrerequisiteBus ? "horizontal" : "vertical",
          },
          markerEnd: usePrerequisiteBus ? undefined : getArrow("prerequisite"),
        });
      });

      if (usePrerequisiteBus) {
        nodeList.push({
          id: "prereq-bus",
          type: "bus",
          position: { x: centerX + NODE_WIDTH / 2 - BUS_WIDTH / 2, y: 0 },
          data: {
            height: centralY,
            targetHandles: busTargetHandles,
          },
        });

        edgeList.push({
          id: "e-prereq-bus-central",
          source: "prereq-bus",
          target: "central",
          sourceHandle: "bottom",
          targetHandle: "top",
          type: "relation",
          data: { relation: "prerequisite", layout: "vertical" },
          markerEnd: getArrow("prerequisite"),
        });
      }

      nodeList.push({
        id: "central",
        type: "course",
        position: { x: centerX, y: centralY },
        data: {
          course,
          isCentral: true,
          showTopHandle: prerequisites.length > 0,
          showBottomHandle: corequisites.length > 0 || dependents.length > 0,
          sourceBottomHandles: outgoingHandles,
          targetTopHandles: incomingTopHandles,
        },
      });

      const busSourceHandles: RelationBusHandle[] = [];
      const outRows = Math.ceil(outgoingNodes.length / outColumns);
      const busY = centralY + NODE_HEIGHT + 5; // Exactly 5px to touch the border of the 10px gray origin dot
      const lastNodeY = lowerStartY + (outRows > 0 ? outRows - 1 : 0) * compactStepY;
      const busBottom = lastNodeY + NODE_HEIGHT / 2 + 12; // Extend slightly below the last node's center
      const busHeight = Math.max(20, busBottom - busY);

      outgoingNodes.forEach((item, index) => {
        const row = Math.floor(index / outColumns);
        const y = lowerStartY + row * compactStepY;
        const x = getX(index);

        nodeList.push({
          id: item.id,
          type: "course",
          position: { x, y },
          data: {
            course: item.course,
            showTopHandle: !useOutgoingBus,
            showLeftHandle: useOutgoingBus && x > centerX,
            showRightTargetHandle: useOutgoingBus && x < centerX,
          },
        });

        if (useOutgoingBus) {
          const busHandleId = `out-${index}`;
          busSourceHandles.push({
            id: busHandleId,
            side: x < centerX ? "left" : "right",
            position: ((y + NODE_HEIGHT / 2 - busY) / busHeight) * 100, // Exact vertical match
            hidden: true,
          });

          edgeList.push({
            id: `e-bus-${item.id}`,
            source: "outgoing-bus",
            target: item.id,
            sourceHandle: busHandleId,
            targetHandle: x < centerX ? "right-target" : "left",
            type: "relation",
            data: { relation: item.relation, layout: "horizontal" },
            markerEnd: undefined, // "dejalos como lineas simplemente"
          });
        } else {
          edgeList.push({
            id: `e-central-${item.id}`,
            source: "central",
            target: item.id,
            sourceHandle: resolveSourceHandle(laneForX(x)),
            targetHandle: "top",
            type: "relation",
            data: { relation: item.relation, layout: "vertical" },
            markerEnd: getArrow(item.relation),
          });
        }
      });

      if (useOutgoingBus) {
        const hasPost = outgoingNodes.some((n) => n.relation === "postrequisite");
        const hasCoreq = outgoingNodes.some((n) => n.relation === "corequisite");
        const busColor =
          hasPost && hasCoreq ? "bg-slate-400" : hasPost ? "bg-emerald-500" : "bg-blue-500";
        const busRelation =
          hasPost && hasCoreq ? "postrequisite" : hasPost ? "postrequisite" : "corequisite";

        nodeList.push({
          id: "outgoing-bus",
          type: "bus",
          position: { x: centerX + NODE_WIDTH / 2 - BUS_WIDTH / 2, y: busY },
          data: {
            height: busHeight,
            sourceHandles: busSourceHandles,
            targetHandles: [{ id: "top", side: "top", position: 50, hidden: true }],
            colorClass: busColor,
          },
        });

        edgeList.push({
          id: "e-central-outgoing-bus",
          source: "central",
          target: "outgoing-bus",
          sourceHandle: "bottom",
          targetHandle: "top",
          type: "relation",
          data: { relation: busRelation, layout: "vertical" },
          markerEnd: undefined, // No arrow on the connection stub
        });
      }

      const minX = Math.min(...nodeList.map((node) => node.position.x));
      const maxX = Math.max(...nodeList.map((node) => node.position.x + NODE_WIDTH));
      const minY = Math.min(...nodeList.map((node) => node.position.y));
      const maxY = Math.max(...nodeList.map((node) => node.position.y + NODE_HEIGHT));
      const offsetX = (minX + maxX) / 2;
      const offsetY = (minY + maxY) / 2;

      nodeList.forEach((node) => {
        node.position = {
          x: node.position.x - offsetX,
          y: node.position.y - offsetY,
        };
      });

      return { nodes: nodeList, edges: edgeList };
    }

    if (prerequisites.length >= DESKTOP_PREREQUISITE_BUS_THRESHOLD) {
      const prereqColumns = Math.ceil(prerequisites.length / 2);
      const prereqColumnStep = NODE_WIDTH + DENSE_DESKTOP_COLUMN_GAP;
      const prereqGridWidth =
        prereqColumns * NODE_WIDTH + (prereqColumns - 1) * DENSE_DESKTOP_COLUMN_GAP;
      const topRowY = -(NODE_HEIGHT + DENSE_DESKTOP_ROW_GAP) / 2;
      const bottomRowY = (NODE_HEIGHT + DENSE_DESKTOP_ROW_GAP) / 2;
      const busY = NODE_HEIGHT / 2;
      const busWidth = prereqGridWidth;
      const busLeft = 0;
      const centralX = (prereqGridWidth - NODE_WIDTH) / 2;
      const centralY = bottomRowY + NODE_HEIGHT + VERTICAL_GAP;
      const dependentX = centralX + NODE_WIDTH + HORIZONTAL_GAP;
      const busHeight = BUS_WIDTH;
      const busTargetHandles: RelationBusNodeData["targetHandles"] = [];

      nodeList.push({
        id: "central",
        type: "course",
        position: { x: centralX, y: centralY },
        data: {
          course,
          isCentral: true,
          showTopHandle: true,
          showRightHandle: dependents.length > 0,
          showBottomHandle: corequisites.length > 0,
        },
      });

      prerequisites.forEach((prereq, index) => {
        const id = `prereq-${prereq.id}`;
        const row = index % 2;
        const col = Math.floor(index / 2);
        const x = col * prereqColumnStep;
        const y = row === 0 ? topRowY : bottomRowY;
        const busHandleId = `desktop-in-${index}`;
        const busHandlePosition = Math.min(
          96,
          Math.max(4, ((x + NODE_WIDTH / 2 - busLeft) / busWidth) * 100),
        );

        nodeList.push({
          id,
          type: "course",
          position: { x, y },
          data: {
            course: prereq,
            showBottomHandle: row === 0,
            showTopSourceHandle: row === 1,
          },
        });

        busTargetHandles.push({
          id: busHandleId,
          side: row === 0 ? "top" : "bottom",
          position: busHandlePosition,
        });

        edgeList.push({
          id: `e-${id}-prereq-bus`,
          source: id,
          target: "prereq-bus",
          sourceHandle: row === 0 ? "bottom" : "top-source",
          targetHandle: busHandleId,
          type: "relation",
          data: { relation: "prerequisite", layout: "vertical" },
        });
      });

      nodeList.push({
        id: "prereq-bus",
        type: "bus",
        position: { x: busLeft, y: busY },
        data: {
          height: busHeight,
          width: busWidth,
          orientation: "horizontal",
          sourceSide: "bottom",
          sourcePosition: 50,
          targetHandles: busTargetHandles,
        },
      });

      edgeList.push({
        id: "e-prereq-bus-central",
        source: "prereq-bus",
        target: "central",
        sourceHandle: "bottom",
        targetHandle: "top",
        type: "relation",
        data: { relation: "prerequisite", layout: "vertical" },
        markerEnd: getArrow("prerequisite"),
      });

      dependents.forEach((dep, index) => {
        const id = `dep-${dep.id}`;
        const y = (index - centralRow) * stepY;

        nodeList.push({
          id,
          type: "course",
          position: { x: dependentX, y },
          data: { course: dep, showLeftHandle: true },
        });

        edgeList.push({
          id: `e-central-${id}`,
          source: "central",
          target: id,
          sourceHandle: "right",
          targetHandle: "left",
          type: "relation",
          data: { relation: "postrequisite" },
          markerEnd: getArrow("postrequisite"),
        });
      });

      corequisites.forEach((coreq, index) => {
        const id = `coreq-${coreq.id}`;
        const y = centralY + (index + 1) * corequisiteStepY;

        nodeList.push({
          id,
          type: "course",
          position: { x: centralX, y },
          data: { course: coreq, showTopHandle: true },
        });

        edgeList.push({
          id: `e-central-${id}`,
          source: "central",
          target: id,
          sourceHandle: "bottom",
          targetHandle: "top",
          type: "relation",
          data: { relation: "corequisite" },
          markerEnd: getArrow("corequisite"),
        });
      });

      const minX = Math.min(...nodeList.map((node) => node.position.x));
      const maxX = Math.max(
        ...nodeList.map(
          (node) =>
            node.position.x +
            (node.type === "bus" && "width" in node.data && node.data.width
              ? node.data.width
              : NODE_WIDTH),
        ),
      );
      const minY = Math.min(...nodeList.map((node) => node.position.y));
      const maxY = Math.max(
        ...nodeList.map(
          (node) =>
            node.position.y +
            (node.type === "bus" && "height" in node.data ? node.data.height : NODE_HEIGHT),
        ),
      );
      const offsetX = (minX + maxX) / 2;
      const offsetY = (minY + maxY) / 2;

      nodeList.forEach((node) => {
        node.position = {
          x: node.position.x - offsetX,
          y: node.position.y - offsetY,
        };
      });

      return { nodes: nodeList, edges: edgeList };
    }

    nodeList.push({
      id: "central",
      type: "course",
      position: { x: middleX, y: centralY },
      data: {
        course,
        isCentral: true,
        showLeftHandle: prerequisites.length > 0,
        showRightHandle: dependents.length > 0,
        showBottomHandle: corequisites.length > 0,
      },
    });

    prerequisites.forEach((prereq, index) => {
      const id = `prereq-${prereq.id}`;
      const y = (index - centralRow) * stepY;

      nodeList.push({
        id,
        type: "course",
        position: { x: leftX, y },
        data: { course: prereq, showRightHandle: true },
      });

      edgeList.push({
        id: `e-${id}-central`,
        source: id,
        target: "central",
        sourceHandle: "right",
        targetHandle: "left",
        type: "relation",
        data: { relation: "prerequisite" },
        markerEnd: getArrow("prerequisite"),
      });
    });

    dependents.forEach((dep, index) => {
      const id = `dep-${dep.id}`;
      const y = (index - centralRow) * stepY;

      nodeList.push({
        id,
        type: "course",
        position: { x: rightX, y },
        data: { course: dep, showLeftHandle: true },
      });

      edgeList.push({
        id: `e-central-${id}`,
        source: "central",
        target: id,
        sourceHandle: "right",
        targetHandle: "left",
        type: "relation",
        data: { relation: "postrequisite" },
        markerEnd: getArrow("postrequisite"),
      });
    });

    corequisites.forEach((coreq, index) => {
      const id = `coreq-${coreq.id}`;
      const y = centralY + (index + 1) * corequisiteStepY;

      nodeList.push({
        id,
        type: "course",
        position: { x: middleX, y },
        data: { course: coreq, showTopHandle: true },
      });

      edgeList.push({
        id: `e-central-${id}`,
        source: "central",
        target: id,
        sourceHandle: "bottom",
        targetHandle: "top",
        type: "relation",
        data: { relation: "corequisite" },
        markerEnd: getArrow("corequisite"),
      });
    });

    if (nodeList.length > 0) {
      const minX = Math.min(...nodeList.map((node) => node.position.x));
      const maxX = Math.max(...nodeList.map((node) => node.position.x + NODE_WIDTH));
      const minY = Math.min(...nodeList.map((node) => node.position.y));
      const maxY = Math.max(...nodeList.map((node) => node.position.y + NODE_HEIGHT));
      const offsetX = (minX + maxX) / 2;
      const offsetY = (minY + maxY) / 2;

      nodeList.forEach((node) => {
        node.position = {
          x: node.position.x - offsetX,
          y: node.position.y - offsetY,
        };
      });
    }

    return { nodes: nodeList, edges: edgeList };
  }, [course, prerequisites, corequisites, dependents, isVerticalLayout]);

  useEffect(() => {
    fitFlow();
  }, [fitFlow, nodes, edges]);

  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;

    let rafId = 0;
    const observer = new ResizeObserver(() => {
      if (suppressResizeRef.current) return;
      cancelAnimationFrame(rafId);
      rafId = requestAnimationFrame(() => {
        setContainerWidth(el.clientWidth);
        fitFlow();
      });
    });

    setContainerWidth(el.clientWidth);
    observer.observe(el);

    return () => {
      cancelAnimationFrame(rafId);
      observer.disconnect();
    };
  }, [fitFlow]);

  return (
    <div className={cn(showLegends ? "space-y-3" : "h-full")}>
      <div
        ref={containerRef}
        className={cn(
          "w-full overflow-hidden",
          !frameless &&
            "border-border rounded-xl border bg-[var(--course-relation-flow-background)]",
          frameless
            ? "h-full"
            : isVerticalLayout
              ? "min-h-[360px]"
              : "aspect-[3/2] max-h-[500px] min-h-[240px]",
        )}
        style={isVerticalLayout && !frameless ? { height: mobileCardHeight } : undefined}
      >
        <ReactFlow
          nodes={nodes}
          edges={edges}
          nodeTypes={nodeTypes}
          edgeTypes={edgeTypes}
          fitView
          fitViewOptions={{ padding: 0.24, minZoom: 0.1 }}
          onInit={(instance) => {
            flowInstanceRef.current = instance;
            fitFlow();
          }}
          minZoom={0.1}
          maxZoom={2}
          nodesDraggable={false}
          nodesConnectable={false}
          elementsSelectable={false}
          nodesFocusable={false}
          edgesFocusable={false}
          zoomOnScroll={false}
          zoomOnPinch={false}
          zoomOnDoubleClick={false}
          panOnDrag={false}
          panOnScroll={false}
          preventScrolling={false}
          attributionPosition="bottom-right"
          proOptions={{ hideAttribution: true }}
        >
          <Background gap={16} size={1} color="var(--course-relation-flow-dot)" />
        </ReactFlow>
      </div>

      {showLegends && (
        <div className="border-border border-t pt-3">
          <div className="flex flex-wrap gap-x-6 gap-y-3 sm:gap-x-8">
            <div>
              <h3 className="text-foreground mb-2 text-xs font-semibold sm:mb-3 sm:text-sm">
                Leyenda de estados
              </h3>
              <div className="flex flex-wrap gap-x-3 gap-y-2 sm:gap-4">
                {STATUS_LEGEND.map(({ status, label, className }) => (
                  <div key={status} className="flex items-center gap-1.5 sm:gap-2">
                    <div className={cn("size-4 rounded border sm:size-6 sm:border-2", className)} />
                    <span className="text-muted-foreground text-xs sm:text-sm">{label}</span>
                  </div>
                ))}
              </div>
            </div>

            <div>
              <h3 className="text-foreground mb-2 text-xs font-semibold sm:mb-3 sm:text-sm">
                Relaciones
              </h3>
              <div className="flex flex-wrap gap-x-3 gap-y-2 sm:gap-4">
                {RELATION_LEGEND.map(({ relation, icon, className }) => (
                  <div key={relation} className="flex items-center gap-1.5 sm:gap-2">
                    <div
                      className={cn(
                        "bg-background flex size-4 shrink-0 items-center justify-center rounded-full border shadow-sm sm:size-6 sm:border-2",
                        className,
                      )}
                    >
                      <Icon icon={icon} className="size-2.5 shrink-0 sm:size-3" />
                    </div>
                    <span className="text-muted-foreground text-xs sm:text-sm">
                      {RELATION_LABELS[relation]}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
