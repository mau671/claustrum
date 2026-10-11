import { Logout01Icon, Settings01Icon } from "@hugeicons/core-free-icons";
import { useQueryClient } from "@tanstack/react-query";
import { Link, useNavigate } from "@tanstack/react-router";

import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuLinkItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Icon } from "@/components/ui/icon";
import { signOut } from "@/lib/auth/client";
import { resetSupabaseAuthTokenState } from "@/lib/supabase/browser-client";

export function UserMenu({
  user,
  trigger,
  open,
  onOpenChange,
}: {
  user: {
    id?: string;
    name: string;
    email: string;
  };
  trigger: React.ReactNode;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
}) {
  const navigate = useNavigate();
  const queryClient = useQueryClient();

  return (
    <DropdownMenu open={open} onOpenChange={onOpenChange}>
      <DropdownMenuTrigger render={trigger as React.ReactElement} />
      <DropdownMenuContent className="w-56" align="end" side="bottom" sideOffset={8}>
        <DropdownMenuGroup>
          <DropdownMenuLabel className="p-0 font-normal">
            <div className="flex flex-col gap-0.5 px-2 py-1.5 text-left text-sm">
              <span className="truncate font-medium">{user.name}</span>
              <span className="text-muted-foreground truncate text-xs">{user.email}</span>
            </div>
          </DropdownMenuLabel>
        </DropdownMenuGroup>
        <DropdownMenuSeparator />
        <DropdownMenuGroup>
          <DropdownMenuLinkItem render={<Link to="/settings/profile" />}>
            <Icon icon={Settings01Icon} size={16} />
            Configuración
          </DropdownMenuLinkItem>
        </DropdownMenuGroup>
        <DropdownMenuSeparator />
        <DropdownMenuItem
          onClick={async () => {
            await signOut();
            resetSupabaseAuthTokenState();
            queryClient.clear();
            void navigate({ to: "/" });
          }}
        >
          <Icon icon={Logout01Icon} size={16} />
          Cerrar sesión
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
