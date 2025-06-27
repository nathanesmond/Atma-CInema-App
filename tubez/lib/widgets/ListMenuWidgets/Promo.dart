import 'package:flutter/material.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/screens/PromoDetail.dart';
import 'package:tubez/entity/Menu.dart';
import 'package:tubez/entity/SpesialPromo.dart';

class Promo extends StatelessWidget {
  const Promo({
    super.key,
    required this.spesialPromoList,
    required this.menuList,
  });

  final List<SpesialPromo> spesialPromoList;
  final List<Menu> menuList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: spesialPromoList.length,
        itemBuilder: (context, index) {
          final promo = spesialPromoList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PromoDetailScreen(
                          itemPromo: promo,
                          itemMenu: getMenu(menuList, promo.id),
                        )),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: Image.network(
                        '$urlGambar${promo.fotoPromo}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
