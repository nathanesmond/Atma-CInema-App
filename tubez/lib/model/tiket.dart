import 'package:json_annotation/json_annotation.dart';

part 'tiket.g.dart';

@JsonSerializable()
class Tiket {
  Tiket(this.idTiket, this.harga, this.kursi);

  final int idTiket;
  final String kursi;
  final double harga;

  factory Tiket.fromJson(Map<String,dynamic> json) => _$TiketFromJson(json); 
  Map<String,dynamic> toJson() => _$TiketToJson(this);
}

