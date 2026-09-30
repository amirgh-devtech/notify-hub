# notify-hub — task runner
# Usage: `just` or `just --list`

set shell := ["bash", "-uc"]
set dotenv-load := true
set dotenv-filename := ".env"

# ─────────────────────────────────────────────
# Default
# ─────────────────────────────────────────────
default:
    @just --list

# ─────────────────────────────────────────────
# Setup / Sync
# ─────────────────────────────────────────────

# Install/sync all dependencies (incl. dev)
sync:
    uv sync --all-groups

# Reinstall the local package (editable)
reinstall:
    uv sync --reinstall-package notify-hub

# Full reset: nuke lock + venv, then reinstall
reset:
    rm -rf .venv uv.lock
    uv lock
    uv sync --all-groups

# ─────────────────────────────────────────────
# Lint / Format / Typecheck
# ─────────────────────────────────────────────

# Run all linters (ruff check + ruff format check + mypy)
lint:
    uv run ruff check src tests scripts
    uv run ruff format --check src tests scripts
    uv run mypy src

# Auto-fix lint issues + format
fmt:
    uv run ruff check --fix src tests scripts
    uv run ruff format src tests scripts

# Only ruff
ruff:
    uv run ruff check src tests scripts

# Only mypy
typecheck:
    uv run mypy src

# ─────────────────────────────────────────────
# Tests
# ─────────────────────────────────────────────

# Run unit tests (fast)
test:
    uv run pytest tests/unit -v

# Run all tests
test-all:
    uv run pytest -v

# Run with coverage report (HTML)
cov:
    uv run pytest --cov=notify_hub --cov-report=term-missing --cov-report=html
    @echo "→ open htmlcov/index.html"

# Run integration tests (needs infra up)
test-int:
    uv run pytest tests/integration -v -m integration

# ─────────────────────────────────────────────
# Infra (Postgres, Redis, etc.)
# ─────────────────────────────────────────────

# Start only infra services (Postgres, Redis)
up-infra:
    docker compose up -d postgres redis

# Stop infra
down-infra:
    docker compose down

# Tail infra logs
logs-infra:
    docker compose logs -f postgres redis

# Nuke infra volumes (⚠️ destroys data)
nuke-infra:
    docker compose down -v

# ─────────────────────────────────────────────
# App (dev)
# ─────────────────────────────────────────────

# Run API with hot reload
api:
    uv run uvicorn notify_hub.api.app:create_app --factory --reload --host 0.0.0.0 --port 8000

# Run Celery worker
worker:
    uv run celery -A notify_hub.workers.celery_app worker --loglevel=INFO --pool=solo

# Run Celery beat (scheduler)
beat:
    uv run celery -A notify_hub.workers.celery_app beat --loglevel=INFO

# Run API + worker + beat in parallel (needs `just` + `&` support)
dev:
    @echo "Starting API + worker + beat..."
    @just api & \
    just worker & \
    just beat & \
    wait

# ─────────────────────────────────────────────
# Migrations (Alembic)
# ─────────────────────────────────────────────

# Create a new migration (usage: just makemigration "add events table")
makemigration name:
    uv run alembic revision --autogenerate -m "{{name}}"

# Apply all migrations
migrate:
    uv run alembic upgrade head

# Downgrade one migration
downgrade:
    uv run alembic downgrade -1

# Show current migration
current:
    uv run alembic current

# Show history
history:
    uv run alembic history --verbose

# ─────────────────────────────────────────────
# Clean
# ─────────────────────────────────────────────

# Clean caches and build artifacts
clean:
    rm -rf .pytest_cache .mypy_cache .ruff_cache htmlcov .coverage coverage.xml
    rm -rf dist build *.egg-info
    find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true

# ─────────────────────────────────────────────
# Shortcuts
# ─────────────────────────────────────────────

# Alias
ci: lint test-all
