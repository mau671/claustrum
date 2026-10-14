# Assets

The Assets resource lets you add [static assets](https://developers.cloudflare.com/workers/static-assets/) to your Cloudflare Workers.

## Minimal Example

Create a basic assets bundle from a local directory:

```ts


const staticAssets = await Assets({
  path: "./src/assets",
});
```

## Bind to a Worker

Bind the assets to a worker to serve them:

```ts


const staticAssets = await Assets({
  path: "./src/assets",
});

const worker = await Worker("frontend", {
  name: "frontend-worker",
  entrypoint: "./src/worker.ts",
  bindings: {
    ASSETS: staticAssets,
  },
});
```
