import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tubez/client/UserClient.dart';
import 'package:tubez/entity/Review.dart';
import 'package:tubez/client/apiURL.dart';

class ReviewClient {
  // static const String apiUrl = 'http://10.0.2.2:8000/api';

  static Future<bool> submitReview(
      int idFilm, BigInt idHistory, String review, double rating) async {
    try {
      UserClient userClient = UserClient();
      String? token = await userClient.getToken();

      var response = await post(
        Uri.https(url, '$endpoint/review/create'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json",
        },
        body: json.encode({
          'idFilm': idFilm,
          'idHistory': idHistory.toString(), // BigInt to string
          'review': review,
          'rating': rating,
        }),
      );

      if (response.statusCode == 200) {
        print('Review submitted successfully');
        return true;
      } else {
        print('Failed to submit review: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error submitting review: $e');
      return false;
    }
  }

  static Future<bool> updateStatusHistory(
      BigInt idHistory, String newStatus, int isReview) async {
    UserClient userClient = UserClient();
    String? token = await userClient.getToken();
    try {
      var response = await post(
        Uri.https(url, '$endpoint/history/update/$idHistory'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json",
        },
        body: json.encode({
          'status': newStatus,
          'isReview': isReview,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update history : ${response.body}');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<Review> fetchDataReview(BigInt idHistory) async {
    UserClient userClient = UserClient();
    String? token = await userClient.getToken();
    try {
      var response = await get(
        Uri.https(url, '$endpoint/review/$idHistory'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json",
        },
      );

      print('wowowowo ${response.statusCode}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print('testingsadas');
        Review review = Review.fromJson(data['review'][0]);
        return review;
      } else {
        throw Exception('Failed to load review: ${response.body}');
      }
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
