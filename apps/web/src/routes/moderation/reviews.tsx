import { createFileRoute } from "@tanstack/react-router";
import { z } from "zod";

const searchSchema = z.object({
  page: z.number().catch(1).optional(),
  reviewId: z.number().optional(),
  status: z.enum(["all", "pending", "approved", "rejected"]).catch("all").optional(),
});

export const Route = createFileRoute("/moderation/reviews")({
  validateSearch: searchSchema,
});
