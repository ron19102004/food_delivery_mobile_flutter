import 'dart:convert';

import 'package:mobile/configs/http_config.dart';
import 'package:mobile/datasource/models/seller_model.dart';
import 'package:mobile/datasource/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static bool isAuthenticated = false;
  static UserModel? userCurrent;

  static Future<SellerModel?> getSellerById(int id)async{
    var response = await http.get(Uri.parse(my_api_url("sellers/details/$id")));
    if(response.statusCode != 200) return null;
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if(jsonData["status"]==false) return null;
    return SellerModel.fromJson(jsonData["data"]);
  }
  static Future<void> _setAuthSharedPreferences(
      UserModel userCurrent, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setBool("isAuth", true);
  }

  static Future<void> checkAuthentication() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthService.isAuthenticated = prefs.getBool("isAuth") ?? false;
    if (AuthService.isAuthenticated) {
      try {
        String token = prefs.getString("token") ?? "";
        var response = await http.get(Uri.parse(my_api_url("auth/me")),
            headers: {
              "content-type": "application/json",
              "Authorization": "Bearer $token"
            });
        var dataJson = jsonDecode(utf8.decode(response.bodyBytes));
        if (dataJson["status"] == false) {
          logout(()=>{});
          return;
        }
        final user = UserModel.fromJson(dataJson["data"]);
        AuthService.userCurrent = user;
        AuthService.isAuthenticated = true;
        await _setAuthSharedPreferences(user, token);
      } catch (e) {
        AuthService.isAuthenticated = false;
        logout(()=>{});
      }
    }
  }

  static Future<void> register(
      String firstName,
      String lastName,
      String username,
      String email,
      String phone,
      String password,
      Function() success,
      Function(String err) fail) async {
    try {
      var response = await http.post(Uri.parse(my_api_url("auth/register")),
          body: jsonEncode({
            "first_name": firstName,
            "last_name": lastName,
            "username": username,
            "email": email,
            "phone_number": phone,
            "password": password
          }),
          headers: {"content-type": "application/json"});
      var dataJson = jsonDecode(utf8.decode(response.bodyBytes));
      if (dataJson["status"] == false) {
        fail(dataJson["message"]);
        return;
      }
      success();
    } catch (e) {
      fail("Undefined error");
    }
  }

  static Future<void> logout(Function() nav) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isAuth", false);
    await prefs.remove("token");
    AuthService.isAuthenticated = false;
    AuthService.userCurrent = null;
    nav();
  }

  static Future<void> login(
      String username,
      String password,
      Function() success,
      Function(String token) successWithTFA,
      Function(String err) fail) async {
    try {
      var response = await http.post(Uri.parse(my_api_url("auth/login")),
          body: jsonEncode({"username": username, "password": password}),
          headers: {"content-type": "application/json"});
      var dataJson = jsonDecode(utf8.decode(response.bodyBytes));
      if (dataJson["status"] == false) {
        fail(dataJson["message"]);
        return;
      }
      bool tfa = dataJson["data"]["two_factor_auth"];
      String token = dataJson["data"]["access_token"];
      if (tfa == true) {
        successWithTFA(token);
        return;
      }
      final user = UserModel.fromJson(dataJson["data"]["user"]);
      AuthService.userCurrent = user;
      AuthService.isAuthenticated = true;
      await _setAuthSharedPreferences(user, token);
      success();
    } catch (e) {
      fail("Check your password!");
    }
  }
}
