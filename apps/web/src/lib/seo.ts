export const DEFAULT_TITLE = "Claustrum | Generador de horarios y avance académico";
export const DEFAULT_DESCRIPTION =
  "Organiza tu horario semestral, evalúa cursos y gestiona tu progreso académico de forma sencilla.";
export const INDEXABLE_ROBOTS = "index, follow, max-snippet:150, max-image-preview:large";
export const NOINDEX_ROBOTS = "noindex, follow";

export const BASE_URL = "https://claustrum.maugp.com";
export const DEFAULT_IMAGE = "/logo512.png";

export type SeoConfig = {
  title?: string;
  description?: string;
  robots?: string;
  ogType?: string;
  breadcrumbName?: string;
  urlPath?: string;
  image?: string;
  jsonLd?: Record<string, unknown>[];
};

export function buildSeoMeta(config: SeoConfig = {}) {
  const title = config.title ?? DEFAULT_TITLE;
  const description = config.description ?? DEFAULT_DESCRIPTION;
  const robots = config.robots ?? INDEXABLE_ROBOTS;
  const ogType = config.ogType ?? "website";
  const canonicalUrl = config.urlPath ? `${BASE_URL}${config.urlPath}` : BASE_URL;
  const imageUrl = new URL(config.image ?? DEFAULT_IMAGE, BASE_URL).toString();

  const meta = [
    { title },
    { name: "description", content: description },
    { name: "robots", content: robots },
    { property: "og:type", content: ogType },
    { property: "og:site_name", content: "Claustrum" },
    { property: "og:locale", content: "es_CR" },
    { property: "og:title", content: title },
    { property: "og:description", content: description },
    { property: "og:url", content: canonicalUrl },
    { property: "og:image", content: imageUrl },
    { property: "og:image:type", content: "image/png" },
    { property: "og:image:width", content: "1200" },
    { property: "og:image:height", content: "630" },
    { property: "og:image:alt", content: "Logo de Claustrum" },
    { name: "twitter:card", content: "summary_large_image" },
    { name: "twitter:title", content: title },
    { name: "twitter:description", content: description },
    { name: "twitter:image", content: imageUrl },
    { name: "twitter:image:alt", content: "Logo de Claustrum" },
  ];

  const links = [{ rel: "canonical", href: canonicalUrl }];

  const scripts = [];

  // Default WebPage JSON-LD
  const webPageJsonLd = {
    "@context": "https://schema.org",
    "@type": "WebPage",
    name: title,
    description: description,
    url: canonicalUrl,
    inLanguage: "es-CR",
    isPartOf: {
      "@type": "WebSite",
      name: "Claustrum",
      url: BASE_URL,
    },
  };

  scripts.push({
    type: "application/ld+json",
    children: JSON.stringify(webPageJsonLd),
  });

  if (config.breadcrumbName && robots === INDEXABLE_ROBOTS) {
    scripts.push({
      type: "application/ld+json",
      children: JSON.stringify({
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        itemListElement: [
          {
            "@type": "ListItem",
            position: 1,
            name: "Claustrum",
            item: BASE_URL,
          },
          {
            "@type": "ListItem",
            position: 2,
            name: config.breadcrumbName,
            item: canonicalUrl,
          },
        ],
      }),
    });
  }

  if (config.jsonLd && config.jsonLd.length > 0) {
    for (const ld of config.jsonLd) {
      scripts.push({
        type: "application/ld+json",
        children: JSON.stringify(ld),
      });
    }
  }

  return { meta, links, scripts };
}
