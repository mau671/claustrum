import { Schema } from "effect";

export const Campus = Schema.Struct({
  id: Schema.Number,
  university_id: Schema.Number,
  code: Schema.String,
  name: Schema.String,
});
export type Campus = typeof Campus.Type;

export class CampusesQuery extends Schema.Class<CampusesQuery>("CampusesQuery")({
  universityId: Schema.optional(Schema.NumberFromString),
  all: Schema.optional(Schema.Literals(["true", "false"])),
}) {}
