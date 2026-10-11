import { createServerFn } from "@tanstack/react-start";
import { getRequest } from "@tanstack/react-start/server";
// @ts-ignore
import { env } from "cloudflare:workers";

import type { UserProfileContextRow } from "@/lib/types";

import { getApiBaseUrl } from "@/lib/env/public";

const getBaseUrl = () => {
  return getApiBaseUrl() ?? "http://localhost:3000/api";
};

async function fetchMeData() {
  const req = getRequest();
  if (!req) return null;

  const fetchHeaders: Record<string, string> = {};
  const cookie = req.headers.get("cookie");
  const authorization = req.headers.get("authorization");

  if (cookie) fetchHeaders.cookie = cookie;
  if (authorization) fetchHeaders.authorization = authorization;

  const apiUrl = `${getBaseUrl()}/v1/users/me`;

  let response: Response;
  if (env?.API) {
    const fetchReq = new Request(apiUrl, { headers: fetchHeaders });
    const incomingUrl = new URL(req.url);
    const url = new URL(fetchReq.url);
    url.protocol = incomingUrl.protocol;
    url.hostname = incomingUrl.hostname;
    url.port = incomingUrl.port;
    response = await env.API.fetch(new Request(url, fetchReq));
  } else {
    response = await fetch(apiUrl, { headers: fetchHeaders });
  }

  if (!response.ok) {
    return null;
  }

  return (await response.json()) as {
    user: unknown;
    onboardingStatus: {
      onboarding_dismissed_at: string | null;
      onboarding_completed_at: string | null;
    } | null;
    profileContext: UserProfileContextRow | null;
  };
}

export const getProfileContextServerFn = createServerFn({ method: "GET" })
  .validator((userId: string) => userId)
  .handler(async ({ data: userId }) => {
    if (!userId) return null;
    const data = await fetchMeData();
    return data?.profileContext ?? null;
  });

export const getOnboardingStatusServerFn = createServerFn({ method: "GET" })
  .validator((userId: string) => userId)
  .handler(async ({ data: userId }) => {
    if (!userId) return null;
    const data = await fetchMeData();
    return data?.onboardingStatus ?? null;
  });

export const getDeviceHintServerFn = createServerFn({ method: "GET" }).handler(async () => {
  const req = getRequest();
  if (!req) return { isMobile: false }; // fallback

  const ua = req.headers.get("user-agent") || "";
  const chMobile = req.headers.get("sec-ch-ua-mobile");

  let isMobile = false;

  if (chMobile) {
    isMobile = chMobile === "?1";
  } else {
    isMobile = /Mobi|Android|iPhone/i.test(ua);
  }

  return { isMobile };
});
