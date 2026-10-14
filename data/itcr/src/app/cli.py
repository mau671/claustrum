"""Main CLI entry point."""

from pathlib import Path

import typer

from src.domains.sync.sql_seed import run_sql
from src.workflows.download_workflow import download
from src.workflows.process_workflow import run_process
from src.workflows.sync_pipeline import run_sync_pipeline
from src.workflows.sync_workflow import SEED_HISTORY_SERVICE_DB_URL
from src.workflows.sync_workflow import sync_cmd

app = typer.Typer(pretty_exceptions_show_locals=False)


@app.command("download")
def download_cmd(
    data_dir: Path = typer.Option(
        Path("data/raw"), "--data-dir", "-d", help="Data directory for raw files"
    ),
    scope: str = typer.Option(
        "all", "--scope", "-s", help="Scope to download: catalog, offering, all"
    ),
    concurrency: int = typer.Option(
        3,
        "--concurrency",
        "-c",
        min=1,
        max=10,
        help="Max concurrent plan detail downloads",
    ),
    years: str | None = typer.Option(
        None,
        "--years",
        help="Comma-separated years for offering downloads (e.g., 2024,2025)",
    ),
) -> None:
    """Download raw data from TEC APIs."""
    years_list: list[str] | None = None
    if years:
        years_list = [item.strip() for item in years.split(",") if item.strip()]

    success = download(
        output_dir=data_dir,
        scope=scope,
        concurrency=concurrency,
        years=years_list,
    )
    if success:
        typer.echo(f"Downloaded raw data to {data_dir}")


@app.command("process")
def process_cmd_cli(
    data_dir: Path = typer.Option(
        Path("data/raw"), "--data-dir", "-d", help="Data directory with raw files"
    ),
    scope: str = typer.Option(
        "all", "--scope", "-s", help="Scope to process: catalog, offering, all"
    ),
    university_id: int | None = typer.Option(
        None, "--university-id", "-u", help="University ID for entities"
    ),
    years: str | None = typer.Option(
        None,
        "--years",
        "-y",
        help="Comma-separated years for academic_term (e.g., 2024,2025,2026)",
    ),
) -> None:
    """Process raw data files into normalized data.json format."""
    years_list: list[int] | None = None
    if years:
        years_list = [int(y.strip()) for y in years.split(",")]
    run_process(
        data_dir=data_dir, scope=scope, university_id=university_id, years=years_list
    )


@app.command("pipeline")
def pipeline_cmd(
    data_dir: Path = typer.Option(
        Path("data/raw"), "--data-dir", "-d", help="Data directory for raw files"
    ),
    scope: str = typer.Option(
        "all", "--scope", "-s", help="Scope to run: catalog, offering, all"
    ),
    years: str = typer.Option(
        "2026", "--years", "-y", help="Comma-separated years (e.g., 2025,2026)"
    ),
    skip_download: bool = typer.Option(
        False,
        "--skip-download",
        help="Run process steps only, reusing previously downloaded raw files",
    ),
) -> None:
    """Run download/process pipeline with dependency-aware orchestration."""
    years_list = [int(y.strip()) for y in years.split(",") if y.strip()]
    if not years_list:
        raise typer.BadParameter("--years must include at least one year")

    run_sync_pipeline(
        data_dir=data_dir,
        years=years_list,
        scope=scope,
        skip_download=skip_download,
    )


@app.command("sql")
def sql_cmd(
    data_dir: Path = typer.Option(
        Path("data/raw"), "--data-dir", "-d", help="Data directory for processed files"
    ),
    output: Path | None = typer.Option(
        None,
        "--output",
        "-o",
        help="Output SQL file path (defaults to timestamped path when mode=delta)",
    ),
    tables: str | None = typer.Option(
        None, "--tables", "-t", help="Comma-separated list of tables to include"
    ),
    mode: str = typer.Option(
        "delta", "--mode", help="Generation mode: delta (versioned) or full"
    ),
    scope: str = typer.Option(
        "all", "--scope", help="Data scope: catalog, offering, all"
    ),
    years: str | None = typer.Option(
        None, "--years", "-y", help="Comma-separated years metadata for the run"
    ),
    terms: str | None = typer.Option(
        None, "--terms", help="Comma-separated academic_term external keys metadata"
    ),
    history_dir: Path = typer.Option(
        Path("../seeds/itcr"),
        "--history-dir",
        help="Directory for timestamped seed files when mode=delta",
    ),
    manifest: bool = typer.Option(
        False,
        "--manifest/--no-manifest",
        help="Generate a JSON manifest next to the SQL file",
    ),
) -> None:
    """Generate SQL inserts from processed data."""
    run_sql(
        data_dir=data_dir,
        output=output,
        tables=tables,
        mode=mode,
        scope=scope,
        years=years,
        term_external_keys=terms,
        history_dir=history_dir,
        manifest=manifest,
    )


@app.command("sync")
def sync_cli(
    data_dir: Path = typer.Option(
        Path("data/raw"), "--data-dir", "-d", help="Data directory for processed files"
    ),
    target: str = typer.Option(
        "local",
        "--target",
        help="Destination target: local, remote, db-url, seed-history",
    ),
    db_url: str | None = typer.Option(
        None, "--db-url", help="Destination Postgres URL (required for target=db-url)"
    ),
    env_file: Path = typer.Option(
        Path("../../.env.prod") if Path("../../.env.prod").exists() else Path("../../.env.production.local"),
        "--env-file",
        help="Env file used when target=remote (default: ../../.env.prod)",
    ),
    years: str = typer.Option(
        "2026", "--years", "-y", help="Comma-separated years for offering sync"
    ),
    skip_pipeline: bool = typer.Option(
        False,
        "--skip-pipeline",
        help="Skip download/process pipeline and reuse current data/raw",
    ),
    skip_download: bool = typer.Option(
        False,
        "--skip-download",
        help="Run process steps only, reusing previously downloaded raw files",
    ),
    apply_seed: bool = typer.Option(
        True,
        "--apply/--no-apply",
        help="Apply generated SQL seed",
    ),
    verify: bool = typer.Option(
        True,
        "--verify/--no-verify",
        help="Run verification queries after apply",
    ),
    output: Path | None = typer.Option(
        None,
        "--output",
        "-o",
        help="Output SQL path (defaults to timestamped seed in ../seeds/itcr)",
    ),
    keep_sql: bool = typer.Option(
        True,
        "--keep-sql",
        help="Keep generated SQL file after command finishes",
    ),
    scope: str = typer.Option(
        "all",
        "--scope",
        help="Data scope: catalog, offering, all",
    ),
    seed_dir: Path = typer.Option(
        Path("../seeds/itcr"),
        "--seed-dir",
        help="Directory with seed_*.sql history for target=seed-history",
    ),
    baseline_seed: str | None = typer.Option(
        None,
        "--baseline-seed",
        help="Baseline seed filename in --seed-dir to start replay from",
    ),
    seed_history_db_url: str = typer.Option(
        SEED_HISTORY_SERVICE_DB_URL,
        "--seed-history-db-url",
        help="Postgres URL used by target=seed-history (typically a GitHub service container)",
    ),
    skip_migrations: bool = typer.Option(
        False,
        "--skip-migrations",
        help="Skip applying migrations and bootstrap SQL to the seed history database",
    ),
) -> None:
    """Run a full idempotent synchronization against local or remote DB."""
    sync_cmd(
        data_dir=data_dir,
        target=target,
        db_url=db_url,
        env_file=env_file,
        years=years,
        skip_pipeline=skip_pipeline,
        skip_download=skip_download,
        apply_seed=apply_seed,
        verify=verify,
        output=output,
        keep_sql=keep_sql,
        scope=scope,
        seed_dir=seed_dir,
        baseline_seed=baseline_seed,
        seed_history_db_url=seed_history_db_url,
        skip_migrations=skip_migrations,
    )


if __name__ == "__main__":
    app()
