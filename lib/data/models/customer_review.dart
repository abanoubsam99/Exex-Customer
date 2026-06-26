class CustomerReview {
  String? customerName;
  DateTime? date;
  double? rating;
  String? review;
  String? image;

  CustomerReview({
    this.customerName,
    this.date,
    this.rating,
    this.review,
    this.image,
  });

  CustomerReview.fromJson(Map<String, dynamic> json)
      : customerName = json['customerName'] as String?,
        date = json['date'] != null
            ? DateTime.tryParse(json['date'] as String)
            : null,
        rating = (json['rating'] as num?)?.toDouble(),
        review = json['review'] as String?,
        image = json['image'] as String?;

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'date': date?.toIso8601String(),
      'rating': rating,
      'review': review,
      'image': image,
    };
  }
}

List<CustomerReview> customerReviews = [
  CustomerReview(
      customerName: "مينا نبيل",
      date: DateTime.parse('2026-10-12'),
      rating: 5.0,
      review:
          'القاعه كانت حلوه جدا وكنت مبسوط وانا هناك والدى جى كان حلو ورايق بس كان زحمه اوى بس فى الاخر جابولنا كراسي وترابيزات ف كان الجو لذيذ اوى '),
  CustomerReview(
      customerName: "evex user",
      date: DateTime.parse('2026-10-12'),
      rating: 5.0,
      review:
          'القاعه كانت حلوه جدا وكنت مبسوط وانا هناك والدى جى كان حلو ورايق بس كان زحمه اوى بس فى الاخر جابولنا كراسي وترابيزات ف كان الجو لذيذ اوى '),
];
