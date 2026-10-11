"use client";

import type * as React from "react";

import { Blobatar as Generated } from "@blobatar/react";

import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { cn } from "@/lib/utils";

type DistributiveOmit<T, K extends PropertyKey> = T extends unknown ? Omit<T, K> : never;

type GeneratedOptions = DistributiveOmit<React.ComponentProps<typeof Generated>, "name">;

export type BlobatarProps = React.ComponentProps<typeof Avatar> & {
  name: string;
  src?: string;
  alt?: string;
  blobatar?: GeneratedOptions;
};

export function Blobatar({ name, src, alt, blobatar, className, ...props }: BlobatarProps) {
  return (
    <Avatar
      className={cn("overflow-visible border-0 bg-transparent shadow-none ring-0", className)}
      {...props}
    >
      {src ? (
        <AvatarImage src={src} alt={alt ?? name} className="rounded-full object-cover" />
      ) : null}
      <AvatarFallback className="overflow-visible border-0 bg-transparent p-0">
        <Generated {...blobatar} name={name} className="size-full" />
      </AvatarFallback>
    </Avatar>
  );
}
