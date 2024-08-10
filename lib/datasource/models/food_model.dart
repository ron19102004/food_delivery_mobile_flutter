import 'package:mobile/datasource/models/category_model.dart';
import 'package:mobile/datasource/models/seller_model.dart';

class FoodModel {
  final int id;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String name;
  final String description;
  final double price;
  final double salePrice;
  final double saleOff;
  final int sold;
  final String poster;
  final bool deleted;
  final SellerModel? sellerModel;
  final CategoryModel? categoryModel;

  FoodModel(
      {required this.id,
      required this.updatedAt,
      required this.createdAt,
      required this.name,
      required this.description,
      required this.price,
      required this.salePrice,
      required this.saleOff,
      required this.sold,
      required this.poster,
      required this.deleted,
      required this.sellerModel,
      required this.categoryModel});

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
        id: json['id'],
        updatedAt: DateTime.parse(json['updatedAt']),
        createdAt: DateTime.parse(json['createdAt']),
        name: json['name'],
        description: json['description'],
        price: json['price'].toDouble(),
        salePrice: json['sale_price'].toDouble(),
        saleOff: json['sale_off'].toDouble(),
        sold: json['sold'],
        poster: json['poster'],
        deleted: json['deleted'],
        sellerModel: json["seller"] != null
            ? SellerModel.fromJson(json["seller"])
            : null,
        categoryModel: json["category"] != null
            ? CategoryModel.fromJson(json["category"])
            : null);
  }
}
