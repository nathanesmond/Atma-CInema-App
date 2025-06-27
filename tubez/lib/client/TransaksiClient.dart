import 'dart:convert';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubez/entity/transaksi.dart';
import 'package:tubez/client/apiURL.dart';

class TransaksiClient {
  // static const String baseUrl =
  //     'http://10.0.2.2:8000/api'; // Your Laravel backend base URL

  static Future<http.Response> createTransaksi(Transaksi transaksi) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token'); // Retrieve the token

      if (token == null) {
        throw Exception('No auth token found');
      }

      // Convert Transaksi object to JSON
      final bodyData = jsonEncode(transaksi.toJson());

      // Send POST request with headers and body
      var response = await post(
        Uri.https(
            url, '$endpoint/transaksi/create'), // Your Transaksi API endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: bodyData,
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to create transaksi: ${response.body}');
      }
      return response;
    } catch (e) {
      print('Error creating transaksi: $e');
      throw e; // Re-throw the error so the calling function can handle it
    }
  }
}
