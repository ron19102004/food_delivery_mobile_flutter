import 'dart:convert';

import 'package:mobile/configs/http_config.dart';
import 'package:mobile/datasource/models/food_model.dart';
import 'package:http/http.dart' as http;

class FoodRepository {
  Future<List<FoodModel>> getFoodsByLocationCode(String code) async {
    var response =
        await http.get(Uri.parse(my_api_url("foods/products?location_code=$code")));
    if (response.statusCode != 200) return [];
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> dataArr = jsonData["data"];
    return dataArr.map((e) => FoodModel.fromJson(e)).toList();
  }
  Future<List<FoodModel>> getFoodsByCategoryIdAndLocationCode(int id,String code) async {
    var response =
    await http.get(Uri.parse(my_api_url("foods/products?category_id=$id&location_code=$code")));
    if (response.statusCode != 200) return [];
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> dataArr = jsonData["data"];
    return dataArr.map((e) => FoodModel.fromJson(e)).toList();
  }

  Future<FoodModel?> getFoodsById(int id) async {
    var response = await http.get(Uri.parse(my_api_url("foods/details/$id")));
    if (response.statusCode != 200) return null;
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    final food = FoodModel.fromJson(jsonData["data"]["food"]);
    return food;
  }
}
