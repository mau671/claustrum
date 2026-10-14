import { Schema } from "effect";
import { HttpApiEndpoint, HttpApiGroup } from "effect/http-api";

import {
  CourseDetail,
  CourseEquivalent,
  CourseEquivalentsQuery,
  CourseGroup,
  CourseGroupsQuery,
  CourseIdParams,
  CourseListItem,
  CourseNotFound,
  CourseProfessorsQuery,
  CourseRecentProfessor,
  CoursesQuery,
  CourseTermsQuery,
} from "../domain/Courses";
import { AcademicTerm } from "../domain/Terms";

export class CoursesApi extends HttpApiGroup.make("courses")
  .add(
    HttpApiEndpoint.get("list", "/", {
      query: CoursesQuery,
      success: Schema.Array(CourseListItem),
    }),
  )
  .add(
    HttpApiEndpoint.get("getById", "/:id", {
      params: CourseIdParams,
      success: CourseDetail,
      error: CourseNotFound,
    }),
  )
  .add(
    HttpApiEndpoint.get("getTerms", "/:id/terms", {
      params: CourseIdParams,
      query: CourseTermsQuery,
      success: Schema.Array(AcademicTerm),
    }),
  )
  .add(
    HttpApiEndpoint.get("getGroups", "/:id/groups", {
      params: CourseIdParams,
      query: CourseGroupsQuery,
      success: Schema.Array(CourseGroup),
    }),
  )
  .add(
    HttpApiEndpoint.get("getProfessors", "/:id/professors", {
      params: CourseIdParams,
      query: CourseProfessorsQuery,
      success: Schema.Array(CourseRecentProfessor),
    }),
  )
  .add(
    HttpApiEndpoint.get("getEquivalents", "/:id/equivalents", {
      params: CourseIdParams,
      query: CourseEquivalentsQuery,
      success: Schema.Array(CourseEquivalent),
    }),
  )
  .prefix("/courses") {}

export class CoursesApiGroup extends CoursesApi {}
