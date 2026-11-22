import { HttpApi, HttpApiEndpoint, HttpApiGroup } from "effect/http-api";
import * as Schema from "effect/Schema";

import { FeedbackItem } from "../domain/Feedback";
import { NotificationItem } from "../domain/Notifications";
import {
  BadRequestError,
  BanUserPayload,
  ForbiddenError,
  InternalServerError,
  ListUsersQuery,
  ListUsersResponse,
  NotFoundError,
  SendNotificationPayload,
  SubmitOnboardingPayload,
  SuccessResponse,
  UnauthorizedError,
  UpdateRolePayload,
  UpdateStudyPlanPayload,
  UpdateVerificationPayload,
  UserAcademicProfile,
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
  HttpApiEndpoint.patch("updateUserVerification", "/users/:id/verification", {
    params: { id: Schema.String },
    payload: UpdateVerificationPayload,
    success: SuccessResponse,
    error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
  }),
  HttpApiEndpoint.get("getUserAcademicProfile", "/users/:id/academic-profile", {
    params: { id: Schema.String },
    success: UserAcademicProfile,
    error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
  }),
  HttpApiEndpoint.get("getUserFeedback", "/users/:id/feedback", {
    params: { id: Schema.String },
    success: Schema.Array(FeedbackItem),
    error: [UnauthorizedError, ForbiddenError, InternalServerError],
  }),
  HttpApiEndpoint.get("getUserNotifications", "/users/:id/notifications", {
    params: { id: Schema.String },
    success: Schema.Array(NotificationItem),
    error: [UnauthorizedError, ForbiddenError, InternalServerError],
  }),
  HttpApiEndpoint.post("sendUserNotification", "/users/:id/notifications", {
    params: { id: Schema.String },
    payload: SendNotificationPayload,
    success: SuccessResponse,
    error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
  }),
) {}

export class UsersApi extends HttpApi.make("claustrum").add(UsersApiGroup) {}
