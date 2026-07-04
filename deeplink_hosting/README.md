# EVEX Deep Links — Hosting & Backend Checklist

Shareable link shape: `https://backend.evexnow.com/port/<portId>`

- App installed → the OS opens the app on the port details screen.
- App not installed → the browser opens `port.html`, which redirects to the
  correct store (Play Store / App Store).

The Flutter side is already wired (package `app_links`). What remains is hosting
the three files below on the **production HTTPS domain** and finalizing a few ids.

---

## 1) Host the association files (REQUIRED)

Serve these at the EXACT paths over HTTPS (valid TLS cert, no redirects):

| Path | File | Notes |
|------|------|-------|
| `/.well-known/assetlinks.json` | `assetlinks.json` | Content-Type `application/json`. Android. |
| `/.well-known/apple-app-site-association` | `apple-app-site-association` | **No `.json` extension.** Content-Type `application/json`. iOS. |

> ASP.NET note: `.well-known` and the extension-less AASA file must be allowed
> by static-file middleware (add a `ContentTypeProvider` mapping or a dedicated
> controller action that returns the JSON with `application/json`).

### Fill in the placeholders
- `assetlinks.json` → `sha256_cert_fingerprints`: the **release** signing cert
  SHA-256. Get it from Play Console → *App integrity → App signing*, or locally:
  `cd android && ./gradlew signingReport` (use the SHA-256 of the release key).
- `apple-app-site-association` → `appIDs`: `<AppleTeamID>.<bundleId>`.
  Current bundle id is `com.example.evexUser` (placeholder — see step 3).

## 2) Route `/port/<id>` to the redirect page

Map any `GET /port/{id}` (for non-app visitors) to `port.html`. Either a rewrite
rule, or a controller action. Best: render the Open Graph tags (title /
description / image) **per port** so WhatsApp/Facebook previews look good.
In `port.html`, set `IOS_APP_ID` to the App Store numeric id once published.

## 3) Finalize app identifiers
- **iOS bundle id** is still `com.example.evexUser` (placeholder). Change it to a
  real reverse-domain id (e.g. `app.evex.user`) in Xcode, then update
  `appIDs` in `apple-app-site-association` and the entitlement.
- **Android** applicationId is `com.evex.evexuser` (already real).

## 4) iOS Xcode step (on a Mac)
`Runner.entitlements` already declares `applinks:backend.evexnow.com`. In Xcode:
*Runner target → Signing & Capabilities → + Capability → Associated Domains*,
confirm `applinks:backend.evexnow.com` is listed, and set the Team / signing.

---

## Verify
- Android: `adb shell pm verify-app-links --re-verify com.evex.evexuser` then
  `adb shell pm get-app-links com.evex.evexuser` → host should be `verified`.
- iOS: open the link from Notes/Messages on a device with the app installed.
- Validators: Google `Statement List Generator and Tester`, Apple AASA validator.

## Changing the domain
If the production domain differs from `backend.evexnow.com`, update all of:
`lib/core/constants/app_deep_link.dart` (`host`),
`android/app/src/main/AndroidManifest.xml` (intent-filter `android:host`),
`ios/Runner/Runner.entitlements` (`applinks:`).
