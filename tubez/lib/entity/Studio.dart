import 'dart:convert';
import 'dart:ffi';

class Studio {
  final int? id;
  final String jenis;
  final int jumlahKursi;
  final dynamic harga;

  Studio({
    required this.id,
    required this.jenis,
    required this.jumlahKursi,
    required this.harga,
  });

  
  factory Studio.fromRawJson(String str) => Studio.fromJson(json.decode(str));

  factory Studio.fromJson(Map<String, dynamic> json) => Studio(
    id: json['id'],
    jenis: json['jenis'],
    jumlahKursi: json['jumlahKursi'],
    harga: json['harga'],
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    'id': id,
    'jenis': jenis,
    'jumlahKursi': jumlahKursi,
    'harga': harga,
  };
  
}