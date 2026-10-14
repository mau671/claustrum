import { Schema } from "effect";
import { HttpApi, HttpApiEndpoint, HttpApiGroup } from "effect/http-api";

import {
  ProfessorCourse,
  ProfessorDetail,
  ProfessorHistoryTerm,
  ProfessorIdParam,
  ProfessorNotFound,
  ProfessorReviewSummary,
  ProfessorSearchResult,
  ProfessorTerm,
  SearchProfessorsQuery,
} from "../domain/Professors";

export class ProfessorsApiGroup extends HttpApiGroup.make("professors")
  .add(
    HttpApiEndpoint.get("search", "/", {
      query: SearchProfessorsQuery,
      success: Schema.Array(ProfessorSearchResult),
    }),
    HttpApiEndpoint.get("getById", "/:id", {
      params: ProfessorIdParam,
      success: ProfessorDetail,
      error: ProfessorNotFound,
    }),
    HttpApiEndpoint.get("getSummary", "/:id/summary", {
      params: ProfessorIdParam,
      success: ProfessorReviewSummary,
    }),
    HttpApiEndpoint.get("getCourses", "/:id/courses", {
      params: ProfessorIdParam,
      success: Schema.Array(ProfessorCourse),
    }),
    HttpApiEndpoint.get("getTerms", "/:id/terms", {
      params: ProfessorIdParam,
      success: Schema.Array(ProfessorTerm),
    }),
    HttpApiEndpoint.get("getHistory", "/:id/history", {
      params: ProfessorIdParam,
      success: Schema.Array(ProfessorHistoryTerm),
    }),
  )
  .prefix("/professors") {}

export class ProfessorsApi extends HttpApi.make("ProfessorsApi").add(ProfessorsApiGroup) {}
