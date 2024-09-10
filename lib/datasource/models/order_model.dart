import 'package:meta/meta.dart';
import 'package:mobile/datasource/models/deliver_model.dart';
import 'package:mobile/datasource/models/food_model.dart';
import 'package:mobile/datasource/models/seller_model.dart';
import 'package:mobile/datasource/models/user_model.dart';

class OrderModel {
  final int id;
  final String codeOrder;
  final double latitudeReceive;
  final double longitudeReceive;
  final double latitudeSend;
  final double longitudeSend;
  final int quantity;
  final String? note;
  final String? reasonCancel;
  final String status;
  final double total;
  final double kilometer;
  final String address;
  final SellerModel seller;
  final FoodModel food;
  final DeliverModel? deliver;
  final UserModel? user;
  OrderModel({
    required this.id,
    required this.codeOrder,
    required this.latitudeReceive,
    required this.longitudeReceive,
    required this.latitudeSend,
    required this.longitudeSend,
    required this.quantity,
    required this.note,
    required this.reasonCancel,
    required this.status,
    required this.total,
    required this.kilometer,
    required this.address,
    required this.seller,
    required this.food,
    this.deliver,
    this.user,
  });

  // Factory method to create an OrderModel from a JSON map
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      codeOrder: json['code_order'],
      latitudeReceive: json['latitude_receive'].toDouble(),
      longitudeReceive: json['longitude_receive'].toDouble(),
      latitudeSend: json['latitude_send'].toDouble(),
      longitudeSend: json['longitude_send'].toDouble(),
      quantity: json['quantity'],
      note: json['note'],
      reasonCancel: json['reason_cancel'],
      status: json['status'],
      total: json['total'].toDouble(),
      kilometer: json['kilometer'].toDouble(),
      address: json['address'],
      seller:  SellerModel.fromJson(json["food"]["seller"]),
      food: FoodModel.fromJson(json["food"]),
      deliver: json["deliver"] != null ? DeliverModel.fromJson(json["deliver"]) : null,
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null
    );
  }
}
