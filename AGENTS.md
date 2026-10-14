# AGENTS.md - Guidelines for AI Coding Agents

This document provides guidelines for AI agents operating in this repository.

## Commands

### Package Manager

- **Always use pnpm** for all package management operations
- Never use npm, npx, bun, or yarn
- Use `pnpm install` to install dependencies
- Use `pnpm add <package>` to add new dependencies
- Use `pnpm remove <package>` to remove dependencies

### Development

- **Do NOT start the dev server** unless explicitly requested by the user

### Building

- Build for production: `pnpm run build`
- Preview production build: `pnpm run preview`
- Deploy to Cloudflare: `pnpm run deploy`

### Testing

- **No tests exist in this project**
- Do NOT run `pnpm run test` or any test commands
- If asked to run tests, inform the user that this project has no tests configured

### Database Commands (`db:*`)

- Start local Postgres container: `pnpm run db:start`
- Stop Postgres container: `pnpm run db:stop`
- Run migrations locally: `pnpm run db:migrate`
- Run migrations in production: `pnpm run db:migrate -- --prod`
- Preview migrations (dry-run): `pnpm run db:migrate -- --dry-run`
- Seed database locally: `pnpm run db:seed`
- Seed database in production: `pnpm run db:seed -- --prod`
- Seed reviews: `pnpm run db:seed -- --reviews` (add `-- --prod` for production)
- Open Drizzle Studio: `pnpm run db:studio` (add `-- --prod` for production)
- Full local setup: `pnpm run db:setup`
- **NEVER run destructive database commands**. Do not drop databases or run manual DELETE/UPDATE queries without explicit confirmation.

### Effect and Alchemy Guidelines

This repository uses **Alchemy** for Infrastructure-as-Code and runtime orchestration on Cloudflare, and **Effect TS** for all backend services and APIs.

- Before writing Effect code, read the Effect documentation in `node_modules/effect/` and the skill references in `.agents/skills/effect-ts` and `.agents/skills/alchemy-run`.
- All code, types, and comments **must be in English**.
- Do not mix unhandled Promises or raw procedural `try/catch` inside Effect workflows; use `Effect.gen`, `Effect.tryPromise`, `Effect.acquireRelease`, and `Layer`.
- Model domain data and HTTP APIs using `effect/Schema` and `effect/unstable/httpapi/HttpApi`.
- Database interactions use `@effect/sql-pg` with scoped layers; do not manually instantiate connection pools or leak handles.
- No hardcoded secrets, database credentials, domains, or hostnames. All infrastructure configuration resides in `alchemy.run.ts` driven by environment variables, `Alchemy.Secret`, and deployment stages.

### Cloudflare CLI (`cf`)

- When interacting with Cloudflare, use the `cf` CLI.
- Inspect and audit live Cloudflare account resources using `cf` commands (e.g., `cf hyperdrive list`, `cf r2 buckets list`, `cf zones list`, `cf cli search`).
- For command discovery and schema inspection, use `cf cli search "<task>"` and `cf schema <command>`.

## Code Style Guidelines

### Imports

- **Always use the `@/` alias** for imports from `apps/web/src/`
  - Correct: `import { Button } from "@/components/ui/button"`
  - Incorrect: `import { Button } from "../../components/ui/button"`
- The `@/` alias is configured in `apps/web/tsconfig.json` and maps to `./src/*`
- Group imports: React/external imports first, then local imports

### TypeScript

- Strict mode is enabled in `tsconfig.json`
- No `any` types - use explicit types or `unknown` where appropriate
- Enable `noUncheckedSideEffectImports: true` in new code
- Use proper type inference, avoid redundant type annotations

### Naming Conventions

- **Components**: PascalCase (e.g., `LoginForm`, `AppSidebar`)
- **Files**: kebab-case for non-component files (e.g., `utils.ts`, `api.ts`)
- **Routes**: Use directory-based structure in `apps/web/src/routes/`
- **Variables/functions**: camelCase (e.g., `isLoading`, `handleSubmit`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `API_BASE_URL`)
- **Booleans**: Prefix with `is`, `has`, `can` (e.g., `isValid`, `hasAccess`)

### File Structure (TanStack Router)

Routes use **file-based routing** in `apps/web/src/routes/`:

```
src/routes/
├── __root.tsx           # Root layout
├── _index.tsx           # Landing page (/)
├── login/
│   └── index.tsx        # /login route
├── signup/
│   └── index.tsx        # /signup route
└── app/
    ├── _layout.tsx      # App layout (Header + Sidebar)
    └── _index.tsx       # Dashboard (/app)
```

- `_layout.tsx` = Pathless layout wrapper (uses Outlet, doesn't add to URL)
- `index.tsx` = Route at that directory's path
- `_index.tsx` = Index route for parent directory
- Routes are automatically generated from file structure

### Error Handling

- Use try/catch with async/await for API calls
- Provide user-friendly error messages
- Log errors appropriately for debugging
- Handle edge cases explicitly (no silent failures)

### React Components

- Use functional components with hooks
- Use TypeScript interfaces for props
- Keep components small and focused
- Extract reusable logic to custom hooks
- Use proper React.FC typing or explicit prop types

### CSS/Tailwind

- Tailwind CSS v4 is configured
- Use utility classes for styling
- Follow existing design patterns from shadcn/ui components
- Use `cn()` from `@/lib/utils` for conditional classes

### shadcn/ui Components

- Components are in `@/components/ui/`
- Use existing components before creating new ones
- Follow shadcn conventions for component structure

## General Guidelines

- Keep responses concise and focused on the task
- Before modifying files, read them to understand the context
- Follow existing code patterns and conventions
- Do not add comments unless explicitly requested
- Ask for clarification when requirements are unclear
- Report errors clearly with relevant context

## Agent Editing Workflow

- **Do not use shell commands to edit files** (e.g., heredoc writes, `sed -i`, `perl -pi`, `cat > file`).
- Always use the agent's file editing tools for code/document changes.
- Use shell commands only for execution tasks (builds, git, migrations, checks), not for file content editing.

<!-- BEGIN:turborepo-agent-rules -->

# This is NOT the Turborepo you know

Turborepo configuration, task behavior, and CLI commands can vary between installed versions and may differ from your training data. Resolve the `turbo` package from this file's directory or relevant workspace; in monorepos, it may not be visible from the repository root. For example, run `node -p "require.resolve('turbo/package.json')"` from a workspace that depends on `turbo`.

Read `docs/README.md` inside that installed package first, then read the relevant pages from its `docs/` directory before changing Turborepo configuration or commands. Heed deprecation notices. These bundled docs match the installed package version and are available without network access.

This block is written and re-added by `turbo` before repository-scoped commands when an AI agent is detected. In the Turborepo source repository, its template is defined in `crates/turborepo-cli/src/cli/agent_guidance.rs`. Removing the managed block while updates are enabled means a later qualifying invocation will add it again. Set `"agentGuidance": false` in the root `turbo.json` or `turbo.jsonc` to opt out; this does not remove an existing block. Keep the block committed with your work to avoid an uncommitted change on the next agent invocation.
<!-- END:turborepo-agent-rules -->
