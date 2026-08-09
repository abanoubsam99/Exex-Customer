import 'package:upgrader/upgrader.dart';

/// Single shared [Upgrader] instance used by every screen that wraps its body
/// in an [UpgradeAlert] (home + login). Keeping one instance means the alert
/// cadence, messages and debug flags stay identical across the app instead of
/// being redefined per screen.
///
/// Why the dialog may NOT appear even when a newer version exists:
///  1. Store lookup: upgrader reads the *published* store listing
///     (Play Store on Android, App Store on iOS). If the build's
///     applicationId/bundleId is not live on the store, or the store version
///     is not strictly greater than the installed one, no alert shows.
///  2. Cadence: after being shown/dismissed once, upgrader waits
///     [durationUntilAlertAgain] (default 3 days) before showing again.
///  3. iOS country: the App Store lookup defaults to the US listing; set
///     [countryCode] if the app is only published in another country.
///
/// Turn on [debugLogging] to print the store version, installed version and the
/// comparison result to the console so the exact reason is visible.
final Upgrader appUpgrader = Upgrader(
  // Print store lookup + version comparison to the console. This is the fastest
  // way to see WHY the dialog does or does not appear. Safe to leave on.
  debugLogging: true,

  // Prompt again on the next launch instead of waiting the default 3 days.
  durationUntilAlertAgain: const Duration(days: 1),

  // The app is published on the Egyptian store (apps.apple.com/eg/...), so
  // look up the EG listing — a US lookup can miss the app / its version.
  countryCode: 'eg',

  // TESTING ONLY: force the dialog on every launch, ignoring the store version
  // check and the cadence above. Uncomment to confirm the UI wiring works, then
  // comment it back before release.
  // debugDisplayAlways: true,
);
