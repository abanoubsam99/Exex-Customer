/// A single customer review.
/// Item of GET /api/Reviews/{portId}.
class Review {
  final int? id;
  final int? reservationId;
  final int? clientId;
  final int? portId;
  final int? stars;
  final String? comment;
  final DateTime? createdAt;
  final String? clientName;
  final String? imagePath;

  Review({
    this.id,
    this.reservationId,
    this.clientId,
    this.portId,
    this.stars,
    this.comment,
    this.createdAt,
    this.clientName,
    this.imagePath,
  });

  Review.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        reservationId = (json['reservationId'] as num?)?.toInt(),
        clientId = (json['clientId'] as num?)?.toInt(),
        portId = (json['portId'] as num?)?.toInt(),
        stars = (json['stars'] as num?)?.toInt(),
        comment = json['comment'] as String?,
        createdAt = json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
        clientName = json['clientName'] as String?,
        imagePath = json['imagePath'] as String?;
}
