import { Schema } from "effect";
import { HttpApiEndpoint, HttpApiGroup } from "effect/http-api";

import {
  CoursePrerequisitesResponse,
  CourseRelation,
  StudyPlan,
  StudyPlanCourse,
  StudyPlanDetail,
  StudyPlanIdParams,
  StudyPlanNotFound,
  StudyPlanRelationsQuery,
  StudyPlansQuery,
} from "../domain/StudyPlans";

export class StudyPlansApiGroup extends HttpApiGroup.make("studyPlans")
  .add(
    HttpApiEndpoint.get("list", "/", {
      query: StudyPlansQuery,
      success: Schema.Array(StudyPlan),
    }),
  )
  .add(
    HttpApiEndpoint.get("getById", "/:id", {
      params: StudyPlanIdParams,
      success: StudyPlanDetail,
      error: StudyPlanNotFound,
    }),
  )
  .add(
    HttpApiEndpoint.get("getCourses", "/:id/courses", {
      params: StudyPlanIdParams,
      success: Schema.Array(StudyPlanCourse),
    }),
  )
  .add(
    HttpApiEndpoint.get("getRelations", "/:id/relations", {
      params: StudyPlanIdParams,
      query: StudyPlanRelationsQuery,
      success: Schema.Union([CoursePrerequisitesResponse, Schema.Array(CourseRelation)]),
    }),
  )
  .prefix("/studyplans") {}
