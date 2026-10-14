import { Schema } from "effect";
import { HttpApiEndpoint, HttpApiGroup } from "effect/http-api";

import { AcademicTerm, SuggestedTermQuery, TermsQuery } from "../domain/Terms";

export class TermsApiGroup extends HttpApiGroup.make("terms")
  .add(
    HttpApiEndpoint.get("active", "/active", {
      success: Schema.Array(AcademicTerm),
    }),
  )
  .add(
    HttpApiEndpoint.get("suggested", "/suggested", {
      query: SuggestedTermQuery,
      success: Schema.NullOr(Schema.Number),
    }),
  )
  .add(
    HttpApiEndpoint.get("list", "/", {
      query: TermsQuery,
      success: Schema.Array(AcademicTerm),
    }),
  )
  .prefix("/terms") {}
