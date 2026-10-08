import { Link } from "@tanstack/react-router";
import { EllipsisVertical, LogIn, Settings } from "lucide-react";

import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import {
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  useSidebar,
} from "@/components/ui/sidebar";
import { UserMenuDropdown } from "@/components/user-menu-dropdown";

export function NavUser({
  user,
}: {
  user?: {
    name: string;
    email: string;
    avatar: string;
  } | null;
}) {
  const { isMobile } = useSidebar();

  if (!user) {
    return (
      <SidebarMenu>
        <SidebarMenuItem>
          <SidebarMenuButton
            asChild
            size="lg"
            className="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
          >
            <Link to="/auth/signin">
              <LogIn className="size-4" />
              <span className="flex-1 text-left">Iniciar sesión</span>
            </Link>
          </SidebarMenuButton>
        </SidebarMenuItem>
        <SidebarMenuItem>
          <SidebarMenuButton
            asChild
            size="lg"
            className="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
          >
            <Link to="/settings/appearance">
              <Settings className="size-4" />
              <span className="flex-1 text-left">Configuración</span>
            </Link>
          </SidebarMenuButton>
        </SidebarMenuItem>
      </SidebarMenu>
    );
  }

  const userInitial = user.name.charAt(0).toUpperCase();

  return (
    <SidebarMenu>
      <SidebarMenuItem>
        <UserMenuDropdown
          user={user}
          trigger={
            <SidebarMenuButton
              size="lg"
              className="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
            >
              <Avatar className="size-8 rounded-full">
                <AvatarImage src={user.avatar} alt={user.name} />
                <AvatarFallback>{userInitial}</AvatarFallback>
              </Avatar>
              <div className="grid flex-1 text-left text-sm leading-tight">
                <span className="truncate font-medium">{user.name}</span>
                <span className="text-muted-foreground truncate text-xs">{user.email}</span>
              </div>
              <EllipsisVertical className="ml-auto size-4" />
            </SidebarMenuButton>
          }
          align="end"
          side={isMobile ? "bottom" : "right"}
          sideOffset={4}
          contentClass="w-56 rounded-lg"
        />
      </SidebarMenuItem>
    </SidebarMenu>
  );
}
