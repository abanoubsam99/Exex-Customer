class Addition {
  String? name;
  int? id;
  int? number;
  int? additionId;

  Addition({this.name, this.id, this.number, this.additionId});

  factory Addition.fromJson(Map<String, dynamic> json) => Addition(
        id: json['id'] as int?,
        number: json['number'] as int?,
        additionId: json['additionId'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'number': number,
        'additionId': additionId,
      };
}
