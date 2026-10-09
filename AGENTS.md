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

### Supabase (when needed)

- Start local Supabase: `pnpm run supabase:start`
- Stop Supabase: `pnpm run supabase:stop`
- Run migrations: `pnpm run supabase:migrate`
- Seed database: `pnpm run supabase:seed`
- Full setup: `pnpm run supabase:setup`
- **NEVER run destructive database commands**. This includes:
  - Any form of database reset (`supabase:reset`, `supabase db reset`, or equivalent).
  - Any commands that roll back migrations (e.g., `supabase migration down`, `supabase db down`).
  - Any raw Supabase CLI commands like `supabase migration up`, `supabase db push`.
  - Scripts like `pnpm run supabase:migrate-dev` or `pnpm run supabase:migrate-prod`.
  - Any manual `DELETE` or `UPDATE` queries on tables without explicit and repeated user confirmation.
    These commands irreversibly wipe all local data because Supabase locally resets the database when rolling back or modifying states manually. If a migration needs to be applied, use exactly `pnpm run supabase:migrate` which only runs pending migrations without deleting data.
- Do NOT use `pnpm run supabase:stop` or any destructive operation on production databases

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
