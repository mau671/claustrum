import { createFileRoute } from "@tanstack/react-router";

import { getGeistSemiBoldFont } from "@/lib/fonts/geist-sans-600";
import {
  getProfessorById,
  getProfessorReviewSummary,
  getProfessorTeachingHistory,
} from "@/lib/professor-reviews/api";

// @ts-ignore
import wasmModule from "./takumi_wasm_bg.wasm";

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

        try {
          const [professor, summary, history] = await Promise.all([
            getProfessorById(professorId).catch(() => null),
            getProfessorReviewSummary(professorId).catch(() => null),
            getProfessorTeachingHistory(professorId).catch(() => null),
          ]);

          if (!professor) {
            return Response.redirect("https://claustrum.maugp.com/og/og-professors.png", 302);
          }

          const professorName = professor.full_name.trim().toUpperCase();

          const hasReviews = (summary?.approved_review_count ?? 0) > 0;

          // Clean & truncate summary
          const rawSummary = summary?.community_summary?.summary;
          const summaryText = rawSummary ? truncate(cleanMarkdownText(rawSummary), 320) : null;

          // Tags logic: up to 4 badges in a single line, plus +N badge if there are more
          const allTags = summary?.tag_counts ?? [];
          const visibleTags = allTags.slice(0, 4);
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
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="36" height="36">
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

          const card = (
            <div tw="flex w-[1200px] h-[630px] flex-col justify-between bg-zinc-950 text-white p-16 font-sans">
              {/* Header / Brand */}
              <div tw="flex items-center gap-3">
                {logoSvg}
                <span tw="text-2xl font-bold tracking-tight text-white">Claustrum</span>
              </div>

              {/* Middle: Professor Name & Hero Community Summary / Courses Fallback */}
              <div tw="flex flex-col gap-6 my-auto">
                <h1 tw="text-6xl font-extrabold tracking-tight text-white leading-tight m-0">
                  {professorName}
                </h1>
                {summaryText ? (
                  <p tw="text-3xl text-zinc-300 font-normal leading-relaxed m-0 text-pretty">
                    {summaryText}
                  </p>
                ) : recentCourses.length > 0 ? (
                  <div tw="flex flex-col gap-3">
                    <span tw="text-sm uppercase font-bold text-zinc-400 tracking-wider">
                      Cursos impartidos recientemente
                    </span>
                    <div tw="flex flex-wrap gap-2.5">
                      {recentCourses.map((c) => (
                        <span
                          key={c}
                          tw="bg-zinc-900 border border-zinc-800 text-zinc-300 text-lg font-medium px-4 py-2 rounded-xl"
                        >
                          {c}
                        </span>
                      ))}
                    </div>
                  </div>
                ) : (
                  <p tw="text-2xl text-zinc-400 font-normal leading-relaxed m-0">
                    Docente activo del Tecnológico de Costa Rica. Consulta materias, grupos y
                    horarios en Claustrum.
                  </p>
                )}
              </div>

              {/* Tags row in a single line with +N badge */}
              {visibleTags.length > 0 ? (
                <div tw="flex items-center gap-2.5">
                  {visibleTags.map((t) => (
                    <span
                      key={t.tag}
                      tw="bg-zinc-900 border border-zinc-800 text-zinc-300 text-base font-medium px-4 py-2 rounded-xl"
                    >
                      {t.tag}
                    </span>
                  ))}
                  {remainingCount > 0 ? (
                    <span tw="bg-zinc-900 border border-zinc-800 text-zinc-300 text-base font-medium px-4 py-2 rounded-xl">
                      +{remainingCount}
                    </span>
                  ) : null}
                </div>
              ) : (
                <div tw="flex" />
              )}
            </div>
          );

          const { render } = await import("takumi-js");
          const resolvedWasm =
            wasmModule && typeof wasmModule === "object" && "default" in wasmModule
              ? (wasmModule as { default: WebAssembly.Module }).default
              : (wasmModule as WebAssembly.Module);

          const imageBuffer = await render(card, {
            width: 1200,
            height: 630,
            format: "png",
            module: resolvedWasm,
            fonts: [
              {
                name: "Geist",
                data: getGeistSemiBoldFont(),
                weight: 600,
              },
            ],
          });

          return new Response(imageBuffer, {
            headers: {
              "Content-Type": "image/png",
              "Cache-Control":
                "public, max-age=86400, s-maxage=604800, stale-while-revalidate=86400",
            },
          });
        } catch {
          return Response.redirect("https://claustrum.maugp.com/og/og-professors.png", 302);
        }
      },
    },
  },
});
