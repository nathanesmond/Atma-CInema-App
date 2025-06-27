import 'package:tubez/entity/SpesialPromo.dart';

import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubez/client/apiURL.dart';

class SpesialPromoClient {
  // static final String url = '10.0.2.2:8000';
  // static final String endpoint = '/api/spesialPromo';

  static Future<List<SpesialPromo>> fetchAll() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      var response = await get(Uri.https(url, '$endpoint/spesialPromo/get'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });

      if (response.statusCode != 200) {
        print(response.statusCode);
        var responseBody = json.decode(response.body);
        print(responseBody['data']);
        throw Exception(response.reasonPhrase);
      }

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => SpesialPromo.fromJson(e)).toList();
    } catch (e) {
      return Future.error('SpesialPromo Error at ${e.toString()}');
    }
  }
}
