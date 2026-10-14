import { HttpApi, HttpApiEndpoint, HttpApiGroup } from "effect/http-api";
import * as Schema from "effect/Schema";

import {
  BadRequestError,
  BanUserPayload,
  ForbiddenError,
  InternalServerError,
  ListUsersQuery,
  ListUsersResponse,
  NotFoundError,
  SubmitOnboardingPayload,
  SuccessResponse,
  UnauthorizedError,
  UpdateRolePayload,
  UpdateStudyPlanPayload,
  UserAdminItem,
  UserProfileResponse,
} from "../domain/Users";

export class UsersApiGroup extends HttpApiGroup.make("users").add(
  HttpApiEndpoint.get("me", "/users/me", {
    success: UserProfileResponse,
    error: [UnauthorizedError, ForbiddenError, InternalServerError],
  }),
  HttpApiEndpoint.patch("updateStudyPlan", "/users/me/studyplan", {
    payload: UpdateStudyPlanPayload,
    success: SuccessResponse,
    error: [UnauthorizedError, ForbiddenError, InternalServerError],
  }),
  HttpApiEndpoint.post("submitOnboarding", "/onboarding/submit", {
    payload: SubmitOnboardingPayload,
    success: SuccessResponse,
    error: [UnauthorizedError, ForbiddenError, InternalServerError],
  }),
  HttpApiEndpoint.post("dismissOnboarding", "/onboarding/dismiss", {
    success: SuccessResponse,
    error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
  }),
  HttpApiEndpoint.get("listUsers", "/users", {
    query: ListUsersQuery,
    success: ListUsersResponse,
    error: [UnauthorizedError, ForbiddenError, InternalServerError],
  }),
  HttpApiEndpoint.get("getUserById", "/users/:id", {
    params: { id: Schema.String },
    success: UserAdminItem,
    error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
  }),
  HttpApiEndpoint.patch("updateUserRole", "/users/:id/role", {
    params: { id: Schema.String },
    payload: UpdateRolePayload,
    success: SuccessResponse,
    error: [BadRequestError, UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
  }),
  HttpApiEndpoint.post("banUser", "/users/:id/ban", {
    params: { id: Schema.String },
    payload: BanUserPayload,
    success: SuccessResponse,
    error: [BadRequestError, UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
  }),
  HttpApiEndpoint.delete("unbanUser", "/users/:id/ban", {
    params: { id: Schema.String },
    success: SuccessResponse,
    error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
  }),
  HttpApiEndpoint.delete("deleteUser", "/users/:id", {
    params: { id: Schema.String },
    success: SuccessResponse,
    error: [BadRequestError, UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
  }),
) {}

export class UsersApi extends HttpApi.make("claustrum").add(UsersApiGroup) {}
