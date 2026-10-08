import type { Root } from "fumadocs-core/page-tree";

export const docsTree: Root = {
  type: "root",
  name: "Documentación",
  children: [
    { type: "page", name: "Inicio", url: "/docs" },
    {
      type: "folder",
      name: "Datos académicos",
      defaultOpen: true,
      children: [
        { type: "page", name: "Extracción de datos", url: "/docs/tec-data/pipeline" },
        {
          type: "page",
          name: "Entidades y dependencias",
          url: "/docs/tec-data/entity-dependencies",
        },
      ],
    },
    {
      type: "folder",
      name: "Base de datos",
      defaultOpen: true,
      children: [
        { type: "page", name: "Esquema general", url: "/docs/database/schema-overview" },
        { type: "page", name: "Migraciones y RLS", url: "/docs/database/migrations-rls" },
      ],
    },
    { type: "page", name: "Frontend y rutas", url: "/docs/frontend-routes" },
    { type: "page", name: "Despliegue y entorno", url: "/docs/deployment-env" },
  ],
};
