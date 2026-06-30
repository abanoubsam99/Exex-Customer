import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Shared cache manager for all network images in the app.
///
/// The backend serves images at a stable URL and overwrites the file in place
/// when an image changes (the URL never changes). The default
/// `flutter_cache_manager` keeps an entry for 30 days, so an updated image would
/// keep showing the stale cached copy for that long.
///
/// To fix that we use a short [stalePeriod]: once an entry is older than this,
/// the cache revalidates against the server. When the backend sends an
/// `ETag` / `Last-Modified` header this is almost free (a 304 just bumps the
/// expiry, no bytes re-downloaded); otherwise the image is re-fetched. Tune
/// [_stalePeriod] if a different freshness/bandwidth balance is needed.
class ImageCacheManager {
  ImageCacheManager._();

  static const _cacheKey = 'evexImageCache';

  /// How long a cached image is trusted before it is revalidated. Kept short so
  /// backend image changes (which reuse the same URL) show up quickly.
  static const _stalePeriod = Duration(hours: 1);

  static final CacheManager instance = CacheManager(
    Config(
      _cacheKey,
      stalePeriod: _stalePeriod,
      maxNrOfCacheObjects: 300,
    ),
  );
}
