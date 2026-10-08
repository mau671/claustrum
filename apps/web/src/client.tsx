import { StartClient } from "@tanstack/react-start/client";
import React from "react";
import ReactDOM from "react-dom/client";

const CHUNK_RELOAD_KEY = "vite-chunk-reload-time";

window.addEventListener("vite:preloadError", () => {
  const lastReloadStr = sessionStorage.getItem(CHUNK_RELOAD_KEY);
  const lastReload = lastReloadStr ? parseInt(lastReloadStr, 10) : 0;
  const now = Date.now();

  if (now - lastReload < 10000) {
    return;
  }

  sessionStorage.setItem(CHUNK_RELOAD_KEY, now.toString());
  window.location.reload();
});

ReactDOM.hydrateRoot(
  document,
  <React.StrictMode>
    <StartClient />
  </React.StrictMode>,
);
