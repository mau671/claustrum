import { createClient } from "@supabase/supabase-js";
import { createFileRoute } from "@tanstack/react-router";

import { getSupabasePublicEnv } from "@/lib/env/public";

export const Route = createFileRoute("/sitemap.xml")({
  server: {
    handlers: {
      GET: async () => {
        const { supabaseUrl, supabasePublishableKey } = getSupabasePublicEnv();
        const supabase = createClient(supabaseUrl, supabasePublishableKey, {
          auth: {
            persistSession: false,
          },
        });

        let allProfessors: { id: string | number }[] = [];
        let page = 0;
        const pageSize = 1000;

        while (true) {
          const { data, error } = await supabase
            .from("professor")
            .select("id")
            .range(page * pageSize, (page + 1) * pageSize - 1);

          if (error || !data || data.length === 0) {
            break;
          }

          allProfessors = allProfessors.concat(data);

          if (data.length < pageSize) {
            break;
          }

          page++;
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
            "Cache-Control": "public, max-age=3600",
          },
        });
      },
    },
  },
});
