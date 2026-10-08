import { createLazyFileRoute } from "@tanstack/react-router";

export const Route = createLazyFileRoute("/settings/")({
  component: SettingsIndex,
});

function SettingsIndex() {
  return null;
}
