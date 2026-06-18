import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Shows the payment-gateway link returned by ConfirmClientReservation inside an
/// in-app WebView so the user can complete the card payment without leaving the
/// app.
class PaymentWebViewScreen extends StatefulWidget {
  final String url;
  const PaymentWebViewScreen({super.key, required this.url});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

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
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 8.h),
              child: Row(
                children: [
                  const CustomBackButtonWidget(),
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
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
