# Folder

The Folder resource creates and manages directories in the filesystem with automatic parent directory creation and cleanup on deletion.

## Minimal Example

Create a directory using the ID as the path:

```ts


const dir = await Folder("uploads");
```

## Custom Path

Create a directory with an explicit path:

```ts


const logs = await Folder("logs", {
  path: "var/log/app",
});
```

## Recursive Creation

Create nested directories with recursive creation enabled (default):

```ts


const nested = await Folder("nested", {
  path: "path/to/nested/dir",
  recursive: true,
});
```

## Cleanup Options

Control folder deletion behavior:

```ts


const temp = await Folder("temp", {
  path: "temp",
  delete: true, // Delete on destroy (default)
  clean: true, // Remove contents on delete
});
```
