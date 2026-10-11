import {
  jwtClient,
  magicLinkClient,
  twoFactorClient,
  lastLoginMethodClient,
  adminClient,
} from "better-auth/client/plugins";
import { createAuthClient } from "better-auth/react";

import { getApiBaseUrl } from "@/lib/env/public";

import { ac, roles } from "./permissions";

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
    adminClient({ ac, roles }),
  ],
});

export const { signIn, signUp, signOut, useSession, getSession } = authClient;
