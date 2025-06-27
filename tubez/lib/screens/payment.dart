import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:tubez/client/TransaksiClient.dart';
import 'package:tubez/client/HistoryClient.dart';
import 'package:tubez/entity/History.dart' as history_entity;
import 'package:tubez/entity/JadwalTayang.dart';
import 'package:tubez/entity/transaksi.dart';
import 'package:tubez/screens/pdf_view.dart';
import 'package:tubez/screens/selectPayment.dart';
import 'package:tubez/widgets/paymentWidgets/MovieDescription.dart';
import 'package:tubez/model/pdfItem.dart';
import 'package:tubez/entity/Film.dart';
import 'package:tubez/client/UserClient.dart';
import 'package:tubez/client/PemesananTiketClient.dart';

class paymentScreenState extends StatefulWidget {
  final Set<String> mySeats;

  paymentScreenState(
      {super.key,
      required this.mySeats,
      required this.movie,
      required this.idPemesananTiket,
      required this.jadwalTayang});
  final Film movie;
  final int idPemesananTiket;
  final Jadwaltayang? jadwalTayang;
  @override
  State<paymentScreenState> createState() => _paymentScreenStateState();
}

NumberFormat currencyFormatter = NumberFormat.currency(
  locale: 'id',
  decimalDigits: 0,
  name: 'Rp ',
  symbol: 'Rp ',
);

double getHargaKursi(int idStudio) {
  print('idstudionya ini bro : $idStudio');
  if (idStudio == 1) {
    return 35000;
  } else if (idStudio == 2) {
    return 50000;
  } else {
    return 0;
  }
}

class _paymentScreenStateState extends State<paymentScreenState> {
  String _metodePembayaran = "Not Selected";
  int? userId; // Variabel untuk menyimpan ID pengguna
  String? token; // Variabel untuk menyimpan token

  String currentDate = DateFormat('EEEEEE, dd-MM-yyyy').format(DateTime.now());
  late final int idStudio;
  late double totalPayment;
  late String datePayment;

  Future<void> ambilToken() async {
    UserClient userClient = UserClient();
    String? token = await userClient.getToken();

    if (token != null) {
      final response = await userClient.dataUser(token);

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        setState(() {
          userId = data['id'];
        });
      } else {
        print('Failed to load user data: ${response.statusCode}');
        // Tampilkan pesan kesalahan jika pemanggilan API gagal
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to load user data. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      print('Token is null');
      // Tampilkan pesan kesalahan jika token tidak ditemukan
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Token not found. Please log in again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    ambilToken();
    if (widget.jadwalTayang != null) {
      idStudio = widget.jadwalTayang!.idStudio;
      datePayment = DateFormat('EEEEEE, dd-MM-yyyy')
          .format(widget.jadwalTayang!.tanggalTayang);
    } else {
      idStudio = 0;
      datePayment = 'Tanggal Kosong';
    }
  }

  Future<void> deletePemesananTiket() async {
    bool success = await PemesananTiketClient.deleteKursi(
        widget.idPemesananTiket // Convert Set to List
        );
  }

  @override
  Widget build(BuildContext context) {
    Set<String> mySeats = widget.mySeats;
    if (idStudio == 1) {
      totalPayment = widget.mySeats.length * 35000;
    } else {
      totalPayment = widget.mySeats.length * 50000;
    }
    final Film movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              deletePemesananTiket();
              Navigator.of(context).pop();
            },
          ),
        ),
        title: const Text(
          "Order Confirmation",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor:
            Colors.transparent, // Make the AppBar background transparent
        elevation: 0, // Remove the default shadow of the AppBar
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Padding around the content
            child: Column(
              children: [
                const SizedBox(height: 20),
                MovieDescription(
                  movie: movie,
                  currentDate: datePayment,
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 63, 62, 62),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Icon(
                              Icons.add_card_outlined,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          width: 10), // Adjusted spacing between icon and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tickets",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "${mySeats.length} x ${currencyFormatter.format(getHargaKursi(idStudio))}",
                                      style: TextStyle(color: Colors.white)),
                                ]),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    " ${mySeats.join(', ')}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines:
                                        2, // Ensure text is on a single line
                                  ),
                                ),
                                Text(
                                  currencyFormatter.format(totalPayment),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Text(
                      "SubTotal",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Text(
                      currencyFormatter.format(totalPayment),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "OrderFees",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Rp 0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Total Payment",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      currencyFormatter.format(totalPayment),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => selectPaymentScreen(
                            title: _metodePembayaran,
                            onPaymentSelected: (metodePembayaran) =>
                                setState(() {
                                  _metodePembayaran = metodePembayaran;
                                })),
                      ),
                    );
                  },
                  child: Container(
                    color: const Color.fromARGB(255, 44, 43, 43),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 63, 62, 62),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Icon(
                              Icons.add_card_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            _metodePembayaran,
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Spacer(),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => selectPaymentScreen(
                                      title: _metodePembayaran,
                                      onPaymentSelected: (metodePembayaran) =>
                                          setState(() {
                                            _metodePembayaran = metodePembayaran;
                                          })),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (_metodePembayaran == "Not Selected") {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'Please select a payment method before proceeding.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    if (userId == null) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'User ID not found. Please log in again.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    try {
                      var response = await TransaksiClient.createTransaksi(
                        Transaksi(
                          metodePembayaran: _metodePembayaran,
                          idUser: BigInt.from(userId!).toInt(),
                          totalHarga: totalPayment,
                          idPemesananTiket:
                              BigInt.from(widget.idPemesananTiket).toInt(),
                        ),
                      );

                      var data = json.decode(response.body)['data'];
                      BigInt idTransaksi = BigInt.from(data['id']);
                      print('Transaction ID: $idTransaksi');

                      Response responseHistory = await HistoryClient.create(
                          history_entity.History(
                              idTransaksi: idTransaksi,
                              idUser: BigInt.from(
                                  userId!), // Menggunakan ID pengguna yang didapat
                              status: 'Uncompleted', // Status yang sesuai
                              isReview: false));

                      print('asdasd ${responseHistory.statusCode}');
                      if (responseHistory.statusCode == 200) {
                        // History berhasil disimpan
                        print("History created successfully");
                      } else {
                        // Tangani jika penyimpanan history gagal
                        print(
                            "Failed to create history: ${responseHistory.reasonPhrase}");
                      }

                      if (responseHistory.statusCode == 200) {
                        // Buat PDF
                        createPDF(
                          widget.movie,
                          totalPayment,
                          context,
                          datePayment,
                          mySeats,
                          idStudio,
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Error'),
                            content: TextButton(
                                onPressed: () => {},
                                child: const Text('Transaction failed')),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
