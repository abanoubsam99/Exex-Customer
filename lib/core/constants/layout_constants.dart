import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/helpers/extensions.dart';

/// Floating bottom nav bar geometry — single source of truth shared by the bar
/// itself (in MainScreen) and any scrollable page that needs to reserve room
/// beneath it.
const double kNavBarHeight = 74;
const double kNavBarMargin = 20;

/// Vertical space the floating nav bar occupies from the screen bottom
/// (height + top & bottom margins). Scrollable pages add this much bottom
/// padding so their last item clears the bar instead of hiding behind it —
/// while the page itself still fills the full height (no dead white band).
const double kFloatingNavBarSpace = kNavBarHeight + kNavBarMargin * 2;

/// Bottom padding a scrollable tab page should reserve so its last item clears
/// the floating nav bar. Adds the system navigation bar inset (the on-screen
/// back/home/recent buttons) because the bar itself is pushed up by that much
/// — see MainScreen. Single source of truth so every page stays in sync.
double navBarBottomReserve(BuildContext context) =>
    kFloatingNavBarSpace.r + context.bottomSafeInset;
