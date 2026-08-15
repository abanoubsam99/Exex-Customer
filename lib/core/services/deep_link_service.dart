import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_deep_link.dart';
import 'package:evex_user/core/routing/routes.dart';

/// Listens for incoming App Links (Android) / Universal Links (iOS) and opens
/// the matching screen inside the app.
///
/// Supported shape today: `https://<host>/port/<id>` → the booking-service
/// details screen for that port.
///
/// ## Why links are held instead of opened immediately
///
/// The startup screens finish with `pushNamedAndRemoveUntil(..., (r) => false)`,
/// which clears the whole stack. A navigator exists from the moment
/// `MaterialApp` builds — i.e. while the splash is still on screen — so a link
/// routed before startup settles gets pushed on top of the splash and is then
/// wiped by that splash's own navigation a moment later (the screen opens, then
/// jumps back to home on its own, killing its half-finished load).
///
/// So a link is never routed on "the navigator exists"; it is held in
/// [_pendingPortId] until [markReady] says the app has landed on its first real
/// route. The splash calls it (or the onboarding screen, when onboarding runs
/// first and takes over the last `pushNamedAndRemoveUntil`).
class DeepLinkService {
  DeepLinkService();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  /// A link captured before the app was ready to show it.
  int? _pendingPortId;

  /// Whether startup has settled on its first real route. See the class doc.
  bool _isReady = false;

  /// The launch link as reported by `getInitialLink`. app_links also replays it
  /// on [AppLinks.uriLinkStream] right after we subscribe, so that one echo is
  /// dropped to avoid opening the same port twice on cold start. Cleared as
  /// soon as the echo arrives (or at [markReady]), so a genuine later tap on
  /// the same URL is never swallowed.
  String? _launchLink;

  /// Starts listening for the cold-start link and runtime links. Call once,
  /// before `runApp`, so the launch link can't be missed.
  Future<void> init() async {
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        _launchLink = initial.toString();
        _handle(initial);
      }
    } catch (_) {
      // Ignore — no valid launch link.
    }
    _sub = _appLinks.uriLinkStream.listen(_onStreamLink, onError: (_) {});
  }

  void _onStreamLink(Uri uri) {
    if (_launchLink != null && uri.toString() == _launchLink) {
      // The cold-start echo of the link `getInitialLink` already gave us.
      _launchLink = null;
      return;
    }
    _handle(uri);
  }

  void _handle(Uri uri) {
    final portId = AppDeepLink.portIdFromUri(uri);
    if (portId == null) return;
    _pendingPortId = portId;
    _route();
  }

  /// Opens the pending port once startup has settled; otherwise leaves it
  /// pending for [markReady].
  void _route() {
    final portId = _pendingPortId;
    if (portId == null) return;
    if (!_isReady) return;
    if (NavigationHelper.navigatorKey.currentState == null) return;
    // Cleared only now that the push actually happens, so a link can never be
    // dropped on a path that returned early above.
    _pendingPortId = null;
    // The port details screen is open to guests, so it opens on top of the
    // home screen or the login screen alike, and back returns to it.
    NavigationHelper.pushNamed(
      Routes.bookingServiceDetailsScreen,
      arguments: portId,
    );
  }

  /// Marks startup as finished — the first real route is in place and nothing
  /// else is about to clear the stack. Opens a link the app was launched from.
  /// Safe to call more than once.
  void markReady() {
    // Past this point every stream delivery is a real new tap, so the
    // cold-start echo guard is no longer needed.
    _launchLink = null;
    if (_isReady) return;
    _isReady = true;
    _route();
  }

  void dispose() => _sub?.cancel();
}
