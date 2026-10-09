import { Link } from "@tanstack/react-router";
import {
  Bookmark,
  ImageDown,
  Link2,
  Loader2,
  MoreHorizontal,
  RotateCcw,
  Save,
  Trash2,
  ZoomIn,
  ZoomOut,
} from "lucide-react";
import { useState, useCallback } from "react";

import type { SavedSchedule } from "@/lib/hooks/use-saved-schedules";

import {
  DEFAULT_HOUR_HEIGHT,
  MIN_HOUR_HEIGHT,
  MAX_HOUR_HEIGHT,
} from "@/components/calendar/calendar-types";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";

import { ScheduleExportDialog, type ScheduleExportOptions } from "./schedule-export-dialog";
import { SCHEDULE_DEFAULT_HOUR_HEIGHT } from "./schedule-zoom-controls";

const ZOOM_STEP = 16;
const ZOOM_STORAGE_KEY = "schedule-hour-height";

interface ScheduleCornerActionsProps {
  onExport: (options: ScheduleExportOptions) => Promise<void> | void;
  onCopyShortLink: () => void | Promise<void>;
  hourHeight: number;
  setHourHeight: (height: number) => void;
  isAuthenticated: boolean;
  savedSchedules?: SavedSchedule[];
  scheduleName: string;
  onScheduleNameChange: (name: string) => void;
  onSaveSchedule: (onSuccess?: () => void) => void;
  isSavingSchedule: boolean;
  hasSelectedGroups: boolean;
  onLoadSchedule: (schedule: SavedSchedule) => void;
  onDeleteSchedule: (id: number) => void;
  onSaveLocalPlan?: () => void;
}

export function ScheduleCornerActions({
  onExport,
  onCopyShortLink,
  hourHeight,
  setHourHeight,
  isAuthenticated,
  savedSchedules,
  scheduleName,
  onScheduleNameChange,
  onSaveSchedule,
  isSavingSchedule,
  hasSelectedGroups,
  onLoadSchedule,
  onDeleteSchedule,
  onSaveLocalPlan,
}: ScheduleCornerActionsProps) {
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const [exportDialogOpen, setExportDialogOpen] = useState(false);
  const [savedDialogOpen, setSavedDialogOpen] = useState(false);

  const handleZoomIn = useCallback(() => {
    const newHeight = Math.min(hourHeight + ZOOM_STEP, MAX_HOUR_HEIGHT);
    setHourHeight(newHeight);
    localStorage.setItem(ZOOM_STORAGE_KEY, newHeight.toString());
  }, [hourHeight, setHourHeight]);

  const handleZoomOut = useCallback(() => {
    const newHeight = Math.max(hourHeight - ZOOM_STEP, MIN_HOUR_HEIGHT);
    setHourHeight(newHeight);
    localStorage.setItem(ZOOM_STORAGE_KEY, newHeight.toString());
  }, [hourHeight, setHourHeight]);

  const handleResetZoom = useCallback(() => {
    setHourHeight(SCHEDULE_DEFAULT_HOUR_HEIGHT);
    localStorage.setItem(ZOOM_STORAGE_KEY, SCHEDULE_DEFAULT_HOUR_HEIGHT.toString());
  }, [setHourHeight]);

  const handleSave = useCallback(() => {
    onSaveSchedule(() => {
      setSavedDialogOpen(false);
    });
  }, [onSaveSchedule]);

  const canZoomIn = hourHeight >= MAX_HOUR_HEIGHT;
  const canZoomOut = hourHeight <= MIN_HOUR_HEIGHT;
  const zoomPercentage = Math.round((hourHeight / DEFAULT_HOUR_HEIGHT) * 100);

  return (
    <>
      <DropdownMenu open={dropdownOpen} onOpenChange={setDropdownOpen}>
        <DropdownMenuTrigger
          render={
            <Button
              type="button"
              variant="ghost"
              size="icon"
              className="text-muted-foreground hover:bg-muted hover:text-foreground size-7 rounded-md transition-colors"
              title="Opciones del horario"
              aria-label="Opciones del horario"
            />
          }
        >
          <MoreHorizontal className="size-4" />
        </DropdownMenuTrigger>

        <DropdownMenuContent align="start" side="bottom" sideOffset={4} className="w-56">
          <DropdownMenuItem
            className="cursor-pointer gap-2"
            onClick={() => {
              setExportDialogOpen(true);
            }}
          >
            <ImageDown className="size-4" />
            <span>Exportar horario...</span>
          </DropdownMenuItem>

          <DropdownMenuItem
            className="cursor-pointer gap-2"
            onClick={() => {
              setSavedDialogOpen(true);
            }}
          >
            <Bookmark className="size-4" />
            <span>Mis horarios...</span>
          </DropdownMenuItem>

          <DropdownMenuItem
            className="cursor-pointer gap-2"
            onClick={() => {
              void onCopyShortLink();
            }}
          >
            <Link2 className="size-4" />
            <span>Copiar enlace</span>
          </DropdownMenuItem>

          <DropdownMenuSeparator />

          <div className="px-2 py-1.5" onPointerDown={(e) => e.stopPropagation()}>
            <div className="text-muted-foreground mb-1.5 flex items-center justify-between text-xs">
              <span>Zoom</span>
              <span className="text-foreground font-semibold tabular-nums">{zoomPercentage}%</span>
            </div>
            <div className="flex items-center gap-1">
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="h-7 flex-1 gap-1 px-1.5 text-xs"
                onClick={handleZoomOut}
                disabled={canZoomOut}
                title="Alejar horas"
              >
                <ZoomOut className="size-3.5" />
                <span>Alejar</span>
              </Button>
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="h-7 flex-1 gap-1 px-1.5 text-xs"
                onClick={handleZoomIn}
                disabled={canZoomIn}
                title="Acercar horas"
              >
                <ZoomIn className="size-3.5" />
                <span>Acercar</span>
              </Button>
              <Button
                type="button"
                variant="ghost"
                size="icon"
                className="text-muted-foreground hover:text-foreground size-7 shrink-0"
                onClick={handleResetZoom}
                title="Restablecer tamaño (100%)"
              >
                <RotateCcw className="size-3.5" />
              </Button>
            </div>
          </div>
        </DropdownMenuContent>
      </DropdownMenu>

      {/* Controlled export dialog without standalone trigger */}
      <ScheduleExportDialog
        open={exportDialogOpen}
        onOpenChange={setExportDialogOpen}
        onExport={onExport}
        trigger={null}
      />

      {/* Controlled saved schedules dialog */}
      <Dialog open={savedDialogOpen} onOpenChange={setSavedDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Mis horarios</DialogTitle>
            <DialogDescription>
              Guarda tus combinaciones de cursos o carga un horario guardado.
            </DialogDescription>
          </DialogHeader>

          {isAuthenticated ? (
            <div className="space-y-5 pt-1">
              <div className="space-y-2">
                <Label htmlFor="schedule-name-dialog" className="text-sm font-medium">
                  Guardar horario actual
                </Label>
                <div className="flex items-center gap-2">
                  <Input
                    id="schedule-name-dialog"
                    value={scheduleName}
                    onChange={(e) => onScheduleNameChange(e.target.value)}
                    placeholder="Nombre (ej: Semestre 1 - Opción A)"
                    className="h-9"
                    onKeyDown={(e) => {
                      if (
                        e.key === "Enter" &&
                        scheduleName.trim() &&
                        hasSelectedGroups &&
                        !isSavingSchedule
                      ) {
                        e.preventDefault();
                        handleSave();
                      }
                    }}
                  />
                  <Button
                    type="button"
                    onClick={handleSave}
                    disabled={!scheduleName.trim() || !hasSelectedGroups || isSavingSchedule}
                    className="h-9 shrink-0 gap-1.5 px-3"
                  >
                    {isSavingSchedule ? (
                      <Loader2 className="size-4 animate-spin" />
                    ) : (
                      <Save className="size-4" />
                    )}
                    <span>Guardar</span>
                  </Button>
                </div>
                {!hasSelectedGroups && (
                  <p className="text-muted-foreground text-xs">
                    Selecciona al menos un curso para poder guardar el horario.
                  </p>
                )}
              </div>

              <Separator />

              <div className="space-y-2">
                <Label className="text-sm font-medium">Horarios guardados</Label>
                <div className="max-h-60 space-y-1.5 overflow-y-auto pr-1">
                  {!savedSchedules?.length ? (
                    <p className="text-muted-foreground py-2 text-sm">
                      No tienes horarios guardados aún.
                    </p>
                  ) : (
                    savedSchedules.map((s) => (
                      <div
                        key={s.id}
                        className="hover:bg-muted/50 flex items-center justify-between rounded-lg border p-2.5 transition-colors"
                      >
                        <button
                          type="button"
                          className="flex-1 cursor-pointer truncate pr-2 text-left text-sm font-medium hover:underline"
                          onClick={() => {
                            onLoadSchedule(s);
                            setSavedDialogOpen(false);
                          }}
                        >
                          {s.name}
                        </button>
                        <Button
                          type="button"
                          variant="ghost"
                          size="icon"
                          className="text-muted-foreground hover:text-destructive size-7 shrink-0"
                          onClick={() => onDeleteSchedule(s.id)}
                          title="Eliminar horario"
                        >
                          <Trash2 className="size-3.5" />
                        </Button>
                      </div>
                    ))
                  )}
                </div>
              </div>
            </div>
          ) : (
            <div className="space-y-4 py-2">
              <p className="text-muted-foreground text-sm">
                Inicia sesión para guardar horarios en tu cuenta y sincronizarlos en todos tus
                dispositivos.
              </p>
              <div className="flex items-center gap-2">
                <Button render={<Link to="/auth/signin" />} className="flex-1">
                  Iniciar sesión
                </Button>
                {onSaveLocalPlan && (
                  <Button variant="outline" onClick={onSaveLocalPlan} className="flex-1">
                    Guardar localmente
                  </Button>
                )}
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </>
  );
}
