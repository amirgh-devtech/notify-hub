# notify-hub

> Multi-channel notification hub — ingests from RSS / API / Webhook, filters, deduplicates, and delivers to Telegram / Slack / Discord / Email.

[![CI](https://github.com/amirgh_devtech/notify-hub/.github/workflows/ci.yml/badge.svg)](https://github.com/amirgh_devtech/notify-hub/.github/workflows/ci.yml)
![Python](https://img.shields.io/badge/python-3.12-blue)
![FastAPI](https://img.shields.io/badge/FastAPI-0.133+-009688)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 🎯 What it does

`notify-hub` is a self-hosted service that:

- **Ingests** events from multiple sources: **RSS feeds**, **HTTP APIs**, and **incoming webhooks**
- **Filters** events based on user-defined rules
- **Deduplicates** identical or near-identical events
- **Delivers** notifications to multiple channels: **Telegram**, **Slack**, **Discord**, **Email**

## 🧱 Tech stack

| Layer        | Technology                                  |
| ------------ | ------------------------------------------- |
| API          | FastAPI + Uvicorn                           |
| Task queue   | Celery + Redis                              |
| Scheduler    | Celery Beat                                 |
| Storage      | PostgreSQL (SQLAlchemy 2.x async + Alembic) |
| Validation   | Pydantic v2 / pydantic-settings             |
| HTTP client  | httpx                                       |
| RSS parsing  | feedparser                                  |
| Logging      | structlog                                   |
| Metrics      | prometheus-client                           |
| Container    | Docker + Docker Compose                     |
| Package mgmt | uv                                          |
| Task runner  | just                                        |

## 🚧 Technical challenges addressed

- **Idempotency** — incoming webhooks can be replayed; dedup by `(source, external_id)`
- **Retry with backoff** — delivery failures retried with exponential backoff
- **Rate limiting** — per-channel rate limits to avoid hitting provider quotas
- **Deduplication** — content-hash based dedup window per source

## 📁 Project layout

```
notify-hub/
├── src/notify_hub/       # application code
│   ├── api/              # FastAPI routes
│   ├── core/             # config, logging, security
│   ├── db/               # SQLAlchemy models & session
│   ├── schemas/          # Pydantic DTOs
│   ├── services/         # domain logic (ingestors/filters/notifiers)
│   └── workers/          # Celery app & tasks
├── migrations/           # Alembic
├── tests/                # unit + integration
├── scripts/              # dev helpers
├── Dockerfile
├── docker-compose.yml
└── justfile
```

## 🚀 Quick start

```bash
# 1. Clone
git clone https://github.com/amirgh_devtech/notify-hub.git
cd notify-hub

# 2. Setup env
cp .env.example .env
# edit .env with your tokens

# 3. Start infra (Postgres + Redis)
just up-infra

# 4. Install deps
just sync

# 5. Run migrations
just migrate

# 6. Run API + worker + beat
just dev
```

## 🗺️ Roadmap

```
    ☑ Project skeleton
    □ Config & logging
    □ Database layer + migrations
    □ API endpoints
    □ Ingestors (RSS / API / Webhook)
    □ Filters & dedup
    □ Notifiers (Telegram / Slack / Discord / Email)
    □ Celery workers
    □ Docker + Compose
    □ Tests + CI
    □ Deploy guide
```

## 🤝 Contributing

This is a personal portfolio project — PRs are welcome but may not be merged. Feel free to fork 😊.

## 📜 License

MIT — see LICENSE.
