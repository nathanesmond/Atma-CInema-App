import 'package:flutter/material.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/screens/profile.dart';
import 'package:tubez/client/UserClient.dart';
import 'dart:convert';
import 'package:tubez/entity/User.dart';
import 'package:tubez/client/MenuClient.dart';
import 'package:tubez/screens/menuDetail.dart';
import 'package:tubez/entity/Menu.dart';

// ignore: must_be_immutable
class MenuHeader extends StatelessWidget {
  MenuHeader({
    super.key,
    required this.size,
    required this.user,
  });

  final Size size;
  User user;

  void handleUpdate(User updatedUser) {
    print('Selected Day: ${updatedUser}');
    user = updatedUser;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 24, right: 24),
      child: SizedBox(
        height: size.height / 14,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromARGB(36, 158, 158, 158),
              radius: 25,
              child: Image.asset(
                'assets/images/logo.png', // Sesuaikan dengan path logo Anda
                height: 50,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 36,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(vertical: 9),
                  ),
                  onSubmitted: (String searchText) async {
                    if (searchText.isNotEmpty) {
                      List<Menu> menus = await MenuClient.find(searchText);

                      if (menus.isNotEmpty) {
                        if (menus.length == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MenuDetailScreen(itemMenu: menus[0]),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Film ditemukan'),
                                content: Container(
                                  width: double.maxFinite,
                                  height: 300,
                                  child: ListView.builder(
                                    itemCount: menus.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8),
                                        leading: Image.network(
                                          '$urlGambar${menus[index].fotoMenu}',
                                          width: 50,
                                          height: 75,
                                          fit: BoxFit.cover,
                                        ),
                                        title: Text(menus[index].nama),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MenuDetailScreen(
                                                      itemMenu: menus[index]),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        // Show a "No film found" message if no menus are found
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Film tidak ada'),
                              content: const Text(
                                  'Maaf, film yang anda cari belum tayang atau tidak ada.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => profileScreen(updatedUser: handleUpdate)),
                );
              },
              child: CircleAvatar(
                radius: size.width / 16,
                backgroundImage: NetworkImage('$urlGambar/storage/${user.foto}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
