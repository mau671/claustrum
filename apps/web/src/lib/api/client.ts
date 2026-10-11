import { getApiBaseUrl } from "@/lib/env/public";

export class ApiError extends Error {
  constructor(
    public status: number,
    message: string,
    public details?: unknown,
  ) {
    super(message);
    this.name = "ApiError";
  }
}

export function getApiV1Url(endpoint: string): string {
  const isServer = typeof window === "undefined";
  const rawBase =
    getApiBaseUrl() ?? (!isServer ? `${window.location.origin}/api` : "http://localhost:3000/api");
  const base = rawBase.endsWith("/") ? rawBase.slice(0, -1) : rawBase;
  const path = endpoint.startsWith("/") ? endpoint : `/${endpoint}`;
  return `${base}/v1${path}`;
}

export async function apiClient<T>(endpoint: string, options?: RequestInit): Promise<T> {
  const url = getApiV1Url(endpoint);

  const headers = new Headers(options?.headers);
  const isFormData = typeof FormData !== "undefined" && options?.body instanceof FormData;
  if (
    !isFormData &&
    !headers.has("Content-Type") &&
    options?.body !== undefined &&
    options?.body !== null
  ) {
    headers.set("Content-Type", "application/json");
  }

  const response = await fetch(url, {
    credentials: "include",
    ...options,
    headers,
  });

  if (!response.ok) {
    let errorData: unknown = null;
    let message = `Request failed with status ${response.status}`;
    try {
      const json = await response.json();
      errorData = json;
      if (typeof json === "object" && json !== null) {
        if ("message" in json && typeof (json as { message: unknown }).message === "string") {
          message = (json as { message: string }).message;
        } else if ("error" in json && typeof (json as { error: unknown }).error === "string") {
          message = (json as { error: string }).error;
        }
      }
    } catch {
      try {
        const text = await response.text();
        if (text) message = text;
      } catch {
        // ignore
      }
    }
    throw new ApiError(response.status, message, errorData);
  }

  if (response.status === 204) {
    return null as T;
  }

  const text = await response.text();
  if (!text || text.trim() === "") {
    return null as T;
  }

  return JSON.parse(text) as T;
}
