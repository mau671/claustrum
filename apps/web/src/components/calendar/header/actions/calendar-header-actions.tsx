export default function CalendarHeaderActions({ children }: { children: React.ReactNode }) {
  return <div className="flex items-center justify-between gap-2 md:justify-start">{children}</div>;
}
