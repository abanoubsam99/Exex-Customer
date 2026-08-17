import 'package:evex_user/core/helpers/date_format_helper.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/data/models/occasion.dart';
import 'package:evex_user/data/repos/location_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _orange = AppColors.primaryColor;

/// "تعديل تاريخ ومكان المناسبة" — edits the occasion date + type + location (the
/// country is fixed to Egypt). All fields are mandatory. Opened from the pen
/// icon on the booking header (logged-in users only). Calls [onConfirm] with
/// the chosen date + occasion type + governorate/city names.
class EditOccasionSheet extends StatefulWidget {
  final DateTime? initialDate;
  final String? initialGovernorate;
  final String? initialCity;

  /// The port whose booking is being edited. When set, the governorate/city
  /// dropdowns are restricted to the port's working area (the areas it serves),
  /// so the user can only pick a location the vendor actually covers.
  final int? portId;

  /// Minimum lead time (in days) the vendor requires before an event. The date
  /// picker disables every day before today + [minimumDays], so the earliest
  /// selectable date is that many days ahead.
  final int minimumDays;

  /// نوع المناسبة options + the currently chosen one. When empty the occasion
  /// type field is hidden (e.g. the complete-booking screen reuses this sheet
  /// only to edit the date/location).
  final List<Occasion> occasions;
  final int? initialOccasionId;
  final void Function(
    DateTime date,
    String governorate,
    String city,
    int? occasionId,
  ) onConfirm;

  const EditOccasionSheet({
    super.key,
    this.initialDate,
    this.initialGovernorate,
    this.initialCity,
    this.portId,
    this.minimumDays = 0,
    this.occasions = const [],
    this.initialOccasionId,
    required this.onConfirm,
  });

  @override
  State<EditOccasionSheet> createState() => _EditOccasionSheetState();
}

class _EditOccasionSheetState extends State<EditOccasionSheet> {
  late final LocationRepo _repo = context.read<LocationRepo>();

  DateTime? _date;
  int? _selectedOccasionId;
  List<Governate> _governorates = const [];
  List<City> _cities = const [];
  Governate? _selectedGov;
  City? _selectedCity;
  bool _loadingGovs = false;
  bool _loadingCities = false;

  /// The port's working-area names (null when not restricted / fetch failed —
  /// in which case the full lists are shown so a backend hiccup can't lock the
  /// user out of booking entirely).
  List<String>? _portGovNames;
  List<String>? _portCityNames;

  @override
  void initState() {
    super.initState();
    _date = widget.initialDate;
    _selectedOccasionId = widget.initialOccasionId;
    _loadGovernorates();
  }

  /// True when [ar]/[en] appears in [allowed] (case-insensitive). Fails open
  /// (allows everything) when [allowed] is null/empty.
  bool _nameAllowed(List<String>? allowed, String? ar, String? en) {
    if (allowed == null || allowed.isEmpty) return true;
    final set = allowed.map((e) => e.trim().toLowerCase()).toSet();
    return set.contains((ar ?? '').trim().toLowerCase()) ||
        set.contains((en ?? '').trim().toLowerCase());
  }

  Future<void> _loadGovernorates() async {
    setState(() => _loadingGovs = true);
    // Load the full list and the port's working-area governorates together, then
    // keep only the governorates the port serves.
    final results = await Future.wait([
      _repo.getGovernorates(),
      widget.portId != null
          ? _repo.getPortGovernorates(widget.portId!)
          : Future.value(null),
    ]);
    if (!mounted) return;
    final allGovs = (results[0] as List<Governate>?) ?? const [];
    _portGovNames = results[1] as List<String>?;
    final govs = allGovs
        .where((g) => _nameAllowed(
            _portGovNames, g.governorateNameAr, g.governorateNameEn))
        .toList();
    // Pre-select the governorate that matches the passed-in name — only if it's
    // still within the port's working area.
    Governate? selected;
    for (final g in govs) {
      if (g.governorateNameAr == widget.initialGovernorate ||
          g.governorateNameEn == widget.initialGovernorate) {
        selected = g;
        break;
      }
    }
    setState(() {
      _governorates = govs;
      _loadingGovs = false;
      _selectedGov = selected;
    });
    if (selected != null) {
      _loadCities(selected.id!, prefillCityName: widget.initialCity);
    }
  }

  Future<void> _loadCities(int govId, {String? prefillCityName}) async {
    setState(() {
      _loadingCities = true;
      _cities = const [];
      _selectedCity = null;
    });
    // Fetch the port's served cities once and cache them for the session.
    if (widget.portId != null && _portCityNames == null) {
      _portCityNames = await _repo.getPortCities(widget.portId!);
    }
    final allCities = await _repo.getCities(govId) ?? const [];
    if (!mounted) return;
    // Keep only the cities the port serves within the chosen governorate.
    final cities = allCities
        .where((c) => _nameAllowed(_portCityNames, c.cityNameAr, c.cityNameEn))
        .toList();
    City? selected;
    if (prefillCityName != null) {
      for (final c in cities) {
        if (c.cityNameAr == prefillCityName ||
            c.cityNameEn == prefillCityName) {
          selected = c;
          break;
        }
      }
    }
    setState(() {
      _cities = cities;
      _loadingCities = false;
      _selectedCity = selected;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    // The vendor requires bookings at least `minimumDays` ahead, so the earliest
    // selectable day is today + minimumDays (every earlier day is disabled).
    final earliest = DateTime(now.year, now.month, now.day)
        .add(Duration(days: widget.minimumDays));
    final initial =
        (_date != null && !_date!.isBefore(earliest)) ? _date! : earliest;
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('ar'),
      initialDate: initial,
      firstDate: earliest,
      lastDate: earliest.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _confirm() {
    if (_date == null) {
      ToastManager.showError('برجاء تحديد تاريخ المناسبة');
      return;
    }
    // Event type (نوع المناسبة) is optional — the user can confirm without it.
    if (_selectedGov == null) {
      ToastManager.showError('برجاء اختيار المحافظة');
      return;
    }
    if (_selectedCity == null) {
      ToastManager.showError('برجاء اختيار المدينة');
      return;
    }
    widget.onConfirm(
      _date!,
      _selectedGov!.governorateNameAr ?? '',
      _selectedCity!.cityNameAr ?? '',
      _selectedOccasionId,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.fromLTRB(21.w, 9.h, 21.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Text(
                  'تعديل تاريخ ومكان المناسبة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 16.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 24.r, color: AppColors.blacksoft),
                ),
              ],
            ),
            24.verticalSpace,
            // ── Occasion date ──
            _label('تاريخ المناسبة'),
            8.verticalSpace,
            GestureDetector(
              onTap: _pickDate,
              child: _fieldBox(
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, color: _orange, size: 18.r),
                    8.horizontalSpace,
                    Text(
                      _date != null
                          ? DateFormatHelper.numericDateOf(_date)
                          : 'حدد تاريخ المناسبة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: _date != null
                            ? AppColors.blacksoft
                            : AppColors.blueGrey,
                        fontSize: 14.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.blueGrey, size: 22.r),

                  ],
                ),
              ),
            ),
            20.verticalSpace,
            // ── Occasion type (نوع المناسبة) ──
            if (widget.occasions.isNotEmpty) ...[
              _label('نوع المناسبة'),
              8.verticalSpace,
              _dropdown<int>(
                hint: 'حدد نوع المناسبة',
                value: _selectedOccasionId,
                items: widget.occasions
                    .where((o) => o.id != null)
                    .map((o) => DropdownMenuItem<int>(
                          value: o.id,
                          child: Text(
                            o.name ?? '',
                            style: TextStyle(
                              color: AppColors.blacksoft,
                              fontSize: 14.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedOccasionId = v),
              ),
              20.verticalSpace,
            ],
            // ── Location ──
            _label('مكان المناسبة'),
            8.verticalSpace,
            // Country is fixed to Egypt.
            _fieldBox(
              child: Row(
                children: [
                  Container(
                    width: 30.r,
                    height: 30.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/flags/eg.png',
                          package: 'flutter_intl_phone_field',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    'مصر',
                    style: TextStyle(
                      color: AppColors.blacksoft,
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.blueGrey, size: 22.r),

                ],
              ),
            ),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _dropdown<Governate>(
                    hint: _loadingGovs ? 'جاري التحميل...' : 'المحافظة',
                    value: _selectedGov,
                    items: _governorates
                        .map((g) => DropdownMenuItem(
                            value: g, child: Text(g.governorateNameAr ?? '')))
                        .toList(),
                    onChanged: (g) {
                      if (g != null) {
                        setState(() => _selectedGov = g);
                        _loadCities(g.id!);
                      }
                    },
                  ),
                ),
                11.horizontalSpace,
                Expanded(
                  child: _dropdown<City>(
                    hint: _loadingCities ? 'جاري التحميل...' : 'المدينة',
                    value: _selectedCity,
                    items: _cities
                        .map((c) => DropdownMenuItem(
                            value: c, child: Text(c.cityNameAr ?? '')))
                        .toList(),
                    onChanged: _selectedGov == null
                        ? null
                        : (c) => setState(() => _selectedCity = c),
                  ),
                ),
              ],
            ),
            28.verticalSpace,
            Row(
              children: [
                Expanded(child: CustomButton(text: 'تأكيد', onTap: _confirm)),
                14.horizontalSpace,
                Expanded(
                  child: CustomButton(
                    isfilled: false,
                    text: 'الغاء',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: AppColors.blacksoft,
          fontSize: 14.r,
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w700,
        ),
      );

  Widget _fieldBox({required Widget child}) => Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: AppColors.boarderFillColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: child,
      );

  Widget _dropdown<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
  }) =>
      _fieldBox(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isExpanded: true,
            value: value,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            hint: Text(
              hint,
              style: TextStyle(
                color: AppColors.blueGrey,
                fontSize: 14.r,
                fontFamily: 'Almarai',
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.blueGrey),
            items: items,
            onChanged: onChanged,
          ),
        ),
      );
}
