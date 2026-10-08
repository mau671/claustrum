import { createServerFn } from "@tanstack/react-start";
import { getRequest } from "@tanstack/react-start/server";
// @ts-ignore
import { env } from "cloudflare:workers";

import { getApiBaseUrl } from "@/lib/env/public";

const getBaseUrl = () => {
  return getApiBaseUrl() ?? "http://localhost:3000/api";
};

export const appStateServerFn = createServerFn({ method: "GET" }).handler(async () => {
  const req = getRequest();
  if (!req) return null;

  const fetchHeaders: Record<string, string> = {};
  const cookie = req.headers.get("cookie");
  const authorization = req.headers.get("authorization");

  if (cookie) fetchHeaders.cookie = cookie;
  if (authorization) fetchHeaders.authorization = authorization;

  const apiUrl = getBaseUrl() + "/auth/me";

  let response;
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
    throw new Error(`App state fetch failed with status: ${response.status}`);
  }

  const data = await response.json();
  return data;
});
