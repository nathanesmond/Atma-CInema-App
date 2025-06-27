import 'dart:convert';

class SpesialPromo{
  int? id;
  String judul;
  String status;
  String tanggalBerlaku;
  double harga;
  String ketentuan;
  String? fotoPromo;

  SpesialPromo({
    this.id,
    required this.judul,
    required this.status,
    required this.tanggalBerlaku,
    required this.harga,
    required this.ketentuan,
    this.fotoPromo,
  });

  factory SpesialPromo.fromRawJson(String str) => SpesialPromo.fromJson(json.decode(str));

  factory SpesialPromo.fromJson(Map<String, dynamic> json) => SpesialPromo(
    id: json['id'],
    judul: json['judul'],
    status: json['status'],
    tanggalBerlaku: json['tanggalBerlaku'],
    harga: json['harga'],
    ketentuan: json['ketentuan'],
    fotoPromo: json['fotoPromo'],
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': judul,
    'status': status,
    'tanggalBerlaku': tanggalBerlaku,
    'harga': harga,
    'ketentuan': ketentuan,
    'fotoPromo': fotoPromo,
  };
}

