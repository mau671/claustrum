import type { ColumnDef, RowSelectionState, SortingState } from "@tanstack/react-table";

import {
  Cancel01Icon,
  CheckIcon,
  ChevronDownIcon,
  ChevronUpIcon,
  RotateCcwIcon,
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
import { useCallback, useEffect, useMemo, useState } from "react";

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
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Frame, FrameFooter, FrameHeader } from "@/components/ui/frame";
import { Icon } from "@/components/ui/icon";
import { InputGroup, InputGroupAddon, InputGroupInput } from "@/components/ui/input-group";
import { Label } from "@/components/ui/label";
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
import { Textarea } from "@/components/ui/textarea";
import { toast } from "@/components/ui/toast";
import { UserAvatar } from "@/components/ui/user-avatar";
import {
  useAdminUser,
  useAdminUsers,
  useBanAdminUser,
  useDeleteAdminUser,
  useUnbanAdminUser,
  useUpdateAdminUserRole,
} from "@/lib/hooks/use-admin-users";
import { useAuthUser } from "@/lib/hooks/use-queries";
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
        <TableRow key={index} className="border-border/70 border-b">
          <TableCell>
            <Skeleton className="size-4 rounded-[.25rem]" />
          </TableCell>
          <TableCell className="max-w-0">
            <div className="flex items-center gap-2.5">
              <Skeleton className="size-8 rounded-full" />
              <div className="flex flex-col gap-1">
                <Skeleton className={cn("h-3.5 rounded-sm", index % 2 ? "w-40" : "w-32")} />
                <Skeleton className="h-2.5 w-48 rounded-sm" />
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
            <Skeleton className="h-3.5 w-16 rounded-sm" />
          </TableCell>
          <TableCell className="hidden md:table-cell">
            <Skeleton className="h-3.5 w-20 rounded-sm" />
          </TableCell>
          <TableCell>
            <Skeleton className="h-6 w-20 rounded-sm" />
          </TableCell>
        </TableRow>
      ))}
    </>
  );
}

export const Route = createLazyFileRoute("/moderation/users")({
  component: AdminUsersPage,
});

function AdminUsersPage() {
  const navigate = useNavigate();
  const isAdmin = useIsAdmin();
  const { data: authUser } = useAuthUser();
  const search = Route.useSearch();

  const page = search.page ?? 1;
  const searchTerm = search.search ?? "";
  const roleFilter: RoleFilter = search.role ?? "all";
  const bannedFilter: BannedFilter = search.banned ?? "all";
  const sortBy: AdminUserSortBy = search.sortBy ?? "createdAt";
  const sortDesc = search.sortDesc ?? true;

  const [searchInput, setSearchInput] = useState(searchTerm);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [isDetailOpen, setIsDetailOpen] = useState(false);
  const [isDeleteOpen, setIsDeleteOpen] = useState(false);
  const [isBulkDeleteOpen, setIsBulkDeleteOpen] = useState(false);
  const [banReason, setBanReason] = useState("");
  const [banDuration, setBanDuration] = useState("permanent");
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
  const detailQuery = useAdminUser(isDetailOpen ? selectedId : null, isAdmin);
  const updateRole = useUpdateAdminUserRole();
  const banUser = useBanAdminUser();
  const unbanUser = useUnbanAdminUser();
  const deleteUser = useDeleteAdminUser();

  useEffect(() => {
    setSearchInput(searchTerm);
  }, [searchTerm]);

  useEffect(() => {
    if (!isAdmin) {
      void navigate({ to: "/moderation/reviews", replace: true });
    }
  }, [isAdmin, navigate]);

  const openDetail = useCallback((id: string) => {
    setSelectedId(id);
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
            onClick={() => openDetail(row.original.id)}
          >
            Ver detalle
          </Button>
        ),
      },
    ],
    [openDetail],
  );

  const users = usersQuery.data?.users ?? [];
  const total = usersQuery.data?.total ?? 0;
  const totalPages = Math.max(1, Math.ceil(total / PAGE_SIZE));
  const hasMore = page < totalPages;
  const selectedUser = detailQuery.data ?? null;
  const isSelf = selectedUser?.id === authUser?.id;
  const isMutating =
    updateRole.isPending || banUser.isPending || unbanUser.isPending || deleteUser.isPending;
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

  async function handleRoleChange(role: AdminUserRole) {
    if (!selectedUser) return;
    try {
      await updateRole.mutateAsync({ id: selectedUser.id, role });
      toast.success("Rol del usuario actualizado");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo actualizar el rol.");
    }
  }

  async function handleBan() {
    if (!selectedUser) return;
    try {
      await banUser.mutateAsync({
        id: selectedUser.id,
        reason: banReason,
        expiresInSeconds: banDuration === "permanent" ? undefined : Number(banDuration),
      });
      toast.success("Usuario suspendido");
      setBanReason("");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo suspender al usuario.");
    }
  }

  async function handleUnban() {
    if (!selectedUser) return;
    try {
      await unbanUser.mutateAsync(selectedUser.id);
      toast.success("Usuario reactivado");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo reactivar al usuario.");
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

  async function handleBulkBan() {
    const ids = Object.keys(rowSelection);
    try {
      await Promise.all(
        ids.map((id) => banUser.mutateAsync({ id, reason: "Suspensión masiva desde moderación" })),
      );
      toast.success(
        `${ids.length} ${ids.length === 1 ? "usuario suspendido" : "usuarios suspendidos"}`,
      );
      setRowSelection({});
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo suspender a los usuarios.");
    }
  }

  async function handleBulkDelete() {
    const ids = Object.keys(rowSelection);
    try {
      await Promise.all(ids.map((id) => deleteUser.mutateAsync(id)));
      toast.success(
        `${ids.length} ${ids.length === 1 ? "usuario eliminado" : "usuarios eliminados"}`,
      );
      setIsBulkDeleteOpen(false);
      setRowSelection({});
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "No se pudo eliminar a los usuarios.");
    }
  }

  const selectionButtons = (
    <>
      <Button variant="ghost" size="sm" className="h-7 text-xs" onClick={() => setRowSelection({})}>
        Limpiar
      </Button>
      <Button
        variant="outline"
        size="sm"
        className="h-7 text-xs"
        disabled={isMutating}
        onClick={() => void handleBulkBan()}
      >
        Suspender
      </Button>
      <Button
        variant="destructive"
        size="sm"
        className="h-7 text-xs"
        disabled={isMutating}
        onClick={() => setIsBulkDeleteOpen(true)}
      >
        Eliminar
      </Button>
    </>
  );

  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <Frame className="min-h-0 w-full flex-1 flex-col">
        <FrameHeader className="flex flex-col gap-3 px-4 py-3 sm:h-auto sm:flex-row sm:items-center sm:justify-end sm:px-5">
          {selectedCount > 0 && (
            <div className="mr-auto hidden items-center gap-2 sm:flex">
              <span className="text-sm font-medium">
                {selectedCount}{" "}
                {selectedCount === 1 ? "usuario seleccionado" : "usuarios seleccionados"}
              </span>
              <div className="flex items-center gap-2">{selectionButtons}</div>
            </div>
          )}

          <div className="flex flex-wrap items-center gap-2">
            <InputGroup className="h-8 w-52 sm:w-60">
              <InputGroupAddon>
                <Icon icon={Search01Icon} size={16} aria-hidden="true" />
              </InputGroupAddon>
              <InputGroupInput
                type="search"
                value={searchInput}
                onChange={(event) => debouncedSearch(event.target.value)}
                placeholder="Buscar por nombre o correo"
                aria-label="Buscar usuarios"
              />
            </InputGroup>

            <Select
              items={ROLE_FILTER_ITEMS as unknown as Array<{ value: string; label: string }>}
              value={roleFilter}
              onValueChange={(value) => goTo({ role: value as RoleFilter, page: 1 })}
            >
              <SelectTrigger size="sm" className="h-8 w-38 text-xs" aria-label="Filtrar por rol">
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
              <SelectTrigger size="sm" className="h-8 w-38 text-xs" aria-label="Filtrar por estado">
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
        </FrameHeader>

        {selectedCount > 0 && (
          <div className="flex flex-wrap items-center justify-between gap-2 px-4 py-2 sm:hidden">
            <span className="text-sm font-medium tabular-nums">{selectedCount}</span>
            <div className="flex items-center gap-2">{selectionButtons}</div>
          </div>
        )}

        <Table variant="card" className="table-fixed">
          <TableHeader>
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
                <TableRow key={row.id} data-state={row.getIsSelected() ? "selected" : undefined}>
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

      <Dialog open={isDetailOpen} onOpenChange={setIsDetailOpen}>
        <DialogContent className="max-h-[90vh] overflow-y-auto sm:max-w-lg">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2.5">
              {selectedUser && (
                <UserAvatar
                  id={selectedUser.id}
                  name={selectedUser.name}
                  email={selectedUser.email}
                  src={selectedUser.image ?? undefined}
                  className="size-9"
                />
              )}
              <span className="min-w-0 truncate">
                {selectedUser?.name ?? "Detalle del usuario"}
              </span>
            </DialogTitle>
            <DialogDescription className="break-all">
              {selectedUser?.email ?? "Cargando información…"}
            </DialogDescription>
          </DialogHeader>

          {detailQuery.isLoading ? (
            <div className="text-muted-foreground flex h-32 items-center justify-center gap-2 text-sm">
              <Spinner className="size-4" />
              <span>Cargando detalle…</span>
            </div>
          ) : selectedUser ? (
            <div className="space-y-5">
              {isSelf && (
                <p className="bg-muted text-muted-foreground rounded-md p-2.5 text-xs">
                  Esta es tu cuenta. No puedes cambiar tu propio rol, suspenderte ni eliminarte
                  desde aquí.
                </p>
              )}

              <div className="grid grid-cols-2 gap-x-4 gap-y-3 text-sm">
                <div>
                  <p className="text-muted-foreground text-xs">Rol actual</p>
                  <p className="mt-0.5 font-medium">{getRoleLabel(selectedUser.role)}</p>
                </div>
                <div>
                  <p className="text-muted-foreground text-xs">Estado</p>
                  <p className="mt-0.5 font-medium">
                    {selectedUser.banned ? "Suspendido" : "Activo"}
                  </p>
                </div>
                <div>
                  <p className="text-muted-foreground text-xs">Correo verificado</p>
                  <p className="mt-0.5 font-medium">{selectedUser.emailVerified ? "Sí" : "No"}</p>
                </div>
                <div>
                  <p className="text-muted-foreground text-xs">Registro</p>
                  <p className="mt-0.5 font-medium">
                    {new Date(selectedUser.createdAt).toLocaleString()}
                  </p>
                </div>
                <div>
                  <p className="text-muted-foreground text-xs">Última actualización</p>
                  <p className="mt-0.5 font-medium">
                    {new Date(selectedUser.updatedAt).toLocaleString()}
                  </p>
                </div>
                <div className="col-span-2">
                  <p className="text-muted-foreground text-xs">ID</p>
                  <p className="mt-0.5 font-mono text-xs break-all">{selectedUser.id}</p>
                </div>
                {selectedUser.banned && (
                  <>
                    <div className="col-span-2">
                      <p className="text-muted-foreground text-xs">Motivo de suspensión</p>
                      <p className="mt-0.5 font-medium">
                        {selectedUser.banReason ?? "Sin motivo registrado"}
                      </p>
                    </div>
                    {selectedUser.banExpires && (
                      <div className="col-span-2">
                        <p className="text-muted-foreground text-xs">Expira el</p>
                        <p className="mt-0.5 font-medium">
                          {new Date(selectedUser.banExpires).toLocaleString()}
                        </p>
                      </div>
                    )}
                  </>
                )}
              </div>

              <div className="border-t pt-4">
                <Label className="text-sm font-medium">Cambiar rol</Label>
                <div className="mt-2 flex items-center gap-2">
                  <Select
                    items={ROLE_ITEMS as unknown as Array<{ value: string; label: string }>}
                    value={(selectedUser.role as AdminUserRole) ?? "user"}
                    onValueChange={(value) => void handleRoleChange(value as AdminUserRole)}
                  >
                    <SelectTrigger
                      size="sm"
                      className="h-8 w-44 text-xs"
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
              </div>

              {selectedUser.banned ? (
                <div className="border-t pt-4">
                  <Button
                    variant="outline"
                    size="sm"
                    className="w-full"
                    disabled={isSelf || isMutating}
                    onClick={() => void handleUnban()}
                  >
                    <Icon icon={RotateCcwIcon} size={15} className="mr-1.5 size-3.5" />
                    Reactivar usuario
                  </Button>
                </div>
              ) : (
                <div className="space-y-2 border-t pt-4">
                  <Label htmlFor="ban-reason" className="text-sm font-medium">
                    Suspender usuario
                  </Label>
                  <Textarea
                    id="ban-reason"
                    value={banReason}
                    onChange={(event) => setBanReason(event.target.value)}
                    placeholder="Motivo de la suspensión (opcional)"
                    className="min-h-16 text-xs"
                    disabled={isSelf || isMutating}
                  />
                  <div className="flex items-center gap-2">
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
                    <Button
                      variant="destructive"
                      size="sm"
                      className="h-8"
                      disabled={isSelf || isMutating}
                      onClick={() => void handleBan()}
                    >
                      <Icon icon={Cancel01Icon} size={15} className="mr-1.5 size-3.5" />
                      Suspender
                    </Button>
                  </div>
                </div>
              )}

              <div className="border-t pt-4">
                <Button
                  variant="destructive"
                  size="sm"
                  className="w-full"
                  disabled={isSelf || isMutating}
                  onClick={() => setIsDeleteOpen(true)}
                >
                  Eliminar usuario
                </Button>
              </div>
            </div>
          ) : (
            <p className="text-muted-foreground py-6 text-center text-sm">
              No se pudo cargar la información del usuario.
            </p>
          )}
        </DialogContent>
      </Dialog>

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

      <AlertDialog open={isBulkDeleteOpen} onOpenChange={setIsBulkDeleteOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Eliminar a los usuarios seleccionados?</AlertDialogTitle>
            <AlertDialogDescription>
              Se eliminarán {selectedCount} {selectedCount === 1 ? "cuenta" : "cuentas"} de forma
              permanente. Esta acción no se puede deshacer.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deleteUser.isPending}>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              variant="destructive"
              disabled={deleteUser.isPending}
              onClick={() => void handleBulkDelete()}
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
