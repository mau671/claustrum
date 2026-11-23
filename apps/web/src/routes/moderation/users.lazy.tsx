import type { ColumnDef, RowSelectionState, SortingState } from "@tanstack/react-table";
import type { ReactNode } from "react";

import {
  Cancel01Icon,
  CheckIcon,
  ChevronDownIcon,
  ChevronUpIcon,
  Search01Icon,
} from "@hugeicons/core-free-icons";
import { useDebouncedCallback } from "@tanstack/react-pacer";
import { createLazyFileRoute, useNavigate } from "@tanstack/react-router";
import {
  columnSizingFeature,
  columnVisibilityFeature,
  createPaginatedRowModel,
  createSortedRowModel,
  flexRender,
  rowPaginationFeature,
  rowSelectionFeature,
  rowSortingFeature,
  sortFn_alphanumeric,
  sortFn_text,
  tableFeatures,
  useTable,
} from "@tanstack/react-table";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";

import type { AdminUser, AdminUserRole, AdminUserSortBy } from "@/lib/hooks/use-admin-users";

import { NumberedPagination } from "@/components/numbered-pagination";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Drawer,
  DrawerFooter,
  DrawerHeader,
  DrawerPanel,
  DrawerPopup,
  DrawerTitle,
} from "@/components/ui/drawer";
import { Frame, FrameFooter, FrameHeader } from "@/components/ui/frame";
import { Icon } from "@/components/ui/icon";
import { Input } from "@/components/ui/input";
import { InputGroup, InputGroupAddon, InputGroupInput } from "@/components/ui/input-group";
import { Label } from "@/components/ui/label";
import { ScrollArea } from "@/components/ui/scroll-area";
import { SearchableCombobox } from "@/components/ui/searchable-combobox";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Skeleton } from "@/components/ui/skeleton";
import { Spinner } from "@/components/ui/spinner";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Tabs, TabsList, TabsPanel, TabsTab } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { toast } from "@/components/ui/toast";
import { UserAvatar } from "@/components/ui/user-avatar";
import { useIsMobile } from "@/hooks/use-mobile";
import {
  useAdminUser,
  useAdminUserAcademicProfile,
  useAdminUserFeedback,
  useAdminUserNotifications,
  useAdminUsers,
  useAdminUserSessions,
  usePrefetchAdminUserDetails,
  useUpdateAdminUserAcademicProfile,
  useBanAdminUser,
  useDeleteAdminUser,
  useRevokeAdminUserSession,
  useRevokeAllAdminUserSessions,
  useSendAdminNotification,
  useUnbanAdminUser,
  useUpdateAdminUserIdentity,
  useUpdateAdminUserRole,
  useUpdateAdminUserVerification,
} from "@/lib/hooks/use-admin-users";
import {
  useAcademicUnits,
  useAuthUser,
  useCampuses,
  useStudyPlans,
  useUniversities,
} from "@/lib/hooks/use-queries";
import { useIsAdmin } from "@/lib/hooks/use-roles";
import { cn } from "@/lib/utils";

const PAGE_SIZE = 20;

type RoleFilter = "all" | AdminUserRole;
type BannedFilter = "all" | "true" | "false";

const ROLE_FILTER_ITEMS: ReadonlyArray<{ value: RoleFilter; label: string }> = [
  { value: "all", label: "Todos los roles" },
  { value: "admin", label: "Administradores" },
  { value: "moderator", label: "Moderadores" },
  { value: "user", label: "Usuarios" },
];

const ROLE_ITEMS: ReadonlyArray<{ value: AdminUserRole; label: string }> = [
  { value: "admin", label: "Administrador" },
  { value: "moderator", label: "Moderador" },
  { value: "user", label: "Usuario" },
];

const VERIFICATION_ITEMS: ReadonlyArray<{ value: string; label: string }> = [
  { value: "true", label: "Verificado" },
  { value: "false", label: "Pendiente" },
];

const STATUS_ITEMS: ReadonlyArray<{ value: string; label: string }> = [
  { value: "active", label: "Activo" },
  { value: "banned", label: "Suspendido" },
];

const BANNED_FILTER_ITEMS: ReadonlyArray<{ value: BannedFilter; label: string }> = [
  { value: "all", label: "Todos los estados" },
  { value: "false", label: "Activos" },
  { value: "true", label: "Suspendidos" },
];

const BAN_DURATION_ITEMS: ReadonlyArray<{ value: string; label: string }> = [
  { value: "permanent", label: "Permanente" },
  { value: "86400", label: "1 día" },
  { value: "604800", label: "7 días" },
  { value: "2592000", label: "30 días" },
];

const userTableFeatures = tableFeatures({
  columnSizingFeature,
  columnVisibilityFeature,
  rowPaginationFeature,
  paginatedRowModel: createPaginatedRowModel(),
  rowSelectionFeature,
  rowSortingFeature,
  sortedRowModel: createSortedRowModel(),
  sortFns: {
    alphanumeric: sortFn_alphanumeric,
    text: sortFn_text,
  },
});

function getRoleLabel(role: string | null): string {
  switch (role) {
    case "admin":
      return "Administrador";
    case "moderator":
      return "Moderador";
    default:
      return "Usuario";
  }
}

function getRoleBadgeVariant(role: string | null): "default" | "info" | "secondary" {
  if (role === "admin") return "default";
  if (role === "moderator") return "info";
  return "secondary";
}

function UsersTableSkeleton() {
  return (
    <>
      {Array.from({ length: PAGE_SIZE }).map((_, index) => (
        <TableRow key={index} className="h-14">
          <TableCell>
            <Skeleton className="size-4 rounded-[.25rem]" />
          </TableCell>
          <TableCell className="max-w-0">
            <div className="flex items-center gap-2.5">
              <Skeleton className="size-8 rounded-full" />
              <div className="flex flex-col">
                <Skeleton className={cn("h-5 rounded-sm", index % 2 ? "w-40" : "w-32")} />
                <Skeleton className="h-4 w-48 rounded-sm" />
              </div>
            </div>
          </TableCell>
          <TableCell>
            <Skeleton className="h-5 w-20 rounded-sm" />
          </TableCell>
          <TableCell>
            <Skeleton className="h-5 w-16 rounded-sm" />
          </TableCell>
          <TableCell className="hidden lg:table-cell">
            <Skeleton className="h-4 w-16 rounded-sm" />
          </TableCell>
          <TableCell className="hidden md:table-cell">
            <Skeleton className="h-4 w-20 rounded-sm" />
          </TableCell>
          <TableCell>
            <Skeleton className="h-7 w-20 rounded-sm" />
          </TableCell>
        </TableRow>
      ))}
    </>
  );
}

function getFeedbackTypeLabel(type: "bug" | "feature" | "other"): string {
  if (type === "bug") return "Error";
  if (type === "feature") return "Sugerencia";
  return "Otro";
}

function DetailField({
  label,
  children,
  className,
}: {
  label: string;
  children: ReactNode;
  className?: string;
}) {
  return (
    <div className={cn("flex min-w-0 flex-col gap-1.5", className)}>
      <span className="text-muted-foreground text-xs font-medium">{label}</span>
      <div className="min-w-0 text-sm break-words">{children}</div>
    </div>
  );
}

function DetailSkeleton() {
  return (
    <div className="flex flex-col gap-3">
      {Array.from({ length: 5 }).map((_, index) => (
        <div key={index} className="flex items-center gap-3">
          <Skeleton className="h-3.5 w-24 rounded-sm" />
          <Skeleton className="h-8 flex-1 rounded-lg" />
        </div>
      ))}
    </div>
  );
}

export const Route = createLazyFileRoute("/moderation/users")({
  component: AdminUsersPage,
});

function AdminUsersPage() {
  const navigate = useNavigate();
  const isAdmin = useIsAdmin();
  const isMobile = useIsMobile();
  const { data: authUser } = useAuthUser();
  const search = Route.useSearch();

  const page = search.page ?? 1;
  const searchTerm = search.search ?? "";
  const roleFilter: RoleFilter = search.role ?? "all";
  const bannedFilter: BannedFilter = search.banned ?? "all";
  const sortBy: AdminUserSortBy = search.sortBy ?? "createdAt";
  const sortDesc = search.sortDesc ?? true;

  const headerRef = useRef<HTMLTableSectionElement | null>(null);
  const [headerHeight, setHeaderHeight] = useState(0);

  const [searchInput, setSearchInput] = useState(searchTerm);
  const [previousSearchTerm, setPreviousSearchTerm] = useState(searchTerm);
  const [lastTypedSearch, setLastTypedSearch] = useState(searchTerm);
  if (searchTerm !== previousSearchTerm) {
    setPreviousSearchTerm(searchTerm);
    if (searchTerm !== lastTypedSearch) {
      setSearchInput(searchTerm);
    }
  }
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [isDetailOpen, setIsDetailOpen] = useState(false);
  const [isDeleteOpen, setIsDeleteOpen] = useState(false);
  const [banReason, setBanReason] = useState("");
  const [banDuration, setBanDuration] = useState("permanent");
  const [notificationTitle, setNotificationTitle] = useState("");
  const [notificationMessage, setNotificationMessage] = useState("");
  const [notificationLink, setNotificationLink] = useState("");
  const [nameDraft, setNameDraft] = useState("");
  const [emailDraft, setEmailDraft] = useState("");
  const [roleDraft, setRoleDraft] = useState<AdminUserRole>("user");
  const [verifiedDraft, setVerifiedDraft] = useState(false);
  const [statusDraft, setStatusDraft] = useState<"active" | "banned">("active");
  const [previousDetail, setPreviousDetail] = useState<{
    id: string;
    name: string;
    email: string;
    role: string;
    emailVerified: boolean;
    banned: boolean;
  } | null>(null);
  const [carnetDraft, setCarnetDraft] = useState("");
  const [universityIdDraft, setUniversityIdDraft] = useState<number | null>(null);
  const [campusIdDraft, setCampusIdDraft] = useState<number | null>(null);
  const [academicUnitIdDraft, setAcademicUnitIdDraft] = useState<number | null>(null);
  const [studyPlanIdDraft, setStudyPlanIdDraft] = useState<number | null>(null);
  const [previousAcademic, setPreviousAcademic] = useState<{
    id: string;
    carnet: string | null;
    university_id: number | null;
    campus_id: number | null;
    academic_unit_id: number | null;
    study_plan_id: number | null;
  } | null>(null);
  const [rowSelection, setRowSelection] = useState<RowSelectionState>({});

  const sorting: SortingState = [{ id: sortBy, desc: sortDesc }];

  const usersQuery = useAdminUsers(
    {
      page,
      pageSize: PAGE_SIZE,
      search: searchTerm,
      role: roleFilter,
      banned: bannedFilter,
      sortBy,
      sortDesc,
    },
    isAdmin,
  );
  const users = usersQuery.data?.users ?? [];
  const selectedRow = users.find((item) => item.id === selectedId) ?? null;
  const detailQuery = useAdminUser(isDetailOpen ? selectedId : null, isAdmin, selectedRow);
  const updateRole = useUpdateAdminUserRole();
  const banUser = useBanAdminUser();
  const unbanUser = useUnbanAdminUser();
  const deleteUser = useDeleteAdminUser();
  const prefetchDetails = usePrefetchAdminUserDetails();
  const updateIdentity = useUpdateAdminUserIdentity();
  const updateVerification = useUpdateAdminUserVerification();
  const updateAcademic = useUpdateAdminUserAcademicProfile();
  const academicQuery = useAdminUserAcademicProfile(selectedId, isDetailOpen && isAdmin);
  const universitiesQuery = useUniversities();
  const campusesQuery = useCampuses(universityIdDraft);
  const academicUnitsQuery = useAcademicUnits(campusIdDraft);
  const studyPlansQuery = useStudyPlans(academicUnitIdDraft);
  const feedbackQuery = useAdminUserFeedback(selectedId, isDetailOpen && isAdmin);
  const notificationsQuery = useAdminUserNotifications(selectedId, isDetailOpen && isAdmin);
  const sessionsQuery = useAdminUserSessions(selectedId, isDetailOpen && isAdmin);
  const sendNotification = useSendAdminNotification();
  const revokeSession = useRevokeAdminUserSession();
  const revokeAllSessions = useRevokeAllAdminUserSessions();

  useEffect(() => {
    if (!isAdmin) {
      void navigate({ to: "/moderation/reviews", replace: true });
    }
  }, [isAdmin, navigate]);

  useEffect(() => {
    const header = headerRef.current;
    if (!header) return;

    const observer = new ResizeObserver(() => {
      const height = header.getBoundingClientRect().height;
      setHeaderHeight((current) => (current === height ? current : height));
    });
    observer.observe(header);
    return () => observer.disconnect();
  }, []);

  const openDetail = useCallback((id: string) => {
    setSelectedId(id);
    setPreviousDetail(null);
    setPreviousAcademic(null);
    setBanReason("");
    setBanDuration("permanent");
    setIsDetailOpen(true);
  }, []);

  const debouncedSearch = useDebouncedCallback(
    (value: string) => {
      goTo({ search: value, page: 1 });
    },
    { wait: 300 },
  );

  const columns = useMemo<ColumnDef<typeof userTableFeatures, AdminUser>[]>(
    () => [
      {
        id: "select",
        size: 28,
        enableSorting: false,
        header: ({ table }) => (
          <Checkbox
            aria-label="Seleccionar todos los usuarios de la página"
            checked={table.getIsAllPageRowsSelected()}
            indeterminate={table.getIsSomePageRowsSelected() && !table.getIsAllPageRowsSelected()}
            onCheckedChange={(value) => table.toggleAllPageRowsSelected(value)}
          />
        ),
        cell: ({ row }) => (
          <Checkbox
            aria-label={`Seleccionar a ${row.original.name}`}
            checked={row.getIsSelected()}
            onCheckedChange={(value) => row.toggleSelected(value)}
          />
        ),
      },
      {
        accessorKey: "name",
        header: "Usuario",
        size: 280,
        cell: ({ row }) => (
          <div className="flex min-w-0 items-center gap-2.5">
            <UserAvatar
              id={row.original.id}
              name={row.original.name}
              email={row.original.email}
              src={row.original.image ?? undefined}
              className="size-8"
            />
            <div className="min-w-0">
              <p className="max-w-56 truncate text-sm font-medium">{row.original.name}</p>
              <p className="text-muted-foreground max-w-56 truncate text-xs">
                {row.original.email}
              </p>
            </div>
          </div>
        ),
      },
      {
        accessorKey: "role",
        header: "Rol",
        size: 130,
        cell: ({ row }) => (
          <Badge variant={getRoleBadgeVariant(row.original.role)} size="sm">
            {getRoleLabel(row.original.role)}
          </Badge>
        ),
      },
      {
        accessorKey: "banned",
        header: "Estado",
        size: 120,
        cell: ({ row }) =>
          row.original.banned ? (
            <Badge variant="error" size="sm">
              Suspendido
            </Badge>
          ) : (
            <Badge variant="success" size="sm">
              Activo
            </Badge>
          ),
      },
      {
        accessorKey: "emailVerified",
        header: "Verificación",
        size: 130,
        enableSorting: false,
        cell: ({ row }) =>
          row.original.emailVerified ? (
            <span className="text-success-foreground inline-flex items-center gap-1 text-xs">
              <Icon icon={CheckIcon} size={13} className="size-3.5" />
              Verificado
            </span>
          ) : (
            <span className="text-muted-foreground text-xs">Pendiente</span>
          ),
      },
      {
        accessorKey: "createdAt",
        header: "Registro",
        size: 170,
        cell: ({ row }) => (
          <span className="text-muted-foreground text-xs whitespace-nowrap">
            {new Date(row.original.createdAt).toLocaleString(undefined, {
              dateStyle: "short",
              timeStyle: "short",
            })}
          </span>
        ),
      },
      {
        id: "actions",
        header: "Acciones",
        size: 110,
        enableSorting: false,
        cell: ({ row }) => (
          <Button
            variant="ghost"
            size="sm"
            className="h-7 px-2 text-xs"
            onPointerEnter={() => prefetchDetails(row.original.id, row.original)}
            onFocus={() => prefetchDetails(row.original.id, row.original)}
            onClick={() => openDetail(row.original.id)}
          >
            Ver detalle
          </Button>
        ),
      },
    ],
    [openDetail, prefetchDetails],
  );

  const total = usersQuery.data?.total ?? 0;
  const totalPages = Math.max(1, Math.ceil(total / PAGE_SIZE));
  const hasMore = page < totalPages;
  const selectedUser = detailQuery.data ?? null;

  if (selectedUser) {
    const snapshot = {
      id: selectedUser.id,
      name: selectedUser.name,
      email: selectedUser.email,
      role: selectedUser.role ?? "user",
      emailVerified: selectedUser.emailVerified,
      banned: Boolean(selectedUser.banned),
    };
    if (
      !previousDetail ||
      previousDetail.id !== snapshot.id ||
      previousDetail.name !== snapshot.name ||
      previousDetail.email !== snapshot.email ||
      previousDetail.role !== snapshot.role ||
      previousDetail.emailVerified !== snapshot.emailVerified ||
      previousDetail.banned !== snapshot.banned
    ) {
      setPreviousDetail(snapshot);
      setNameDraft(snapshot.name);
      setEmailDraft(snapshot.email);
      setRoleDraft(snapshot.role as AdminUserRole);
      setVerifiedDraft(snapshot.emailVerified);
      setStatusDraft(snapshot.banned ? "banned" : "active");
    }
  }

  const academicProfile = academicQuery.data ?? null;
  if (academicProfile) {
    const snapshot = {
      id: academicProfile.user_id,
      carnet: academicProfile.carnet,
      university_id: academicProfile.university_id,
      campus_id: academicProfile.campus_id,
      academic_unit_id: academicProfile.academic_unit_id,
      study_plan_id: academicProfile.study_plan_id,
    };
    if (
      !previousAcademic ||
      previousAcademic.id !== snapshot.id ||
      previousAcademic.carnet !== snapshot.carnet ||
      previousAcademic.university_id !== snapshot.university_id ||
      previousAcademic.campus_id !== snapshot.campus_id ||
      previousAcademic.academic_unit_id !== snapshot.academic_unit_id ||
      previousAcademic.study_plan_id !== snapshot.study_plan_id
    ) {
      setPreviousAcademic(snapshot);
      setCarnetDraft(snapshot.carnet ?? "");
      setUniversityIdDraft(snapshot.university_id);
      setCampusIdDraft(snapshot.campus_id);
      setAcademicUnitIdDraft(snapshot.academic_unit_id);
      setStudyPlanIdDraft(snapshot.study_plan_id);
    }
  }

  const hasAcademicChanges =
    academicProfile !== null &&
    (carnetDraft !== (academicProfile.carnet ?? "") ||
      universityIdDraft !== academicProfile.university_id ||
      studyPlanIdDraft !== academicProfile.study_plan_id);

  const hasUnsavedChanges =
    (selectedUser !== null &&
      (nameDraft.trim() !== selectedUser.name ||
        emailDraft.trim() !== selectedUser.email ||
        roleDraft !== (selectedUser.role ?? "user") ||
        verifiedDraft !== selectedUser.emailVerified ||
        statusDraft !== (selectedUser.banned ? "banned" : "active"))) ||
    hasAcademicChanges;

  const isSelf = selectedUser?.id === authUser?.id;
  const isMutating =
    updateRole.isPending ||
    updateIdentity.isPending ||
    updateVerification.isPending ||
    updateAcademic.isPending ||
    banUser.isPending ||
    unbanUser.isPending ||
    deleteUser.isPending;
  const selectedCount = Object.keys(rowSelection).length;

  const table = useTable(
    {
      columns,
      data: users,
      features: userTableFeatures,
      enableMultiSort: false,
      enableSortingRemoval: false,
      getRowId: (row) => row.id,
      manualPagination: true,
      manualSorting: true,
      pageCount: totalPages,
      rowCount: total,
      state: {
        pagination: { pageIndex: page - 1, pageSize: PAGE_SIZE },
        rowSelection,
        sorting,
      },
      onRowSelectionChange: setRowSelection,
      onSortingChange: (updater) => {
        const next = typeof updater === "function" ? updater(sorting) : updater;
        const first = next[0];
        goTo({
          sortBy: (first?.id as AdminUserSortBy) ?? "createdAt",
          sortDesc: first?.desc ?? true,
          page: 1,
        });
      },
    },
    (state) => ({
      pagination: state.pagination,
      rowSelection: state.rowSelection,
      sorting: state.sorting,
    }),
  );

  if (!isAdmin) return null;

  function goTo(next: {
    page?: number;
    search?: string;
    role?: RoleFilter;
    banned?: BannedFilter;
    sortBy?: AdminUserSortBy;
    sortDesc?: boolean;
  }) {
    const nextPage = next.page ?? page;
    const nextSearch = next.search ?? searchTerm;
    const nextRole = next.role ?? roleFilter;
    const nextBanned = next.banned ?? bannedFilter;
    const nextSortBy = next.sortBy ?? sortBy;
    const nextSortDesc = next.sortDesc ?? sortDesc;

    setRowSelection({});
    void navigate({
      from: "/moderation/users",
      search: {
        page: nextPage === 1 ? undefined : nextPage,
        search: nextSearch || undefined,
        role: nextRole === "all" ? undefined : nextRole,
        banned: nextBanned === "all" ? undefined : nextBanned,
        sortBy: nextSortBy,
        sortDesc: nextSortDesc,
      },
    });
  }

  async function handleSave() {
    if (!selectedUser || !hasUnsavedChanges) return;
    if (hasAcademicChanges && (campusIdDraft === null || studyPlanIdDraft === null)) {
      toast.error("Selecciona una escuela y un plan de estudios.");
      return;
    }
    try {
      const identityChanged =
        nameDraft.trim() !== selectedUser.name || emailDraft.trim() !== selectedUser.email;
      const roleChanged = roleDraft !== (selectedUser.role ?? "user");
      const verificationChanged = verifiedDraft !== selectedUser.emailVerified;
      const statusChanged = statusDraft !== (selectedUser.banned ? "banned" : "active");

      const tasks: Promise<unknown>[] = [];
      if (identityChanged) {
        tasks.push(
          updateIdentity.mutateAsync({
            id: selectedUser.id,
            name: nameDraft.trim(),
            email: emailDraft.trim(),
          }),
        );
      }
      if (roleChanged) {
        tasks.push(updateRole.mutateAsync({ id: selectedUser.id, role: roleDraft }));
      }
      if (verificationChanged) {
        tasks.push(
          updateVerification.mutateAsync({ id: selectedUser.id, verified: verifiedDraft }),
        );
      }
      if (statusChanged) {
        tasks.push(
          statusDraft === "banned"
            ? banUser.mutateAsync({
                id: selectedUser.id,
                reason: banReason,
                expiresInSeconds: banDuration === "permanent" ? undefined : Number(banDuration),
              })
            : unbanUser.mutateAsync(selectedUser.id),
        );
      }
      if (hasAcademicChanges) {
        tasks.push(
          updateAcademic.mutateAsync({
            id: selectedUser.id,
            carnet: carnetDraft.trim() === "" ? null : carnetDraft.trim(),
            campusId: campusIdDraft ?? undefined,
            studyPlanId: studyPlanIdDraft ?? undefined,
            entryYear: carnetDraft ? Number(carnetDraft.slice(0, 4)) : undefined,
          }),
        );
      }
      await Promise.all(tasks);
      toast.success("Cambios guardados");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudieron guardar los cambios.");
    }
  }

  async function handleDelete() {
    if (!selectedUser) return;
    try {
      await deleteUser.mutateAsync(selectedUser.id);
      toast.success("Usuario eliminado");
      setIsDeleteOpen(false);
      setIsDetailOpen(false);
      setSelectedId(null);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo eliminar al usuario.");
    }
  }

  async function handleRevokeSession(token: string) {
    try {
      await revokeSession.mutateAsync(token);
      toast.success("Sesión revocada");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo revocar la sesión.");
    }
  }

  async function handleRevokeAllSessions() {
    if (!selectedId) return;
    try {
      await revokeAllSessions.mutateAsync(selectedId);
      toast.success("Se revocaron todas las sesiones");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudieron revocar las sesiones.");
    }
  }

  async function handleSendNotification() {
    if (!selectedId || !notificationTitle.trim() || !notificationMessage.trim()) return;
    try {
      await sendNotification.mutateAsync({
        id: selectedId,
        title: notificationTitle.trim(),
        message: notificationMessage.trim(),
        link: notificationLink.trim() || undefined,
      });
      toast.success("Notificación enviada");
      setNotificationTitle("");
      setNotificationMessage("");
      setNotificationLink("");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo enviar la notificación.");
    }
  }

  const clearSelectionButton = (iconOnly: boolean) => (
    <Button
      variant="ghost"
      size={iconOnly ? "icon" : "sm"}
      aria-label="Limpiar selección"
      className={iconOnly ? "size-8" : "h-7 gap-1.5 px-2 text-xs"}
      onClick={() => setRowSelection({})}
    >
      <Icon icon={Cancel01Icon} size={14} className="size-3.5" />
      {!iconOnly && "Limpiar"}
    </Button>
  );

  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <Frame className="min-h-0 w-full flex-1 flex-col">
        <FrameHeader className="flex flex-col gap-3 px-4 py-3 sm:h-auto sm:flex-row sm:items-center sm:justify-end sm:px-5">
          {selectedCount > 0 && (
            <div className="mr-auto hidden items-center gap-2 md:flex">
              <span className="text-sm font-medium">
                {selectedCount}{" "}
                {selectedCount === 1 ? "usuario seleccionado" : "usuarios seleccionados"}
              </span>
              {clearSelectionButton(false)}
            </div>
          )}

          <div className="flex w-full min-w-0 flex-col gap-2 sm:w-auto sm:flex-row sm:flex-wrap sm:items-center">
            <InputGroup className="h-8 w-full sm:w-60">
              <InputGroupAddon>
                <Icon icon={Search01Icon} size={16} aria-hidden="true" />
              </InputGroupAddon>
              <InputGroupInput
                type="search"
                value={searchInput}
                onChange={(event) => {
                  const next = event.target.value;
                  setLastTypedSearch(next);
                  setSearchInput(next);
                  debouncedSearch(next);
                }}
                placeholder="Buscar por nombre o correo"
                aria-label="Buscar usuarios"
              />
            </InputGroup>

            <div className="flex w-full min-w-0 items-center gap-2 sm:w-auto">
              <Select
                items={ROLE_FILTER_ITEMS as unknown as Array<{ value: string; label: string }>}
                value={roleFilter}
                onValueChange={(value) => goTo({ role: value as RoleFilter, page: 1 })}
              >
                <SelectTrigger
                  size="sm"
                  className="h-8 min-w-0 flex-1 text-xs sm:w-38 sm:flex-none"
                  aria-label="Filtrar por rol"
                >
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {ROLE_FILTER_ITEMS.map((item) => (
                    <SelectItem key={item.value} value={item.value}>
                      {item.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>

              <Select
                items={BANNED_FILTER_ITEMS as unknown as Array<{ value: string; label: string }>}
                value={bannedFilter}
                onValueChange={(value) => goTo({ banned: value as BannedFilter, page: 1 })}
              >
                <SelectTrigger
                  size="sm"
                  className="h-8 min-w-0 flex-1 text-xs sm:w-38 sm:flex-none"
                  aria-label="Filtrar por estado"
                >
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {BANNED_FILTER_ITEMS.map((item) => (
                    <SelectItem key={item.value} value={item.value}>
                      {item.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
        </FrameHeader>

        {selectedCount > 0 && !isDetailOpen && (
          <div className="animate-in fade-in-0 slide-in-from-bottom-2 bg-popover fixed inset-x-4 bottom-[calc(max(1rem,env(safe-area-inset-bottom))+4.25rem)] z-40 flex items-center justify-between gap-3 rounded-full border px-3 py-1.5 shadow-xl md:hidden">
            <span className="text-sm font-medium tabular-nums">
              {selectedCount} {selectedCount === 1 ? "seleccionado" : "seleccionados"}
            </span>
            {clearSelectionButton(true)}
          </div>
        )}

        <ScrollArea
          fade="y"
          fadeTopOffset={headerHeight > 0 ? `${headerHeight}px` : undefined}
          hideScrollbar
          className="min-h-0 flex-1"
          viewportClassName="[&_[data-slot=table-container]]:overflow-visible"
        >
          <Table variant="card" className="table-fixed">
            <TableHeader
              ref={headerRef}
              className="sticky top-0 z-10"
              style={{
                backgroundColor:
                  "color-mix(in oklab, var(--color-foreground) 2.88%, var(--color-background))",
              }}
            >
              {table.getHeaderGroups().map((headerGroup) => (
                <TableRow className="hover:bg-transparent" key={headerGroup.id}>
                  {headerGroup.headers.map((header) => {
                    const sort = header.column.getIsSorted();
                    const columnSize = header.column.getSize();
                    return (
                      <TableHead
                        key={header.id}
                        aria-sort={
                          sort === "asc" ? "ascending" : sort === "desc" ? "descending" : undefined
                        }
                        style={columnSize ? { width: `${columnSize}px` } : undefined}
                        className={cn(
                          (header.column.id === "emailVerified" ||
                            header.column.id === "createdAt") &&
                            "hidden lg:table-cell",
                          header.column.id === "actions" && "text-right",
                        )}
                      >
                        {header.isPlaceholder ? null : header.column.getCanSort() ? (
                          <button
                            type="button"
                            className="flex h-full w-full cursor-pointer items-center justify-between gap-2 select-none"
                            onClick={header.column.getToggleSortingHandler()}
                          >
                            {flexRender(header.column.columnDef.header, header.getContext())}
                            {{
                              asc: (
                                <Icon
                                  icon={ChevronUpIcon}
                                  size={14}
                                  className="size-3.5 shrink-0 opacity-80"
                                />
                              ),
                              desc: (
                                <Icon
                                  icon={ChevronDownIcon}
                                  size={14}
                                  className="size-3.5 shrink-0 opacity-80"
                                />
                              ),
                            }[sort as string] ?? null}
                          </button>
                        ) : (
                          flexRender(header.column.columnDef.header, header.getContext())
                        )}
                      </TableHead>
                    );
                  })}
                </TableRow>
              ))}
            </TableHeader>
            <TableBody>
              {usersQuery.isLoading ? (
                <UsersTableSkeleton />
              ) : table.getRowModel().rows.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={columns.length} className="h-24 text-center">
                    <span className="text-muted-foreground text-sm">
                      No se encontraron usuarios con esos filtros.
                    </span>
                  </TableCell>
                </TableRow>
              ) : (
                table.getRowModel().rows.map((row) => (
                  <TableRow
                    key={row.id}
                    data-state={row.getIsSelected() ? "selected" : undefined}
                    className="h-14"
                  >
                    {row.getVisibleCells().map((cell) => (
                      <TableCell
                        key={cell.id}
                        className={cn(
                          (cell.column.id === "emailVerified" || cell.column.id === "createdAt") &&
                            "hidden lg:table-cell",
                          cell.column.id === "actions" && "text-right",
                        )}
                      >
                        {flexRender(cell.column.columnDef.cell, cell.getContext())}
                      </TableCell>
                    ))}
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </ScrollArea>

        <FrameFooter className="p-1.5 pt-2">
          <NumberedPagination
            page={page - 1}
            totalPages={totalPages}
            hasMore={hasMore}
            isFetching={usersQuery.isFetching}
            onPageChange={(nextPage) => goTo({ page: nextPage + 1 })}
          />
        </FrameFooter>
      </Frame>

      <Drawer
        open={isDetailOpen}
        onOpenChange={setIsDetailOpen}
        position={isMobile ? "bottom" : "right"}
      >
        <DrawerPopup
          variant="inset"
          showCloseButton={!isMobile}
          showBar={isMobile}
          className="sm:max-w-md"
        >
          <DrawerHeader className="px-5 py-4">
            <DrawerTitle>Detalles de usuario</DrawerTitle>
          </DrawerHeader>

          <DrawerPanel className="p-0">
            {detailQuery.isLoading ? (
              <div className="text-muted-foreground flex h-32 items-center justify-center gap-2 text-sm">
                <Spinner className="size-4" />
                <span>Cargando detalle…</span>
              </div>
            ) : selectedUser ? (
              <div className="flex flex-col gap-5 p-5">
                {isSelf && (
                  <p className="bg-muted text-muted-foreground rounded-md p-2.5 text-xs">
                    Esta es tu cuenta. No puedes cambiar tu propio rol, suspenderte ni eliminarte
                    desde aquí.
                  </p>
                )}

                <div className="grid grid-cols-2 gap-x-4 gap-y-4">
                  <DetailField label="Nombre" className="col-span-2">
                    <Input
                      value={nameDraft}
                      onChange={(event) => setNameDraft(event.target.value)}
                      aria-label="Nombre del usuario"
                      placeholder="Nombre del usuario"
                      className="h-8 text-xs"
                      disabled={isSelf || isMutating}
                    />
                  </DetailField>

                  <DetailField label="Correo" className="col-span-2">
                    <Input
                      type="email"
                      value={emailDraft}
                      onChange={(event) => setEmailDraft(event.target.value)}
                      aria-label="Correo del usuario"
                      placeholder="Correo del usuario"
                      className="h-8 text-xs"
                      disabled={isSelf || isMutating}
                    />
                  </DetailField>

                  <DetailField label="Verificación">
                    <Select
                      items={VERIFICATION_ITEMS}
                      value={verifiedDraft ? "true" : "false"}
                      onValueChange={(value) => setVerifiedDraft(value === "true")}
                    >
                      <SelectTrigger
                        size="sm"
                        className="h-8 w-full text-xs"
                        disabled={isSelf || isMutating}
                      >
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        {VERIFICATION_ITEMS.map((item) => (
                          <SelectItem key={item.value} value={item.value}>
                            {item.label}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </DetailField>

                  <DetailField label="Rol">
                    <div className="flex items-center gap-2">
                      <Select
                        items={ROLE_ITEMS as unknown as Array<{ value: string; label: string }>}
                        value={roleDraft}
                        onValueChange={(value) => setRoleDraft(value as AdminUserRole)}
                      >
                        <SelectTrigger
                          size="sm"
                          className="h-8 w-full text-xs"
                          disabled={isSelf || isMutating}
                        >
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          {ROLE_ITEMS.map((item) => (
                            <SelectItem key={item.value} value={item.value}>
                              {item.label}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                      {updateRole.isPending && <Spinner className="size-4" />}
                    </div>
                  </DetailField>

                  <DetailField label="Registro">
                    {new Date(selectedUser.createdAt).toLocaleString(undefined, {
                      dateStyle: "short",
                      timeStyle: "short",
                    })}
                  </DetailField>

                  <DetailField label="Última actualización">
                    {new Date(selectedUser.updatedAt).toLocaleString(undefined, {
                      dateStyle: "short",
                      timeStyle: "short",
                    })}
                  </DetailField>

                  <DetailField label="ID" className="col-span-2">
                    <span className="font-mono text-xs break-all">{selectedUser.id}</span>
                  </DetailField>
                </div>

                <Tabs defaultValue="sesiones" className="flex min-w-0 flex-col gap-3">
                  <div className="min-w-0 border-b">
                    <ScrollArea
                      fade="x"
                      hideScrollbar
                      className="w-full"
                      viewportClassName="h-auto! overflow-y-hidden!"
                    >
                      <TabsList variant="underline" className="w-max min-w-full">
                        <TabsTab value="sesiones">Sesiones</TabsTab>
                        <TabsTab value="academico">Datos académicos</TabsTab>
                        <TabsTab value="feedback">Retroalimentación</TabsTab>
                        <TabsTab value="notificaciones">Notificaciones</TabsTab>
                        <TabsTab value="cuenta">Gestión de cuenta</TabsTab>
                      </TabsList>
                    </ScrollArea>
                  </div>

                  <TabsPanel value="sesiones" className="flex flex-col gap-2">
                    {sessionsQuery.isLoading ? (
                      <div className="text-muted-foreground flex items-center justify-center gap-2 py-6 text-sm">
                        <Spinner className="size-4" />
                        <span>Cargando sesiones…</span>
                      </div>
                    ) : sessionsQuery.data?.length ? (
                      <>
                        {sessionsQuery.data.map((session) => (
                          <div
                            key={session.id}
                            className="bg-muted/40 flex flex-col gap-1 rounded-lg p-3 text-xs"
                          >
                            <div className="flex items-center justify-between gap-2">
                              <span className="font-medium">
                                {session.ipAddress ?? "IP desconocida"}
                              </span>
                              <Button
                                variant="ghost"
                                size="sm"
                                className="h-6 text-xs"
                                disabled={revokeSession.isPending}
                                onClick={() => void handleRevokeSession(session.token)}
                              >
                                Revocar
                              </Button>
                            </div>
                            <span className="text-muted-foreground break-all">
                              {session.userAgent ?? "Sin user-agent"}
                            </span>
                            <span className="text-muted-foreground">
                              Inicio:{" "}
                              {new Date(session.createdAt).toLocaleString(undefined, {
                                dateStyle: "short",
                                timeStyle: "short",
                              })}
                              {" · Expira: "}
                              {new Date(session.expiresAt).toLocaleString(undefined, {
                                dateStyle: "short",
                                timeStyle: "short",
                              })}
                            </span>
                          </div>
                        ))}
                        <Button
                          variant="outline"
                          size="sm"
                          className="text-xs"
                          disabled={revokeAllSessions.isPending}
                          onClick={() => void handleRevokeAllSessions()}
                        >
                          Revocar todas las sesiones
                        </Button>
                      </>
                    ) : (
                      <p className="text-muted-foreground text-sm">
                        El usuario no tiene sesiones activas.
                      </p>
                    )}
                  </TabsPanel>

                  <TabsPanel value="academico" className="flex flex-col gap-3">
                    {academicQuery.isLoading ? (
                      <DetailSkeleton />
                    ) : academicQuery.data ? (
                      <>
                        <DetailField label="Carnet">
                          <Input
                            value={carnetDraft}
                            onChange={(event) => setCarnetDraft(event.target.value)}
                            placeholder="2020042209"
                            aria-label="Carnet"
                            className="h-8 text-xs"
                            disabled={isSelf || isMutating}
                          />
                        </DetailField>

                        <DetailField label="Universidad">
                          <SearchableCombobox
                            label="Universidad"
                            items={universitiesQuery.data ?? []}
                            value={
                              (universitiesQuery.data ?? []).find(
                                (item) => item.id === universityIdDraft,
                              ) ?? null
                            }
                            onValueChange={(item) => {
                              setUniversityIdDraft(item ? item.id : null);
                              setCampusIdDraft(null);
                              setAcademicUnitIdDraft(null);
                              setStudyPlanIdDraft(null);
                            }}
                            itemToString={(item) => item.name}
                            placeholder="Sin seleccionar"
                            disabled={universitiesQuery.isLoading || isSelf || isMutating}
                          />
                        </DetailField>

                        <DetailField label="Sede">
                          <SearchableCombobox
                            label="Sede"
                            items={campusesQuery.data ?? []}
                            value={
                              (campusesQuery.data ?? []).find(
                                (item) => item.id === campusIdDraft,
                              ) ?? null
                            }
                            onValueChange={(item) => {
                              setCampusIdDraft(item ? item.id : null);
                              setAcademicUnitIdDraft(null);
                              setStudyPlanIdDraft(null);
                            }}
                            itemToString={(item) =>
                              item.code ? `${item.code}: ${item.name}` : item.name
                            }
                            placeholder="Sin seleccionar"
                            disabled={
                              universityIdDraft === null ||
                              campusesQuery.isLoading ||
                              isSelf ||
                              isMutating
                            }
                          />
                        </DetailField>

                        <DetailField label="Escuela">
                          <SearchableCombobox
                            label="Escuela"
                            items={academicUnitsQuery.data ?? []}
                            value={
                              (academicUnitsQuery.data ?? []).find(
                                (item) => item.id === academicUnitIdDraft,
                              ) ?? null
                            }
                            onValueChange={(item) => {
                              setAcademicUnitIdDraft(item ? item.id : null);
                              setStudyPlanIdDraft(null);
                            }}
                            itemToString={(item) =>
                              item.code ? `${item.code}: ${item.name}` : item.name
                            }
                            placeholder="Sin seleccionar"
                            disabled={
                              campusIdDraft === null ||
                              academicUnitsQuery.isLoading ||
                              isSelf ||
                              isMutating
                            }
                          />
                        </DetailField>

                        <DetailField label="Plan de estudios">
                          <SearchableCombobox
                            label="Plan de estudios"
                            items={studyPlansQuery.data ?? []}
                            value={
                              (studyPlansQuery.data ?? []).find(
                                (item) => item.id === studyPlanIdDraft,
                              ) ?? null
                            }
                            onValueChange={(item) => setStudyPlanIdDraft(item ? item.id : null)}
                            itemToString={(item) => item.name.replace(" - ", ": ")}
                            placeholder="Sin seleccionar"
                            disabled={
                              academicUnitIdDraft === null ||
                              studyPlansQuery.isLoading ||
                              isSelf ||
                              isMutating
                            }
                          />
                        </DetailField>

                        <DetailField label="Año de ingreso">
                          {academicQuery.data.entry_year ?? "—"}
                        </DetailField>

                        <DetailField label="Onboarding">
                          {academicQuery.data.onboarding_completed_at
                            ? `Completado el ${new Date(academicQuery.data.onboarding_completed_at).toLocaleDateString()}`
                            : "Pendiente"}
                        </DetailField>
                      </>
                    ) : (
                      <p className="text-muted-foreground text-sm">No hay datos académicos.</p>
                    )}
                  </TabsPanel>

                  <TabsPanel value="feedback" className="flex flex-col gap-2">
                    {feedbackQuery.isLoading ? (
                      <div className="text-muted-foreground flex items-center justify-center gap-2 py-6 text-sm">
                        <Spinner className="size-4" />
                        <span>Cargando retroalimentación…</span>
                      </div>
                    ) : feedbackQuery.data?.length ? (
                      feedbackQuery.data.map((item) => (
                        <div
                          key={item.id}
                          className="bg-muted/40 flex flex-col gap-1 rounded-lg p-3 text-xs"
                        >
                          <div className="flex items-center justify-between gap-2">
                            <Badge variant="outline" size="sm">
                              {getFeedbackTypeLabel(item.type)}
                            </Badge>
                            <span className="text-muted-foreground">
                              {new Date(item.created_at).toLocaleDateString()}
                            </span>
                          </div>
                          <p className="break-words">{item.content}</p>
                          {item.admin_notes && (
                            <p className="text-muted-foreground">Notas: {item.admin_notes}</p>
                          )}
                        </div>
                      ))
                    ) : (
                      <p className="text-muted-foreground text-sm">
                        El usuario no ha enviado retroalimentación.
                      </p>
                    )}
                  </TabsPanel>

                  <TabsPanel value="notificaciones" className="flex flex-col gap-3">
                    <div className="flex flex-col gap-2 rounded-lg border p-3">
                      <Label htmlFor="admin-notification-title" className="text-sm font-medium">
                        Enviar notificación
                      </Label>
                      <Input
                        id="admin-notification-title"
                        value={notificationTitle}
                        onChange={(event) => setNotificationTitle(event.target.value)}
                        placeholder="Título"
                        className="h-8 text-xs"
                      />
                      <Textarea
                        id="admin-notification-message"
                        value={notificationMessage}
                        onChange={(event) => setNotificationMessage(event.target.value)}
                        placeholder="Mensaje"
                        aria-label="Mensaje de la notificación"
                        className="min-h-16 text-xs"
                      />
                      <Input
                        id="admin-notification-link"
                        value={notificationLink}
                        onChange={(event) => setNotificationLink(event.target.value)}
                        placeholder="Enlace (opcional)"
                        className="h-8 text-xs"
                      />
                      <Button
                        size="sm"
                        className="text-xs"
                        disabled={
                          !notificationTitle.trim() ||
                          !notificationMessage.trim() ||
                          sendNotification.isPending
                        }
                        onClick={() => void handleSendNotification()}
                      >
                        Enviar notificación
                      </Button>
                    </div>

                    {notificationsQuery.isLoading ? (
                      <div className="text-muted-foreground flex items-center justify-center gap-2 py-6 text-sm">
                        <Spinner className="size-4" />
                        <span>Cargando notificaciones…</span>
                      </div>
                    ) : notificationsQuery.data?.length ? (
                      notificationsQuery.data.map((item) => (
                        <div
                          key={item.id}
                          className="bg-muted/40 flex flex-col gap-1 rounded-lg p-3 text-xs"
                        >
                          <div className="flex items-center justify-between gap-2">
                            <span className="font-medium">{item.title}</span>
                            <span className="text-muted-foreground">
                              {new Date(item.created_at).toLocaleDateString()}
                            </span>
                          </div>
                          <p className="break-words">{item.message}</p>
                          {item.link && (
                            <p className="text-muted-foreground break-all">{item.link}</p>
                          )}
                        </div>
                      ))
                    ) : (
                      <p className="text-muted-foreground text-sm">
                        El usuario no tiene notificaciones.
                      </p>
                    )}
                  </TabsPanel>

                  <TabsPanel value="cuenta" className="flex flex-col gap-3">
                    <DetailField label="Estado">
                      <Select
                        items={STATUS_ITEMS}
                        value={statusDraft}
                        onValueChange={(value) => setStatusDraft(value as "active" | "banned")}
                      >
                        <SelectTrigger
                          size="sm"
                          className="h-8 w-full text-xs"
                          disabled={isSelf || isMutating}
                        >
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          {STATUS_ITEMS.map((item) => (
                            <SelectItem key={item.value} value={item.value}>
                              {item.label}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </DetailField>

                    {selectedUser.banned && (
                      <div className="bg-muted/40 flex flex-col gap-1 rounded-lg p-3 text-xs">
                        <p className="break-words">
                          <span className="text-muted-foreground">Motivo: </span>
                          {selectedUser.banReason ?? "Sin motivo registrado"}
                        </p>
                        {selectedUser.banExpires && (
                          <p>
                            <span className="text-muted-foreground">Expira: </span>
                            {new Date(selectedUser.banExpires).toLocaleString()}
                          </p>
                        )}
                      </div>
                    )}

                    {statusDraft === "banned" && !selectedUser.banned && (
                      <div className="flex flex-col gap-2">
                        <Textarea
                          value={banReason}
                          onChange={(event) => setBanReason(event.target.value)}
                          placeholder="Motivo de la suspensión (opcional)"
                          aria-label="Motivo de la suspensión"
                          className="min-h-16 text-xs"
                          disabled={isSelf || isMutating}
                        />
                        <Select
                          items={BAN_DURATION_ITEMS}
                          value={banDuration}
                          onValueChange={(value) => setBanDuration(value ?? "permanent")}
                        >
                          <SelectTrigger
                            size="sm"
                            className="h-8 w-36 text-xs"
                            disabled={isSelf || isMutating}
                          >
                            <SelectValue />
                          </SelectTrigger>
                          <SelectContent>
                            {BAN_DURATION_ITEMS.map((item) => (
                              <SelectItem key={item.value} value={item.value}>
                                {item.label}
                              </SelectItem>
                            ))}
                          </SelectContent>
                        </Select>
                      </div>
                    )}

                    <p className="text-muted-foreground text-xs">
                      Los cambios de estado se aplican al guardar.
                    </p>

                    <div className="mt-1 flex flex-wrap items-center justify-between gap-2">
                      <p className="text-muted-foreground text-xs">
                        Esta acción no se puede deshacer.
                      </p>
                      <Button
                        variant="destructive"
                        size="sm"
                        className="text-xs"
                        disabled={isSelf || isMutating}
                        onClick={() => setIsDeleteOpen(true)}
                      >
                        Eliminar usuario
                      </Button>
                    </div>
                  </TabsPanel>
                </Tabs>
              </div>
            ) : (
              <p className="text-muted-foreground py-6 text-center text-sm">
                No se pudo cargar la información del usuario.
              </p>
            )}
          </DrawerPanel>

          <DrawerFooter variant="bare" className="px-5">
            <Button
              disabled={!hasUnsavedChanges || isSelf || isMutating}
              onClick={() => void handleSave()}
            >
              {isMutating && <Spinner className="size-4" />}
              Guardar
            </Button>
          </DrawerFooter>
        </DrawerPopup>
      </Drawer>

      <AlertDialog open={isDeleteOpen} onOpenChange={setIsDeleteOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Eliminar a este usuario?</AlertDialogTitle>
            <AlertDialogDescription>
              Esta acción es permanente y no se puede deshacer. Se eliminará la cuenta y todos sus
              datos asociados.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deleteUser.isPending}>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              variant="destructive"
              disabled={deleteUser.isPending}
              onClick={() => void handleDelete()}
            >
              {deleteUser.isPending ? <Spinner className="mr-1.5 size-4" /> : null}
              Eliminar definitivamente
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
