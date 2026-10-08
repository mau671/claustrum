import { QueryClientProvider, dehydrate, hydrate } from "@tanstack/react-query";
import { createRouter as createTanStackRouter } from "@tanstack/react-router";

import { createQueryClient } from "@/lib/query-client";

// Import the generated route tree
import { routeTree } from "./routeTree.gen";

// Create a new router instance
export const getRouter = () => {
  const queryClient = createQueryClient();

  const router = createTanStackRouter({
    routeTree,
    scrollRestoration: true,
    defaultPreload: false,
    defaultPreloadStaleTime: 0,
    defaultStructuralSharing: true,
    context: {
      queryClient,
    },
    dehydrate: () => {
      return {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        queryClientState: dehydrate(queryClient) as any,
      };
    },
    hydrate: (dehydrated) => {
      if (dehydrated.queryClientState) {
        hydrate(queryClient, dehydrated.queryClientState);
      }
    },
    Wrap: ({ children }) => (
      <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
    ),
  });

  return router;
};

export const createRouter = getRouter;

// Register the router instance for type safety
declare module "@tanstack/react-router" {
  interface Register {
    router: ReturnType<typeof createRouter>;
  }
}
