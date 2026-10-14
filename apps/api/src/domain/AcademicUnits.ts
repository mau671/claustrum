import { Schema } from "effect";

export class AcademicUnit extends Schema.Class<AcademicUnit>("AcademicUnit")({
  id: Schema.Number,
  code: Schema.String,
  name: Schema.String,
  university_id: Schema.optional(Schema.Number),
}) {}

export class AcademicUnitsQuery extends Schema.Class<AcademicUnitsQuery>("AcademicUnitsQuery")({
  campusId: Schema.optional(Schema.NumberFromString),
  withProfessors: Schema.optional(Schema.Literals(["true", "false"])),
}) {}
