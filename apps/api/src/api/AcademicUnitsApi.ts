import { Schema } from "effect";
import { HttpApiEndpoint, HttpApiGroup } from "effect/http-api";

import { AcademicUnit, AcademicUnitsQuery } from "../domain/AcademicUnits";

export class AcademicUnitsApiGroup extends HttpApiGroup.make("academicUnits")
  .add(
    HttpApiEndpoint.get("list", "/", {
      query: AcademicUnitsQuery,
      success: Schema.Array(AcademicUnit),
    }),
  )
  .prefix("/academicunits") {}
