import { createFileRoute } from "@tanstack/react-router";
import { z } from "zod";

const searchSchema = z.object({
  page: z.number().catch(1).optional(),
  search: z.string().optional(),
  role: z.enum(["all", "admin", "moderator", "user"]).catch("all").optional(),
  banned: z.enum(["all", "true", "false"]).catch("all").optional(),
  sortBy: z
    .enum(["name", "email", "role", "banned", "createdAt", "updatedAt"])
    .catch("createdAt")
    .optional(),
  sortDesc: z.boolean().catch(true).optional(),
});

export const Route = createFileRoute("/moderation/users")({
  validateSearch: searchSchema,
});
