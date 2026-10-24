import * as Schema from "effect/Schema";

/**
 * ITCR carnet: 10 digits, `<year:4><sequence:6>` (e.g. 2020042209).
 * Mirrors the `user_carnet_format_check` constraint so the API rejects an
 * invalid carnet with a 400 instead of surfacing a Postgres constraint
 * violation as a 500.
 */
const Carnet = Schema.String.pipe(Schema.check(Schema.isPattern(/^20[0-9]{2}[0-9]{6}$/)));

export class UnauthorizedError extends Schema.TaggedError<UnauthorizedError>()(
  "UnauthorizedError",
  {
    error: Schema.String,
  },
  { httpApiStatus: 401 },
) {}

export class ForbiddenError extends Schema.TaggedError<ForbiddenError>()(
  "ForbiddenError",
  {
    error: Schema.String,
    reason: Schema.optional(Schema.NullOr(Schema.String)),
  },
  { httpApiStatus: 403 },
) {}

export class NotFoundError extends Schema.TaggedError<NotFoundError>()(
  "NotFoundError",
  {
    error: Schema.String,
  },
  { httpApiStatus: 404 },
) {}

export class BadRequestError extends Schema.TaggedError<BadRequestError>()(
  "BadRequestError",
  {
    error: Schema.String,
    details: Schema.optional(Schema.Unknown),
  },
  { httpApiStatus: 400 },
) {}

export class InternalServerError extends Schema.TaggedError<InternalServerError>()(
  "InternalServerError",
  {
    error: Schema.String,
  },
  { httpApiStatus: 500 },
) {}

export { type AuthUser, CurrentUser, checkAuth, checkRole } from "./Auth";

export const UserRole = Schema.Literals(["admin", "moderator", "user"]);
export type UserRole = typeof UserRole.Type;

export const SuccessResponse = Schema.Struct({
  success: Schema.Boolean,
});
export type SuccessResponse = typeof SuccessResponse.Type;

export const UpdateStudyPlanPayload = Schema.Struct({
  studyPlanId: Schema.Number,
  campusId: Schema.Number,
  entryYear: Schema.optional(Schema.Number),
  carnet: Schema.optional(Carnet),
});
export type UpdateStudyPlanPayload = typeof UpdateStudyPlanPayload.Type;

export const SubmitOnboardingPayload = Schema.Struct({
  campusId: Schema.Number,
  academicUnitId: Schema.optional(Schema.Number),
  studyPlanId: Schema.Number,
  entryYear: Schema.optional(Schema.NullOr(Schema.Number)),
  carnet: Schema.optional(Schema.NullOr(Carnet)),
});
export type SubmitOnboardingPayload = typeof SubmitOnboardingPayload.Type;

export const ListUsersQuery = Schema.Struct({
  limit: Schema.optional(Schema.NumberFromString),
  offset: Schema.optional(Schema.NumberFromString),
  search: Schema.optional(Schema.String),
  role: Schema.optional(UserRole),
  banned: Schema.optional(Schema.Literals(["true", "false"])),
});
export type ListUsersQuery = typeof ListUsersQuery.Type;

export const UserAdminItem = Schema.Struct({
  id: Schema.String,
  name: Schema.String,
  email: Schema.String,
  emailVerified: Schema.Boolean,
  image: Schema.NullOr(Schema.String),
  role: Schema.NullOr(Schema.String),
  banned: Schema.NullOr(Schema.Boolean),
  banReason: Schema.NullOr(Schema.String),
  banExpires: Schema.NullOr(Schema.String),
  createdAt: Schema.String,
  updatedAt: Schema.String,
});
export type UserAdminItem = typeof UserAdminItem.Type;

export const ListUsersResponse = Schema.Struct({
  users: Schema.Array(UserAdminItem),
  total: Schema.Number,
});
export type ListUsersResponse = typeof ListUsersResponse.Type;

export const UpdateRolePayload = Schema.Struct({
  role: UserRole,
});
export type UpdateRolePayload = typeof UpdateRolePayload.Type;

export const BanUserPayload = Schema.Struct({
  reason: Schema.optional(Schema.String),
  expiresInSeconds: Schema.optional(Schema.Number),
});
export type BanUserPayload = typeof BanUserPayload.Type;

export const UserProfileResponse = Schema.Struct({
  id: Schema.String,
  email: Schema.String,
  name: Schema.String,
  role: Schema.String,
  banned: Schema.Boolean,
  session: Schema.NullOr(Schema.Unknown),
  user: Schema.Unknown,
  onboardingStatus: Schema.NullOr(Schema.Unknown),
  profileContext: Schema.NullOr(Schema.Unknown),
  userStudyPlanId: Schema.optional(Schema.Number),
  studyPlanId: Schema.optional(Schema.Number),
  campusId: Schema.optional(Schema.Number),
  entryYear: Schema.optional(Schema.Number),
  studyPlanName: Schema.optional(Schema.NullOr(Schema.String)),
  campusName: Schema.optional(Schema.NullOr(Schema.String)),
  universityId: Schema.optional(Schema.NullOr(Schema.Number)),
  departmentId: Schema.optional(Schema.NullOr(Schema.Number)),
  academicUnitId: Schema.optional(Schema.NullOr(Schema.Number)),
  termId: Schema.optional(Schema.NullOr(Schema.Number)),
  carnet: Schema.optional(Schema.NullOr(Carnet)),
  user_study_plan_id: Schema.optional(Schema.Number),
  study_plan_id: Schema.optional(Schema.Number),
  campus_id: Schema.optional(Schema.Number),
  entry_year: Schema.optional(Schema.Number),
  study_plan_name: Schema.optional(Schema.NullOr(Schema.String)),
  campus_name: Schema.optional(Schema.NullOr(Schema.String)),
  academic_unit_id: Schema.optional(Schema.NullOr(Schema.Number)),
  term_id: Schema.optional(Schema.NullOr(Schema.Number)),
});
export type UserProfileResponse = typeof UserProfileResponse.Type;
