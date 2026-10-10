import { DashboardSquare02Icon, Grid02Icon, ListViewIcon } from "@hugeicons/core-free-icons";
import { HugeiconsIcon } from "@hugeicons/react";

import type { Mode } from "./calendar-types";

export const calendarModeIconMap: Record<Mode, React.ReactNode> = {
  day: <HugeiconsIcon icon={ListViewIcon} size={16} />,
  week: <HugeiconsIcon icon={DashboardSquare02Icon} size={16} />,
  month: <HugeiconsIcon icon={Grid02Icon} size={16} />,
};
