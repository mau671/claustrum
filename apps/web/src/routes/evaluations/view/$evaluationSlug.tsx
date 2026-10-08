import { createFileRoute, notFound } from "@tanstack/react-router";

export const Route = createFileRoute("/evaluations/view/$evaluationSlug")({
  loader: ({ params }) => {
    const match = params.evaluationSlug.match(/^(\d+)\.pdf$/);
    if (!match) throw notFound();
    return { evaluationId: parseInt(match[1], 10) };
  },
});
