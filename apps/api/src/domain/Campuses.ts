import { Schema } from "effect";

export class Campus extends Schema.Class<Campus>("Campus")({
  id: Schema.Number,
  university_id: Schema.Number,
  code: Schema.String,
  name: Schema.String,
}) {}

export class CampusesQuery extends Schema.Class<CampusesQuery>("CampusesQuery")({
  universityId: Schema.optional(Schema.NumberFromString),
  all: Schema.optional(Schema.Literals(["true", "false"])),
}) {}
