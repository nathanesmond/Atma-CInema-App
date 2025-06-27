import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tubez/widgets/historyWidgets/historyHeader.dart';
import 'package:tubez/entity/History.dart';
import 'package:tubez/client/HistoryClient.dart';
import 'package:tubez/client/UserClient.dart';
import 'package:tubez/widgets/historyWidgets/isiHistory.dart';
import 'package:tubez/client/apiURL.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int? userId;
  Future<List<History>>? _historyFuture;

  Future<void> initializeData() async {
    await ambilToken();
    if (userId != null) {
      setState(() {
        _historyFuture = HistoryClient.fetchHistory();
      });
    }
  }

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
        print('Failed to load user data');
      }
    } else {
      print('Token is null');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HistoryHeader(),
      body: FutureBuilder<List<History>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Fetching History',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            List<History> historyList = snapshot.data!;
            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                History history = historyList[index];
                return IsiHistory(
                  image: history.transaksi?.pemesanan_tiket?.jadwal_tayang?.film
                              ?.fotoFilm !=
                          null
                      ? '$urlGambar${history.transaksi!.pemesanan_tiket!.jadwal_tayang!.film!.fotoFilm}'
                      : '$urlGambar/storage/profilepict/profile.jpg',
                  title: history.transaksi?.pemesanan_tiket?.jadwal_tayang?.film
                          ?.judul ??
                      'Unknown',
                  status: history.status ?? 'Unknown',
                  studio: history
                          .transaksi?.pemesanan_tiket?.jadwal_tayang?.studio?.id
                          ?.toInt() ??
                      0,
                  date: history.transaksi?.pemesanan_tiket?.jadwal_tayang
                          ?.tanggalTayang
                          .toString() ??
                      'Unknown Date',
                  total: 'Rp ${history.transaksi?.totalHarga ?? 0}',
                  isReview: history.isReview ?? false,
                  ticketCount:
                      history.transaksi?.pemesanan_tiket?.countTiket ?? 0,
                  idFilm: history
                      .transaksi!.pemesanan_tiket!.jadwal_tayang!.film!.id,
                  idHistory: history.id!,
                );
              },
            );
          }
        },
      ),
    );
  }
}
