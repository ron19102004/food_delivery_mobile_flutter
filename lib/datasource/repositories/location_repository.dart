import 'dart:convert';

import 'package:mobile/configs/http_config.dart';
import 'package:mobile/datasource/models/location_map_model.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/datasource/models/location_server_model.dart';

class LocationRepository {
  Future<LocationModel> getLocationByLatLon(double lat, double lon) async {
    var response = await http.get(Uri.parse(address_url(lat, lon)));
    if (response.statusCode != 200) return Future.error("Location not found");
    var data = jsonDecode(response.body) as Map<String, dynamic>;
    return LocationModel.fromJson(data);
  }

  Future<List<LocationServerModel>> getLocationServer() async {
    var response = await http.get(Uri.parse(my_api_url("locations")));
    if (response.statusCode != 200) return Future.error("Error");
    var dataJson = jsonDecode(response.body);
    List<dynamic> dataArr = dataJson["data"];
    return dataArr.map((e) => LocationServerModel.fromJson(e)).toList();
  }
}
