import 'package:flutter/material.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/entity/Menu.dart';
import 'package:tubez/screens/list.dart';
import 'package:tubez/widgets/MovieDetailWidgets/BackButton.dart';

class MenuDetailScreen extends StatefulWidget {
  final Menu itemMenu;

  MenuDetailScreen({
    required this.itemMenu,
  });

  @override
  _MenuDetailScreenState createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  late String ukuran;
  late Map<String, double> price;
  late Menu menus;

  @override
  void initState() {
    super.initState();
    ukuran = 'Kecil';
    menus = widget.itemMenu;
    price = {
      'Besar': menus.harga * 2.5,
      'Sedang': menus.harga * 2,
      'Kecil': menus.harga * 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      '$urlGambar${menus.fotoMenu}',
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
                  const BackButtonWidget(),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                color: Color.fromARGB(36, 158, 158, 158),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menus.nama,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      menus.deskripsi,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Ukuran',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: price.keys.map((size) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              ukuran = size;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: ukuran == size
                                  ? Colors.amber
                                  : Colors.transparent,
                              border: Border.all(
                                color: Colors.amber,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              size,
                              style: TextStyle(
                                color: ukuran == size
                                    ? Colors.black
                                    : Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ukuran: $ukuran',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          currencyFormatter.format(price[ukuran]),
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 22,
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
      ),
    );
  }
}
