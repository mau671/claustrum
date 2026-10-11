import { Alert02Icon, BubbleChatIcon, Comment01Icon, File01Icon } from "@hugeicons/core-free-icons";
import { Link, Outlet, useLocation, useNavigate } from "@tanstack/react-router";
import { useEffect, useRef } from "react";

import { Badge } from "@/components/ui/badge";
import { Icon } from "@/components/ui/icon";
import { ScrollArea } from "@/components/ui/scroll-area";
import { useModerationCounts } from "@/lib/hooks/use-moderation";
import { useAuthUser } from "@/lib/hooks/use-queries";
import { useCanModerate } from "@/lib/hooks/use-roles";
import { cn } from "@/lib/utils";

export function ModerationLayout() {
  const navigate = useNavigate();
  const location = useLocation();
  const { data: authUser, isLoading: isAuthLoading } = useAuthUser();
  const canModerate = useCanModerate();

  useEffect(() => {
    if (isAuthLoading) return;
    if (!authUser) {
      void navigate({ to: "/auth/signin", replace: true });
      return;
    }
    if (!canModerate) {
      void navigate({ to: "/overview", replace: true });
    }
  }, [authUser, canModerate, isAuthLoading, navigate]);

  const countsQuery = useModerationCounts(canModerate);

  if (isAuthLoading) {
    return (
      <div className="flex flex-1 items-center justify-center p-6">
        <p className="text-muted-foreground text-sm">Verificando permisos…</p>
      </div>
    );
  }

  if (!authUser || !canModerate) {
    return null;
  }

  const reviewPending = countsQuery.data?.pendingReviews ?? 0;
  const evaluationPending = countsQuery.data?.pendingEvaluations ?? 0;
  const reviewReportsPending = countsQuery.data?.pendingReviewReports ?? 0;
  const feedbackPending = countsQuery.data?.pendingFeedback ?? 0;

  const navItems = [
    {
      label: "Reseñas",
      path: "/moderation/reviews",
      icon: Comment01Icon,
      count: reviewPending,
    },
    {
      label: "Evaluaciones",
      path: "/moderation/evaluations",
      icon: File01Icon,
      count: evaluationPending,
    },
    {
      label: "Reportes",
      path: "/moderation/reports",
      icon: Alert02Icon,
      count: reviewReportsPending,
    },
    {
      label: "Retroalimentación",
      path: "/moderation/feedback",
      icon: BubbleChatIcon,
      count: feedbackPending,
    },
  ];

  const navRefs = useRef<Record<string, HTMLAnchorElement | null>>({});

  useEffect(() => {
    const activeItem = navItems.find((item) => location.pathname.startsWith(item.path));
    if (activeItem) {
      const el = navRefs.current[activeItem.path];
      if (el) {
        el.scrollIntoView({ behavior: "smooth", block: "nearest", inline: "nearest" });
      }
    }
  }, [location.pathname]);

  return (
    <div className="flex h-full min-h-0 flex-1 flex-col gap-6 px-4 py-6 lg:px-6">
      <div className="w-full">
        <ScrollArea scrollFade className="w-full">
          <nav className="border-border/60 bg-muted/40 flex w-max min-w-full items-center gap-1.5 rounded-xl border p-1">
            {navItems.map((item) => {
              const isActive = location.pathname.startsWith(item.path);
              return (
                <Link
                  key={item.path}
                  to={item.path}
                  ref={(node) => {
                    navRefs.current[item.path] = node;
                  }}
                  className={cn(
                    "flex items-center gap-2 rounded-lg px-3.5 py-2 text-sm font-medium whitespace-nowrap transition-colors",
                    isActive
                      ? "bg-background text-foreground shadow-xs"
                      : "text-muted-foreground hover:bg-background/50 hover:text-foreground",
                  )}
                >
                  <Icon icon={item.icon} size={16} className="size-4 shrink-0" />
                  <span>{item.label}</span>
                  {item.count > 0 && (
                    <Badge
                      variant={isActive ? "default" : "secondary"}
                      className="h-5 min-w-5 rounded-full px-1.5 text-[10px] leading-none font-semibold"
                    >
                      {item.count > 99 ? "99+" : item.count}
                    </Badge>
                  )}
                </Link>
              );
            })}
          </nav>
        </ScrollArea>
      </div>

      <Outlet />
    </div>
  );
}
