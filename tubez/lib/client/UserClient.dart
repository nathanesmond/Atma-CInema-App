import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart'; // Untuk MIME type
import 'package:mime/mime.dart'; // Untuk deteksi MIME type file
import 'package:tubez/client/apiURL.dart' as apibro;

import 'package:tubez/entity/User.dart';

class UserClient {
  // sesuaikan url dan endpoint dengan device yang digunakan

  //untuk emulator
  // static final String url = '10.0.2.2:8000';
  // static final String endpoint = '/api';

  // untuk hp
  // static final String url = 'ipv4 kalian';
  // static final String endpoint = '/GD_API_1697/public/api/user';

  // mengambil semua data user dari API
  // static Future<List<User>> fetchAll() async{
  //   try{
  //     var response = await get(Uri.https(url, endpoint));

  //     if(response.statusCode != 200) throw Exception(response.reasonPhrase);

  //     //mengambil bagian data dari response body
  //     Iterable list = json.decode(response.body)['data'];

  //     // list.map untuk membuat list objek User berdasarkan tiap elemen dari list
  //     return list.map((e) => User.fromJson(e)).toList();
  //   }catch(e){
  //     return Future.error(e.toString());
  //   }
  // }

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
  static Future<Response> register(User user) async {
    try {
      var response = await post(
          Uri.https(apibro.url,
              '/api/register'), // pergi ke /api/register

          headers: {"Content-Type": "application/json"},
          body: user.toRawJson());
      // hasil inputan register kita dalam bentuk user dirubah menjadi json dan dimasukkan ke dalam body

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Login

  // static Future<bool> login(String email, String password) async {
  //   try {
  //     var response = await post(Uri.https(url, '$endpoint/login'),
  //         headers: {"Content-Type": "application/json"},
  //         body: json.encode({"email": email, "password": password}));
  //     // masukin emiail dan password yang sudah diinput ke dalam body untuk dibawa ke API login

  //     if (response.statusCode != 200) throw Exception(response.reasonPhrase);

  //     Map<String, dynamic> data = json.decode(response.body);
  //     // data dari response body di decode ke dalam bentuk json dan disimpan di variabel data

  //     if (data['status'] == true) {
  //       // di cek kalau status nya true maka akan diambil token nya, status itu dari controller login di laravel
  //       String token = data['token'];

  //       // token disimpan di shared preferences biar bisa diambil dari manapun
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setString('auth_token', token);
  //       // nama token di shared preferences nya auth_token
  //       prefs.setString('userId', data['data']['id'].toString());

  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  // static Future<bool> login(String email, String password) async {
  //   try {
  //     var response = await post(
  //       Uri.https(url, '$endpoint/login'),
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode({"email": email, "password": password}),
  //     );

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> data = json.decode(response.body);
  //       print("Login Response: ${data}");

  //       if (data['status'] == true) {
  //         // Jika status = true, simpan token
  //         String token = data['token'];
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         prefs.setString('auth_token', token);
  //         prefs.setString(
  //             'userId', data['data']['id'].toString()); // Save user ID

  //         return true;
  //       } else {
  //         // Login gagal, tampilkan error message
  //         print("Login failed with message: ${data['message']}");
  //         return false;
  //       }
  //     } else {
  //       print(
  //           "Error: Failed to login with status code: ${response.statusCode}");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Login error: $e");
  //     return Future.error(e.toString());
  //   }
  // }

  static Future<bool> login(String email, String password) async {
    try {
      var response = await post(
          Uri.https(apibro.url, '${apibro.endpoint}/login'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"email": email, "password": password}));
      // masukin emiail dan password yang sudah diinput ke dalam body untuk dibawa ke API login
      print('anjay mabar ${response.statusCode}');

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Map<String, dynamic> data = json.decode(response.body);
      // data dari response body di decode ke dalam bentuk json dan disimpan di variabel data

      if (data['status'] == true) {
        // di cek kalau status nya true maka akan diambil token nya, status itu dari controller login di laravel
        String token = data['token'];

        // token disimpan di shared preferences biar bisa diambil dari manapun
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', token);
        // nama token di shared preferences nya auth_token
        prefs.setString('userId', data['data']['id'].toString());

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // Method untuk update user profile
  static Future<http.Response> update(User user, {File? profileImage}) async {
    try {
      // Mendapatkan token
      final String? token = await UserClient().getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Ambil userId dari SharedPreferences
      String? userIdString = prefs.getString('userId');
      int userId = userIdString != null
          ? int.tryParse(userIdString) ?? 0
          : 0; // Jika null atau gagal parse, gunakan 0

      if (token != null) {
        var uri = Uri.https(apibro.url,
            '${apibro.endpoint}/update/$userId'); // URL untuk update profil

        var request = http.MultipartRequest('POST', uri)
          ..headers.addAll({
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          });

        // Menambahkan data profil (misalnya username, email, dll)
        request.fields['username'] = user.username;
        request.fields['email'] = user.email;
        request.fields['noTelepon'] = user.noTelepon;
        request.fields['tanggalLahir'] = user.tanggalLahir;
        request.fields['password'] = user.password;

        // Jika ada gambar yang diupload, tambahkan ke request
        if (profileImage != null) {
          var mimeType = lookupMimeType(profileImage.path) ??
              'image/jpeg'; // Menentukan MIME type
          var fileBytes =
              await profileImage.readAsBytes(); // Membaca bytes file
          var file = http.MultipartFile.fromBytes('foto', fileBytes,
              filename: basename(profileImage.path),
              contentType: MediaType.parse(mimeType));
          request.files.add(file); // Menambahkan file ke request
        }

        // Mengirim request
        var response = await request.send();

        // Menerima response
        final responseBody = await http.Response.fromStream(response);
        return responseBody;
      } else {
        return Future.error('Token is missing');
      }
    } catch (e) {
      return Future.error('Error: $e');
    }
  }

  // Menghapus data user sesuai ID
  static Future<Response> destroy(id) async {
    try {
      var response =
          await delete(Uri.https(apibro.url, '${apibro.endpoint}/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      var response = await post(
          Uri.https(apibro.url, '${apibro.endpoint}/logout'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      prefs.remove('auth_token');
      prefs.remove('userId');

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // static Future<Response> logout() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('auth_token');

  //     var response = await post(Uri.https(url, '$endpoint/logout'), headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token"
  //     });

  //     if (response.statusCode == 200) {
  //       // Menghapus data setelah logout
  //       prefs.remove('auth_token');
  //       prefs.remove('userId');
  //       return response;
  //     } else {
  //       throw Exception('Logout failed: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  // static Future<Response> logout() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('auth_token');

  //     var response = await post(Uri.https(url, '$endpoint/logout'), headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token"
  //     });

  //     if (response.statusCode != 200) throw Exception(response.reasonPhrase);

  //     prefs.remove('auth_token');
  //     prefs.remove('userId');

  //     return response;
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  Future<Response> dataUser(String? token) async {
    if (token != null) {
      final response = await get(
        Uri.https(apibro.url, '${apibro.endpoint}/index'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json",
        },
      );
      return response;
    } else {
      return Future.error('Token tidak ada!');
    }
  }
}
