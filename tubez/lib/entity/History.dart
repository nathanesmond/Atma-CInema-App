import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:tubez/entity/User.dart';

class History {
  BigInt? id;
  BigInt idTransaksi;
  BigInt idUser;
  String status;
  bool isReview;
  Transaksi? transaksi;

  History({
    this.id,
    required this.idTransaksi,
    required this.idUser,
    required this.status,
    required this.isReview,
    this.transaksi,
  });

  factory History.fromRawJson(String str) => History.fromJson(json.decode(str));

  factory History.fromJson(Map<String, dynamic> json) {
    bool isReview = json['isReview'] == 1;

    Transaksi? transaksi = json['transaksi'] != null
        ? Transaksi.fromJson(json['transaksi'])
        : null;

    String status = json['status'] ?? '';

    return History(
      id: BigInt.from(json['id']),
      idTransaksi: BigInt.from(json['idTransaksi']),
      idUser: BigInt.from(json['idUser']),
      status: status,
      isReview: isReview,
      transaksi: transaksi,
    );
  }

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'idTransaksi': idTransaksi.toString(),
      'idUser': idUser.toString(),
      'status': status,
      'isReview': isReview ? 1 : 0,
      'transaksi': transaksi?.toJson(),
    };
  }
}

class Film {
  int id;
  String judul;
  String status;
  String durasi;
  String genre;
  String ageRestriction;
  String sinopsis;
  double jumlahRating;
  String fotoFilm;

  Film({
    required this.id,
    required this.judul,
    required this.status,
    required this.durasi,
    required this.genre,
    required this.ageRestriction,
    required this.sinopsis,
    required this.jumlahRating,
    required this.fotoFilm,
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

class Transaksi {
  final int? id;
  final int idUser;
  final int idPemesananTiket;
  final String metodePembayaran;
  final double totalHarga;
  final PemesananTiket? pemesanan_tiket;

  Transaksi({
    this.id,
    required this.idUser,
    required this.idPemesananTiket,
    required this.metodePembayaran,
    required this.totalHarga,
    required this.pemesanan_tiket,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      idUser:
          json['idUser'] is int ? json['idUser'] : int.parse(json['idUser']),
      idPemesananTiket: json['idPemesananTiket'] is int
          ? json['idPemesananTiket']
          : int.parse(json['idPemesananTiket']),
      metodePembayaran: json['metodePembayaran'],
      totalHarga: json['totalHarga'] is double
          ? json['totalHarga']
          : double.parse(json['totalHarga'].toString()),
      pemesanan_tiket: json['pemesanan_tiket'] != null
          ? PemesananTiket.fromJson(json['pemesanan_tiket'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'idPemesananTiket': idPemesananTiket,
      'metodePembayaran': metodePembayaran,
      'totalHarga': totalHarga,
      'pemesanan_tiket': pemesanan_tiket,
    };
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

class PemesananTiket {
  final int? id;
  final int idJadwalTayang;
  final List<String> kursiDipesan;
  final JadwalTayang? jadwal_tayang;
  final int countTiket;

  PemesananTiket({
    required this.id,
    required this.idJadwalTayang,
    required this.kursiDipesan,
    required this.jadwal_tayang,
    required this.countTiket,
  });

  factory PemesananTiket.fromJson(Map<String, dynamic> json) {
    return PemesananTiket(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      idJadwalTayang: json['idJadwalTayang'] is int
          ? json['idJadwalTayang']
          : int.parse(json['idJadwalTayang']),
      kursiDipesan: List<String>.from(jsonDecode(json['kursiDipesan'])),
      countTiket: json['kursiDipesan'] is String
          ? List<String>.from(jsonDecode(json['kursiDipesan'])).length
          : json['kursiDipesan'].length,
      jadwal_tayang: json['jadwal_tayang'] != null
          ? JadwalTayang.fromJson(json['jadwal_tayang'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idJadwalTayang': idJadwalTayang,
      'kursiDipesan': kursiDipesan,
      'jadwalTayang': jadwal_tayang?.toJson(),
    };
  }
}

class JadwalTayang {
  final int? id;
  final int? idStudio;
  final int? idJadwal;
  final int? idFilm;
  final String tanggalTayang;
  final Studio? studio;
  final Film? film;

  JadwalTayang({
    this.id,
    required this.idStudio,
    required this.idJadwal,
    required this.idFilm,
    required this.tanggalTayang,
    required this.studio,
    required this.film,
  });

  factory JadwalTayang.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.parse(json['tanggalTayang'].toString());

    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return JadwalTayang(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      idStudio: json['idStudio'] is int
          ? json['idStudio']
          : int.parse(json['idStudio']),
      idJadwal: json['idJadwal'] is int
          ? json['idJadwal']
          : int.parse(json['idJadwal']),
      idFilm:
          json['idFilm'] is int ? json['idFilm'] : int.parse(json['idFilm']),
      tanggalTayang: formattedDate,
      studio: json['studio'] != null ? Studio.fromJson(json['studio']) : null,
      film: json['film'] != null ? Film.fromJson(json['film']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idStudio': idStudio,
      'idJadwal': idJadwal,
      'idFilm': idFilm,
      'tanggalTayang': tanggalTayang,
      'studio': studio?.toJson(),
      'film': film?.toJson(),
    };
  }
}
