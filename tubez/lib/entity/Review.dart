import 'dart:convert';
import 'package:intl/intl.dart';

class Review {
  BigInt? id;
  BigInt idFilm;
  BigInt idHistory;
  String review;
  double rating;

  Review({
    this.id,
    required this.idFilm,
    required this.idHistory,
    required this.review,
    required this.rating,
  });

  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));

  factory Review.fromJson(Map<String, dynamic> json) {
    String review = json['review'] ?? '';

    double rating = json['rating'] ?? 0;

    return Review(
      id: BigInt.from(json['id']),
      idFilm: BigInt.from(json['idFilm']),
      idHistory: BigInt.from(json['idHistory']),
      review: review,
      rating: rating,
    );
  }

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'idFilm': idFilm.toString(),
      'idHistory': idHistory.toString(),
      'review': review,
      'rating': rating,
    };
  }
}
