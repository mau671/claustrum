import { Schema } from "effect";
import { HttpApiEndpoint, HttpApiGroup } from "effect/http-api";

import { University } from "../domain/Universities";

export class UniversitiesApiGroup extends HttpApiGroup.make("universities")
  .add(
    HttpApiEndpoint.get("list", "/", {
      success: Schema.Array(University),
    }),
  )
  .prefix("/universities") {}
