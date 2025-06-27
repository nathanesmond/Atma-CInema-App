import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/screens/spesialPromoDetail.dart';
import 'package:tubez/entity/Menu.dart';
import 'package:tubez/entity/SpesialPromo.dart';

class Spesialpromocarousel extends StatelessWidget {
  const Spesialpromocarousel({
    super.key,
    required this.spesialPromoList,
    required this.menuList,
  });

  final List<SpesialPromo> spesialPromoList;
  final List<Menu> menuList;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          autoPlay: true,
          height: 180.0,
          enlargeCenterPage: false,
          viewportFraction: 1),
      items: spesialPromoList.map((spesialPromo) {
        int? index = spesialPromo.id;
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SpesialPromoDetailScreen(
                          itemSpesial: spesialPromo,
                          itemMenu: getMenu(menuList, index),
                        )));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Image.network(
                      '$urlGambar${spesialPromo.fotoPromo}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Menu> getMenu(List<Menu> menuList, int? promoIndex) {
    List<Menu> menus = [];

    for (var i = 0; i < menuList.length; i++) {
      if (menuList[i].idSpesialPromo == promoIndex) {
        menus.add(menuList[i]);
      }
    }
    return menus;
  }
}
