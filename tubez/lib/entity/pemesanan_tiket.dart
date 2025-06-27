import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'pemesanan_tiket.g.dart';

@JsonSerializable(explicitToJson: true)
class PemesananTiket {
  final int? id;
  final int idJadwalTayang;
  final List<String> kursiDipesan;

  PemesananTiket({
    this.id = null,
    required this.idJadwalTayang,
    required this.kursiDipesan,
  });

  // Factory constructor to parse JSON
  factory PemesananTiket.fromJson(Map<String, dynamic> json) =>
      _$PemesananTiketFromJson(json);

  Map<String, dynamic> toJson() => _$PemesananTiketToJson(this);
}
