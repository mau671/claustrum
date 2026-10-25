import { Alert02Icon, BubbleChatIcon, Comment01Icon, File01Icon } from "@hugeicons/core-free-icons";
import { Link, Outlet, useLocation, useNavigate } from "@tanstack/react-router";
import { useEffect } from "react";

import { createFilledIcon, Icon } from "@/components/ui/icon";
import { ScrollArea } from "@/components/ui/scroll-area";
import { useModerationCounts } from "@/lib/hooks/use-moderation";
import { useAuthUser } from "@/lib/hooks/use-queries";
import { useCanModerate } from "@/lib/hooks/use-roles";
import { cn } from "@/lib/utils";

const filledCommentIcon = createFilledIcon(Comment01Icon, { invertKeys: ["0"], fillKeys: ["1"] });
const filledFileIcon = createFilledIcon(File01Icon, ["0", "1"]);
const filledAlertIcon = createFilledIcon(Alert02Icon, ["1", "2"]);
const filledBubbleIcon = createFilledIcon(BubbleChatIcon, ["1"]);

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
      filledIcon: filledCommentIcon,
      count: reviewPending,
    },
    {
      label: "Evaluaciones",
      path: "/moderation/evaluations",
      icon: File01Icon,
      filledIcon: filledFileIcon,
      count: evaluationPending,
    },
    {
      label: "Reportes",
      path: "/moderation/reports",
      icon: Alert02Icon,
      filledIcon: filledAlertIcon,
      count: reviewReportsPending,
    },
    {
      label: "Retroalimentación",
      path: "/moderation/feedback",
      icon: BubbleChatIcon,
      filledIcon: filledBubbleIcon,
      count: feedbackPending,
    },
  ];

  return (
    <div className="flex min-h-full flex-1 flex-col gap-6 px-4 py-6 lg:h-[calc(100dvh-var(--header-height))] lg:min-h-0 lg:flex-none lg:overflow-hidden lg:px-6">
      {/* Tabs principales de moderación */}
      <div className="w-full">
        <ScrollArea scrollFade className="w-full [&_[data-slot=scroll-area-scrollbar]]:hidden">
          <nav className="border-border/60 bg-muted/40 flex w-max min-w-full items-center gap-1.5 rounded-xl border p-1">
            {navItems.map((item) => {
              const isActive = location.pathname.startsWith(item.path);
              return (
                <Link
                  key={item.path}
                  to={item.path}
                  className={cn(
                    "flex items-center gap-2 rounded-lg px-3.5 py-2 text-sm font-medium whitespace-nowrap transition-colors",
                    isActive
                      ? "bg-background text-foreground shadow-xs"
                      : "text-muted-foreground hover:bg-background/50 hover:text-foreground",
                  )}
                >
                  <Icon
                    icon={isActive ? item.filledIcon : item.icon}
                    size={16}
                    className="size-4 shrink-0"
                  />
                  <span>{item.label}</span>
                  {item.count > 0 && (
                    <span
                      className={cn(
                        "inline-flex h-5 min-w-5 shrink-0 items-center justify-center rounded-full text-[11px] leading-none font-semibold tabular-nums",
                        item.count > 9 ? "px-1.5" : "size-5 p-0",
                        isActive
                          ? "bg-primary text-primary-foreground"
                          : "bg-muted-foreground/15 text-muted-foreground",
                      )}
                    >
                      {item.count > 99 ? "99+" : item.count}
                    </span>
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
