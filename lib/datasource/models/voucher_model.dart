import 'package:mobile/datasource/models/category_model.dart';

class VoucherModel {
  final int id;
  final double percent;
  final String code;
  final String name;
  final int quantity;
  final int quantityCurrent;
  final String issuedAt;
  final String expiredAt;
  final bool ofSystem;
  final CategoryModel categoryModel;

  VoucherModel(
      {required this.id,
      required this.percent,
      required this.code,
      required this.name,
      required this.quantity,
      required this.quantityCurrent,
      required this.issuedAt,
      required this.expiredAt,
      required this.ofSystem,
      required this.categoryModel});

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
        id: json['id'],
        percent: json['percent'],
        code: json['code'],
        name: json['name'],
        quantity: json['quantity'],
        quantityCurrent: json['quantity_current'],
        issuedAt: json['issued_at'],
        expiredAt: json['expired_at'],
        ofSystem: json['of_system'],
        categoryModel: CategoryModel.fromJson(json['category']));
  }
}
