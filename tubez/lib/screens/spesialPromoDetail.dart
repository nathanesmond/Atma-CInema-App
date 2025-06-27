import 'package:flutter/material.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/entity/Menu.dart';
import 'package:tubez/entity/SpesialPromo.dart';
import 'package:tubez/screens/list.dart';

class SpesialPromoDetailScreen extends StatefulWidget {
  final SpesialPromo itemSpesial;
  final List<Menu> itemMenu;

  SpesialPromoDetailScreen({
    required this.itemSpesial,
    required this.itemMenu,
  });

  @override
  _SpesialPromoDetailScreenState createState() =>
      _SpesialPromoDetailScreenState();
}

class _SpesialPromoDetailScreenState extends State<SpesialPromoDetailScreen> {
  late SpesialPromo spesial;
  late List<Menu> menus;
  late List<String> terms;

  @override
  void initState() {
    super.initState();
    spesial = widget.itemSpesial;
    menus = widget.itemMenu;
    terms = spesial.ketentuan.split('.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Positioned.fill(
                  //tampil foto spesialnya-_-
                  child: Image.network(
                    '$urlGambar${spesial.fotoPromo}',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Color.fromARGB(36, 158, 158, 158),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //tampil nama/judul spesialnya-_-
                  Text(
                    spesial.judul,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  //tampil deskripsi spesialnya-_-
                  Text(
                    deskripsiSpesial(menus),
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Syarat dan Ketentuan:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  //Tampil setiap ketentuan-_-
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: terms.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Expanded(
                              child: Text(
                                terms[index], //ini ketentuannya-_-
                                style: TextStyle(
                                    color: Colors.grey[300], fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Berlaku sampai dengan ${spesial.tanggalBerlaku}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        currencyFormatter.format(spesial.harga),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBulletPoint(String text) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '• ',
  //           style: TextStyle(color: Colors.white, fontSize: 16),
  //         ),
  //         Expanded(
  //           child: Text(
  //             text,
  //             style: TextStyle(color: Colors.grey[300], fontSize: 16),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String deskripsiSpesial(List<Menu> menuList) {
    String deskripsi = '';

    for (var i = 0; i < menuList.length; i++) {
      if (i != 0) {
        deskripsi += ' + ';
      }
      deskripsi += menuList[i].nama;
    }
    return deskripsi;
  }
}
