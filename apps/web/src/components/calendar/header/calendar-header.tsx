export default function CalendarHeader({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex flex-col justify-between gap-4 border-b p-4 lg:flex-row lg:items-center">
      {children}
    </div>
  );
}
