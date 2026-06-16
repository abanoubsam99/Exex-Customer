import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:url_launcher/url_launcher.dart';

/// Thin wrapper around url_launcher for the common actions used across the app:
/// opening web links, dialing a number, sending an email, opening WhatsApp,
/// and opening a location in Google Maps. Use these instead of repeating the
/// launch/maps-URL logic in each screen.
class LauncherHelper {
  LauncherHelper._();

  /// Opens Google Maps for a location. Prefers [gps] coordinates; falls back to
  /// the text [address]. Shows a message if neither is available.
  static Future<void> openMaps({String? gps, String? address}) async {
    final g = gps?.trim() ?? '';
    final a = address?.trim() ?? '';
    final query = g.isNotEmpty ? g : a;
    if (query.isEmpty) {
      ToastManager.showError('الموقع غير متاح');
      return;
    }
    await _launch(
      Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
      ),
    );
  }

  /// Opens a web URL in an external browser.
  static Future<void> openUrl(String? url) async {
    if (url == null || url.trim().isEmpty) return;
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;
    await _launch(uri);
  }

  /// Opens the dialer with [phone] pre-filled.
  static Future<void> call(String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    await _launch(Uri(scheme: 'tel', path: phone.trim()));
  }

  /// Opens the mail app composing to [address].
  static Future<void> email(String? address) async {
    if (address == null || address.trim().isEmpty) return;
    await _launch(Uri(scheme: 'mailto', path: address.trim()));
  }

  /// Opens a WhatsApp chat with [number]. Egyptian local numbers (leading 0)
  /// are normalized to the international form (20...).
  static Future<void> whatsApp(String? number) async {
    if (number == null || number.trim().isEmpty) return;
    var digits = number.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('0')) digits = '20${digits.substring(1)}';
    await _launch(Uri.parse('https://wa.me/$digits'));
  }

  static Future<void> _launch(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // Silently ignore — no handler app installed, etc.
    }
  }
}
