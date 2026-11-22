import { useEffect, useState } from "react";

export function useBlobUrl(blob: Blob | null | undefined): string | null {
  const [url, setUrl] = useState<string | null>(null);

  useEffect(() => {
    const nextUrl = blob ? URL.createObjectURL(blob) : null;
    // oxlint-disable-next-line react/set-state-in-effect -- object URLs are an external resource whose lifecycle is owned by this effect
    setUrl(nextUrl);

    return () => {
      if (nextUrl) URL.revokeObjectURL(nextUrl);
    };
  }, [blob]);

  return url;
}
