import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tubez/widgets/ListMenuWidgets/menuHeader.dart';
import 'package:tubez/widgets/ListMenuWidgets/PromoHeader.dart';
import 'package:tubez/widgets/ListMenuWidgets/Menus.dart';
import 'package:tubez/widgets/ListMenuWidgets/SpesialPromoCarousel.dart';
import 'package:tubez/widgets/ListMenuWidgets/Promo.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tubez/entity/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:tubez/entity/User.dart';
import 'package:tubez/client/MenuClient.dart';
import 'package:tubez/entity/Menu.dart';
import 'package:tubez/client/SpesialPromoClient.dart';
import 'package:tubez/entity/SpesialPromo.dart';
import 'package:tubez/client/UserClient.dart';
import 'package:intl/intl.dart';

final themeMode = ValueNotifier(2);

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

NumberFormat currencyFormatter = NumberFormat.currency(
  locale: 'id',
  decimalDigits: 0,
  name: 'Rp ',
  symbol: 'Rp ',
);

class _ListScreenState extends State<ListScreen> {
  int? userId;
  User user = User(email: '', id: 0, username: '', password: '', noTelepon: '', tanggalLahir: '', foto: '');
  Iterable<SpesialPromo> spesialPromoList = [];
  Iterable<Menu> menuList = [];
  int selectedTab = 0;
  late Future<void> dataMakanan = Future.value([]);

  @override
  void initState() {
    super.initState();
    ambilToken(); // Memanggil ambilToken() saat screen pertama kali dimuat
    super.initState();
    
  }

  Future<void> ambilToken() async {
    UserClient userClient = UserClient();
    String? token = await userClient.getToken();

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
    }else{
        final response = await userClient.dataUser(token);

        if (response.statusCode == 200) {
          // Mengambil data dari response body
          var data = json.decode(response.body);
          user = User.fromJson(data['data']);

          setState(() {
            userId = user.id; // Menyimpan userId di state
            dataMakanan = fetchAllData();
          });

          print('User ID: $userId');
          print('Nama User: ${user.username}');
        } else {
          print('Failed to load user data');
        }
    }
  }

  Future<void> fetchAllData() async {
    try {
      print('Test : ${user.email}');
      final dataMenu = await MenuClient.fetchAll();
      final dataPromo = await SpesialPromoClient.fetchAll();

      if(dataMenu.isEmpty || dataPromo.isEmpty){
        throw Exception('Data is empty');
      }

      setState(() {
        menuList = dataMenu;
        spesialPromoList = dataPromo;
      });

    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            MenuHeader(size: size, user: user),
            Expanded(
              child: FutureBuilder<void>(
                future: dataMakanan,
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
                  } else if (menuList.isEmpty || spesialPromoList.isEmpty) {
                    return Center(
                      child: Text(
                        'Fetching Data',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    );
                  }else{
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(left: 12),
                            child: const Text(
                              "Today's Special Offer!",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Spesialpromocarousel(spesialPromoList: getSpesialPromoList(spesialPromoList.toList(), 'spesial'), menuList: menuList.toList()),
                          const SizedBox(height: 20),
                          const PromoHeader(),
                          const SizedBox(height: 20),
                          Promo(spesialPromoList: getSpesialPromoList(spesialPromoList.toList(), 'promo'), menuList: menuList.toList()),
                          const SizedBox(height: 20),
                          Menus(menuList: menuList.toList()),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  } 
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SpesialPromo> getSpesialPromoList(List<SpesialPromo> spesialPromoList, String status){
    List<SpesialPromo> spesialList = [];

    for (var i = 0; i < spesialPromoList.length; i++) {
      if(spesialPromoList[i].status == status){
        spesialList.add(spesialPromoList[i]);
      }
    }

    return spesialList;
  }
}
