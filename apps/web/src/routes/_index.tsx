import { createFileRoute, redirect } from "@tanstack/react-router";

export const Route = createFileRoute("/_index")({
  beforeLoad: () => {
    throw redirect({
      to: "/schedule",
      statusCode: 301,
    });
  },
});
