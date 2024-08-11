import 'dart:convert';

import 'package:mobile/configs/http_config.dart';
import 'package:mobile/datasource/models/category_model.dart';
import 'package:http/http.dart' as http;

class CategoryRepository {
  Future<List<CategoryModel>> getCategories() async {
    var response = await http.get(Uri.parse(my_api_url("categories")));
    if (response.statusCode != 200) return [];
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> dataArr = jsonData["data"];
    return dataArr.map((e) => CategoryModel.fromJson(e)).toList();
  }
}
