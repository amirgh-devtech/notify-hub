"""Entrypoint: `python -m notify_hub`."""

from __future__ import annotations


def main() -> None:
    """Run the notify-hub API server."""
    import uvicorn

    from notify_hub.core.config import get_settings

    settings = get_settings()
    uvicorn.run(
        "notify_hub.api.app:create_app",
        factory=True,
        host=settings.app_host,
        port=settings.app_port,
        reload=settings.app_env == "development",
        log_level=settings.app_log_level.lower(),
    )


if __name__ == "__main__":
    main()
