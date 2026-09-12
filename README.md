# Experience Ghana

**Explore Ghana. Deeply.**

Mobile guide for curated places, location-aware audio, trip planning, and offline access.

## Projects

- `frontend/` — Flutter + Riverpod client
- `backend/` — Django REST Framework + PostGIS API

## Run locally

Backend: run `docker compose up --build` to start PostGIS, Redis, and the API. Then run `docker compose exec api python manage.py seed_experiences` to load starter content. The API is served at `http://localhost:8000/api/experiences/`.

Mobile: install Flutter, run `flutter pub get`, then `flutter run` from `frontend/`.

### Mobile configuration

Generate the native project folders once Flutter is installed with `flutter create .` from `frontend/`. Run with a Mapbox public token (do not commit it):

```powershell
flutter run --dart-define=ACCESS_TOKEN=your_public_mapbox_token
```

Add Android `ACCESS_FINE_LOCATION` and `ACCESS_COARSE_LOCATION` permissions, plus iOS `NSLocationWhenInUseUsageDescription`, after generating the platform folders. The location component needs those platform declarations before it can request GPS access.
