/// Formats money amounts for display: whole values lose the trailing ".0",
/// fractional ones keep two decimals (e.g. 6350 → "6350", 6350.5 → "6350.50").
String formatAmount(num value) => value == value.roundToDouble()
    ? value.round().toString()
    : value.toStringAsFixed(2);
