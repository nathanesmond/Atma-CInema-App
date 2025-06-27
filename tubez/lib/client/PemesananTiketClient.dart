import 'dart:developer';

import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubez/entity/pemesanan_tiket.dart';
import 'package:tubez/client/apiURL.dart';

class PemesananTiketClient {
  // sesuaikan url dan endpoint dengan device yang digunakan

  //untuk emulator
  // static final String url = '10.0.2.2:8000';
  // static final String endpoint = '/api';

  static Future<List<PemesananTiket>> getAllKursi(int idJadwalTayang) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      var response = await get(
        Uri.https(url,
            '$endpoint/kursi/all/$idJadwalTayang'), // Passing idJadwalTayang
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      log("Response Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      // Decode the response body
      final List<String> kursiDipesanStrings =
          List<String>.from(json.decode(response.body));

      // Decode each string item in the list
      final List<PemesananTiket> list = kursiDipesanStrings.map((encodedSeats) {
        // Decode the JSON string inside each element
        List<String> kursiDipesan =
            List<String>.from(json.decode(encodedSeats));

        // Assuming you also have the `idJadwalTayang` in your response, you can extract it here.
        // If idJadwalTayang is not part of the response data, adjust accordingly.
        return PemesananTiket(
          idJadwalTayang: idJadwalTayang,
          kursiDipesan: kursiDipesan,
        );
      }).toList();

      for (var PemesananTiket in list) {
        log('ID Jadwal Tayang: ${PemesananTiket.idJadwalTayang}');
        log('Kursi Dipesan: ${PemesananTiket.kursiDipesan}');
        for (var kursi in PemesananTiket.kursiDipesan) {
          log('Kursi: $kursi');
        }
      }

      return list;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> createPemesananTiket(
      int idJadwalTayang, List<String> kursiDipesan) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      log("Token: $token");

      final data = PemesananTiket(
        idJadwalTayang: idJadwalTayang,
        kursiDipesan: kursiDipesan,
      );

      log("Data: $data");

      // Encode to JSON
      final bodyData = jsonEncode(data.toJson());
      log("BodyData: $bodyData");

      // Send POST request with headers and body
      var response = await post(
        Uri.https(url, '$endpoint/pemesanantiket'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type":
              "application/json", // Set Content-Type header to application/json
        },
        body: bodyData, // Send the JSON data in the body
      );

      print(response.statusCode);

      log("Response Status Code: ${response.statusCode}");
      log("Response Headers: ${response.headers}");
      log("Response Body: ${response.body}");

      if (response.statusCode == 302) {
        log("Redirect Location: ${response.headers['location']}");
      }

      return response;
    } catch (e) {
      log("Error: ${e.toString()}");
      return Future.error(e.toString());
    }
  }

  static Future<bool> deleteKursi(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      var response = await delete(
        Uri.https(url, '$endpoint/pemesanantiket/delete/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      log("Response Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        return true; // Return true if delete was successful
      } else {
        throw Exception('Failed to delete seats');
      }
    } catch (e) {
      log("Error: $e");
      return false; // Return false if an error occurred
    }
  }
}
