// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerReview _$CustomerReviewFromJson(Map<String, dynamic> json) =>
    CustomerReview(
      customerName: json['customerName'] as String,
      date: DateTime.parse(json['date'] as String),
      rating: (json['rating'] as num).toDouble(),
      review: json['review'] as String,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$CustomerReviewToJson(CustomerReview instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'date': instance.date.toIso8601String(),
      'rating': instance.rating,
      'review': instance.review,
      'image': instance.image,
    };
