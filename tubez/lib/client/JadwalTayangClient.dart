import 'package:tubez/entity/JadwalTayang.dart';

import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubez/client/apiURL.dart';

class JadwalTayangClient {
  // sesuaikan url dan endpoint dengan device yang digunakan

  //untuk emulator
  // static final String url = '10.0.2.2:8000';
  // static final String endpoint = '/api/jadwaltayang';

  // // untuk hp
  // static final String url = '192.168.1.134';
  // static final String endpoint = '/database/public/api/film';

  // untuk hp
  // static final String url = 'ipv4 kalian';
  // static final String endpoint = '/GD_API_1697/public/api/user';

  // mengambil semua data user dari API
  static Future<List<Jadwaltayang>> fetchByIdFilm(int idFilm) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      var response = await get(
          Uri.https(url, '$endpoint/jadwaltayang/get/$idFilm'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });

      if (response.statusCode != 200) {
        print(response.statusCode);
        throw Exception(response.reasonPhrase);
      }

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Jadwaltayang.fromJson(e)).toList();
    } catch (e) {
      return Future.error('anjay ${e.toString()}');
    }
  }

  static Future<List<Jadwaltayang>> find(String searchText) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      var response = await get(
          Uri.https(url, '$endpoint/jadwaltayang/find/$searchText'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });

      if (response.statusCode != 200) {
        throw Exception('Failed to load films');
      }

      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('data')) {
        Iterable list = jsonResponse['data'];
        return list.map((e) => Jadwaltayang.fromJson(e)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to load films');
    }
  }
}
