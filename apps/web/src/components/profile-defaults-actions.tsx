import { FloppyDiskIcon, UserIcon } from "@hugeicons/core-free-icons";

import { Button } from "@/components/ui/button";
import { Icon } from "@/components/ui/icon";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";

export function ProfileDefaultsActions({
  isActive,
  canUseProfile,
  isAuthenticated,
  onUseProfile,
  onSaveLocal,
}: {
  isActive: boolean;
  canUseProfile: boolean;
  isAuthenticated: boolean;
  onUseProfile: () => void;
  onSaveLocal: () => void;
}) {
  return (
    <>
      {canUseProfile && (
        <Button
          type="button"
          variant={isActive ? "secondary" : "outline"}
          size="sm"
          onClick={onUseProfile}
          disabled={isActive}
          className="h-8 shrink-0 gap-1.5 rounded-lg text-xs"
        >
          <Icon icon={UserIcon} size={14} />
          {isActive ? "Perfil activo" : "Usar mi perfil"}
        </Button>
      )}
      {!isAuthenticated && (
        <Tooltip>
          <TooltipTrigger
            render={
              <Button
                type="button"
                variant={isActive ? "secondary" : "outline"}
                size="sm"
                onClick={onSaveLocal}
                onPointerDown={(event) => event.preventDefault()}
                disabled={isActive}
                className="h-8 shrink-0 gap-1.5 rounded-lg text-xs"
              />
            }
          >
            <Icon icon={FloppyDiskIcon} size={14} />
            {isActive ? "Guardado" : "Guardar"}
          </TooltipTrigger>
          <TooltipContent>Solo se guarda en este dispositivo</TooltipContent>
        </Tooltip>
      )}
    </>
  );
}
