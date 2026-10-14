import * as Schema from "effect/Schema";

export const FeedbackType = Schema.Literals(["bug", "feature", "other"]);
export type FeedbackType = typeof FeedbackType.Type;

export const FeedbackItem = Schema.Struct({
  id: Schema.Number,
  type: FeedbackType,
  content: Schema.String,
  is_reviewed: Schema.Boolean,
  created_at: Schema.Unknown,
  user_id: Schema.NullOr(Schema.String),
  admin_notes: Schema.NullOr(Schema.String),
});
export type FeedbackItem = typeof FeedbackItem.Type;

export const ListFeedbackQuery = Schema.Struct({
  limit: Schema.optional(Schema.NumberFromString),
  offset: Schema.optional(Schema.NumberFromString),
});
export type ListFeedbackQuery = typeof ListFeedbackQuery.Type;

export const CreateFeedbackPayload = Schema.Struct({
  type: FeedbackType,
  content: Schema.String.check(Schema.isMinLength(5), Schema.isMaxLength(2000)),
  turnstileToken: Schema.String.check(Schema.isNonEmpty()),
  isAnonymous: Schema.optional(Schema.Boolean),
});
export type CreateFeedbackPayload = typeof CreateFeedbackPayload.Type;

export const CreateFeedbackResponse = Schema.Struct({
  success: Schema.Boolean,
  feedback: Schema.Struct({
    id: Schema.Number,
    type: FeedbackType,
    content: Schema.String,
    created_at: Schema.Unknown,
  }),
});
export type CreateFeedbackResponse = typeof CreateFeedbackResponse.Type;

export const UpdateFeedbackPayload = Schema.Struct({
  isReviewed: Schema.optional(Schema.Boolean),
  adminNotes: Schema.optional(Schema.NullOr(Schema.String)),
});
export type UpdateFeedbackPayload = typeof UpdateFeedbackPayload.Type;

export const UpdateFeedbackResponse = Schema.Struct({
  success: Schema.Boolean,
  feedback: Schema.Unknown,
});
export type UpdateFeedbackResponse = typeof UpdateFeedbackResponse.Type;

export const ReplyFeedbackPayload = Schema.Struct({
  message: Schema.String.check(Schema.isNonEmpty()),
  notes: Schema.optional(Schema.String),
});
export type ReplyFeedbackPayload = typeof ReplyFeedbackPayload.Type;
