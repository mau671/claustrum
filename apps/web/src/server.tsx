import handler, { createServerEntry } from "@tanstack/react-start/server-entry";
// @ts-ignore
import { env } from "cloudflare:workers";

interface WorkerEnv {
  API?: {
    fetch: (request: Request) => Promise<Response>;
  };
}

export default createServerEntry({
  fetch(request) {
    const url = new URL(request.url);
    if (
      url.pathname.startsWith("/api") ||
      url.pathname.startsWith("/docs") ||
      url.pathname === "/openapi.json"
    ) {
      const apiBinding = (env as WorkerEnv | undefined)?.API;
      if (apiBinding) {
        return apiBinding.fetch(request);
      }
    }

    return handler.fetch(request);
  },
});
