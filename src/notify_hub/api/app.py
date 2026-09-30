"""FastAPI application factory."""

from __future__ import annotations

from fastapi import FastAPI

from notify_hub import __version__


def create_app() -> FastAPI:
    """Create and configure the FastAPI application.

    Returns:
        Configured FastAPI instance.
    """
    return FastAPI(
        title="notify-hub",
        version=__version__,
        description="Multi-channel notification hub.",
        docs_url="/docs",
        redoc_url="/redoc",
        openapi_url="/openapi.json",
    )
