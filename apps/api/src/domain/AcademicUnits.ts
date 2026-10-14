import { Schema } from "effect";

export const AcademicUnit = Schema.Struct({
  id: Schema.Number,
  code: Schema.String,
  name: Schema.String,
  university_id: Schema.optional(Schema.Number),
});
export type AcademicUnit = typeof AcademicUnit.Type;

export class AcademicUnitsQuery extends Schema.Class<AcademicUnitsQuery>("AcademicUnitsQuery")({
  campusId: Schema.optional(Schema.NumberFromString),
  withProfessors: Schema.optional(Schema.Literals(["true", "false"])),
}) {}
