# Redwood

Deploy a RedwoodJS application to Cloudflare Workers with automatically configured defaults. This resource handles the deployment of RedwoodJS applications with optimized settings for Cloudflare Workers.

## Minimal Example

Deploy a basic RedwoodJS application with default settings:

```ts


const redwoodApp = await Redwood("my-redwood-app");
```

## With Database Binding

Add a D1 database binding to your RedwoodJS application:

```ts


const database = await D1Database("redwood-db");

const redwoodApp = await Redwood("redwood-with-db", {
  bindings: {
    DB: database,
  },
});
```

## Custom Build Configuration

Deploy with custom build command and environment variables:

```ts


const redwoodApp = await Redwood("custom-redwood", {
  build: "bun run test && RWSDK_DEPLOY=1 bun run build:production",
  bindings: {
    API_KEY: alchemy.secret("api-key-secret"),
  },
  vars: {
    NODE_ENV: "production",
    APP_ENV: "staging",
  },
});
```

## Bind to a Worker

Bind a RedwoodJS application to a Worker:

```ts


const redwoodApp = await Redwood("my-redwood-app", {
  name: "redwood-worker",
  build: "bun run build",
});

await Worker("my-worker", {
  name: "my-worker",
  script: "console.log('Hello from worker')",
  bindings: {
    REDWOOD: redwoodApp,
  },
});
```

## With Transform Hook

The transform hook allows you to customize the wrangler.json configuration. For example, adding a custom environment variable:

```ts
await Redwood("my-app", {
  wrangler: {
    transform: (spec) => ({
      ...spec,
      vars: {
        ...spec.vars,
        CUSTOM_VAR: "value",
      },
    }),
  },
});
```
