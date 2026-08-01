import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/date_format_helper.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/widgets/custom_circle.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/data/models/occasion.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/edit_occasion_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class ChangeOccasion extends StatelessWidget {
  /// البوابة المختارة من الشاشة السابقة. لو اتبعتت بنعرض اسمها وموقعها الحقيقي،
  /// وإلا بنستخدم القيم الافتراضية (زي ما في شاشة تفاصيل الخدمة).
  final Item? port;

  /// The picked occasion date; shown instead of the placeholder when provided.
  final DateTime? occasionDate;

  /// نوع المناسبة options + the currently chosen one, surfaced inside the edit
  /// sheet. Left empty (with a null callback) when the host screen doesn't let
  /// the user pick an occasion type (e.g. complete-booking).
  final List<Occasion> occasions;
  final int? selectedOccasionId;
  final ValueChanged<int?>? onOccasionSelected;

  /// Edit mode + the reservation's original date/place. When editing, if the
  /// user keeps the same date + governorate + city, the only thing occupying
  /// that slot is the user's own reservation, so it's shown as available for
  /// instant booking instead of "غير متاح".
  final bool isEditMode;
  final DateTime? editOriginalDate;
  final String? editOriginalGovernorate;
  final String? editOriginalCity;

  const ChangeOccasion({
    super.key,
    this.port,
    this.occasionDate,
    this.occasions = const [],
    this.selectedOccasionId,
    this.onOccasionSelected,
    this.isEditMode = false,
    this.editOriginalDate,
    this.editOriginalGovernorate,
    this.editOriginalCity,
  });

  /// True when editing and the chosen date + place still match the original
  /// reservation, i.e. the conflicting booking is the user's own one.
  bool _isOwnOriginalSlot(DateTime? date, String? gov, String? city) {
    if (!isEditMode) return false;
    final orig = editOriginalDate;
    if (date == null || orig == null) return false;
    if (date.year != orig.year ||
        date.month != orig.month ||
        date.day != orig.day) {
      return false;
    }
    bool sameStr(String? a, String? b) =>
        (a ?? '').trim().toLowerCase() == (b ?? '').trim().toLowerCase();
    return sameStr(gov, editOriginalGovernorate) &&
        sameStr(city, editOriginalCity);
  }

  /// The event location shown in the header: the value picked in the edit sheet
  /// ([eventGov]/[eventCity]) if any, otherwise the signed-in user's own
  /// governorate/city from their profile. Falls back to a prompt when neither
  /// is available.
  String _eventLocationText(
      BuildContext context, String? eventGov, String? eventCity) {
    final user = context.read<UserService>().currentUser?.userViewModel;
    final gov = (eventGov?.trim().isNotEmpty ?? false)
        ? eventGov
        : user?.governorate;
    final city =
        (eventCity?.trim().isNotEmpty ?? false) ? eventCity : user?.city;
    final parts = [gov, city]
        .where((e) => e != null && e.trim().isNotEmpty)
        .cast<String>()
        .toList();
    if (parts.isEmpty) return 'حدد مكان المناسبة';
    return parts.join('، ');
  }

  /// Opens the "تعديل تاريخ ومكان المناسبة" sheet, pre-filled with the current
  /// date + the event location (or the user's profile location). On confirm it
  /// stores them on [HomeCubit] and re-checks instant-booking availability.
  void _openEditSheet(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final repo = context.read<ConfirmBookingRepo>();
    final user = context.read<UserService>().currentUser?.userViewModel;
    final st = homeCubit.state;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditOccasionSheet(
        initialDate: st.bookingDate ?? occasionDate,
        initialGovernorate: st.eventGovernorate ?? user?.governorate,
        initialCity: st.eventCity ?? user?.city,
        // Restrict the location picker to the port's working area.
        portId: port?.id,
        // Disable dates before today + minimumDays (vendor's required lead time).
        minimumDays: port?.minimumDays ?? 0,
        occasions: occasions,
        initialOccasionId: selectedOccasionId,
        onConfirm: (date, gov, city, occasionId) async {
          homeCubit.setBookingDate(date);
          homeCubit.setEventLocation(gov, city);
          onOccasionSelected?.call(occasionId);
          final portId = port?.id;
          if (portId != null) {
            homeCubit.setAvailabilityChecking();
            homeCubit.setAvailability(
              await repo.checkAvailability(
                portId: portId,
                date: date,
                governorate: gov,
                city: city,
              ),
            );
          }
        },
      ),
    );
  }

  /// Re-runs the availability check after a failed attempt, using the date +
  /// place currently on [HomeCubit]. Mirrors the check done on screen open so
  /// the badge can recover from a network/timeout error without leaving the
  /// screen.
  Future<void> _retryAvailability(BuildContext context) async {
    final homeCubit = context.read<HomeCubit>();
    final repo = context.read<ConfirmBookingRepo>();
    final st = homeCubit.state;
    final date = st.bookingDate ?? occasionDate;
    final portId = port?.id;
    if (date == null || portId == null) return;
    homeCubit.setAvailabilityChecking();
    homeCubit.setAvailability(
      await repo.checkAvailability(
        portId: portId,
        date: date,
        governorate: st.eventGovernorate,
        city: st.eventCity,
      ),
    );
  }

  /// Maps the availability response (+ whether a date was picked) to the exact
  /// status message/colour shown next to the glowing dot.
  _AvailabilityView _statusFor(
      DateTime? date, CheckReservationResponse? av, AvailabilityStatus status) {
    // Can't know availability without a date — prompt the user to pick one.
    if (date == null) {
      return const _AvailabilityView(
        'حدد تاريخ المناسبة لمعرفة متاح أم لا !',
        AppColors.primaryColor,
        AppColors.primaryColor,
      );
    }
    // The check failed (network/timeout) — offer a retry instead of spinning.
    if (status == AvailabilityStatus.failed && av == null) {
      return const _AvailabilityView(
        'تعذّر التحقق من الإتاحة، اضغط لإعادة المحاولة',
        AppColors.coral,
        AppColors.coral,
        isRetry: true,
      );
    }
    // Date picked, response not back yet.
    if (av == null) {
      return const _AvailabilityView(
        'جاري التحقق من الإتاحة...',
        AppColors.blueGrey,
        AppColors.blueGrey,
      );
    }
    // The backend ships the exact wording to show in `verificationResultMessage`
    // (e.g. "متاح الحجز الفورى لخدمات معينة" — a case the flags alone can't
    // express). Always surface it; the flags only decide the colour. The local
    // strings stay as a fallback for when the backend sends no message.
    final serverMsg = av.verificationResultMessage?.trim();
    _AvailabilityView view(String fallback, Color textColor, Color dotColor) {
      final msg =
          (serverMsg != null && serverMsg.isNotEmpty) ? serverMsg : fallback;
      // Colour follows the wording: anything starting with "متاح" reads as
      // available → green; "غير متاح ..." stays red. Checked in this order
      // because "غير متاح" also contains the word "متاح".
      if (msg.startsWith('غير متاح')) {
        return _AvailabilityView(msg, AppColors.coral, AppColors.coral);
      }
      if (msg.startsWith('متاح')) {
        return _AvailabilityView(msg, AppColors.green2, AppColors.greenSoft);
      }
      return _AvailabilityView(msg, textColor, dotColor);
    }

    if (av.allowedToReservation == true) {
      // Vendor requires confirmation → bookable but pending the vendor's
      // approval, so it reads as available-with-confirmation (blue) rather
      // than instant (green).
      if (av.confirmationIsRequiredFromVendor == true) {
        return view(
          'متاح للحجز ولكن يلزم التأكيد من التاجر',
          AppColors.blue2,
          AppColors.blue2,
        );
      }
      return view(
        'متاح للحجز الفوري',
        AppColors.green2,
        AppColors.greenSoft,
      );
    }
    // Event area is outside the vendor's working area.
    if (av.reservationLocationAllowed == false) {
      return view(
        'غير متاح للحجز في هذه المنطقة',
        AppColors.coral,
        AppColors.coral,
      );
    }
    // Backend says only the vendor's own work team can be booked (blue, per the
    // design — distinct from the unavailable/red states).
    if (av.allowedToReserveWorkTeam == true) {
      return view(
        'متاح لحجز فريق العمل الخاص به فقط',
        AppColors.blue2,
        AppColors.blue2,
      );
    }
    // Otherwise the date/time itself isn't available.
    return view(
      'غير متاح للحجز في هذا الميعاد',
      AppColors.coral,
      AppColors.coral,
    );
  }

  /// The chosen occasion type's name (e.g. "كتب كتاب"), or null when nothing
  /// is selected yet — shown as the last chip on the date/location row.
  String? get _selectedOccasionName {
    final id = selectedOccasionId;
    if (id == null) return null;
    for (final o in occasions) {
      if (o.id == id) {
        final name = o.name?.trim();
        return (name != null && name.isNotEmpty) ? name : null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final occasionName = _selectedOccasionName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Availability status line (standalone, no background) ──
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (p, c) =>
              p.availability != c.availability ||
              p.availabilityStatus != c.availabilityStatus ||
              p.bookingDate != c.bookingDate ||
              p.eventGovernorate != c.eventGovernorate ||
              p.eventCity != c.eventCity,
          builder: (context, state) {
            final rawDate = state.bookingDate ?? occasionDate;
            // A carried-over date earlier than the vendor's earliest bookable day
            // (today + minimumDays, blocked in their agenda) isn't a valid pick
            // for THIS port. Treat it as "no date" so the status prompts the user
            // to pick a valid one instead of misleadingly reading "متاح".
            final now = DateTime.now();
            final earliest = DateTime(now.year, now.month, now.day)
                .add(Duration(days: port?.minimumDays ?? 0));
            final date = (!isEditMode &&
                    rawDate != null &&
                    rawDate.isBefore(earliest))
                ? null
                : rawDate;
            // Editing one's own reservation at the same slot → always available.
            final view = _isOwnOriginalSlot(
                    date, state.eventGovernorate, state.eventCity)
                ? const _AvailabilityView('متاح للحجز الفوري',
                    AppColors.green2, AppColors.greenSoft)
                : _statusFor(date, state.availability, state.availabilityStatus);
            final row = Row(
              children: [
                _GlowingDot(color: view.dotColor),
                6.horizontalSpace,
                Expanded(
                  child: Text(
                    view.message,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: view.textColor,
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                8.horizontalSpace,
                GestureDetector(
                  onTap: () => _openEditSheet(context),
                  child: CustomImageHandler(
                    AppImages.iconsEdit,
                    width: 18.r,
                    height: 18.r,
                    color: AppColors.primaryColor,
                  ),
                ),
                // Refresh affordance so a failed check reads as retryable.
                if (view.isRetry) ...[
                  6.horizontalSpace,
                  Icon(Icons.refresh, size: 18.r, color: view.textColor),
                ],
              ],
            );
            if (!view.isRetry) return row;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _retryAvailability(context),
              child: row,
            );
          },
        ),
        10.verticalSpace,
        // ── Date / location / occasion box (outlined, like the design) ──
        // The whole box is tappable, not just the edit icon.
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // Editing the occasion date/location is a logged-in-only action.
            if (!AuthGuard.requireLogin(context)) return;
            _openEditSheet(context);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            decoration: ShapeDecoration(
              // color: AppColors.bg,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: Row(
              children: [
                BlocSelector<HomeCubit, HomeState, DateTime?>(
                  selector: (s) => s.bookingDate,
                  builder: (context, date) {
                    final d = date ?? occasionDate;
                    // A carried-over date earlier than this port's earliest
                    // bookable day (today + minimumDays) isn't valid here, so
                    // show "حدد التاريخ" — consistent with the availability
                    // status line above — instead of a date they can't book.
                    final now = DateTime.now();
                    final earliest = DateTime(now.year, now.month, now.day)
                        .add(Duration(days: port?.minimumDays ?? 0));
                    final valid =
                        d != null && (isEditMode || !d.isBefore(earliest));
                    return Text(
                      valid
                          ? 'في ${DateFormatHelper.arabicDate(d.toIso8601String())}'
                          : 'حدد التاريخ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.descriptionText,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
                6.horizontalSpace,
                Transform.translate(
                  offset: Offset(0, 2.h),
                  child:
                      CustomCircle(radius: 5.r, color: AppColors.dividerGrey),
                ),
                6.horizontalSpace,
                Flexible(
                  child: BlocSelector<HomeCubit, HomeState, String>(
                    selector: (s) => _eventLocationText(
                        context, s.eventGovernorate, s.eventCity),
                    builder: (context, loc) => Text(
                      loc,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.descriptionText,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                // نوع المناسبة chip — falls back to a prompt so the user can
                // see the type is still unset (same as the date/location).
                6.horizontalSpace,
                Transform.translate(
                  offset: Offset(0, 2.h),
                  child: CustomCircle(
                      radius: 5.r, color: AppColors.dividerGrey),
                ),
                6.horizontalSpace,
                Flexible(
                  child: Text(
                    occasionName ?? 'نوع المناسبة',
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.descriptionText,
                      fontSize: 13.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Immutable view-model for the availability status line.
class _AvailabilityView {
  final String message;
  final Color textColor;
  final Color dotColor;

  /// True when the line represents a failed check the user can tap to retry.
  final bool isRetry;
  const _AvailabilityView(
    this.message,
    this.textColor,
    this.dotColor, {
    this.isRetry = false,
  });
}

/// A status dot with a soft halo that breathes in and out (glow), so the
/// "live/instant" availability reads as active.
class _GlowingDot extends StatefulWidget {
  final Color color;
  const _GlowingDot({required this.color});

  @override
  State<_GlowingDot> createState() => _GlowingDotState();
}

class _GlowingDotState extends State<_GlowingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28.r,
      height: 28.r,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value; // 0 → 1 → 0
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer halo grows + fades as it pulses.
                Container(
                  width: (14 + 12 * t).r,
                  height: (14 + 12 * t).r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: 0.45 * (1 - t)),
                  ),
                ),
                Container(
                  width: 12.r,
                  height: 12.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
