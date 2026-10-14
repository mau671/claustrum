"""Shared scope definitions for tec-data commands."""

import typer


VALID_SCOPES = {"catalog", "offering", "all"}


def normalize_scope(scope: str) -> str:
    normalized = scope.strip().lower()
    if normalized not in VALID_SCOPES:
        raise typer.BadParameter(
            f"Invalid scope: {scope!r}. Expected one of: {', '.join(sorted(VALID_SCOPES))}"
        )
    return normalized
