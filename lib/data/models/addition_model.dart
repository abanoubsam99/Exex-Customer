class AdditionModel {
  String? additionKey;
  bool? displayNumber;
  int? id;
  String? name;
  int? price;
  bool? specificToBuffet;
  int? portId;
  int? giftId;
  int? count;

  AdditionModel({
    this.additionKey,
    this.displayNumber,
    this.id,
    this.name,
    this.price,
    this.specificToBuffet,
    this.giftId,
    this.portId,
    this.count,
  });

  AdditionModel.fromJson(Map<String, dynamic> json) {
    additionKey = json['additionKey'];
    displayNumber = json['displayNumber'];
    id = (json['id'] as num?)?.toInt();
    name = json['name'];
    price = (json['price'] as num?)?.toInt();
    specificToBuffet = json['specificToBuffet'];
    portId = (json['portId'] as num?)?.toInt();
    giftId = (json['giftId'] as num?)?.toInt();
    count = (json['count'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['additionKey'] = additionKey;
    data['displayNumber'] = displayNumber;
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['specificToBuffet'] = specificToBuffet;
    data['portId'] = portId;
    data['giftId'] = giftId;
    data['count'] = count;
    return data;
  }
}
