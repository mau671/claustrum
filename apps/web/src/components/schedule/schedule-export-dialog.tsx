import { ImageDownload02Icon } from "@hugeicons/core-free-icons";
import { HugeiconsIcon } from "@hugeicons/react";
import { useState, type ReactElement } from "react";

import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  Drawer,
  DrawerDescription,
  DrawerFooter,
  DrawerHeader,
  DrawerPopup,
  DrawerTitle,
} from "@/components/ui/drawer";
import { Label } from "@/components/ui/label";
import { useIsMobile } from "@/hooks/use-mobile";
import { cn } from "@/lib/utils";

export type ScheduleExportFormat = "png" | "jpeg" | "ics";
export type ScheduleExportTheme = "light" | "dark";

export interface ScheduleExportOptions {
  format: ScheduleExportFormat;
  theme: ScheduleExportTheme;
  transparent: boolean;
}

const formatOptions: Array<{
  value: ScheduleExportFormat;
  title: string;
  description: string;
}> = [
  {
    value: "png",
    title: "PNG",
    description: "Imagen con fondo transparente.",
  },
  {
    value: "jpeg",
    title: "JPEG",
    description: "Imagen liviana con fondo sólido.",
  },
  {
    value: "ics",
    title: "Calendario",
    description: "Archivo .ics para apps de calendario.",
  },
];

interface ScheduleExportDialogProps {
  onExport: (options: ScheduleExportOptions) => Promise<void> | void;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  trigger?: ReactElement | null;
}

export function ScheduleExportDialog({
  onExport,
  open: controlledOpen,
  onOpenChange: controlledOnOpenChange,
  trigger,
}: ScheduleExportDialogProps) {
  const [format, setFormat] = useState<ScheduleExportFormat>("png");
  const [internalOpen, setInternalOpen] = useState(false);
  const isOpen = controlledOpen !== undefined ? controlledOpen : internalOpen;
  const setIsOpen = controlledOnOpenChange ?? setInternalOpen;
  const [isExporting, setIsExporting] = useState(false);
  const isMobile = useIsMobile();

  const handleExport = async () => {
    setIsExporting(true);
    try {
      const isDark =
        typeof document !== "undefined" && document.documentElement.classList.contains("dark");
      const currentTheme: ScheduleExportTheme = isDark ? "dark" : "light";
      await onExport({ format, theme: currentTheme, transparent: format === "png" });
      setIsOpen(false);
    } finally {
      setIsExporting(false);
    }
  };

  const formFields = (
    <div className="space-y-5">
      <div className="space-y-2.5">
        <Label>Formato</Label>
        <div className="grid gap-2 sm:grid-cols-3">
          {formatOptions.map((option) => {
            const isSelected = format === option.value;

            return (
              <button
                key={option.value}
                type="button"
                className={cn(
                  "hover:border-primary/60 hover:bg-muted/40 rounded-xl border p-3 text-left transition-all",
                  isSelected && "border-primary bg-primary/5 shadow-sm",
                )}
                onClick={() => setFormat(option.value)}
              >
                <span className="block text-sm leading-none font-semibold">{option.title}</span>
                <span className="text-muted-foreground mt-1.5 block text-xs leading-snug">
                  {option.description}
                </span>
              </button>
            );
          })}
        </div>
      </div>

      {format !== "ics" && (
        <div>
          <p className="text-muted-foreground text-sm">
            Nota: El calendario se exporta con el tema actual. Si deseas otro resultado, cambia el
            tema de la página antes de exportar.
          </p>
        </div>
      )}
    </div>
  );

  if (isMobile) {
    return (
      <>
        {trigger !== null &&
          (trigger ?? (
            <Button
              variant="outline"
              size="icon"
              title="Exportar calendario"
              onClick={() => setIsOpen(true)}
            >
              <HugeiconsIcon icon={ImageDownload02Icon} size={16} />
            </Button>
          ))}
        <Drawer open={isOpen} onOpenChange={setIsOpen}>
          <DrawerPopup
            showBar
            className="grid max-h-[90dvh] grid-rows-[auto_minmax(0,1fr)_auto] overflow-hidden"
          >
            <DrawerHeader className="px-4 pt-4 pb-2 text-left">
              <DrawerTitle>Exportar calendario</DrawerTitle>
              <DrawerDescription>
                Descarga el horario como imagen o archivo de calendario.
              </DrawerDescription>
            </DrawerHeader>
            <div className="min-h-0 overflow-y-auto px-4 pb-4">{formFields}</div>
            <DrawerFooter className="px-4 pt-2 pb-6">
              <Button onClick={handleExport} disabled={isExporting} className="w-full">
                {isExporting ? "Exportando..." : format === "ics" ? "Descargar" : "Exportar"}
              </Button>
            </DrawerFooter>
          </DrawerPopup>
        </Drawer>
      </>
    );
  }

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      {trigger !== null &&
        (trigger ? (
          <DialogTrigger render={trigger} />
        ) : (
          <DialogTrigger
            render={<Button variant="outline" size="icon" title="Exportar calendario" />}
          >
            <HugeiconsIcon icon={ImageDownload02Icon} size={16} />
          </DialogTrigger>
        ))}
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Exportar calendario</DialogTitle>
          <DialogDescription>
            Descarga el horario como imagen o archivo de calendario.
          </DialogDescription>
        </DialogHeader>

        <div className="px-6 pb-2">{formFields}</div>

        <DialogFooter>
          <Button onClick={handleExport} disabled={isExporting}>
            {isExporting ? "Exportando..." : format === "ics" ? "Descargar" : "Exportar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
