import * as Context from "effect/Context";
import * as Effect from "effect/Effect";

export interface StorageService {
  put(
    key: string,
    value: ReadableStream | ArrayBuffer | string,
    options?: { contentType?: string },
  ): Effect.Effect<void, Error>;
  get(key: string): Effect.Effect<R2ObjectBody | null, Error>;
  delete(key: string): Effect.Effect<void, Error>;
}

export class Storage extends Context.Service<Storage, StorageService>()("claustrum/Storage") {}

export const makeStorageService = (bucket: R2Bucket): StorageService => ({
  put: (key, value, options) =>
    Effect.tryPromise({
      try: async () => {
        await bucket.put(key, value, {
          httpMetadata: options?.contentType ? { contentType: options.contentType } : undefined,
        });
      },
      catch: (e) => (e instanceof Error ? e : new Error(String(e))),
    }),
  get: (key) =>
    Effect.tryPromise({
      try: () => bucket.get(key),
      catch: (e) => (e instanceof Error ? e : new Error(String(e))),
    }),
  delete: (key) =>
    Effect.tryPromise({
      try: async () => {
        await bucket.delete(key);
      },
      catch: (e) => (e instanceof Error ? e : new Error(String(e))),
    }),
});
