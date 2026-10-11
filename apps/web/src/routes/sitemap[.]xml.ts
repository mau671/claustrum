import { createFileRoute } from "@tanstack/react-router";

import { apiClient } from "@/lib/api/client";

export const Route = createFileRoute("/sitemap.xml")({
  server: {
    handlers: {
      GET: async () => {
        let allProfessors: { id: string | number }[] = [];
        let offset = 0;
        const limit = 1000;

        while (true) {
          try {
            const data = await apiClient<Array<{ id: number }>>(
              `/professors?limit=${limit}&offset=${offset}`,
            );

            if (!data || data.length === 0) {
              break;
            }

            allProfessors = allProfessors.concat(data);

            if (data.length < limit) {
              break;
            }

            offset += limit;
          } catch {
            break;
          }
        }

        const baseUrl = "https://claustrum.maugp.com";

        // Static routes
        const urls = [
          { loc: `${baseUrl}/`, priority: 1.0, changefreq: "weekly" },
          { loc: `${baseUrl}/schedule`, priority: 0.9, changefreq: "weekly" },
          { loc: `${baseUrl}/curriculum`, priority: 0.9, changefreq: "weekly" },
          { loc: `${baseUrl}/professors`, priority: 0.9, changefreq: "weekly" },
          { loc: `${baseUrl}/policies`, priority: 0.6, changefreq: "monthly" },
        ];

        if (allProfessors.length > 0) {
          for (const professor of allProfessors) {
            urls.push({
              loc: `${baseUrl}/professors/${professor.id}`,
              priority: 0.8,
              changefreq: "weekly",
            });
          }
        }

        const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls
  .map(
    (url) => `  <url>
    <loc>${url.loc}</loc>
    <changefreq>${url.changefreq}</changefreq>
    <priority>${url.priority}</priority>
  </url>`,
  )
  .join("\n")}
</urlset>`;

        return new Response(xml, {
          headers: {
            "Content-Type": "application/xml",
            "Cache-Control": "public, max-age=86400, s-maxage=86400",
          },
        });
      },
    },
  },
});
