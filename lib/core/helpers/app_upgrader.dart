import 'package:upgrader/upgrader.dart';

/// [Upgrader] that treats *any* store version newer than the installed one as a
/// blocking (mandatory) update.
///
/// The base class only blocks when the installed version is below an explicit
/// `minAppVersion` — a value that has to be maintained by hand, either in code
/// or as a `[Minimum supported app version: x.y.z]` tag in the store listing.
/// Overriding [blocked] with [isUpdateAvailable] removes that bookkeeping: the
/// published store version is the single source of truth, so the moment a newer
/// build goes live every older install must update to keep using the app.
///
/// Being "blocked" changes the dialog in two ways, both handled by
/// [UpgradeAlert]:
///  * the Ignore / Later buttons are dropped entirely;
///  * tapping "Update Now" opens the store WITHOUT closing the dialog, so the
///    app stays unusable until the new version is actually installed.
class _ForceUpgrader extends Upgrader {
  _ForceUpgrader({
    super.countryCode,
    super.debugLogging,
    super.durationUntilAlertAgain,
    super.debugDisplayAlways,
  });

  /// Installed version must match the store version, so an available update is
  /// itself the blocking condition.
  @override
  bool blocked() => isUpdateAvailable();
}

/// Single shared upgrader instance used by every screen that wraps its body in
/// an [UpgradeAlert] (home + login). Keeping one instance means the store
/// lookup, messages and debug flags stay identical across the app instead of
/// being redefined per screen.
///
/// Why the dialog may NOT appear even when a newer version exists:
///  1. Store lookup: upgrader reads the *published* store listing (Play Store
///     on Android, App Store on iOS). If the build's applicationId/bundleId is
///     not live on the store, or the listing does not expose a version number,
///     the comparison cannot run and no alert shows.
///  2. The store version is not strictly greater than the installed one — e.g.
///     when running a local build whose version was already bumped ahead of
///     what is published.
///  3. iOS country: the App Store lookup defaults to the US listing; set
///     [countryCode] if the app is only published in another country.
///
/// [debugLogging] prints the store version, the installed version and the
/// comparison result to the console, so the exact reason is always visible.
final Upgrader appUpgrader = _ForceUpgrader(
  // Print store lookup + version comparison to the console. This is the fastest
  // way to see WHY the dialog does or does not appear. Safe to leave on.
  debugLogging: true,

  // The update is mandatory, so there is no "remind me later" cadence: zero
  // means upgrader never considers the alert "too soon" and shows it on every
  // app launch (and on every screen that wraps itself in an UpgradeAlert)
  // until the user actually installs the new version.
  durationUntilAlertAgain: Duration.zero,

  // The app is published on the Egyptian store (apps.apple.com/eg/...), so
  // look up the EG listing — a US lookup can miss the app / its version.
  countryCode: 'eg',

  // TESTING ONLY: flip to true to force the dialog on every launch, ignoring
  // the store version check — useful to confirm the UI wiring works. Note that
  // with no real store version behind it the dialog is not blocking, so the
  // update button still closes it. Must be false for release.
  debugDisplayAlways: false,
);
