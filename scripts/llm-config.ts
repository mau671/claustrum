export const DEFAULT_COURSE_MATCH_MODELS = [
  "nvidia/nemotron-3-ultra-550b-a55b:free",
  "baidu/ernie-5.5-flash-preview:free",
  "particle-ai/particle-1:free",
  "nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free",
].join(", ");

export const DEFAULT_SUMMARY_MODEL = "opencode/deepseek-v4.1-flash-free";
export const DEFAULT_SUMMARY_AGENT = "professor-reviews-summarizer";

export function courseMatchModels(): string[] {
  return (process.env.COURSE_MATCH_MODELS ?? DEFAULT_COURSE_MATCH_MODELS)
    .split(",")
    .map((model) => model.trim())
    .filter(Boolean);
}

export function summaryModel(): string {
  return process.env.REVIEW_SUMMARY_MODEL ?? DEFAULT_SUMMARY_MODEL;
}
