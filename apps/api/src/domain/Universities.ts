import { Schema } from "effect";

export const University = Schema.Struct({
  id: Schema.Number,
  name: Schema.String,
  short_name: Schema.String,
});
export type University = typeof University.Type;
