import { createFileRoute } from "@tanstack/react-router";
import { z } from "zod";

const searchSchema = z.object({
  page: z.number().catch(1).optional(),
  evaluationId: z.number().optional(),
});

export const Route = createFileRoute("/moderation/evaluations")({
  validateSearch: searchSchema,
});
