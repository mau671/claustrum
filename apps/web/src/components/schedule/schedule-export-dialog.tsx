import { ImageDown } from "lucide-react";
import { useState } from "react";

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
import { Label } from "@/components/ui/label";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";
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
}

export function ScheduleExportDialog({ onExport }: ScheduleExportDialogProps) {
  const [format, setFormat] = useState<ScheduleExportFormat>("png");
  const [isOpen, setIsOpen] = useState(false);
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
        <Button
          variant="outline"
          size="icon"
          title="Exportar calendario"
          onClick={() => setIsOpen(true)}
        >
          <ImageDown className="size-4" />
        </Button>
        <Sheet open={isOpen} onOpenChange={setIsOpen}>
          <SheetContent
            side="bottom"
            className="grid max-h-[90vh] grid-rows-[auto_minmax(0,1fr)] gap-0 overflow-hidden p-0"
          >
            <SheetHeader className="px-4 pt-4 pb-2">
              <SheetTitle>Exportar calendario</SheetTitle>
              <SheetDescription>
                Descarga el horario como imagen o archivo de calendario.
              </SheetDescription>
            </SheetHeader>
            <div className="min-h-0 overflow-y-auto px-4 pb-4">
              {formFields}
              <div className="mt-5">
                <Button onClick={handleExport} disabled={isExporting} className="w-full">
                  {isExporting ? "Exportando..." : format === "ics" ? "Descargar" : "Exportar"}
                </Button>
              </div>
            </div>
          </SheetContent>
        </Sheet>
      </>
    );
  }

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <Button variant="outline" size="icon" title="Exportar calendario">
          <ImageDown className="size-4" />
        </Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Exportar calendario</DialogTitle>
          <DialogDescription>
            Descarga el horario como imagen o archivo de calendario.
          </DialogDescription>
        </DialogHeader>

        {formFields}

        <DialogFooter>
          <Button onClick={handleExport} disabled={isExporting}>
            {isExporting ? "Exportando..." : format === "ics" ? "Descargar" : "Exportar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
