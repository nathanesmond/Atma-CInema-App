import 'dart:convert';
import 'dart:ffi';

class Jadwal {
  final int? id;
  final DateTime jamTayang;

  Jadwal({
    required this.id,
    required this.jamTayang,
  });

  
  factory Jadwal.fromRawJson(String str) => Jadwal.fromJson(json.decode(str));

  factory Jadwal.fromJson(Map<String, dynamic> json) => Jadwal(
    id: json['id'],
    jamTayang: DateTime.parse("2024-01-01 ${json['jamTayang']}"),
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    'id': id,
    'jamTayang': jamTayang.toIso8601String(),
  };
  
}