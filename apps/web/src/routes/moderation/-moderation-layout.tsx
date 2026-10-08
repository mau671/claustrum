import { Link, Outlet, useNavigate } from "@tanstack/react-router";
import { useEffect } from "react";

import { useModerationCounts } from "@/lib/hooks/use-moderation";
import { useIsAdmin } from "@/lib/hooks/use-professor-reviews";
import { useAuthUser } from "@/lib/hooks/use-queries";

export function ModerationLayout() {
  const navigate = useNavigate();
  const { data: authUser, isLoading: isAuthLoading } = useAuthUser();
  const isAdminQuery = useIsAdmin(authUser?.id ?? null);

  const canModerate = !!authUser && isAdminQuery.data === true;

  useEffect(() => {
    if (isAuthLoading || isAdminQuery.isLoading) return;
    if (!authUser) {
      void navigate({ to: "/auth/signin", replace: true });
      return;
    }
    if (!canModerate) {
      void navigate({ to: "/overview", replace: true });
    }
  }, [authUser, canModerate, isAuthLoading, isAdminQuery.isLoading, navigate]);

  const countsQuery = useModerationCounts(canModerate);

  if (isAuthLoading || isAdminQuery.isLoading) {
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

  return (
    <div className="flex h-full min-h-0 flex-1 flex-col gap-6 px-4 py-6 lg:px-6">
      <div className="flex shrink-0 scrollbar-none items-center gap-1 overflow-x-auto rounded-lg border p-1 text-sm">
        <Link
          to="/moderation/reviews"
          className="relative flex flex-1 items-center justify-center px-3 py-2 text-sm font-medium transition-colors sm:flex-initial"
        >
          {({ isActive }) => (
            <>
              Reseñas
              {reviewPending > 0 && (
                <span className="bg-foreground text-background ml-1.5 inline-flex h-5 min-w-5 items-center justify-center rounded-full px-1 text-[10px] leading-none font-semibold">
                  {reviewPending > 99 ? "99+" : reviewPending}
                </span>
              )}
              {isActive && (
                <span className="bg-foreground absolute right-2 bottom-0 left-2 h-0.5 rounded-full" />
              )}
            </>
          )}
        </Link>
        <Link
          to="/moderation/evaluations"
          className="relative flex flex-1 items-center justify-center px-3 py-2 text-sm font-medium transition-colors sm:flex-initial"
        >
          {({ isActive }) => (
            <>
              Evaluaciones
              {evaluationPending > 0 && (
                <span className="bg-foreground text-background ml-1.5 inline-flex h-5 min-w-5 items-center justify-center rounded-full px-1 text-[10px] leading-none font-semibold">
                  {evaluationPending > 99 ? "99+" : evaluationPending}
                </span>
              )}
              {isActive && (
                <span className="bg-foreground absolute right-2 bottom-0 left-2 h-0.5 rounded-full" />
              )}
            </>
          )}
        </Link>
        <Link
          to="/moderation/reports"
          className="relative flex flex-1 items-center justify-center px-3 py-2 text-sm font-medium transition-colors sm:flex-initial"
        >
          {({ isActive }) => (
            <>
              Reportes
              {reviewReportsPending > 0 && (
                <span className="bg-foreground text-background ml-1.5 inline-flex h-5 min-w-5 items-center justify-center rounded-full px-1 text-[10px] leading-none font-semibold">
                  {reviewReportsPending > 99 ? "99+" : reviewReportsPending}
                </span>
              )}
              {isActive && (
                <span className="bg-foreground absolute right-2 bottom-0 left-2 h-0.5 rounded-full" />
              )}
            </>
          )}
        </Link>
        <Link
          to="/moderation/feedback"
          className="relative flex flex-1 items-center justify-center px-3 py-2 text-sm font-medium transition-colors sm:flex-initial"
        >
          {({ isActive }) => (
            <>
              Retroalimentación
              {feedbackPending > 0 && (
                <span className="bg-foreground text-background ml-1.5 inline-flex h-5 min-w-5 items-center justify-center rounded-full px-1 text-[10px] leading-none font-semibold">
                  {feedbackPending > 99 ? "99+" : feedbackPending}
                </span>
              )}
              {isActive && (
                <span className="bg-foreground absolute right-2 bottom-0 left-2 h-0.5 rounded-full" />
              )}
            </>
          )}
        </Link>
      </div>

      <Outlet />
    </div>
  );
}
