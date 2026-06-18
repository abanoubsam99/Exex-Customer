import 'dart:io';

import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

/// Shared "save downloaded bytes → open in the device viewer" logic, used by any
/// screen that downloads a reservation PDF (DownloadInfo). Keeps the save/open
/// flow in one place instead of repeating it per cubit.
class FileDownloadHelper {
  FileDownloadHelper._();

  /// Writes [bytes] as `reservation_<id>.pdf` to a temp dir and opens it.
  /// Shows an error toast when the bytes are null or the file can't be opened.
  static Future<void> openReservationPdf({
    required int id,
    required List<int>? bytes,
  }) async {
    if (bytes == null) {
      ToastManager.showError('تعذّر تحميل الملف');
      return;
    }
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/reservation_$id.pdf');
      await file.writeAsBytes(bytes);
      await OpenFilex.open(file.path);
    } catch (_) {
      ToastManager.showError('تعذّر فتح الملف');
    }
  }
}
