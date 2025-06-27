import 'dart:convert';
import 'dart:ffi';

class Film{
  int? id;
  String judul;
  String status;
  String durasi;
  String genre;
  String ageRestriction;
  String sinopsis;
  double jumlahRating;
  String? fotoFilm;

  Film({
    this.id,
    required this.judul,
    required this.status,
    required this.durasi,
    required this.genre,
    required this.ageRestriction,
    required this.sinopsis,
    required this.jumlahRating,
    this.fotoFilm,
  });

  factory Film.fromRawJson(String str) => Film.fromJson(json.decode(str));

  factory Film.fromJson(Map<String, dynamic> json) => Film(
    id: json['id'],
    judul: json['judul'],
    status: json['status'],
    durasi: json['durasi'],
    genre: json['genre'],
    ageRestriction: json['ageRestriction'],
    sinopsis: json['sinopsis'],
    jumlahRating: json['jumlahRating'],
    fotoFilm: json['fotoFilm'],
  );

  get idFilm => null;

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': judul,
    'status': status,
    'durasi': durasi,
    'genre': genre,
    'ageRestriction': ageRestriction,
    'sinopsis': sinopsis,
    'jumlahRating': jumlahRating,
    'fotoFilm': fotoFilm,
  };

}

