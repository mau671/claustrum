import { createFileRoute } from "@tanstack/react-router";
import { z } from "zod";

const searchSchema = z.object({
  page: z.number().catch(1).optional(),
  reportId: z.number().optional(),
});

export const Route = createFileRoute("/moderation/reports")({
  validateSearch: searchSchema,
});
