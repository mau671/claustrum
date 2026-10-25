import { defineConfig } from "drizzle-kit";

export default defineConfig({
  out: "./data/migrations",
  dialect: "postgresql",
  schema: "./src/db/schema.ts",
  dbCredentials: {
    url: process.env.DATABASE_URL || "postgresql://postgres:postgres@127.0.0.1:54322/postgres",
  },
});
