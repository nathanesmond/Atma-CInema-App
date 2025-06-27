import 'dart:convert';

class Transaksi {
  final int idUser;
  final int idPemesananTiket;
  final String metodePembayaran;
  final double totalHarga;

  Transaksi({
    required this.idUser,
    required this.idPemesananTiket,
    required this.metodePembayaran,
    required this.totalHarga,
  });

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'idPemesananTiket': idPemesananTiket,
      'metodePembayaran': metodePembayaran,
      'totalHarga': totalHarga,
    };
  }
}
