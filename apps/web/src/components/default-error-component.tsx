import type { ErrorComponentProps } from "@tanstack/react-router";

import * as React from "react";

import { Button } from "@/components/ui/button";
import {
  Empty,
  EmptyContent,
  EmptyDescription,
  EmptyHeader,
  EmptyTitle,
} from "@/components/ui/empty";
import { Spinner } from "@/components/ui/spinner";
import { handleStaleChunkReload, isModuleNotFoundError } from "@/lib/chunk-error";

export function DefaultErrorComponent({ error, reset }: ErrorComponentProps): React.ReactElement {
  const isChunkError = isModuleNotFoundError(error);
  const [reloadThrottled, setReloadThrottled] = React.useState(false);

  React.useEffect(() => {
    if (isChunkError) {
      const triggered = handleStaleChunkReload();
      if (!triggered) {
        setReloadThrottled(true);
      }
    }
  }, [isChunkError]);

  if (isChunkError) {
    if (reloadThrottled) {
      return (
        <div className="container mx-auto px-4 py-16">
          <Empty>
            <EmptyHeader>
              <EmptyTitle>Nueva versión disponible</EmptyTitle>
              <EmptyDescription>
                Se ha publicado una actualización de la aplicación. Por favor, actualiza la página
                para continuar.
              </EmptyDescription>
            </EmptyHeader>
            <EmptyContent>
              <Button onClick={() => window.location.assign(window.location.href)}>
                Actualizar página
              </Button>
            </EmptyContent>
          </Empty>
        </div>
      );
    }

    return (
      <div className="flex h-[50vh] w-full flex-col items-center justify-center gap-3">
        <Spinner className="text-muted-foreground size-6" />
        <p className="text-muted-foreground text-xs">Cargando actualización...</p>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-16">
      <Empty>
        <EmptyHeader>
          <EmptyTitle>Ocurrió un error inesperado</EmptyTitle>
          <EmptyDescription>
            {error instanceof Error ? error.message : "Algo salió mal al cargar esta sección."}
          </EmptyDescription>
        </EmptyHeader>
        <EmptyContent>
          <Button onClick={reset}>Reintentar</Button>
        </EmptyContent>
      </Empty>
    </div>
  );
}
