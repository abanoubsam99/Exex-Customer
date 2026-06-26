class Hall {
  final String? name;
  final String? discription;
  final num? price;
  final num? stars;
  final List<String> images;

  Hall(this.name, this.discription, this.price, this.stars, this.images);

  Hall.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        discription = json['discription'] as String?,
        price = json['price'] as num?,
        stars = json['stars'] as num?,
        images =
            (json['images'] as List?)?.map((e) => e as String).toList() ??
                const [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'discription': discription,
      'price': price,
      'stars': stars,
      'images': images,
    };
  }
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
