import { Schema } from "effect";

export class University extends Schema.Class<University>("University")({
  id: Schema.Number,
  name: Schema.String,
  short_name: Schema.String,
}) {}
