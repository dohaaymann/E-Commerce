import 'package:hive/hive.dart';

// part 'hive_adapter.g.dart';

@HiveType(typeId: 0)
class Dataa extends HiveObject {
  @HiveField(0)
  final int idp;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final String detailsImage;

  @HiveField(5)
  final int trend;

  Dataa({
    required this.idp,
    required this.name,
    required this.price,
    required this.image,
    required this.detailsImage,
    required this.trend,
  });

  factory Dataa.fromJson(Map<String, dynamic> json) {
    return Dataa(
      idp: json['idp'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      detailsImage: json['details_image'],
      trend: json['trend'],
    );
  }
}
