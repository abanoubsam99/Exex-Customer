/// Item of GET /api/Occasions — an occasion type (نوع المناسبة).
class Occasion {
  final int? id;
  final String? name;

  Occasion({this.id, this.name});

  Occasion.fromJson(Map<String, dynamic> json)
      : id = (json['id'] as num?)?.toInt(),
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
