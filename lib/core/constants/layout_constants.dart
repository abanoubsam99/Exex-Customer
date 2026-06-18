/// Floating bottom nav bar geometry — single source of truth shared by the bar
/// itself (in MainScreen) and any scrollable page that needs to reserve room
/// beneath it.
const double kNavBarHeight = 74;
const double kNavBarMargin = 22;

/// Vertical space the floating nav bar occupies from the screen bottom
/// (height + top & bottom margins). Scrollable pages add this much bottom
/// padding so their last item clears the bar instead of hiding behind it —
/// while the page itself still fills the full height (no dead white band).
const double kFloatingNavBarSpace = kNavBarHeight + kNavBarMargin * 2;
