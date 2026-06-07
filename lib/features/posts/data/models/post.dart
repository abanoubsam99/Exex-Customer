import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int? userId;
  int? id;
  String? title;
  String? body;
  // @JsonKey(name: 'appoint_price')
  // int? price;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
