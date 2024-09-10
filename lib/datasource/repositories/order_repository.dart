import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/configs/http_config.dart';
import 'package:mobile/configs/utils/response_layout.dart';
import 'package:mobile/datasource/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/datasource/services/auth_service.dart';
import 'package:mobile/datasource/services/location_service.dart';

class OrderRepository {
  final db = FirebaseFirestore.instance.collection("orders");

  Stream<OrderRealtime> getDetailOrderRealtime(int orderId) {
    return db
        .doc(LocationService.locationCodeCurrent)
        .collection("handling")
        .doc(orderId.toString())
        .snapshots()
        .map((event) {
      final docs = event.data();
      return OrderRealtime.fromJson(docs!);
    });
  }

  Future<List<OrderModel>> myOrder() async {
    var response =
        await http.get(Uri.parse(my_api_url("foods/orders/my")), headers: {
      "content-type": "application/json",
      "Authorization": "Bearer ${AuthService.token}"
    });
    if (response.statusCode != 200) return [];
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> dataArr = jsonData["data"];
    return dataArr.map((e) => OrderModel.fromJson(e)).toList();
  }
  Future<ResponseLayout<dynamic>> updateDeliver(int orderId)async{
    if (AuthService.isAuthenticated) {
      var response = await http.patch(Uri.parse(my_api_url("foods/orders/update-deliver/$orderId")),
          headers: {
            "content-type": "application/json",
            "Authorization": "Bearer ${AuthService.token}"
          });
      var dataJson = jsonDecode(utf8.decode(response.bodyBytes));
      return ResponseLayout(message: dataJson["message"], status: dataJson["status"]);
    }
    return ResponseLayout(message: "Error", status: false);
  }
  Future<List<OrderModel>> getAllOrderForDeliver() async {
    var response =
    await http.get(Uri.parse(my_api_url("foods/orders/deliver/getAll/${LocationService.locationCurrent.code}")), headers: {
      "content-type": "application/json",
      "Authorization": "Bearer ${AuthService.token}"
    });
    if (response.statusCode != 200) return [];
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> dataArr = jsonData["data"];
    return dataArr.map((e) => OrderModel.fromJson(e)).toList();
  }
  Future<ResponseLayout<OrderModel>> orderFood(
      int foodId,
      double latRe,
      double lonRe,
      int quantity,
      String note,
      String address,
      String voucherCode) async {
    var data = {};
    if (voucherCode.isEmpty) {
      data = {
        "latitude_receive": latRe,
        "longitude_receive": lonRe,
        "quantity": quantity,
        "note": note,
        "address": address,
      };
    } else {
      data = {
        "latitude_receive": latRe,
        "longitude_receive": lonRe,
        "quantity": quantity,
        "note": note,
        "address": address,
        "code_voucher": voucherCode
      };
    }
    var res = await http.post(Uri.parse(my_api_url("foods/orders/new/$foodId")),
        body: jsonEncode(data),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer ${AuthService.token}"
        });
    if (res.statusCode != 200) {
      return ResponseLayout(message: "Error", status: false);
    }
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    if (jsonData["status"] == false) {
      return ResponseLayout(message: jsonData["message"], status: false);
    }
    final order = OrderModel.fromJson(jsonData["data"]);
    //save realtime
    await db
        .doc(LocationService.locationCodeCurrent)
        .collection("handling")
        .doc(order.id.toString())
        .set({
      "lat_deliver": 0.0,
      "lon_deliver": 0.0,
      "lat_rec": LocationService.locationCurrent.latitude,
      "lon_rec": LocationService.locationCurrent.longitude,
      "status_order": order.status
    });
    return ResponseLayout(
        message: jsonData["message"], status: true, data: order);
  }
}

class OrderRealtime {
  double latDeliver;
  double lonDeliver;
  double latRec;
  double lonRec;
  String statusOrder;

  OrderRealtime({
    required this.latDeliver,
    required this.lonDeliver,
    required this.latRec,
    required this.lonRec,
    required this.statusOrder,
  });

  factory OrderRealtime.fromJson(Map<String, dynamic> json) {
    return OrderRealtime(
      latDeliver: json['lat_deliver'],
      lonDeliver: json['lon_deliver'],
      latRec: json['lat_rec'],
      lonRec: json['lon_rec'],
      statusOrder: json['status_order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat_deliver': latDeliver,
      'lon_deliver': lonDeliver,
      'lat_rec': latRec,
      'lon_rec': lonRec,
      'status_order': statusOrder,
    };
  }
}
