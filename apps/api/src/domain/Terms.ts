import { Schema } from "effect";

export class AcademicTerm extends Schema.Class<AcademicTerm>("AcademicTerm")({
  id: Schema.Number,
  academic_modality_id: Schema.Number,
  year: Schema.Number,
  period_number: Schema.Number,
  external_key: Schema.String,
  display_name: Schema.String,
  starts_on: Schema.String,
  ends_on: Schema.String,
}) {}

export class SuggestedTermQuery extends Schema.Class<SuggestedTermQuery>("SuggestedTermQuery")({
  studyPlanId: Schema.optional(Schema.NumberFromString),
}) {}

export class TermsQuery extends Schema.Class<TermsQuery>("TermsQuery")({
  campusId: Schema.optional(Schema.NumberFromString),
  studyPlanId: Schema.optional(Schema.NumberFromString),
}) {}
