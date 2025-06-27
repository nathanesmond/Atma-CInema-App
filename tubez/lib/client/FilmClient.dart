import 'package:tubez/entity/Film.dart';

import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubez/client/apiURL.dart';

class FilmClient {
  // sesuaikan url dan endpoint dengan device yang digunakan

  //untuk emulator
  // static final String url = '10.0.2.2:8000';
  // static final String endpoint = '/api/film';

  // untuk hp
  // static final String url = '192.168.1.134';
  // static final String endpoint = '/database/public/api/film';

  // mengambil semua data user dari API
  static Future<List<Film>> fetchAll() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      var response = await get(Uri.https(url, '$endpoint/film/get'), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode != 200) {
        print(response.statusCode);
        throw Exception(response.reasonPhrase);
      }

      //mengambil bagian data dari response body
      Iterable list = json.decode(response.body)['data'];

      // list.map untuk membuat list objek User berdasarkan tiap elemen dari list
      return list.map((e) => Film.fromJson(e)).toList();
    } catch (e) {
      return Future.error('anjay ${e.toString()}');
    }
  }

  static Future<List<Film>> find(String searchText) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      var response = await get(Uri.https(url, '$endpoint/film/find/$searchText'),
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
        return list.map((e) => Film.fromJson(e)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to load films');
    }
  }
  static Future<bool> updateRating(id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      var response = await post(Uri.https(url, '$endpoint/film/updateRating/$id'), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      print('asdasdlasksadk ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to load films');
      }

      return true;
      
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to load films');
    }
  }

  // // Mengambil data User dari API sesuai ID
  // static Future<User> find(id) async {
  //   try{
  //     var response = await get(Uri.https(url, '$endpoint/$id'));

  //     if(response.statusCode != 200) throw Exception(response.reasonPhrase);

  //     return User.fromJson(json.decode(response.body)['data']);
  //   }catch (e){
  //     return Future.error(e.toString());
  //   }
  // }

  // Membuat data User baru
//   static Future<Response> register(Film film) async {
//     try {
//       var response = await post(
//           Uri.https(url, '$endpoint/register'), // pergi ke /api/register
//           headers: {"Content-Type": "application/json"},
//           body: user.toRawJson());
//       // hasil inputan register kita dalam bentuk user dirubah menjadi json dan dimasukkan ke dalam body

//       if (response.statusCode != 200) throw Exception(response.reasonPhrase);

//       return response;
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   // Login

//   static Future<bool> login(String email, String password) async {
//     try {
//       var response = await post(Uri.https(url, '$endpoint/login'),
//           headers: {"Content-Type": "application/json"},
//           body: json.encode({"email": email, "password": password}));
//       // masukin emiail dan password yang sudah diinput ke dalam body untuk dibawa ke API login

//       if (response.statusCode != 200) throw Exception(response.reasonPhrase);

//       Map<String, dynamic> data = json.decode(response.body);
//       // data dari response body di decode ke dalam bentuk json dan disimpan di variabel data

//       if (data['status'] == true) {
//         // di cek kalau status nya true maka akan diambil token nya, status itu dari controller login di laravel
//         String token = data['token'];

//         // token disimpan di shared preferences biar bisa diambil dari manapun
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString('auth_token', token);
//         // nama token di shared preferences nya auth_token
//         prefs.setString('userId', data['data']['id'].toString());

//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   Future<String?> getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<String?> getId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userId');
//   }

//   // Mengubah data user sesuai ID
//   static Future<Response> update(Film film) async {
//     try {
//       var response = await put(Uri.https(url, '$endpoint/${user.id}'),
//           headers: {"Content-Type": "application/json"},
//           body: user.toRawJson());

//       if (response.statusCode != 200) throw Exception(response.reasonPhrase);

//       return response;
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   // Menghapus data user sesuai ID
//   static Future<Response> destroy(id) async {
//     try {
//       var response = await delete(Uri.https(url, '$endpoint/$id'));

//       if (response.statusCode != 200) throw Exception(response.reasonPhrase);

//       return response;
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   static Future<Response> logout() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('auth_token');

//       var response = await post(Uri.https(url, '$endpoint/logout'), headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token"
//       });

//       if (response.statusCode != 200) throw Exception(response.reasonPhrase);

//       prefs.remove('auth_token');
//       prefs.remove('userId');

//       return response;
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   Future<Response> dataUser(String? token) async {
//     if (token != null) {
//       final response = await get(
//         Uri.https(url, '$endpoint/index'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           "Content-Type": "application/json",
//         },
//       );
//       return response;
//     } else {
//       return Future.error('Token tidak ada!');
//     }
//   }
}
