import 'dart:convert';

import 'package:mobile/configs/constant.dart';
import 'package:mobile/datasource/models/location_model.dart';
import 'package:http/http.dart' as http;

class LocationRepository {
  Future<LocationModel> getLocationByLatLon(double lat, double lon) async {
    var response = await http.get(Uri.parse(address_url(lat, lon)));
    if (response.statusCode != 200) return Future.error("Location not found");
    var data = jsonDecode(response.body) as Map<String, dynamic>;
    return LocationModel.fromJson(data);
  }
}
