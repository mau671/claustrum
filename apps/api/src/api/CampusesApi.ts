import { Schema } from "effect";
import { HttpApiEndpoint, HttpApiGroup } from "effect/http-api";

import { Campus, CampusesQuery } from "../domain/Campuses";

export class CampusesApiGroup extends HttpApiGroup.make("campuses")
  .add(
    HttpApiEndpoint.get("list", "/", {
      query: CampusesQuery,
      success: Schema.Array(Campus),
    }),
  )
  .prefix("/campuses") {}
