# Experience Ghana

**Explore Ghana. Deeply.**

Mobile guide for curated places, location-aware audio, trip planning, and offline access.

## Projects

- `frontend/` — Flutter + Riverpod client
- `backend/` — Django REST Framework + PostGIS API

## Run locally

Backend: copy `backend/.env.example` to `backend/.env`, configure PostGIS and Redis, install `backend/requirements.txt`, then run migrations and `python manage.py runserver`.

Mobile: install Flutter, run `flutter pub get`, then `flutter run` from `frontend/`.
