import { cloudflare } from "@cloudflare/vite-plugin";
import tailwindcss from "@tailwindcss/vite";
import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import viteReact from "@vitejs/plugin-react";
import mdx from "fumadocs-mdx/vite";
import { defineConfig } from "vite";

export default defineConfig({
  define: {
    "import.meta.url": JSON.stringify("file:///worker.js"),
  },
  plugins: [
    {
      name: "fix-cloudflare-create-require",
      renderChunk(code) {
        if (code.includes("createRequire(import.meta.url)")) {
          return code.replaceAll(
            "createRequire(import.meta.url)",
            'createRequire("file:///worker.js")',
          );
        }
        return null;
      },
    },
    cloudflare({ viteEnvironment: { name: "ssr" } }),
    tanstackStart(),
    viteReact(),
    tailwindcss(),
    mdx(),
  ],
  build: {
    rolldownOptions: {
      external: ["cloudflare:workers"],
    },
  },
  ssr: {
    noExternal: true,
    external: ["cloudflare:workers"],
  },
  server: {
    proxy: {
      "/api": {
        target: "http://127.0.0.1:8787",
        changeOrigin: true,
      },
    },
  },
  resolve: {
    dedupe: ["react", "react-dom"],
    alias: {
      "@": "/src",
    },
    tsconfigPaths: true,
  },
});
