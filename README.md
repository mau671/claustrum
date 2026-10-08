# Claustrum

Herramienta académica de código abierto para estudiantes del Instituto Tecnológico de Costa Rica (TEC), diseñada para facilitar la creación de horarios, el seguimiento de la malla curricular y la consulta de evaluaciones mediante una interfaz moderna y rápida.

El proyecto no está afiliado, respaldado ni representa oficialmente al Instituto Tecnológico de Costa Rica, siendo una iniciativa independiente distribuida bajo licencia MIT.

## Características principales

- Dashboard académico con resumen de progreso del estudiante
- Selección de universidad, campus, carrera y plan de estudios durante el onboarding
- Visualización de malla curricular con requisitos, correquisitos y equivalencias
- Exploración de horarios y grupos disponibles por periodo académico
- Búsqueda de profesores junto con reseñas moderadas y protección anti-spam
- Visualización y carga de evaluaciones en PDF mediante Cloudflare R2
- Autenticación completa con correo, magic link, recuperación de contraseña, Google OAuth y 2FA
- Temas claro, oscuro y sincronización con el sistema

## Stack técnico

El frontend está construido con React 19, TypeScript y Vite 8, utilizando Tailwind CSS v4 y shadcn/ui para el diseño visual, mientras que la obtención de datos y el enrutamiento se manejan con TanStack Query y TanStack Router. Para el backend y la infraestructura dependemos de Supabase PostgreSQL con RLS, integrando Cloudflare Workers para el manejo de archivos y despliegues estáticos mediante Cloudflare Pages.

## Desarrollo local

Para levantar el proyecto en tu máquina necesitas tener instalado pnpm, Docker (para la base de datos local) y contar con Python 3.14+ junto a `uv` únicamente si planeas trabajar con el pipeline de datos académicos.

1. Instala las dependencias del frontend:
   ```bash
   pnpm install
   ```
2. Configura las variables de entorno basándote en la plantilla:
   ```bash
   cp .env.example .env.local
   ```
3. Inicia los servicios de base de datos locales con Docker:
   ```bash
   pnpm run supabase:start
   pnpm run supabase:migrate
   ```
4. Levanta el servidor de desarrollo:
   ```bash
   pnpm run dev
   ```

La aplicación estará disponible en `http://localhost:3000`.

### Comandos frecuentes

| Comando                     | Descripción                                        |
| --------------------------- | -------------------------------------------------- |
| `pnpm install`              | Instala dependencias según `pnpm-lock.yaml`        |
| `pnpm run dev`              | Inicia el servidor de desarrollo Vite              |
| `pnpm run build`            | Ejecuta TypeScript y genera el build de producción |
| `pnpm run supabase:start`   | Levanta los contenedores de Supabase local         |
| `pnpm run supabase:stop`    | Detiene la instancia local de Supabase             |
| `pnpm run supabase:migrate` | Aplica las migraciones SQL pendientes              |

## Documentación

Los detalles técnicos profundos de la arquitectura y los servicios están documentados en la carpeta `/docs` del repositorio, donde podrás encontrar información sobre:

- Esquemas de base de datos, migraciones y políticas RLS
- Configuración del API Worker para manejo de archivos y moderación
- Flujos de autenticación con Better Auth
- Pipeline de descarga y procesamiento de datos del TEC
- Guías de despliegue en GitHub Actions y Cloudflare

## Cómo contribuir

Si deseas proponer mejoras o solucionar errores, por favor revisa nuestro archivo [CONTRIBUTING.md](CONTRIBUTING.md) para conocer las convenciones de código y el flujo esperado para los Pull Requests.

## Licencia

Este proyecto se distribuye bajo la licencia MIT, cuyos términos completos puedes consultar en el archivo `LICENSE`.
