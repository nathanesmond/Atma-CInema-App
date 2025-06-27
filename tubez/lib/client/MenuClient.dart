import 'package:tubez/entity/Menu.dart';

import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubez/client/apiURL.dart';

class MenuClient {
  // static final String url = '10.0.2.2:8000';
  // static final String endpoint = '/api/menu';

  static Future<List<Menu>> fetchAll() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      var response = await get(Uri.https(url, '$endpoint/menu/get'), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode != 200) {
        print(response.statusCode);
        throw Exception(response.reasonPhrase);
      }

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Menu.fromJson(e)).toList();
    } catch (e) {
      return Future.error('Menu Error at ${e.toString()}');
    }
  }

  static Future<List<Menu>> find(String searchText) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      var response = await get(Uri.https(url, '$endpoint/menu/find/$searchText'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });

      if (response.statusCode != 200) {
        throw Exception('Menu not found!');
      }

      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('data')) {
        Iterable list = jsonResponse['data'];
        return list.map((e) => Menu.fromJson(e)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to load films');
    }
  }
}
