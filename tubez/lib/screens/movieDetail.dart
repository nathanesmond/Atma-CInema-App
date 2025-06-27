import 'package:flutter/material.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/screens/selectSeat.dart';
import 'dart:ui';
import 'package:tubez/widgets/MovieDetailWidgets/MovieDescription.dart';
import 'package:tubez/widgets/MovieDetailWidgets/BackButton.dart';
import 'package:tubez/widgets/MovieDetailWidgets/scheduleWidget.dart';
import 'package:tubez/widgets/MovieDetailWidgets/timeWidget.dart';
import 'package:tubez/widgets/MovieDetailWidgets/cinemaTypeWidget.dart';
import 'package:tubez/entity/Film.dart';
import 'package:tubez/entity/JadwalTayang.dart';
import 'package:tubez/client/JadwalTayangClient.dart';

class moveiDetailScreen extends StatefulWidget {
  const moveiDetailScreen({super.key, required this.movie});

  final Film movie;

  @override
  State<moveiDetailScreen> createState() => _moveiDetailScreenState();
}

class _moveiDetailScreenState extends State<moveiDetailScreen> {
  late Future<List<Jadwaltayang>> jadwalTayang;
  DateTime? SelectedDay;
  int? idSelectedTime;
  int? idSelectedJenis;

  @override
  void initState() {
    super.initState();
    jadwalTayang = JadwalTayangClient.fetchByIdFilm(widget.movie.id!);
    jadwalTayang.then((jadwalList) {
      if (jadwalList.isNotEmpty) {
        setState(() {
          SelectedDay = jadwalList[0].tanggalTayang;
          idSelectedTime = jadwalList[0].idJadwal;
          idSelectedJenis = jadwalList[0].idStudio;
        });
      }
    });
  }

  void handleSelectedDay(DateTime selectedJadwal) {
    print('Selected Day: ${selectedJadwal}');
    SelectedDay = selectedJadwal;
  }

  void handleSelectedTime(int selectedJadwal) {
    print('Selected Time: ${selectedJadwal.toString()}');
    idSelectedTime = selectedJadwal;
  }

  void handleSelectedJenis(int selectedJadwal) {
    print('Selected Jenis: ${selectedJadwal.toString()}');
    idSelectedJenis = selectedJadwal;
  }

  Jadwaltayang? cariJadwalTayang(List<Jadwaltayang> jadwalTayangList) {
    try {
      return jadwalTayangList.firstWhere((jadwalTayang) =>
          jadwalTayang.tanggalTayang == SelectedDay &&
          jadwalTayang.idJadwal == idSelectedTime &&
          jadwalTayang.idStudio == idSelectedJenis);
    } catch (e) {
      print('Jadwal tidak ditemukan');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Film movie = widget.movie;
    return FutureBuilder<List<Jadwaltayang>>(
        future: jadwalTayang,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available')); // No data
          } else if (snapshot.data == null) {
            return Center(child: Text('No data available')); // No data
          } else {
            return Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Image.network(
                        '$urlGambar${movie.fotoFilm!}',
                        width: MediaQuery.of(context).size.width,
                        height: 500,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      left: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 35, 35, 35),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Stack(
                          children: [
                            MovieDescription(movie: movie),
                            const SizedBox(height: 20),
                            Positioned(
                              top: 240,
                              left: 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Wrap(
                                      spacing: 15.0,
                                      runSpacing: 8.0,
                                      children: List.generate(2, (index) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: index == 0
                                              ? Text(
                                                  "${movie.genre}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Text(
                                                  "${movie.durasi}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        );
                                      }),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (movie.status == 'Now Playing') ...[
                                    const Text(
                                      "Schedule",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Schedulewidget(
                                          jadwalTayang: snapshot.data!,
                                          onTimeSelected: handleSelectedDay),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TimeWidget(
                                          jadwalTayang: snapshot.data!,
                                          onTimeSelected: handleSelectedTime),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: cinemaTypeWidget(
                                          jadwalTayang: snapshot.data!,
                                          onTimeSelected: handleSelectedJenis),
                                    ),
                                  ] else ...[
                                    SizedBox(height: 20),
                                    Center(
                                      child: Text(
                                        "Movie is not available right now",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (movie.status == 'Now Playing') ...[
                              Positioned(
                                bottom: 280,
                                left: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      var selectedJadwal =
                                          cariJadwalTayang(snapshot.data!);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  selectSeatScreen(
                                                      movie: movie,
                                                      jadwalTayang:
                                                          selectedJadwal!)));
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 90, vertical: 15),
                                      child: Text(
                                        'Continue',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                    const BackButtonWidget(),
                  ],
                ),
              ),
            );
          }
        });
  }
}
