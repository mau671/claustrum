import { Notification03Icon, TickDouble01Icon } from "@hugeicons/core-free-icons";
import { HugeiconsIcon } from "@hugeicons/react";

import { Button } from "@/components/ui/button";
import { Card, CardPanel } from "@/components/ui/card";
import { Dialog, DialogHeader, DialogPopup, DialogTitle } from "@/components/ui/dialog";
import { Drawer, DrawerHeader, DrawerPopup, DrawerTitle } from "@/components/ui/drawer";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { useIsMobile } from "@/hooks/use-mobile";
import {
  useMarkAllNotificationsAsRead,
  useMarkNotificationAsRead,
  useNotifications,
} from "@/lib/hooks/use-notifications";
import { cn } from "@/lib/utils";

interface NotificationsDialogProps {
  userId?: string | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function NotificationsDialog({ userId, open, onOpenChange }: NotificationsDialogProps) {
  const isMobile = useIsMobile();
  const notificationsQuery = useNotifications(userId ?? null);
  const markAsRead = useMarkNotificationAsRead();
  const markAllAsRead = useMarkAllNotificationsAsRead();
  const unreadCount = notificationsQuery.data?.filter((n) => !n.is_read).length ?? 0;

  const content = (
    <div className="flex flex-col">
      {notificationsQuery.isLoading ? (
        <div className="text-muted-foreground p-6 text-center text-sm">Cargando...</div>
      ) : !notificationsQuery.data || notificationsQuery.data.length === 0 ? (
        <div className="text-muted-foreground p-6 text-center text-sm">
          No tienes notificaciones.
        </div>
      ) : (
        notificationsQuery.data.map((n, idx) => (
          <div key={n.id} className="w-full">
            {idx > 0 && <Separator className="w-full" />}
            <button
              type="button"
              className={cn(
                "hover:bg-muted/50 focus-visible:bg-muted/50 flex w-full cursor-pointer items-start gap-3 px-4 py-3 text-left transition-colors focus-visible:outline-none",
                !n.is_read && "bg-muted/25",
              )}
              onClick={() => {
                if (!n.is_read) markAsRead.mutate(n.id);
              }}
            >
              <div
                className={cn(
                  "mt-0.5 flex size-8 shrink-0 items-center justify-center rounded-full",
                  !n.is_read ? "bg-primary/10 text-primary" : "bg-muted text-muted-foreground",
                )}
              >
                <HugeiconsIcon icon={Notification03Icon} size={16} className="size-4" />
              </div>

              <div className="flex min-w-0 flex-1 flex-col gap-0.5">
                <div className="flex items-center justify-between gap-2">
                  <span
                    className={cn(
                      "truncate text-sm tracking-tight",
                      !n.is_read
                        ? "text-foreground font-semibold"
                        : "text-foreground/80 font-medium",
                    )}
                  >
                    {n.title}
                  </span>
                  {!n.is_read && <span className="bg-primary size-2 shrink-0 rounded-full" />}
                </div>
                <p className="text-muted-foreground line-clamp-2 text-xs leading-relaxed">
                  {n.message}
                </p>
                <span className="text-muted-foreground/75 mt-0.5 text-[10px]">
                  {new Date(n.created_at).toLocaleString()}
                </span>
              </div>
            </button>
          </div>
        ))
      )}
    </div>
  );

  if (isMobile) {
    return (
      <Drawer open={open} onOpenChange={onOpenChange}>
        <DrawerPopup
          showBar
          className="grid max-h-[85dvh] grid-rows-[auto_minmax(0,1fr)] overflow-hidden"
        >
          <DrawerHeader className="flex flex-row items-center justify-between gap-2 px-4 pt-3 pb-2 text-left">
            <div className="flex items-center gap-2">
              <DrawerTitle className="text-base font-semibold">Notificaciones</DrawerTitle>
              {unreadCount > 0 && (
                <span className="bg-primary/10 text-primary rounded-full px-1.5 py-0.5 text-[11px] font-semibold">
                  {unreadCount}
                </span>
              )}
            </div>
            <Button
              type="button"
              variant="ghost"
              size="sm"
              onClick={() => {
                if (userId && unreadCount > 0) {
                  markAllAsRead.mutate(userId);
                }
              }}
              disabled={!userId || unreadCount === 0 || markAllAsRead.isPending}
              className="text-muted-foreground hover:text-foreground !h-7 gap-1.5 px-2 text-xs font-medium"
            >
              <HugeiconsIcon icon={TickDouble01Icon} size={15} className="size-3.5" />
              <span>Marcar leído</span>
            </Button>
          </DrawerHeader>
          <ScrollArea className="min-h-0">{content}</ScrollArea>
        </DrawerPopup>
      </Drawer>
    );
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogPopup className="sm:max-w-md">
        <DialogHeader className="flex flex-row items-center justify-between gap-2 pr-8">
          <div className="flex items-center gap-2">
            <DialogTitle className="text-base font-semibold">Notificaciones</DialogTitle>
            {unreadCount > 0 && (
              <span className="bg-primary/10 text-primary rounded-full px-1.5 py-0.5 text-[11px] font-semibold">
                {unreadCount}
              </span>
            )}
          </div>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={() => {
              if (userId && unreadCount > 0) {
                markAllAsRead.mutate(userId);
              }
            }}
            disabled={!userId || unreadCount === 0 || markAllAsRead.isPending}
            className="text-muted-foreground hover:text-foreground !h-7 gap-1.5 px-2 text-xs font-medium"
          >
            <HugeiconsIcon icon={TickDouble01Icon} size={15} className="size-3.5" />
            <span>Marcar leído</span>
          </Button>
        </DialogHeader>

        <Card className="border-border/60 bg-background overflow-hidden rounded-xl border shadow-xs">
          <CardPanel className="p-0">
            <ScrollArea className="max-h-[380px]">{content}</ScrollArea>
          </CardPanel>
        </Card>
      </DialogPopup>
    </Dialog>
  );
}
