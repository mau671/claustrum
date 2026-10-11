import { Login01Icon, MoreVerticalIcon, Settings01Icon } from "@hugeicons/core-free-icons";
import { Link } from "@tanstack/react-router";

import { Icon } from "@/components/ui/icon";
import {
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  useSidebar,
} from "@/components/ui/sidebar";
import { UserAvatar } from "@/components/ui/user-avatar";
import { UserMenuDropdown } from "@/components/user-menu-dropdown";

export function NavUser({
  user,
}: {
  user?: {
    id?: string;
    name: string;
    email: string;
  } | null;
}) {
  const { isMobile } = useSidebar();

  if (!user) {
    return (
      <SidebarMenu>
        <SidebarMenuItem>
          <SidebarMenuButton
            render={<Link to="/auth/signin" />}
            size="lg"
            className="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
          >
            <Icon icon={Login01Icon} size={16} className="size-4" />
            <span className="flex-1 text-left">Iniciar sesión</span>
          </SidebarMenuButton>
        </SidebarMenuItem>
        <SidebarMenuItem>
          <SidebarMenuButton
            render={<Link to="/settings/appearance" />}
            size="lg"
            className="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
          >
            <Icon icon={Settings01Icon} size={16} className="size-4" />
            <span className="flex-1 text-left">Configuración</span>
          </SidebarMenuButton>
        </SidebarMenuItem>
      </SidebarMenu>
    );
  }

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
              <UserAvatar id={user.id} name={user.name} email={user.email} className="size-8" />
              <div className="grid flex-1 text-left text-sm leading-tight">
                <span className="truncate font-medium">{user.name}</span>
                <span className="text-muted-foreground truncate text-xs">{user.email}</span>
              </div>
              <Icon icon={MoreVerticalIcon} size={16} className="ml-auto size-4" />
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
