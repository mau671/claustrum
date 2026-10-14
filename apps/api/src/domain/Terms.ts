import { Schema } from "effect";

export const AcademicTerm = Schema.Struct({
  id: Schema.Number,
  academic_modality_id: Schema.Number,
  year: Schema.Number,
  period_number: Schema.Number,
  external_key: Schema.String,
  display_name: Schema.String,
  starts_on: Schema.NullOr(Schema.String),
  ends_on: Schema.NullOr(Schema.String),
});
export type AcademicTerm = typeof AcademicTerm.Type;

export class SuggestedTermQuery extends Schema.Class<SuggestedTermQuery>("SuggestedTermQuery")({
  studyPlanId: Schema.optional(Schema.NumberFromString),
}) {}

export class TermsQuery extends Schema.Class<TermsQuery>("TermsQuery")({
  campusId: Schema.optional(Schema.NumberFromString),
  studyPlanId: Schema.optional(Schema.NumberFromString),
}) {}
