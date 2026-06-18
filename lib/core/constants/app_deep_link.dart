/// Shareable deep / app links (Android App Links + iOS Universal Links).
///
/// One public link shape backs the share feature:
///   `https://<host>/port/<portId>`
///
/// When the app is installed the OS opens it directly (verified via the
/// `.well-known` association files hosted on [host]); otherwise the browser
/// loads the same URL and a small redirect page sends the user to the store.
class AppDeepLink {
  AppDeepLink._();

  /// HTTPS host that backs the links. It MUST serve, over HTTPS:
  ///   `https://<host>/.well-known/assetlinks.json`            (Android)
  ///   `https://<host>/.well-known/apple-app-site-association` (iOS)
  /// Change this to the final production domain — it has to match the host
  /// declared in AndroidManifest.xml and the iOS Associated Domains.
  static const String host = 'evex.runasp.net';

  /// Path prefix for a port: `https://<host>/port/<id>`.
  static const String portPath = 'port';

  /// Builds the public shareable link for a port.
  static String portLink(int portId) => 'https://$host/$portPath/$portId';

  /// Returns the port id when [uri] is a `/port/<id>` link, otherwise null.
  static int? portIdFromUri(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.length >= 2 && segments.first == portPath) {
      return int.tryParse(segments[1]);
    }
    return null;
  }
}
