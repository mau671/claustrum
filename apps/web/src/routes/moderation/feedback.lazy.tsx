import { CheckIcon, FloppyDiskIcon } from "@hugeicons/core-free-icons";
import { createLazyFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";

import type { FeedbackRow } from "@/lib/feedback/api";

import { Button } from "@/components/ui/button";
import { Card, CardPanel } from "@/components/ui/card";
import { Frame, FrameFooter, FrameHeader, FrameTitle } from "@/components/ui/frame";
import { Icon } from "@/components/ui/icon";
import { Label } from "@/components/ui/label";
import { Spinner } from "@/components/ui/spinner";
import { Textarea } from "@/components/ui/textarea";
import {
  useFeedbackList,
  useMarkFeedbackAsReviewed,
  useReplyToFeedback,
} from "@/lib/feedback/hooks";
import { cn } from "@/lib/utils";

import { ModerationPagination } from "./-moderation-components";

const PAGE_SIZE = 20;

export const Route = createLazyFileRoute("/moderation/feedback")({
  component: FeedbackModerationPage,
});

function FeedbackModerationPage() {
  const navigate = useNavigate();
  const search = Route.useSearch() as { page?: number; feedbackId?: number };
  const page = search.page ?? 1;
  const queryPage = Math.max(page - 1, 0);
  const selectedFeedbackId = search.feedbackId ?? null;

  const feedbackQuery = useFeedbackList(PAGE_SIZE, queryPage * PAGE_SIZE);
  const markAsReviewed = useMarkFeedbackAsReviewed();
  const replyToFeedback = useReplyToFeedback();

  const [adminNotes, setAdminNotes] = useState<Record<number, string>>({});
  const [replyMessage, setReplyMessage] = useState<Record<number, string>>({});

  const feedbackRows = useMemo(
    () => (feedbackQuery.data ?? []) as FeedbackRow[],
    [feedbackQuery.data],
  );
  const hasMore = feedbackRows.length === PAGE_SIZE; // Approximation, we don't have total count yet.

  // Auto-select first if none selected
  useEffect(() => {
    if (feedbackRows.length > 0 && selectedFeedbackId === null && !feedbackQuery.isFetching) {
      const firstId = feedbackRows[0].id;
      void navigate({
        from: "/moderation/feedback",
        search: (prev: any) => ({ ...prev, feedbackId: firstId }),
        replace: true,
      });
    }
  }, [feedbackRows, selectedFeedbackId, navigate, feedbackQuery.isFetching]);

  const selectedFeedback = useMemo(
    () => feedbackRows.find((r) => r.id === selectedFeedbackId) ?? null,
    [feedbackRows, selectedFeedbackId],
  );

  const handlePageChange = (newPage: number) => {
    void navigate({
      from: "/moderation/feedback",
      search: { page: newPage },
    });
  };

  const getTypeLabel = (type: string) => {
    switch (type) {
      case "bug":
        return "Error";
      case "feature":
        return "Sugerencia";
      default:
        return "Otro";
    }
  };

  const getTypeColor = (type: string) => {
    switch (type) {
      case "bug":
        return "text-red-600 dark:text-red-400";
      case "feature":
        return "text-blue-600 dark:text-blue-400";
      default:
        return "text-foreground";
    }
  };

  return (
    <div className="flex flex-1 flex-col gap-4 lg:min-h-0 lg:flex-row">
      <Frame className="min-h-0 w-full shrink-0 flex-col lg:w-80 xl:w-96">
        <FrameHeader className="flex h-11 shrink-0 flex-row items-center px-4 py-2 sm:h-12 sm:px-5">
          <FrameTitle className="text-muted-foreground text-sm font-semibold">
            Retroalimentación
          </FrameTitle>
        </FrameHeader>

        <Card className="bg-card flex max-h-[340px] min-h-0 flex-1 flex-col overflow-hidden rounded-xl border shadow-xs/5 lg:max-h-none">
          <div className="divide-border/60 flex min-h-0 flex-1 flex-col divide-y overflow-y-auto">
            {feedbackQuery.isLoading ? (
              <div className="text-muted-foreground flex flex-1 items-center justify-center gap-2 p-6 text-sm">
                <Spinner className="size-4" />
                <span>Cargando retroalimentación…</span>
              </div>
            ) : feedbackRows.length === 0 ? (
              <p className="text-muted-foreground p-6 text-center text-sm">
                No hay retroalimentación pendiente.
              </p>
            ) : (
              feedbackRows.map((fb) => (
                <CardPanel
                  key={fb.id}
                  render={
                    <button type="button" aria-label={`Ver feedback de ${getTypeLabel(fb.type)}`} />
                  }
                  onClick={() => {
                    void navigate({
                      from: "/moderation/feedback",
                      search: (prev: any) => ({ ...prev, feedbackId: fb.id }),
                      replace: true,
                    });
                  }}
                  className={cn(
                    "focus-visible:bg-accent relative flex w-full flex-none cursor-pointer flex-col p-3.5 text-left transition-colors outline-none",
                    selectedFeedbackId === fb.id
                      ? "bg-accent/80 text-accent-foreground"
                      : "hover:bg-muted/50 text-foreground",
                    !fb.is_reviewed && selectedFeedbackId !== fb.id && "bg-muted/30",
                  )}
                >
                  {!fb.is_reviewed && (
                    <span className="absolute top-3 right-3 size-2 rounded-full bg-blue-500" />
                  )}
                  <div className="flex w-full items-center justify-between gap-2 pr-4">
                    <span className={cn("truncate font-medium", getTypeColor(fb.type))}>
                      {getTypeLabel(fb.type)}
                    </span>
                    <span className="text-muted-foreground shrink-0 text-xs">
                      {new Date(fb.created_at).toLocaleDateString()}
                    </span>
                  </div>
                  <span className="text-muted-foreground mt-0.5 line-clamp-2 pr-4 text-xs">
                    {fb.content}
                  </span>
                </CardPanel>
              ))
            )}
          </div>
        </Card>

        <FrameFooter className="flex h-12 shrink-0 items-center justify-center p-1.5 sm:h-13">
          <ModerationPagination
            page={queryPage}
            totalPages={hasMore ? queryPage + 2 : queryPage + 1}
            hasMore={hasMore}
            isFetching={feedbackQuery.isFetching}
            onPageChange={(p) => handlePageChange(p + 1)}
          />
        </FrameFooter>
      </Frame>

      {/* Right Detail Pane */}
      {selectedFeedback && (
        <Frame className="min-w-0 flex-1 flex-col lg:max-h-full lg:min-h-0">
          <FrameHeader className="flex h-11 shrink-0 flex-row items-center justify-between px-4 py-2 sm:h-12 sm:px-5">
            <FrameTitle
              className={cn(
                "min-w-0 flex-1 truncate text-base font-semibold sm:text-lg",
                getTypeColor(selectedFeedback.type),
              )}
            >
              {getTypeLabel(selectedFeedback.type)}
            </FrameTitle>

            <div className="flex shrink-0 items-center gap-3">
              <span className="text-muted-foreground text-xs">
                {new Date(selectedFeedback.created_at).toLocaleString()}
              </span>

              {!selectedFeedback.is_reviewed && (
                <Button
                  size="sm"
                  onClick={() => markAsReviewed.mutate(selectedFeedback.id)}
                  disabled={markAsReviewed.isPending}
                  className="h-8 shrink-0 px-2.5 text-xs"
                >
                  <Icon icon={CheckIcon} size={14} className="mr-1 size-3.5" />
                  Marcar como revisado
                </Button>
              )}
            </div>
          </FrameHeader>

          <Card className="bg-card min-h-0 flex-1 overflow-hidden rounded-xl border shadow-xs/5">
            <CardPanel className="flex min-h-0 flex-1 flex-col gap-4 overflow-y-auto p-4 sm:p-5">
              <div className="space-y-1.5">
                <h4 className="text-foreground text-sm font-medium">Comentario</h4>
                <blockquote className="border-primary/50 bg-muted/20 text-foreground rounded-r-lg border-l-2 py-2.5 pr-4 pl-3.5 text-sm leading-relaxed whitespace-pre-wrap">
                  {selectedFeedback.content}
                </blockquote>
              </div>

              <div className="space-y-1.5 pt-1">
                <div className="inline-flex w-full items-center justify-between gap-2">
                  <Label htmlFor="admin-notes" className="text-sm font-medium">
                    Notas internas
                  </Label>
                  <Label className="text-muted-foreground text-sm font-normal" render={<span />}>
                    Opcional
                  </Label>
                </div>
                <Textarea
                  id="admin-notes"
                  placeholder="Escribe notas sobre cómo se resolvió este caso..."
                  value={adminNotes[selectedFeedback.id] ?? selectedFeedback.admin_notes ?? ""}
                  onChange={(e) =>
                    setAdminNotes({ ...adminNotes, [selectedFeedback.id]: e.target.value })
                  }
                  className="bg-background min-h-[70px] text-xs sm:text-sm"
                />
              </div>

              <div className="space-y-1.5">
                <Label htmlFor="reply-message" className="text-sm font-medium">
                  Respuesta al usuario
                </Label>
                <Textarea
                  id="reply-message"
                  placeholder={
                    selectedFeedback.user_id
                      ? "Escribe un mensaje para enviarle al usuario..."
                      : "El usuario envió esto de forma anónima o no había iniciado sesión."
                  }
                  value={replyMessage[selectedFeedback.id] ?? ""}
                  onChange={(e) =>
                    setReplyMessage({ ...replyMessage, [selectedFeedback.id]: e.target.value })
                  }
                  disabled={!selectedFeedback.user_id}
                  className="bg-background min-h-[70px] text-xs sm:text-sm"
                />
              </div>
            </CardPanel>
          </Card>

          <FrameFooter className="flex h-12 shrink-0 items-center justify-end p-2 sm:h-13 sm:p-2.5">
            <div className="flex w-full flex-col gap-2 sm:flex-row sm:items-center sm:justify-end">
              <Button
                variant="outline"
                onClick={() => {
                  replyToFeedback.mutate({
                    id: selectedFeedback.id,
                    adminNotes:
                      adminNotes[selectedFeedback.id] ?? selectedFeedback.admin_notes ?? "",
                    replyMessage: "",
                  });
                }}
                disabled={replyToFeedback.isPending}
                className="w-full sm:w-auto"
              >
                {replyToFeedback.isPending ? (
                  <Spinner className="mr-1.5 size-4" />
                ) : (
                  <Icon icon={FloppyDiskIcon} size={16} className="mr-1.5 size-4" />
                )}
                Guardar notas
              </Button>

              <Button
                onClick={() => {
                  replyToFeedback.mutate({
                    id: selectedFeedback.id,
                    adminNotes:
                      adminNotes[selectedFeedback.id] ?? selectedFeedback.admin_notes ?? "",
                    replyMessage: replyMessage[selectedFeedback.id] ?? "",
                  });
                }}
                disabled={replyToFeedback.isPending || !selectedFeedback.user_id}
                className="w-full sm:w-auto"
              >
                {replyToFeedback.isPending ? <Spinner className="mr-1.5 size-4" /> : null}
                Enviar respuesta al usuario
              </Button>
            </div>
          </FrameFooter>
        </Frame>
      )}
    </div>
  );
}
