import 'package:evex_user/core/helpers/date_format_helper.dart';

class PortService {
  int id;
  String? name;
  String? serviceKey;
  String? details;
  int? priceAfterDiscount;
  List<String>? serviceImages;
  int? price;
  int? priceBeforDiscount;

  /// Discount percentage straight from the backend — the badge uses this rather
  /// than recomputing it from the before/after prices.
  int? discountPercentage;
  String? picturesAlbumName;
  int? portId;

  /// When true the price is hidden across the UI (the vendor doesn't want to
  /// publish a fixed price for this service).
  bool displayPrice;

  /// When true the service has time-boxed special prices: during [startPeriod1]
  /// →[endPeriod1] the price is [priceAfterDiscountInPeriod1], and during
  /// [startPeriod2] →[endPeriod2] it's [priceAfterDiscountInPeriod2]. The dates
  /// come as ISO strings (the .NET default 0001-01-01 marks an unused period).
  bool hasSpecialPrices;
  String? startPeriod1;
  String? endPeriod1;
  String? startPeriod2;
  String? endPeriod2;

  /// Raw period prices (before the service discount) — kept only as a fallback
  /// for backends that don't send the after/before-discount period prices.
  int? priceInPeriod1;
  int? priceInPeriod2;

  /// The prices actually shown for a booking inside each period: the discounted
  /// one, plus the original that gets struck through. 0 marks an unused period.
  int? priceAfterDiscountInPeriod1;
  int? priceAfterDiscountInPeriod2;
  int? priceBeforDiscountInPeriod1;
  int? priceBeforDiscountInPeriod2;

  /// Discount percentage for each period. An unused period comes back as
  /// int.MinValue (-2147483648), which is filtered out like the 0 prices.
  int? discountPercentageInPeriod1;
  int? discountPercentageInPeriod2;

  PortService({
    required this.id,
    this.name,
    this.serviceKey,
    this.details,
    this.priceAfterDiscount,
    this.priceBeforDiscount,
    this.discountPercentage,
    this.picturesAlbumName,
    this.serviceImages,
    this.portId,
    this.price,
    this.displayPrice = false,
    this.hasSpecialPrices = false,
    this.startPeriod1,
    this.endPeriod1,
    this.startPeriod2,
    this.endPeriod2,
    this.priceInPeriod1,
    this.priceInPeriod2,
    this.priceAfterDiscountInPeriod1,
    this.priceAfterDiscountInPeriod2,
    this.priceBeforDiscountInPeriod1,
    this.priceBeforDiscountInPeriod2,
    this.discountPercentageInPeriod1,
    this.discountPercentageInPeriod2,
  });

  PortService.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num).toInt(),
        name = json['name'],
        serviceKey = json['serviceKey'],
        details = json['details'],
        priceAfterDiscount = (json['priceAfterDiscount'] as num?)?.toInt(),
        serviceImages =
            (json['serviceImages'] as List?)?.map((e) => e as String).toList(),
        price = (json['price'] as num?)?.toInt(),
        priceBeforDiscount = (json['priceBeforDiscount'] as num?)?.toInt(),
        discountPercentage = (json['discountPercentage'] as num?)?.toInt(),
        picturesAlbumName = json['picturesAlbumName'],
        portId = (json['portId'] as num?)?.toInt(),
        displayPrice = json['displayPrice'] as bool? ?? false,
        hasSpecialPrices = json['hasSpecialPrices'] as bool? ?? false,
        startPeriod1 = json['startPeriod1'] as String?,
        endPeriod1 = json['endPeriod1'] as String?,
        startPeriod2 = json['startPeriod2'] as String?,
        endPeriod2 = json['endPeriod2'] as String?,
        priceInPeriod1 = (json['priceInPeriod1'] as num?)?.toInt(),
        priceInPeriod2 = (json['priceInPeriod2'] as num?)?.toInt(),
        priceAfterDiscountInPeriod1 =
            (json['priceAfterDiscountInPeriod1'] as num?)?.toInt(),
        priceAfterDiscountInPeriod2 =
            (json['priceAfterDiscountInPeriod2'] as num?)?.toInt(),
        priceBeforDiscountInPeriod1 =
            (json['priceBeforDiscountInPeriod1'] as num?)?.toInt(),
        priceBeforDiscountInPeriod2 =
            (json['priceBeforDiscountInPeriod2'] as num?)?.toInt(),
        discountPercentageInPeriod1 =
            (json['discountPercentageInPeriod1'] as num?)?.toInt(),
        discountPercentageInPeriod2 =
            (json['discountPercentageInPeriod2'] as num?)?.toInt();

  /// The normal price the service costs outside any special-price period (after
  /// its regular discount, falling back to the raw price).
  int get normalPrice => priceAfterDiscount ?? price ?? 0;

  /// True when [date] (date-only) falls within [start]..[end] inclusive. False
  /// when either bound is the .NET default / unparseable.
  static bool _within(DateTime date, String? start, String? end) {
    final s = DateFormatHelper.parse(start);
    final e = DateFormatHelper.parse(end);
    if (s == null || e == null) return false;
    final d = DateTime(date.year, date.month, date.day);
    final from = DateTime(s.year, s.month, s.day);
    final to = DateTime(e.year, e.month, e.day);
    return !d.isBefore(from) && !d.isAfter(to);
  }

  /// Which special-price period a booking on [date] falls in: 1, 2, or 0 (none —
  /// either no special prices, no date picked yet, or the date is outside both
  /// periods, so the normal price applies).
  int periodFor(DateTime? date) {
    if (!hasSpecialPrices || date == null) return 0;
    if (_within(date, startPeriod1, endPeriod1)) return 1;
    if (_within(date, startPeriod2, endPeriod2)) return 2;
    return 0;
  }

  /// A price the backend actually filled in — it sends 0 for the fields of an
  /// unused period, which must not be shown as a real price.
  static int? _positive(int? value) =>
      (value != null && value > 0) ? value : null;

  /// The price that actually applies for a booking on [date]: the matching
  /// period's discounted price, or [normalPrice] when the date is outside every
  /// period. Falls back to the raw period price for older backend responses.
  int effectivePrice(DateTime? date) {
    switch (periodFor(date)) {
      case 1:
        return _positive(priceAfterDiscountInPeriod1) ??
            _positive(priceInPeriod1) ??
            normalPrice;
      case 2:
        return _positive(priceAfterDiscountInPeriod2) ??
            _positive(priceInPeriod2) ??
            normalPrice;
      default:
        return normalPrice;
    }
  }

  /// The original (pre-discount) price to strike through next to
  /// [effectivePrice]: the matching period's one, or the regular
  /// [priceBeforDiscount] outside every period.
  int? effectivePriceBeforeDiscount(DateTime? date) {
    switch (periodFor(date)) {
      case 1:
        return _positive(priceBeforDiscountInPeriod1) ?? priceBeforDiscount;
      case 2:
        return _positive(priceBeforDiscountInPeriod2) ?? priceBeforDiscount;
      default:
        return priceBeforDiscount;
    }
  }

  /// The discount percentage shown on the badge for a booking on [date]: the
  /// matching period's one, or the regular [discountPercentage]. Null when the
  /// backend didn't send a real percentage — the card then derives it from the
  /// before/after prices.
  int? effectiveDiscountPercentage(DateTime? date) {
    switch (periodFor(date)) {
      case 1:
        return _positive(discountPercentageInPeriod1) ??
            _positive(discountPercentage);
      case 2:
        return _positive(discountPercentageInPeriod2) ??
            _positive(discountPercentage);
      default:
        return _positive(discountPercentage);
    }
  }

  /// "20/6/2026 - 20/7/2026" for the special-price period a booking on [date]
  /// falls in, or an empty string when the normal price applies (so the caller
  /// hides the date row).
  String effectiveRangeLabel(DateTime? date) {
    switch (periodFor(date)) {
      case 1:
        return DateFormatHelper.numericRange(startPeriod1, endPeriod1);
      case 2:
        return DateFormatHelper.numericRange(startPeriod2, endPeriod2);
      default:
        return '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['serviceKey'] = serviceKey;
    data['details'] = details;
    data['priceAfterDiscount'] = priceAfterDiscount;
    data['serviceImages'] = serviceImages;
    data['price'] = price;
    data['priceBeforDiscount'] = priceBeforDiscount;
    data['discountPercentage'] = discountPercentage;
    data['picturesAlbumName'] = picturesAlbumName;
    data['portId'] = portId;
    data['displayPrice'] = displayPrice;
    data['hasSpecialPrices'] = hasSpecialPrices;
    data['startPeriod1'] = startPeriod1;
    data['endPeriod1'] = endPeriod1;
    data['startPeriod2'] = startPeriod2;
    data['endPeriod2'] = endPeriod2;
    data['priceInPeriod1'] = priceInPeriod1;
    data['priceInPeriod2'] = priceInPeriod2;
    data['priceAfterDiscountInPeriod1'] = priceAfterDiscountInPeriod1;
    data['priceAfterDiscountInPeriod2'] = priceAfterDiscountInPeriod2;
    data['priceBeforDiscountInPeriod1'] = priceBeforDiscountInPeriod1;
    data['priceBeforDiscountInPeriod2'] = priceBeforDiscountInPeriod2;
    data['discountPercentageInPeriod1'] = discountPercentageInPeriod1;
    data['discountPercentageInPeriod2'] = discountPercentageInPeriod2;
    return data;
  }
}
