import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tubez/entity/History.dart';
import 'package:tubez/client/UserClient.dart';
import 'package:tubez/client/apiURL.dart';

class HistoryClient {
  // static final String apiUrl = '192.168.1.134/database/public/api/film';

  // untuk hp
  // static final String url = '192.168.1.134';
  // static final String endpoint = '/database/public/api/film';

  static Future<List<History>> fetchHistory() async {
    try {
      UserClient userClient = UserClient();
      String? token = await userClient.getToken();

      var response = await get(Uri.https(url, '$endpoint/history'), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        Iterable list = json.decode(response.body)['history'];

        return list.map((e) => History.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load history');
      }
    } catch (e) {
      print('Error fetching history: $e');
      return [];
    }
  }

  static Future<http.Response> create(History history) async {
    try {
      UserClient userClient = UserClient();
      String? token = await userClient.getToken();
      var response = await post(Uri.https(url, '$endpoint/history/create'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: history.toRawJson());
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
