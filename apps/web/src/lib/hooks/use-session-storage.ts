import { useSyncExternalStore } from "react";

const subscribe = () => () => {};

export function useSessionStorageValue(key: string): string {
  return useSyncExternalStore(
    subscribe,
    () => window.sessionStorage.getItem(key) ?? "",
    () => "",
  );
}
