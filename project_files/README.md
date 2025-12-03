# Location Picker (Flutter)

A minimal, self-contained Flutter screen that recreates a Swiggy/Dominos-style location selection page with:

- Google Map with current-location marker and subtle radius circle
- Top search bar overlay (with mic icon placeholder)
- Bottom card with "Use current location", saved address chips, info card, and a large gradient "Confirm Location" button

## Files

- `lib/main.dart` – Boots the app and shows `LocationPickerPage`.
- `lib/location_picker_page.dart` – All UI and logic for the location picker.
- `pubspec.yaml` – Dependencies: `google_maps_flutter`, `geolocator`, `geocoding`.

## Quick start (Windows PowerShell)

1. Ensure Flutter is installed and on PATH.
2. From the project root (`d:\quro_proj`), fetch packages and run:

```powershell
flutter pub get
flutter run
```

> If you see a white screen instead of a map, you still need to add a Google Maps API key (see below).

## Google Maps setup

Google Maps requires an API key on each platform.

### Android
1. Get a Maps SDK key from Google Cloud for Android.
2. Add your key to `local.properties` (do not commit secrets):

```properties
MAPS_API_KEY=YOUR_ANDROID_MAPS_API_KEY
```

3. The build is already configured to pass this key to the manifest via
	`manifestPlaceholders` in `android/app/build.gradle.kts`.

4. Ensure `minSdkVersion` is 21 or higher (the default in most recent templates).

### iOS
1. In `ios/Runner/AppDelegate.swift` (or `AppDelegate.m`), add:

```swift
GMSServices.provideAPIKey("YOUR_IOS_MAPS_API_KEY")
```

2. Add the following to `ios/Runner/Info.plist` for location permissions (these are already handled by `geolocator` prompts, but messages are required):

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We use your location to show it on the map and to deliver to your address.</string>
```

## Location permissions
This screen requests location permission at runtime via `geolocator`. If denied, the UI still works—users can tap anywhere on the map or type an address manually.

On Android we declare `ACCESS_COARSE_LOCATION` and `ACCESS_FINE_LOCATION` in the manifest.

## Notes and customizations
- Hook up the search bar to Google Places for autocomplete if needed.
- The mic icon is a placeholder; integrate `speech_to_text` to enable voice search.
- `Confirm Location` currently shows a Snackbar with the selected address. Replace with your callback/navigation.
