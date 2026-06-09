import 'package:evex_user/core/constants/app_endpoints.dart';

/// Helper لبناء روابط الصور الجاية من السيرفر.
///
/// السيرفر بيرجّع مسارات نسبية أحياناً بـ backslashes (`Uploads\images\...`)،
/// وأحياناً بقيمة `"not found"` أو `null` لما الصورة مش موجودة.
class ImageUrlHelper {
  ImageUrlHelper._();

  /// المسار غير صالح (null / فاضي / "not found").
  static bool isInvalid(String? path) {
    if (path == null) return true;
    final p = path.trim();
    return p.isEmpty || p.toLowerCase() == 'not found';
  }

  /// بيبني URL كامل لصورة من مسار نسبي.
  /// بيحوّل `\` لـ `/` ويعمل encoding (للمسافات والأسماء العربية).
  /// بيرجّع `null` لو المسار غير صالح.
  static String? full(String? path) {
    if (isInvalid(path)) return null;
    final normalized = path!.trim().replaceAll('\\', '/');
    return '${AppEndpoints.baseUrl}${Uri.encodeFull(normalized)}';
  }
}
