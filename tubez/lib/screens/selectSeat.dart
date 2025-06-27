import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:tubez/client/TransaksiClient.dart';
import 'package:tubez/client/PemesananTiketClient.dart';
import 'package:tubez/entity/JadwalTayang.dart';
import 'package:tubez/model/pdfItem.dart';
import 'package:tubez/entity/pemesanan_tiket.dart';
import 'dart:ui';
import 'package:tubez/widgets/MovieDetailWidgets/BackButton.dart';
import 'package:book_my_seat/book_my_seat.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'package:tubez/screens/payment.dart';
import 'package:tubez/entity/Film.dart';
import 'package:tubez/client/apiURL.dart';

class selectSeatScreen extends StatefulWidget {
  const selectSeatScreen(
      {super.key, required this.movie, required this.jadwalTayang});
  final Film movie;
  final Jadwaltayang? jadwalTayang;

  @override
  State<selectSeatScreen> createState() => _selectSeatScreenState();
}

class _selectSeatScreenState extends State<selectSeatScreen> {
  late int idStudio;
  Set<SeatNumber> selectedSeats = Set();
  Set<String> mySeats = {}; // This will store the translated seat numbers
  late Future<List<PemesananTiket>> futureTransaksi;
  late int rows;
  late int cols;
  late String datePayment;

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    decimalDigits: 0,
    name: 'Rp ',
    symbol: 'Rp ',
  );

  @override
  void initState() {
    super.initState();
    _fetchSeatData();
    datePayment = DateFormat('EEEEEE, dd-MM-yyyy')
        .format(widget.jadwalTayang!.tanggalTayang);
  }

  @override
  void didUpdateWidget(covariant selectSeatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.jadwalTayang?.id != oldWidget.jadwalTayang?.id) {
      _fetchSeatData();
    } else {
      _fetchSeatData();
    }
  }

  void _fetchSeatData() {
    idStudio = widget.jadwalTayang!.idStudio;
    if (idStudio == 1) {
      rows = 10;
      cols = 10;
    } else {
      rows = 8;
      cols = 8;
    }

    if (widget.jadwalTayang?.id != null) {
      setState(() {
        futureTransaksi =
            PemesananTiketClient.getAllKursi(widget.jadwalTayang!.id!);
        log("Fetching seat data for jadwalTayang ID: ${widget.jadwalTayang?.id}");
      });
    } else {
      setState(() {
        futureTransaksi = Future.error('Invalid jadwalTayang ID');
      });
    }
  }

  List<List<SeatState>> generateSeatLayout(List<PemesananTiket> transaksiList) {
    List<String> reservedSeats = transaksiList.expand((transaksi) {
      return transaksi.kursiDipesan;
    }).toList();
    List<List<SeatState>> seatLayout = List.generate(
      rows,
      (rowIndex) => List.generate(
        cols,
        (colIndex) {
          // Create a SeatNumber object for this seat
          SeatNumber seatNumber = SeatNumber(rowI: rowIndex, colI: colIndex);

          // Translate the SeatNumber object to a seat code (e.g., "A1", "B1")
          String seatCode = seatNumber.toString();

          // If the seat is reserved, mark it as unavailable, else available
          if (reservedSeats.contains(seatCode)) {
            return SeatState.sold; // Seat is reserved
          } else {
            return SeatState.unselected; // Seat is available for selection
          }
        },
      ),
    );

    return seatLayout;
  }

  @override
  Widget build(BuildContext context) {
    final Film movie = widget.movie;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const BackButtonWidget(),

            // Trapezium Container
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // First widget: CustomPaint for the trapezium
                    Container(
                      child: Image.asset('assets/images/screen.png'),
                    ),

                    const SizedBox(height: 10),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: FutureBuilder(
                            future: futureTransaksi,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                log("Reserved Seats: ${snapshot.error}"); // Perbaiki untuk menampilkan data yang diterima

                                return Center(
                                    child: Text("Error: ${snapshot.error}"));
                              } else if (snapshot.hasData) {
                                List<List<SeatState>> currentSeatsState =
                                    generateSeatLayout(snapshot.data!);
                                return SeatLayoutWidget(
                                  onSeatStateChanged: (rowI, colI, seatState) {
                                    String seatString =
                                        SeatNumber(rowI: rowI, colI: colI)
                                            .toString();
                                    if (seatState == SeatState.selected) {
                                      selectedSeats.add(
                                          SeatNumber(rowI: rowI, colI: colI));
                                      mySeats.add(seatString);
                                    } else {
                                      selectedSeats.remove(
                                          SeatNumber(rowI: rowI, colI: colI));
                                      mySeats.remove(seatString);
                                    }
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          seatState == SeatState.selected
                                              ? "My Selected Seats: ${mySeats.join(', ')}"
                                              : "My Selected Seats: ${mySeats.join(', ')}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                            255, 56, 55, 55),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  },
                                  stateModel: SeatLayoutStateModel(
                                    rows: rows,
                                    cols: cols,
                                    seatSvgSize: 35,
                                    pathUnSelectedSeat:
                                        'assets/images/availableSeat.svg',
                                    pathSelectedSeat:
                                        'assets/images/selectedlivecode.svg',
                                    pathSoldSeat:
                                        'assets/images/livecodesold.svg',
                                    pathDisabledSeat:
                                        'assets/images/soldSeat.svg',
                                    currentSeatsState: currentSeatsState,
                                  ),
                                );
                              } else {
                                return Center(child: Text("No data available"));
                              }
                            }),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          showSlideInModal(
                              context,
                              mySeats,
                              movie,
                              widget.jadwalTayang!,
                              currencyFormatter,
                              0,
                              datePayment);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 60, vertical: 15),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SvgPicture.asset(
                                  'assets/images/selectedSeat.svg'),
                              SizedBox(height: 10),
                              Text(
                                "Selected",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(
                                  'assets/images/availableSeat.svg'),
                              SizedBox(height: 10),
                              Text(
                                "Available",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            children: [
                              SvgPicture.asset('assets/images/soldSeat.svg'),
                              SizedBox(height: 10),
                              Text(
                                "Unavailable",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(0, 158, 158, 158),
                      radius: 30,
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeatNumber {
  final int rowI;
  final int colI;

  const SeatNumber({required this.rowI, required this.colI});

  @override
  bool operator ==(Object other) {
    return rowI == (other as SeatNumber).rowI &&
        colI == (other as SeatNumber).colI;
  }

  @override
  int get hashCode =>
      rowI.hashCode ^
      colI.hashCode; // Ensure both row and col are used for hashing

  @override
  String toString() {
    return '${translateRowToString(rowI)}${colI + 1}'; // Convert to seat label like A1, B2, C3, etc.
  }

  // Function to convert row index to letter (A, B, C, etc.)
  String translateRowToString(int rowIndex) {
    return String.fromCharCode(65 + rowIndex); // 65 is ASCII for 'A'
  }
}

void showSlideInModal(
    BuildContext context,
    Set<String> mySeats,
    Film movie,
    Jadwaltayang? jadwalTayang,
    NumberFormat currencyFormatter,
    double totalPayment,
    String datePayment) {
  if (jadwalTayang!.idStudio == 1) {
    totalPayment = mySeats.length * 35000;
  } else {
    totalPayment = mySeats.length * 50000;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow height to adjust based on content
    backgroundColor: Colors.black, // Optional: make the background transparent
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          color: const Color.fromARGB(255, 35, 35, 35),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 6,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Text(
                        "Seat Details",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                          height: 80,
                          width: 80,
                          child: Image.network('$url${movie.fotoFilm}')),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.judul,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              datePayment,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 180, 180, 180)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "- Your Tickets cannot be exchanged or refunded",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "- Children ages 2 or above require tickets",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 12, right: 8, left: 8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 63, 62, 62),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 8),
                                  child: Text(
                                    "Number of Seats: ${mySeats.length}", // This number can be dynamic if needed
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 7.0),
                                  child: Text(
                                    "My Seats: ${mySeats.join(', ')}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      children: [
                        Text(
                          "Total:",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                        Text(
                          currencyFormatter.format(totalPayment),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        var response =
                            await PemesananTiketClient.createPemesananTiket(
                                jadwalTayang.id!, mySeats.toList());

                        if (response.statusCode == 200) {
                          Map<String, dynamic> responseData =
                              jsonDecode(response.body);

                          // Check if the response contains 'data' and 'id' inside it
                          if (responseData.containsKey('data') &&
                              responseData['data'] != null) {
                            var data = responseData['data'];

                            var idPemesananTiket = data['id'];

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => paymentScreenState(
                                  mySeats: mySeats,
                                  movie: movie,
                                  idPemesananTiket: idPemesananTiket,
                                  jadwalTayang: jadwalTayang,
                                ),
                              ),
                            );
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Password Salah'),
                              content: TextButton(
                                  onPressed: () => {},
                                  child: const Text('Daftar Disini !!!')),
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
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Error'),
                            content: TextButton(
                                onPressed: () => {},
                                child: const Text('Samting wong')),
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
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 90, vertical: 12),
                      child: Text(
                        'Confirm',
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
              )
            ],
          ),
        ),
      );
    },
  );
}
