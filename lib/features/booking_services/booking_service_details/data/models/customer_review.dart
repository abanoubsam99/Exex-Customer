import 'package:json_annotation/json_annotation.dart';

part 'customer_review.g.dart';

@JsonSerializable()
class CustomerReview {
  String customerName;
  DateTime date;
  double rating;
  String review;
  String? image;

  CustomerReview({
    required this.customerName,
    required this.date,
    required this.rating,
    required this.review,
    this.image,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) =>
      _$CustomerReviewFromJson(json);
}

List<CustomerReview> customerReviews = [
  CustomerReview(customerName: "مينا نبيل", date: DateTime.parse('2026-10-12'), rating: 5.0, review: 'القاعه كانت حلوه جدا وكنت مبسوط وانا هناك والدى جى كان حلو ورايق بس كان زحمه اوى بس فى الاخر جابولنا كراسي وترابيزات ف كان الجو لذيذ اوى '),
  CustomerReview(customerName: "evex user", date: DateTime.parse('2026-10-12'), rating: 5.0, review: 'القاعه كانت حلوه جدا وكنت مبسوط وانا هناك والدى جى كان حلو ورايق بس كان زحمه اوى بس فى الاخر جابولنا كراسي وترابيزات ف كان الجو لذيذ اوى '),
];