import 'dart:convert';

import 'package:mobile/configs/http_config.dart';
import 'package:mobile/datasource/models/voucher_model.dart';
import 'package:http/http.dart' as http;

class VoucherRepository {
  Future<List<VoucherModel>> getVoucher(
      String usernameSeller, bool isSystem) async {
    String url = isSystem ? "vouchers/system/all" : "vouchers/$usernameSeller";
    var response = await http.get(Uri.parse(my_api_url(url)));
    if (response.statusCode != 200) return [];
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> dataArr = jsonData["data"];
    return dataArr.map((e) {
      return VoucherModel.fromJson(e);
    }).toList();
  }
}
