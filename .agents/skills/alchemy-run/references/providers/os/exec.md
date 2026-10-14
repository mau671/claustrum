# Exec

The Exec resource allows you to execute shell commands as part of your Alchemy infrastructure. It provides a way to run system commands with full control over the execution environment and output handling.

## Minimal Example

Execute a simple shell command:

```ts


const result = await Exec("list-files", {
  command: "ls -la",
});

console.log(result.stdout);
```

## Working Directory and Environment

Run a command in a specific directory with custom environment variables:

```ts


const build = await Exec("build-project", {
  command: "npm run build",
  cwd: "./my-project",
  env: {
    NODE_ENV: "production",
  },
});
```

## Command Memoization

### Basic Memoization

Cache command output and only re-run when the command changes:

```ts


const status = await Exec("git-status", {
  command: "git status",
  memoize: true,
});
```

### File-Based Memoization

Memoize commands based on file contents. The command will be re-executed if either:

1. The command string changes, or
2. The contents of any files matching the glob patterns change

```ts


// Memoize database migrations based on schema files
const migrate = await Exec("db-migrate", {
  command: "drizzle-kit push:pg",
  memoize: {
    patterns: ["./src/db/schema/**"],
  },
});
```

### Build Commands with Memoization

When using memoization with build commands, be aware that build outputs won't be produced if the command is memoized. For build commands, consider disabling memoization in CI environments:

```ts


const build = await Exec("build", {
  command: "vite build",
  memoize: process.env.CI
    ? false
    : {
        patterns: ["./src/**"],
      },
});
```

## Custom Buffer Size

Handle large command output by increasing the buffer size:

```ts


const logs = await Exec("get-logs", {
  command: "cat large-log-file.log",
  maxBuffer: 10 * 1024 * 1024, // 10MB
});
```
