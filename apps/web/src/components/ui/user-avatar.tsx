import { Blobatar } from "@/components/ui/blobatar";
import { cn } from "@/lib/utils";

export interface UserAvatarProps {
  name?: string;
  email?: string;
  id?: string;
  src?: string;
  className?: string;
  size?: number;
}

export function UserAvatar({ name, email, id, src, className }: UserAvatarProps) {
  const seed = (id || email || name || "user").trim();

  return (
    <Blobatar
      name={seed}
      src={src}
      className={cn(
        "inline-flex size-9 shrink-0 items-center justify-center overflow-visible border-0 bg-transparent shadow-none select-none",
        className,
      )}
      blobatar={{
        animate: "hover",
      }}
    />
  );
}
