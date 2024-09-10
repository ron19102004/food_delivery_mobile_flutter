import 'dart:convert';

import 'package:mobile/configs/http_config.dart';
import 'package:mobile/configs/utils/response_layout.dart';
import 'package:mobile/datasource/models/seller_model.dart';
import 'package:mobile/datasource/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static bool isAuthenticated = false;
  static UserModel? userCurrent;
  static String token = "";
  static bool isRole(UserRole role){
    if(AuthService.userCurrent == null) {
      return false;
    }
    return role.role == AuthService.userCurrent!.role;
  }
  static Future<ResponseLayout<dynamic>> updateLatLonForSeller(double lat, double lon)async{
    if (AuthService.isAuthenticated) {
      var response = await http.patch(Uri.parse(my_api_url("sellers/updateLatLon/${lat}/${lon}")),
          headers: {
            "content-type": "application/json",
            "Authorization": "Bearer ${AuthService.token}"
          });
      var dataJson = jsonDecode(utf8.decode(response.bodyBytes));
      return ResponseLayout(message: dataJson["message"], status: dataJson["status"]);
    }
    return ResponseLayout(message: "Error", status: false);
  }
  static Future<ResponseLayout<dynamic>> changeTFA()async{
    if (AuthService.isAuthenticated) {
      var response = await http.post(Uri.parse(my_api_url("auth/change-tfa")),
          headers: {
            "content-type": "application/json",
            "Authorization": "Bearer ${AuthService.token}"
          });
      var dataJson = jsonDecode(utf8.decode(response.bodyBytes));
      return ResponseLayout(message: dataJson["message"], status: dataJson["status"]);
    }
    return ResponseLayout(message: "Error", status: false);
  }
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
        AuthService.token = token;
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
    AuthService.token = "";
    nav();
  }
  static Future<void> verifyOTP(String _token,String code, Function() success,Function(String err) fail)async{
    try {
      var response = await http.post(Uri.parse(my_api_url("auth/verify-otp")),
          body: jsonEncode({"token": _token, "code": code}),
          headers: {"content-type": "application/json"});
      var dataJson = jsonDecode(utf8.decode(response.bodyBytes));
      if (dataJson["status"] == false) {
        fail(dataJson["message"]);
        return;
      }
      String token = dataJson["data"]["access_token"];
      final user = UserModel.fromJson(dataJson["data"]["user"]);
      AuthService.userCurrent = user;
      AuthService.isAuthenticated = true;
      AuthService.token = token;
      await _setAuthSharedPreferences(user, token);
      success();
    } catch (e) {
      fail("Check your password!");
    }
  }
  static Future<void> login(
      String username,
      String password,
      Function() success,
      Function(String token,String email) successWithTFA,
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
        successWithTFA(token,dataJson["data"]["user"]["email"]);
        return;
      }
      final user = UserModel.fromJson(dataJson["data"]["user"]);
      AuthService.userCurrent = user;
      AuthService.isAuthenticated = true;
      AuthService.token = token;
      await _setAuthSharedPreferences(user, token);
      success();
    } catch (e) {
      fail("Check your password!");
    }
  }
}
