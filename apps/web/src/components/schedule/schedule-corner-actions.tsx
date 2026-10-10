import {
  Bookmark02Icon,
  Delete02Icon,
  FloppyDiskIcon,
  ImageDownload02Icon,
  Link01Icon,
  Loading02Icon,
  MoreHorizontalIcon,
  ZoomInIcon,
  ZoomOutIcon,
} from "@hugeicons/core-free-icons";
import { HugeiconsIcon } from "@hugeicons/react";
import { Link } from "@tanstack/react-router";
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
  Drawer,
  DrawerDescription,
  DrawerHeader,
  DrawerPopup,
  DrawerTitle,
} from "@/components/ui/drawer";
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
import { useIsMobile } from "@/hooks/use-mobile";

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
  const isMobile = useIsMobile();

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
              className="text-muted-foreground hover:bg-muted hover:text-foreground data-popup-open:bg-muted flex h-6 w-full cursor-pointer items-center justify-center rounded-none transition-colors"
              title="Opciones del horario"
              aria-label="Opciones del horario"
            />
          }
        >
          <HugeiconsIcon icon={MoreHorizontalIcon} size={16} />
        </DropdownMenuTrigger>

        <DropdownMenuContent align="start" side="bottom" sideOffset={4} className="w-56">
          <DropdownMenuItem
            className="cursor-pointer gap-2"
            onClick={() => {
              setExportDialogOpen(true);
            }}
          >
            <HugeiconsIcon icon={ImageDownload02Icon} size={16} />
            <span>Exportar horario...</span>
          </DropdownMenuItem>

          <DropdownMenuItem
            className="cursor-pointer gap-2"
            onClick={() => {
              setSavedDialogOpen(true);
            }}
          >
            <HugeiconsIcon icon={Bookmark02Icon} size={16} />
            <span>Mis horarios...</span>
          </DropdownMenuItem>

          <DropdownMenuItem
            className="cursor-pointer gap-2"
            onClick={() => {
              void onCopyShortLink();
            }}
          >
            <HugeiconsIcon icon={Link01Icon} size={16} />
            <span>Copiar enlace</span>
          </DropdownMenuItem>

          <DropdownMenuSeparator />

          <div
            className="flex items-center gap-1 px-2 py-1.5"
            onPointerDown={(e) => e.stopPropagation()}
          >
            <Button
              type="button"
              variant="ghost"
              size="icon"
              className="size-7 shrink-0"
              onClick={handleZoomOut}
              disabled={canZoomOut}
              title="Alejar"
              aria-label="Alejar"
            >
              <HugeiconsIcon icon={ZoomOutIcon} size={16} />
            </Button>
            <button
              type="button"
              onClick={handleResetZoom}
              title="Restablecer tamaño (100%)"
              aria-label="Restablecer tamaño (100%)"
              className="text-muted-foreground hover:text-foreground h-7 flex-1 cursor-pointer rounded-md text-center text-xs font-semibold tabular-nums transition-colors"
            >
              {zoomPercentage}%
            </button>
            <Button
              type="button"
              variant="ghost"
              size="icon"
              className="size-7 shrink-0"
              onClick={handleZoomIn}
              disabled={canZoomIn}
              title="Acercar"
              aria-label="Acercar"
            >
              <HugeiconsIcon icon={ZoomInIcon} size={16} />
            </Button>
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

      {/* Controlled saved schedules dialog / drawer */}
      {isMobile ? (
        <Drawer open={savedDialogOpen} onOpenChange={setSavedDialogOpen}>
          <DrawerPopup showBar className="max-h-[90dvh] overflow-hidden">
            <DrawerHeader className="px-4 pt-4 pb-2 text-left">
              <DrawerTitle>Mis horarios</DrawerTitle>
              <DrawerDescription>
                Guarda tus combinaciones de cursos o carga un horario guardado.
              </DrawerDescription>
            </DrawerHeader>
            <div className="min-h-0 overflow-y-auto px-4 pb-6">
              {isAuthenticated ? (
                <div className="space-y-5 pt-1">
                  <div className="space-y-2">
                    <Label htmlFor="schedule-name-dialog-mobile" className="text-sm font-medium">
                      Guardar horario actual
                    </Label>
                    <div className="flex items-center gap-2">
                      <Input
                        id="schedule-name-dialog-mobile"
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
                          <HugeiconsIcon icon={Loading02Icon} size={16} className="animate-spin" />
                        ) : (
                          <HugeiconsIcon icon={FloppyDiskIcon} size={16} />
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
                              <HugeiconsIcon icon={Delete02Icon} size={14} />
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
            </div>
          </DrawerPopup>
        </Drawer>
      ) : (
        <Dialog open={savedDialogOpen} onOpenChange={setSavedDialogOpen}>
          <DialogContent className="sm:max-w-md">
            <DialogHeader>
              <DialogTitle>Mis horarios</DialogTitle>
              <DialogDescription>
                Guarda tus combinaciones de cursos o carga un horario guardado.
              </DialogDescription>
            </DialogHeader>

            <div className="px-6 pb-6">
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
                          <HugeiconsIcon icon={Loading02Icon} size={16} className="animate-spin" />
                        ) : (
                          <HugeiconsIcon icon={FloppyDiskIcon} size={16} />
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
                              <HugeiconsIcon icon={Delete02Icon} size={14} />
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
            </div>
          </DialogContent>
        </Dialog>
      )}
    </>
  );
}
