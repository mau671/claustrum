# AiGateway

The AiGateway resource lets you create and manage [Cloudflare AI Gateway](https://developers.cloudflare.com/workers-ai/get-started/workers-ai-gateway/) configurations for accessing AI models through Cloudflare Workers.

## Minimal Example

Create a basic AI Gateway with default settings:

```ts


const gateway = await AiGateway("my-ai-gateway", {
  name: "my-ai-gateway",
});
```

## With Authentication and Rate Limiting

Configure an AI Gateway with authentication and rate limiting:

```ts


const secureGateway = await AiGateway("secure-gateway", {
  name: "secure-gateway",
  authentication: true,
  rateLimitingInterval: 60,
  rateLimitingLimit: 100,
  rateLimitingTechnique: "sliding",
});
```

## With Logging and Logpush

Create an AI Gateway with logging and logpush enabled:

```ts


const loggingGateway = await AiGateway("logging-gateway", {
  name: "logging-gateway",
  collectLogs: true,
  logpush: true,
  logpushPublicKey: "mypublickey...",
});
```

## Bind to a Worker

Use the AI Gateway in a Cloudflare Worker:

```ts


const gateway = await AiGateway("my-gateway", {
  name: "my-gateway",
});

await Worker("my-worker", {
  name: "my-worker",
  script: "console.log('Hello, world!')",
  bindings: {
    AI: Ai(),
    GATEWAY_ID: gateway.id,
  },
});
```

## Worker Example with AI Model Usage

Here's a simple example showing how to use AI Gateway in a Cloudflare Worker:

```ts


const aiGateway = await AiGateway("chat-gateway", {
  rateLimitingInterval: 60,
  rateLimitingLimit: 100,
  collectLogs: true,
});

await Worker("chat-worker", {
  entrypoint: "./src/worker.ts",
  bindings: {
    AI: Ai(),
    GATEWAY_ID: aiGateway.id,
  },
});
```

```ts
// src/worker.ts
export default {
  async fetch(request, env) {
    const { prompt } = await request.json();

    const response = await env.AI.run(
      "@cf/meta/llama-3.1-8b-instruct-fast",
      {
        prompt,
      },
      {
        gateway: {
          id: env.GATEWAY_ID,
        },
      },
    );

    return Response.json({ response: response.response });
  },
};
```
