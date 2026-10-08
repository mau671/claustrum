import {
  jwtClient,
  magicLinkClient,
  twoFactorClient,
  lastLoginMethodClient,
} from "better-auth/client/plugins";
import { createAuthClient } from "better-auth/react";

import { getApiBaseUrl } from "@/lib/env/public";

const apiBaseUrl =
  getApiBaseUrl() ??
  (typeof window !== "undefined" ? `${window.location.origin}/api` : "http://localhost:3000/api");

export const authClient = createAuthClient({
  baseURL: `${apiBaseUrl}/auth`,
  plugins: [
    lastLoginMethodClient(),
    magicLinkClient(),
    twoFactorClient({
      twoFactorPage: "/auth/2fa",
    }),
    jwtClient(),
  ],
});

export const { signIn, signUp, signOut, useSession, getSession } = authClient;
