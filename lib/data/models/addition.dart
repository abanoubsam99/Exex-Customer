class Addition {
  String? name;
  int? id;
  int? number;
  int? additionId;

  Addition({this.name, this.id, this.number, this.additionId});

  Addition.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    number = json['number'] as int?;
    additionId = json['additionId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['number'] = number;
    data['additionId'] = additionId;
    return data;
  }
}
