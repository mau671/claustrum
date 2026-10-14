# AiSearch

The AiSearch resource lets you create and manage [Cloudflare AI Search](https://developers.cloudflare.com/ai-search/) instances (formerly AutoRAG). AI Search automatically indexes your data from R2 buckets or web crawlers, creates vector embeddings, and provides natural language search with AI-generated responses.

## Minimal Example

Create an AI Search instance backed by an R2 bucket. Just pass the bucket directly as the source - Alchemy automatically handles service token management:

```ts


const bucket = await R2Bucket("docs", { name: "my-docs" });

const search = await AiSearch("docs-search", {
  source: bucket,
});
```

## Using AI Search from a Worker

AI Search instances are accessed through the `AI` binding using `env.AI.autorag(name)`. Pass `search.id` as a binding so your worker knows the actual instance name (which may be auto-generated based on your app and stage):

```ts


const bucket = await R2Bucket("docs", { name: "my-docs" });

const search = await AiSearch("docs-search", {
  source: bucket,
});

await Worker("api", {
  entrypoint: "./src/worker.ts",
  bindings: {
    AI: Ai(), // AI binding required to access AI Search
    RAG_ID: search.id, // Pass the actual instance name
  },
});
```

```ts
// src/worker.ts
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const query = url.searchParams.get("q") || "";

    // Use search() for vector similarity search only
    const searchResults = await env.AI.autorag(env.RAG_ID).search({
      query,
      max_num_results: 10,
    });

    return Response.json({
      results: searchResults.data,
    });
  },
};
```

:::tip[Instance Naming]
If you don't provide an explicit `name`, Alchemy generates one using `${app}-${stage}-${id}` (e.g., `myapp-dev-docs-search`). Always use `search.id` as a binding for portability across environments, or pass an explicit `name` if you need a predictable value.
:::

## RAG Response Generation

Use `aiSearch()` to get AI-generated responses along with source documents:

```ts
// src/worker.ts
export default {
  async fetch(request, env) {
    const { question } = await request.json();

    // Use aiSearch() for RAG - returns AI response + sources
    const result = await env.AI.autorag(env.RAG_ID).aiSearch({
      query: question,
      model: "@cf/meta/llama-3.3-70b-instruct-fp8-fast",
      max_num_results: 5,
      reranking: {
        enabled: true,
        model: "@cf/baai/bge-reranker-base",
      },
    });

    return Response.json({
      answer: result.response,
      sources: result.data,
    });
  },
};
```

## With Custom Models and Chunking

Configure an AI Search instance with custom embedding and generation models:

```ts


const bucket = await R2Bucket("docs", { name: "my-docs" });

const search = await AiSearch("custom-search", {
  source: bucket,
  aiSearchModel: "@cf/meta/llama-3.3-70b-instruct-fp8-fast",
  embeddingModel: "@cf/baai/bge-m3",
  chunkSize: 512,
  chunkOverlap: 20,
  maxNumResults: 15,
});
```

## With Reranking and Query Rewriting

Enable advanced retrieval features for better search results:

```ts


const bucket = await R2Bucket("docs", { name: "my-docs" });

const search = await AiSearch("advanced-search", {
  source: bucket,
  reranking: true,
  rerankingModel: "@cf/baai/bge-reranker-base",
  rewriteQuery: true,
  scoreThreshold: 0.3,
});
```

## Web Crawler Source

For crawling websites, use the [`AiCrawler`](/providers/cloudflare/ai-crawler) helper to build the source configuration from URLs:

```ts


const search = await AiSearch("docs-search", {
  source: AiCrawler(["https://docs.example.com"]),
});
```

### Crawl Specific Paths

Provide multiple URLs to crawl specific sections of a site:

```ts


const search = await AiSearch("blog-search", {
  source: AiCrawler([
    "https://example.com/blog",
    "https://example.com/news",
  ]),
});
```

:::warning[Domain Requirements]
The domain must be:
- Added as a zone in your Cloudflare account
- Have active nameservers pointing to Cloudflare
- All URLs must be from the same domain
:::

### R2 Source with Paths and Jurisdiction

When using an R2 source object instead of a bucket directly, you can set jurisdiction, prefix, and path filters:

```ts


const bucket = await R2Bucket("docs", { name: "my-docs" });

const search = await AiSearch("docs-search", {
  source: {
    type: "r2",
    bucket,
    jurisdiction: "eu", // or "default"
    prefix: "public/",
    includePaths: ["**/*.md", "**/docs/**"],
    excludePaths: ["**/draft/**"],
  },
});
```

Path patterns support wildcards: `*` matches any characters except `/`, `**` matches any characters including `/` (up to 10 patterns each for include and exclude).

### Low-Level Web Crawler Configuration

For more control, configure the web-crawler source directly:

```ts


const search = await AiSearch("docs-search", {
  source: {
    type: "web-crawler",
    domain: "docs.example.com", // Just the domain, not a URL
    includePaths: ["**/docs/**", "**/blog/**"],
    excludePaths: ["**/api/**"],
    parseType: "sitemap", // or "feed-rss"
    parseOptions: {
      include_images: true,
      use_browser_rendering: false,
      specific_sitemaps: ["https://docs.example.com/sitemap.xml"],
    },
    storeOptions: {
      storage_id: "my-r2-bucket-name",
      jurisdiction: "default",
      storage_type: "r2",
    },
  },
});
```

Path patterns support wildcards (up to 10 each). `parseOptions` can include `include_headers`, `include_images`, `specific_sitemaps` (when `parseType` is `"sitemap"`), and `use_browser_rendering`. Use `storeOptions` to send crawled content to an R2 bucket.

## With Caching

Enable similarity caching to improve latency on repeated queries:

```ts


const bucket = await R2Bucket("docs", { name: "my-docs" });

const search = await AiSearch("cached-search", {
  source: bucket,
  cache: true,
  cacheThreshold: "close_enough", // or "super_strict_match" | "flexible_friend" | "anything_goes"
});
```

## Service Token

AI Search requires a service token with specific permissions to access resources in your account. Alchemy handles this automatically:

1. **If tokens already exist**: Alchemy detects existing AI Search service tokens in your account and lets AI Search auto-select one. No new token is created.

2. **If no tokens exist**: Alchemy creates an account API token with the required permissions and registers it with AI Search.

The automatically created token has:
- **AI Search Index Engine** permission
- **Workers R2 Storage Write** permission

When the AI Search instance is destroyed, the token is automatically cleaned up.

### Using an Explicit Token

For advanced use cases (e.g., sharing a token across multiple instances), you can create an [AiSearchToken](/providers/cloudflare/ai-search-token) explicitly:

```ts


const bucket = await R2Bucket("docs", { name: "my-docs" });

// Create a token resource explicitly
const token = await AiSearchToken("my-token", {
  name: "docs-search-token",
});

const search = await AiSearch("docs-search", {
  source: {
    type: "r2",
    bucket,
  },
  token, // Use the explicit token
});
```

See [AiSearchToken](/providers/cloudflare/ai-search-token) for more details.

## Configuration Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | `string` | auto-generated | Instance name (1-32 characters) |
| `source` | `R2Bucket \| AiSearchR2Source \| AiSearchWebCrawlerSource` | required | Data source (bucket or config) |
| `aiSearchModel` | `string` | `@cf/meta/llama-3.3-70b-instruct-fp8-fast` | Text generation model |
| `embeddingModel` | `string` | `@cf/baai/bge-m3` | Embedding model |
| `chunk` | `boolean` | `true` | Enable document chunking |
| `chunkSize` | `number` | `256` | Chunk size (minimum 64) |
| `chunkOverlap` | `number` | `10` | Overlap between chunks (0-30) |
| `maxNumResults` | `number` | `10` | Max search results (1-50) |
| `scoreThreshold` | `number` | `0.4` | Minimum match score (0-1) |
| `reranking` | `boolean` | `false` | Enable result reranking |
| `rerankingModel` | `string` | `@cf/baai/bge-reranker-base` | Reranking model |
| `rewriteQuery` | `boolean` | `false` | Enable query rewriting |
| `rewriteModel` | `string` | `@cf/meta/llama-3.3-70b-instruct-fp8-fast` | Query rewriting model |
| `cache` | `boolean` | `false` | Enable similarity caching |
| `cacheThreshold` | `"super_strict_match" \| "close_enough" \| "flexible_friend" \| "anything_goes"` | `"close_enough"` | Cache similarity threshold |
| `metadata` | `Record<string, unknown>` | — | Custom metadata |
| `indexOnCreate` | `boolean` | `true` | Index source documents when the instance is created |
| `token` | `AiSearchToken` | auto-created | Service token (or use `tokenId` with an existing token UUID) |
| `delete` | `boolean` | `true` | Delete instance on removal |
| `adopt` | `boolean` | `false` | Adopt existing instance |
