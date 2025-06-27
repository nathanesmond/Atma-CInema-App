import 'package:flutter/material.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/screens/menuDetail.dart';
import 'package:tubez/entity/Menu.dart';

class Menus extends StatefulWidget {
  const Menus({
    super.key,
    required this.menuList,
  });

  final List<Menu> menuList;

  @override
  _MenusState createState() => _MenusState();
}

class _MenusState extends State<Menus> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = 0;
                });
              },
              child: Text(
                'Menu',
                style: TextStyle(
                  color: selectedTab == 0 ? Colors.white : Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = 1;
                });
              },
              child: Text(
                'Makanan',
                style: TextStyle(
                  color: selectedTab == 1 ? Colors.white : Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = 2;
                });
              },
              child: Text(
                'Minuman',
                style: TextStyle(
                  color: selectedTab == 2 ? Colors.white : Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          padding: EdgeInsets.all(16.0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: selectedMenu(widget.menuList).length,
          itemBuilder: (context, index) {
            final item = selectedMenu(widget.menuList)[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuDetailScreen(
                      itemMenu: item,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[900],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 170,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          '$urlGambar${item.fotoMenu!}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item.nama,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<Menu> selectedMenu(List<Menu> listMenu) {
    if (selectedTab == 1) {
      return listMenu.where((menu) => menu.jenis == 'makanan').toList();
    } else if (selectedTab == 2) {
      return listMenu.where((menu) => menu.jenis == 'minuman').toList();
    } else {
      return listMenu;
    }
  }

  // String getTitle(Menu item) {
  //   String itemTitle = '';

  //   if (selectedTab == 1) {
  //     itemTitle = item.makanan;
  //   } else if (selectedTab == 2) {
  //     itemTitle = item.minuman;
  //   } else {
  //     if (item.minuman.isEmpty) {
  //       itemTitle = item.makanan;
  //     } else if (item.makanan.isEmpty) {
  //       itemTitle = item.minuman;
  //     }
  //   }
  //   return itemTitle;
  // }
}
