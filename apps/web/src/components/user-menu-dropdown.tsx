import { Logout01Icon, Settings01Icon } from "@hugeicons/core-free-icons";
import { Link, useNavigate } from "@tanstack/react-router";

import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
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

interface UserMenuDropdownProps {
  user: {
    name: string;
    email: string;
    avatar?: string;
  };
  trigger: React.ReactNode;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  align?: "start" | "center" | "end";
  side?: "top" | "right" | "bottom" | "left";
  sideOffset?: number;
  contentClass?: string;
}

import { useQueryClient } from "@tanstack/react-query";

import { resetSupabaseAuthTokenState } from "@/lib/supabase/browser-client";

export function UserMenuDropdown({
  user,
  trigger,
  open,
  onOpenChange,
  align = "end",
  side = "bottom",
  sideOffset = 4,
  contentClass = "w-56 rounded-lg",
}: UserMenuDropdownProps) {
  const navigate = useNavigate();
  const queryClient = useQueryClient();

  return (
    <DropdownMenu open={open} onOpenChange={onOpenChange}>
      <DropdownMenuTrigger render={trigger as React.ReactElement} />
      <DropdownMenuContent
        className={contentClass}
        side={side as any}
        align={align}
        sideOffset={sideOffset}
      >
        <DropdownMenuLabel className="p-0 font-normal">
          <div className="flex items-center gap-2 px-1 py-1.5 text-left text-sm">
            <Avatar className="size-8 rounded-lg">
              <AvatarImage src={user.avatar} alt={user.name} />
              <AvatarFallback className="rounded-lg">
                {user.name.charAt(0).toUpperCase()}
              </AvatarFallback>
            </Avatar>
            <div className="grid flex-1 text-left text-sm leading-tight">
              <span className="truncate font-medium">{user.name}</span>
              <span className="text-muted-foreground truncate text-xs">{user.email}</span>
            </div>
          </div>
        </DropdownMenuLabel>
        <DropdownMenuSeparator />
        <DropdownMenuGroup>
          <DropdownMenuLinkItem render={<Link to="/settings/profile" />}>
            <Icon icon={Settings01Icon} size={16} className="size-4" />
            Configuración
          </DropdownMenuLinkItem>
        </DropdownMenuGroup>
        <DropdownMenuSeparator />
        <DropdownMenuItem
          onClick={async () => {
            await signOut();
            resetSupabaseAuthTokenState();
            queryClient.clear();
            void navigate({ to: "/auth/signin" });
          }}
        >
          <Icon icon={Logout01Icon} size={16} className="size-4" />
          Cerrar sesión
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
