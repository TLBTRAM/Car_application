# Car Booking App (Flutter + Node.js + MySQL)

Ride‑hailing sample app (Uber/Grab‑style) with three roles (Admin, Driver, Customer). Uses Google Maps SDK for map UI, Nominatim (OpenStreetMap) for geocoding + autocomplete, and OSRM for real driving distance and route. Multilingual (EN/VI).

## Features
- Customer: pick origin/destination, show route, distance/time, dynamic fare.
- Map UI: Google Maps (Android), draw polylines.
- Geocoding + Autocomplete: Nominatim (restricted to Vietnam).
- Directions + Distance: OSRM (public demo for dev).
- Admin: manage users. Driver: accept/complete rides.
- Booking history + i18n.

## Tech Stack
- Flutter 3.x (google_maps_flutter, http, provider, intl)
- Node.js + Express + MySQL
- Nominatim (geocoding), OSRM (routing)

## Setup
```powershell
git clone <REPO_URL> car_booking_app
cd car_booking_app
flutter pub get
cd backend && npm install
```

### Android Map UI
Add your Google Maps API key (UI only) in:
```xml
<!-- android/app/src/main/AndroidManifest.xml inside <application> -->
<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_KEY"/>
```
Ensure permissions:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

## Run
```powershell
# Backend
cd backend && npm run start
# App (Android)
cd .. && flutter run
```

## Distance & Pricing
- Distance/time from OSRM; polyline drawn on Google Map.
- Fare: `total = basePrice + pricePerKm * distanceKm`.
- Nominatim queries restricted to Vietnam to avoid wrong countries; debounce and >=3 chars to trigger autocomplete.

## Troubleshooting
- App “Not Responding” on map: missing Google Maps API key or location permission.
- Huge fares: address resolved outside Vietnam; now restricted and outlier distance (>500km) is rejected.
- Autocomplete not showing: type ≥3 chars, wait ~0.5s debounce; public Nominatim may rate‑limit.

## Notes
- Public Nominatim/OSRM are for development; consider self‑hosting for production.
- Don’t commit secrets in public repos.
- License: MIT (adjust as needed).
