import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/configs/http_config.dart';
import 'package:mobile/datasource/models/weather_model.dart';

class WeatherRepository {
  Future<WeatherModel> getWeatherByLatLon(String lat, String lon) async {
    var response = await http.get(Uri.parse(weather_url(lat, lon)));
    if (response.statusCode != 200) return Future.error("Weather not found");
    var data = jsonDecode(response.body) as Map<String, dynamic>;
    return WeatherModel.fromJson(data);
  }
}
