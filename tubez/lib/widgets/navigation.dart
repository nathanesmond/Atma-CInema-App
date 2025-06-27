import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tubez/client/TransaksiClient.dart';
import 'package:tubez/network/tiket_repository.dart';
import 'package:tubez/screens/history.dart';
import 'package:tubez/screens/home.dart';
import 'package:tubez/screens/list.dart';
import 'package:tubez/screens/profile.dart';

class navigationBar extends StatefulWidget {
  final Map? data;
  const navigationBar({super.key, this.data});

  @override
  State<navigationBar> createState() => _navigationBarState();
}

class _navigationBarState extends State<navigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ListScreen(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        backgroundColor: const Color.fromARGB(255, 37, 36, 36),
        color: Colors.amber,
        activeColor: Colors.amber,
        tabBackgroundColor: const Color.fromARGB(255, 72, 60, 44),
        padding: const EdgeInsets.all(16),
        gap: 8,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(icon: Icons.list, text: 'Menu'),
          GButton(icon: Icons.bookmark, text: 'History'),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
