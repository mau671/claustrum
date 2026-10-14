import { StartClient } from "@tanstack/react-start/client";
import React from "react";
import ReactDOM from "react-dom/client";

import { handleStaleChunkReload, isModuleNotFoundError } from "@/lib/chunk-error";

window.addEventListener("vite:preloadError", (event) => {
  event.preventDefault();
  handleStaleChunkReload();
});

window.addEventListener("unhandledrejection", (event) => {
  if (isModuleNotFoundError(event.reason)) {
    event.preventDefault();
  }
});

ReactDOM.hydrateRoot(
  document,
  <React.StrictMode>
    <StartClient />
  </React.StrictMode>,
);
