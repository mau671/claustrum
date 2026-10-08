import { createFileRoute } from "@tanstack/react-router";
import { z } from "zod";

const searchSchema = z.object({
  page: z.number().catch(1).optional(),
});

export const Route = createFileRoute("/moderation/feedback")({
  validateSearch: searchSchema,
});
