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

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
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
      )
      ..loadRequest(Uri.parse(widget.result?.paymentUrl ?? ''));
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
                        child: Icon(Icons.arrow_forward_ios,
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
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    if (_isLoading || _verifying)
                      Container(
                        color: _verifying ? Colors.white70 : Colors.transparent,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
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
