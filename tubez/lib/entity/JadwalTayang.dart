import 'dart:convert';
import 'dart:ffi';

import 'package:tubez/entity/Jadwal.dart';
import 'package:tubez/entity/Studio.dart';

class Jadwaltayang{
  int? id;
  int idStudio;
  int idJadwal;
  int idFilm;
  DateTime tanggalTayang;
  Jadwal? jadwal;
  Studio? studio;
  
  Jadwaltayang({
    this.id,
    required this.idFilm,
    required this.idJadwal,
    required this.idStudio,
    required this.tanggalTayang,
    this.jadwal,
    this.studio,
  });

  factory Jadwaltayang.fromRawJson(String str) => Jadwaltayang.fromJson(json.decode(str));

  factory Jadwaltayang.fromJson(Map<String, dynamic> json) => Jadwaltayang(
    id: json['id'],
    idFilm: json['idFilm'],
    idJadwal: json['idJadwal'],
    idStudio: json['idStudio'],
    tanggalTayang: DateTime.parse(json['tanggalTayang']),
    jadwal: json['jadwal'] != null ? Jadwal.fromJson(json['jadwal']) : null,
    studio: json['studio'] != null ? Studio.fromJson(json['studio']) : null,
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    'id': id,
    'idFilm': idFilm,
    'idJadwal': idJadwal,
    'idStudio': idStudio,
    'tanggalTayang': tanggalTayang.toIso8601String(),
    'jadwal': jadwal,
    'studio': studio,
  };

}

class Jadwal {
  final int id;
  final String jamTayang; // TIME field as String

  Jadwal({
    required this.id,
    required this.jamTayang,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      id: json['id'],
      jamTayang: json['jamTayang'],
    );
  }
}

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