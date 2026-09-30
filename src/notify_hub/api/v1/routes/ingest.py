"""Inbound event ingestion endpoints (webhooks, manual triggers)."""

from __future__ import annotations

from fastapi import APIRouter

router = APIRouter(prefix="/ingest", tags=["ingest"])

# Endpoints implemented in a later step.
