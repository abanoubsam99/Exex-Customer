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
/// Cold start: the launching link is read in [init]. Warm start: the link
/// stream delivers links while the app is already running. A link that
/// arrives before the user is signed in (or before the navigator exists) is
/// held in [_pendingPortId] and replayed by [flushPending] — called by the
/// splash screen once the initial route is in place.
class DeepLinkService {
  DeepLinkService();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  /// A link captured before we could route it (no navigator / not signed in).
  int? _pendingPortId;

  /// The last port actually opened, with its timestamp. app_links can deliver
  /// the launch link twice on cold start (getInitialLink + the stream), which
  /// would open the same port twice; a repeat within this window is ignored.
  int? _lastOpenedPortId;
  DateTime? _lastOpenedAt;
  static const _dedupeWindow = Duration(seconds: 3);

  /// Starts listening for cold-start and runtime links. Safe to call once.
  Future<void> init() async {
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) _handle(initial);
    } catch (_) {
      // Ignore — no valid launch link.
    }
    _sub = _appLinks.uriLinkStream.listen(_handle, onError: (_) {});
  }

  void _handle(Uri uri) {
    final portId = AppDeepLink.portIdFromUri(uri);
    if (portId == null) return;
    _pendingPortId = portId;
    _route();
  }

  /// Opens the pending port if the navigator is mounted and the user is signed
  /// in; otherwise leaves it pending for [flushPending].
  void _route() {
    final portId = _pendingPortId;
    if (portId == null) return;
    if (NavigationHelper.navigatorKey.currentState == null) return;
    // The port details screen is open to guests, so deep links resolve without
    // requiring sign-in — we only need the navigator to be mounted.
    _pendingPortId = null;
    // Ignore a duplicate delivery of the same launch link (see [_lastOpenedAt]).
    final now = DateTime.now();
    if (_lastOpenedPortId == portId &&
        _lastOpenedAt != null &&
        now.difference(_lastOpenedAt!) < _dedupeWindow) {
      return;
    }
    _lastOpenedPortId = portId;
    _lastOpenedAt = now;
    NavigationHelper.pushNamed(
      Routes.bookingServiceDetailsScreen,
      arguments: portId,
    );
  }

  /// Re-attempts a held link. Call after the initial route is in place
  /// (e.g. from the splash screen) or after a successful sign-in.
  void flushPending() => _route();

  void dispose() => _sub?.cancel();
}
