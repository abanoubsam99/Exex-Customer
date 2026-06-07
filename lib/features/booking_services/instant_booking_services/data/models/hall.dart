import 'package:json_annotation/json_annotation.dart';

part 'hall.g.dart';

@JsonSerializable()
class Hall {
  final String name;
  final String discription;
  final num price;
  final num stars;
  final List<String> images;

  Hall(this.name, this.discription, this.price, this.stars, this.images);

  factory Hall.fromJson(Map<String, dynamic> json) => _$HallFromJson(json);
}

List<Hall> halls = [
  Hall(
    'قاعه الؤلؤه',
    'قاعه الؤلؤه تمتاز بالمساحه الواسعه وقد تسع الى +500 فرد وخدمه المتواصله . . .',
    1100,
    4.6,
    ['assets/images/wedding0.jpg', 'assets/images/wedding1.jpg'],
  ),
  Hall(
    'قاعه الؤلؤه',
    'قاعه الؤلؤه تمتاز بالمساحه الواسعه وقد تسع الى +500 فرد وخدمه المتواصله . . .',
    1100,
    4.6,
    ['assets/images/wedding1.jpg', 'assets/images/wedding1.jpg'],
  ),
  Hall(
    'قاعه الؤلؤه',
    'قاعه الؤلؤه تمتاز بالمساحه الواسعه وقد تسع الى +500 فرد وخدمه المتواصله . . .',
    1100,
    4.6,
    ['assets/images/wedding2.jpg', 'assets/images/wedding1.jpg'],
  ),
  Hall(
    'قاعه الؤلؤه',
    'قاعه الؤلؤه تمتاز بالمساحه الواسعه وقد تسع الى +500 فرد وخدمه المتواصله . . .',
    1100,
    4.6,
    ['assets/images/wedding3.jpg', 'assets/images/wedding1.jpg'],
  ),
  Hall(
    'قاعه الؤلؤه',
    'قاعه الؤلؤه تمتاز بالمساحه الواسعه وقد تسع الى +500 فرد وخدمه المتواصله . . .',
    1100,
    4.6,
    ['assets/images/wedding4.jpg', 'assets/images/wedding1.jpg'],
  ),
  Hall(
    'قاعه الؤلؤه',
    'قاعه الؤلؤه تمتاز بالمساحه الواسعه وقد تسع الى +500 فرد وخدمه المتواصله . . .',
    1100,
    4.6,
    ['assets/images/wedding5.jpg', 'assets/images/wedding1.jpg'],
  ),
  Hall(
    'قاعه الؤلؤه',
    'قاعه الؤلؤه تمتاز بالمساحه الواسعه وقد تسع الى +500 فرد وخدمه المتواصله . . .',
    1100,
    4.6,
    ['assets/images/wedding0.jpg', 'assets/images/wedding1.jpg'],
  ),
];
