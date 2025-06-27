// import 'dart:developer';

// import 'package:tubez/model/tiket.dart';
// import 'package:tubez/network/api_service.dart';

// class TiketRepository {
//   final ApiService _service = ApiService();

//   Future<List<Tiket>?> getTiket() async {
//     final response = await _service.dio.get('/tiket');

//     if (response.statusCode == 200) {
//       final List<Tiket> locations = [];

//       for (dynamic data in response.data) {
//         locations.add(Tiket.fromJson(data));
//       }

//       if (locations.isNotEmpty) {
//         return locations;
//       } else {
//         log('No locations found.');
//         return null;
//       }
//     }
//   }
// }
