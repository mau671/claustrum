# D1StateStore

## Basic Configuration

```typescript


const app = await alchemy("my-app", {
  stateStore: (scope) => new D1StateStore(scope)
});
```

## Configuration Options

```typescript
const app = await alchemy("my-app", {
  stateStore: (scope) => new D1StateStore(scope, {
    // Database name (defaults to "alchemy-state")
    databaseName: "my-app-state",
    
    // Cloudflare API configuration
    apiToken: process.env.CLOUDFLARE_API_TOKEN,
    accountId: process.env.CLOUDFLARE_ACCOUNT_ID,
    email: process.env.CLOUDFLARE_EMAIL,
    apiKey: process.env.CLOUDFLARE_API_KEY
  })
});
```

## Environment-Specific Setup

```typescript
const stage = process.env.STAGE ?? "dev";

const app = await alchemy("my-app", {
  stage,
  stateStore: (scope) => new D1StateStore(scope, {
    databaseName: `my-app-state-${stage}`
  })
});
```

## Authentication

For Cloudflare authentication setup, see the [Cloudflare guide](/guides/cloudflare).
