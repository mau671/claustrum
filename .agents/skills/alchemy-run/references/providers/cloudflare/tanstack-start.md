# TanStackStart

Deploy a TanStack Start application to Cloudflare Workers with automatically configured defaults.

## Minimal Example

```ts


const app = await TanStackStart("my-app");
```

## With Custom Build Command

```ts


const app = await TanStackStart("my-app", {
  build: "bun run test && bun run build:production",
});
```

## With Database Binding

```ts


const database = await D1Database("my-db", {
  name: "my-db",
});

const app = await TanStackStart("my-app", {
  bindings: {
    DB: database,
  },
});
```

## With Environment Variables

```ts


const app = await TanStackStart("my-app", {
  bindings: {
    API_KEY: alchemy.secret(process.env.API_KEY),
    NODE_ENV: "production",
    APP_ENV: "staging",
  },
});
```

## Bind to a Worker

```ts


const api = await Worker("api", {
  script: `export default {
  async fetch(request, env) {
    return new Response("Hello, world!");
  },
};
`,
});
const app = await TanStackStart("my-app", {
  bindings: {
    API: api,
  },
});
```

## With Transform Hook

The transform hook allows you to customize the wrangler.json configuration. For example, adding a custom environment variable:

```ts
await TanStackStart("my-app", {
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
