import 'dart:async';

import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/data/models/general_response.dart';
import 'package:evex_user/data/models/payment_gateway_result.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Opens the Paymob payment link in an in-app WebView. When the user finishes
/// (closes the screen, or the gateway redirects to its result page) it calls
/// VerifyPayment with the paymobOrderId, shows a success/failure alert, then
/// goes to "حجوزاتي".
class PaymentWebViewScreen extends StatefulWidget {
  final PaymentGatewayResult? result;
  const PaymentWebViewScreen({super.key, required this.result});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _verifying = false;
  bool _finishing = false;

  /// Main-frame load progress (0-100) for the thin bar under the header.
  int _progress = 0;

  /// Set when the gateway page can't be loaded at all, so the user gets a retry
  /// button instead of staring at a page that never arrives.
  String? _loadError;

  /// Guards a load that starts and never finishes: gateway 3DS pages often hold
  /// their connection open, which used to leave the loading state stuck on
  /// forever.
  Timer? _loadTimeout;

  /// How long a load may run before it is treated as stuck.
  static const _loadTimeoutDuration = Duration(seconds: 25);

  static const _loadErrorMessage =
      'تعذّر تحميل صفحة الدفع. تأكد من اتصالك بالإنترنت ثم حاول مرة أخرى.';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _progress = 0;
              _loadError = null;
            });
            _startLoadTimeout();
          },
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
          onPageFinished: (_) {
            _loadTimeout?.cancel();
            if (mounted) setState(() => _isLoading = false);
          },
          // Only a failed main-frame navigation breaks the payment page — a
          // missing image or script must never replace a usable page with the
          // retry panel. A null value (iOS) is treated as the main frame.
          onWebResourceError: (error) {
            if (error.isForMainFrame == false) return;
            _showLoadError();
          },
          onUrlChange: (change) {
            final url = (change.url ?? '').toLowerCase();
            // Paymob appends the result to its redirect URL — finish automatically.
            if (url.contains('txn_response_code') ||
                url.contains('success=true') ||
                url.contains('success=false')) {
              _finish();
            }
          },
        ),
      );
    _beginLoad();
  }

  @override
  void dispose() {
    _loadTimeout?.cancel();
    // webview_flutter 4.x exposes no WebViewController.dispose(), so the native
    // WebView — and the gateway page's JS timers — keep running until the
    // controller is garbage collected. Loading a blank page tears the page down
    // as the screen leaves, so retrying a payment can't pile up several live
    // WebViews (battery/heat, and an OOM kill on low-end devices).
    _controller.loadRequest(Uri.parse('about:blank')).ignore();
    super.dispose();
  }

  /// Starts (or restarts) the gateway page load and arms the stuck-load timeout.
  /// Mutates the fields directly so it can also run from [initState]; callers
  /// that need a rebuild wrap it in `setState` (see [_retry]).
  void _beginLoad() {
    final uri = Uri.tryParse(widget.result?.paymentUrl ?? '');
    // An empty or relative URL makes loadRequest throw, so treat it like any
    // other failed load instead of blowing up initState.
    if (uri == null || !uri.hasScheme) {
      _isLoading = false;
      _loadError = _loadErrorMessage;
      return;
    }
    _isLoading = true;
    _progress = 0;
    _loadError = null;
    _startLoadTimeout();
    _controller.loadRequest(uri);
  }

  void _retry() => setState(_beginLoad);

  void _startLoadTimeout() {
    _loadTimeout?.cancel();
    _loadTimeout = Timer(_loadTimeoutDuration, () {
      if (!mounted || !_isLoading) return;
      // A page that already rendered most of its content but never reports
      // onPageFinished is still usable — just drop the progress bar. Anything
      // less than that really is stuck, so offer a retry.
      setState(() {
        _isLoading = false;
        if (_progress < 50) _loadError = _loadErrorMessage;
      });
    });
  }

  void _showLoadError() {
    _loadTimeout?.cancel();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _loadError = _loadErrorMessage;
    });
  }

  /// Verifies the payment, shows the result alert, then goes to "حجوزاتي".
  Future<void> _finish() async {
    if (_finishing) return;
    _finishing = true;
    final orderId = widget.result?.paymobOrderId ?? 0;
    final repo = context.read<ConfirmBookingRepo>();
    setState(() => _verifying = true);
    final GeneralResponse? res =
        orderId != 0 ? await repo.verifyPayment(orderId) : null;
    if (!mounted) return;
    setState(() => _verifying = false);
    await _showResultDialog(res?.isSuccess == true, res?.message);
    NavigationHelper.pushNamedAndRemoveUntil(
      Routes.mainScreen,
      arguments: 1, // "حجوزاتي"
    );
  }

  Future<void> _showResultDialog(bool success, String? message) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: success ? AppColors.green : Colors.red,
              size: 56.r,
            ),
            16.verticalSpace,
            Text(
              success ? 'تم تأكيد الحجز بنجاح' : 'لم يتم تأكيد الحجز',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blacksoft,
                fontSize: 16.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w800,
              ),
            ),
            if ((message ?? '').isNotEmpty) ...[
              8.verticalSpace,
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 13.r,
                  fontFamily: 'Almarai',
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'حسناً',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 15.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shown when the gateway page can't be loaded — the page behind it is blank,
  /// so this is a dead end without a way back in.
  Widget _buildLoadError() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, color: AppColors.grey, size: 48.r),
          16.verticalSpace,
          Text(
            _loadError!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blacksoft,
              fontSize: 14.r,
              fontFamily: 'Almarai',
              height: 1.6,
            ),
          ),
          20.verticalSpace,
          TextButton(
            onPressed: _retry,
            child: Text(
              'إعادة المحاولة',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 15.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 8.h),
                child: Row(
                  children: [
                    InkWell(
                      onTap: _finish,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        width: 40.r,
                        height: 40.r,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.fillGrey2),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(Icons.arrow_back_ios_new,
                            color: AppColors.black, size: 16.r),
                      ),
                    ),
                    12.horizontalSpace,
                    Text(
                      'إتمام الدفع',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 18.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ],
                ),
              ),
              // Page loading shows as a thin determinate bar above the page: it
              // covers nothing, swallows no taps, and stops repainting once the
              // load ends — unlike a full-size spinner, which animates at the
              // display's refresh rate on top of the WebView's platform view
              // and keeps recompositing it every frame.
              // The slot keeps its height whether or not the bar is showing, so
              // starting/finishing a load never resizes the WebView underneath
              // (a platform-view resize is an expensive surface change, and the
              // gateway navigates several times per payment).
              SizedBox(
                height: 2.h,
                child: _isLoading
                    ? LinearProgressIndicator(
                        value: _progress / 100,
                        minHeight: 2.h,
                        color: AppColors.primaryColor,
                        backgroundColor: AppColors.fillGrey2,
                      )
                    : null,
              ),
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    // Verifying the payment is the only state allowed to block
                    // input. A page that is merely still loading must stay
                    // tappable, so nothing hit-testable goes over the WebView
                    // for it: a Container with a color — even a fully
                    // transparent one — is opaque to hit tests and used to
                    // swallow every touch on the payment form.
                    if (_verifying)
                      Container(
                        color: Colors.white70,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    if (_loadError != null) _buildLoadError(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
