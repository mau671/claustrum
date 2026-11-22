const STALE_CHUNK_RELOAD_KEY = "claustrum_chunk_reload";
const COOLDOWN_MS = 10000;

export function isModuleNotFoundError(error: unknown): boolean {
  if (!error) return false;

  let message = "";
  if (error instanceof Error) {
    message = error.message;
  } else if (typeof error === "object" && "message" in error) {
    const raw = (error as { message: unknown }).message;
    message = typeof raw === "string" ? raw : "";
  } else if (typeof error === "string") {
    message = error;
  }

  return (
    message.includes("Failed to fetch dynamically imported module") ||
    message.includes("error loading dynamically imported module") ||
    message.includes("Importing a module script failed") ||
    message.includes("dynamically imported module") ||
    message.includes("Unable to preload CSS")
  );
}

export function isStaleChunkReloadThrottled(targetUrl?: string): boolean {
  if (typeof window === "undefined") {
    return false;
  }

  const destination = targetUrl || window.location.href;

  try {
    const raw = sessionStorage.getItem(STALE_CHUNK_RELOAD_KEY);
    if (!raw) {
      return false;
    }

    const data = JSON.parse(raw) as { url?: string; timestamp?: number };
    return (
      data.url === destination &&
      typeof data.timestamp === "number" &&
      Date.now() - data.timestamp < COOLDOWN_MS
    );
  } catch {
    return false;
  }
}

export function handleStaleChunkReload(targetUrl?: string): boolean {
  if (typeof window === "undefined") {
    return false;
  }

  const destination = targetUrl || window.location.href;

  if (isStaleChunkReloadThrottled(destination)) {
    return false;
  }

  try {
    sessionStorage.setItem(
      STALE_CHUNK_RELOAD_KEY,
      JSON.stringify({ url: destination, timestamp: Date.now() }),
    );
  } catch {
    // sessionStorage access might fail in restricted iframe environments
  }

  window.location.assign(destination);
  return true;
}
