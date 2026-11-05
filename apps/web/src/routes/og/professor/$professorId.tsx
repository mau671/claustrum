import { createFileRoute } from "@tanstack/react-router";
import { ImageResponse } from "takumi-js/response";

import {
  getProfessorById,
  getProfessorReviewSummary,
  getProfessorTeachingHistory,
} from "@/lib/professor-reviews/api";

function toTitleCase(text: string): string {
  return text.toLowerCase().replace(/(?:^|\s|-|\/)\S/g, (char) => char.toUpperCase());
}

function cleanMarkdownText(text: string): string {
  return text
    .replace(/\*\*(.*?)\*\*/g, "$1")
    .replace(/\*(.*?)\*/g, "$1")
    .replace(/<u>(.*?)<\/u>/g, "$1")
    .replace(/[~`_]/g, "")
    .trim();
}

function truncate(text: string, maxLen: number): string {
  if (text.length <= maxLen) return text;
  return text.slice(0, maxLen).trim() + "…";
}

export const Route = createFileRoute("/og/professor/$professorId")({
  server: {
    handlers: {
      GET: async ({ params: { professorId } }) => {
        if (!/^\d+$/.test(professorId)) {
          return new Response("Invalid professor ID", { status: 400 });
        }

        const [professor, summary, history] = await Promise.all([
          getProfessorById(professorId).catch(() => null),
          getProfessorReviewSummary(professorId).catch(() => null),
          getProfessorTeachingHistory(professorId).catch(() => null),
        ]);

        if (!professor) {
          return new Response("Professor not found", { status: 404 });
        }

        const professorName = toTitleCase(professor.full_name);
        const academicUnit = professor.academic_unit
          ? `${toTitleCase(professor.academic_unit)} • TEC`
          : "Tecnológico de Costa Rica (ITCR)";

        const hasReviews = (summary?.approved_review_count ?? 0) > 0;
        const overallScore = summary?.average_overall_score?.toFixed(1) ?? null;
        const easeScore = summary?.average_ease_score?.toFixed(1) ?? null;
        const qualityScore = summary?.average_quality_score?.toFixed(1) ?? null;
        const wouldTakeAgain =
          summary?.would_take_again_percentage !== null &&
          summary?.would_take_again_percentage !== undefined
            ? `${Math.round(summary.would_take_again_percentage)}%`
            : null;

        // Clean & truncate summary
        const rawSummary = summary?.community_summary?.summary;
        const summaryText = rawSummary ? truncate(cleanMarkdownText(rawSummary), 240) : null;

        // Tags logic: up to 3 badges in a single line, plus +N badge if there are more
        const allTags = summary?.tag_counts ?? [];
        const visibleTags = allTags.slice(0, 3);
        const remainingCount = allTags.length - visibleTags.length;

        // If no reviews, extract recent courses from history
        const recentCourses =
          !hasReviews && Array.isArray(history) && history.length > 0
            ? Array.from(
                new Set(
                  history
                    .flatMap((term) => term.courses)
                    .map((course) => `${course.code} - ${toTitleCase(course.name)}`),
                ),
              ).slice(0, 3)
            : [];

        const logoSvg = (
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="34" height="34">
            <path
              d="M 220.73 23.51 H 74.45 C 52.81 23.51 35.27 41.05 35.27 62.69 v 130.61 c 0 21.64 17.54 39.18 39.18 39.18 h 146.29"
              fill="none"
              stroke="#ea580c"
              strokeWidth="26"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
            <rect
              x="82.3"
              y="70.5"
              width="115"
              height="115"
              rx="23.5"
              fill="none"
              stroke="#ca8a04"
              strokeWidth="18"
            />
          </svg>
        );

        return new ImageResponse(
          <div tw="flex w-[1200px] h-[630px] flex-col justify-between bg-zinc-950 text-white p-14 font-sans">
            {/* Header / Brand */}
            <div tw="flex items-center justify-between w-full border-b border-zinc-800/80 pb-4">
              <div tw="flex items-center gap-3">
                {logoSvg}
                <span tw="text-2xl font-bold tracking-tight text-white">Claustrum</span>
              </div>
              <span tw="text-sm font-semibold tracking-wider text-zinc-500 uppercase">
                claustrum.maugp.com
              </span>
            </div>

            {/* Professor identity */}
            <div tw="flex flex-col mt-1">
              <h1 tw="text-5xl font-extrabold tracking-tight text-zinc-100">{professorName}</h1>
              <p tw="text-xl font-medium text-zinc-400 mt-2">{academicUnit}</p>
            </div>

            {/* Metrics row or courses fallback */}
            {hasReviews ? (
              <div tw="flex gap-4">
                <div tw="flex flex-col bg-zinc-900 border border-zinc-800 rounded-2xl p-4 w-52">
                  <span tw="text-xs uppercase font-bold text-zinc-400 tracking-wider">
                    Calidad General
                  </span>
                  <span tw="text-4xl font-black text-orange-500 mt-1">{overallScore ?? "-"}</span>
                </div>

                <div tw="flex flex-col bg-zinc-900 border border-zinc-800 rounded-2xl p-4 w-44">
                  <span tw="text-xs uppercase font-bold text-zinc-400 tracking-wider">
                    Facilidad
                  </span>
                  <span tw="text-3xl font-bold text-zinc-200 mt-1">{easeScore ?? "-"}</span>
                </div>

                <div tw="flex flex-col bg-zinc-900 border border-zinc-800 rounded-2xl p-4 w-44">
                  <span tw="text-xs uppercase font-bold text-zinc-400 tracking-wider">Calidad</span>
                  <span tw="text-3xl font-bold text-zinc-200 mt-1">{qualityScore ?? "-"}</span>
                </div>

                {wouldTakeAgain ? (
                  <div tw="flex flex-col bg-zinc-900 border border-zinc-800 rounded-2xl p-4 w-52">
                    <span tw="text-xs uppercase font-bold text-zinc-400 tracking-wider">
                      Lo llevarían otra vez
                    </span>
                    <span tw="text-3xl font-bold text-emerald-400 mt-1">{wouldTakeAgain}</span>
                  </div>
                ) : null}
              </div>
            ) : recentCourses.length > 0 ? (
              <div tw="flex flex-col bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5">
                <span tw="text-xs uppercase font-bold text-zinc-400 tracking-wider mb-2">
                  Cursos impartidos recientemente
                </span>
                <div tw="flex flex-wrap gap-2">
                  {recentCourses.map((c) => (
                    <span
                      key={c}
                      tw="bg-zinc-800 text-zinc-300 text-sm font-medium px-3 py-1 rounded-lg"
                    >
                      {c}
                    </span>
                  ))}
                </div>
              </div>
            ) : (
              <div tw="flex bg-zinc-900/40 border border-zinc-800/60 rounded-2xl p-5 text-zinc-400 text-base">
                Docente activo del Tecnológico de Costa Rica. Consulta materias, grupos y horarios
                en Claustrum.
              </div>
            )}

            {/* Community summary (without title) */}
            {summaryText ? (
              <div tw="flex bg-zinc-900/60 border border-zinc-800/80 rounded-2xl p-5 text-zinc-300 text-lg leading-relaxed">
                <p tw="m-0">{summaryText}</p>
              </div>
            ) : null}

            {/* Tags row in a single line with +N badge */}
            {visibleTags.length > 0 ? (
              <div tw="flex items-center gap-2">
                {visibleTags.map((t) => (
                  <span
                    key={t.tag}
                    tw="bg-zinc-800 text-zinc-200 text-sm font-medium px-3.5 py-1.5 rounded-lg"
                  >
                    {t.tag}
                  </span>
                ))}
                {remainingCount > 0 ? (
                  <span tw="bg-orange-950 text-orange-400 border border-orange-800/60 text-sm font-bold px-3 py-1.5 rounded-lg">
                    +{remainingCount}
                  </span>
                ) : null}
              </div>
            ) : (
              <div tw="flex" />
            )}
          </div>,
          {
            width: 1200,
            height: 630,
            headers: {
              "Content-Type": "image/png",
              "Cache-Control":
                "public, max-age=86400, s-maxage=604800, stale-while-revalidate=86400",
            },
          },
        );
      },
    },
  },
});
