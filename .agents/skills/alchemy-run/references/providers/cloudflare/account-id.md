# AccountId

The AccountId resource retrieves a Cloudflare [Account ID](https://developers.cloudflare.com/fundamentals/setup/find-account-and-zone-ids/) for use with other Cloudflare resources.

## Minimal Example

Get the account ID from environment variables or API token:

```ts


const accountId = await AccountId("my-account");
```

## With Explicit API Key

Provide an API key and email directly:

```ts


const accountId = await AccountId("my-account", {
  apiKey: alchemy.secret(process.env.CF_API_KEY),
  email: "user@example.com",
});
```

## Bind to a Worker

Use the account ID with a Worker:

```ts


const accountId = await AccountId("my-account");

await Worker("my-worker", {
  name: "my-worker",
  script: "console.log('Hello, world!')",
  accountId: accountId,
});
```
