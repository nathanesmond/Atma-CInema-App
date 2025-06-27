import 'package:flutter/material.dart';

class HistoryHeader extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  HistoryHeader({Key? key})
      : preferredSize = Size.fromHeight(110.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 110,
      backgroundColor: Color(0xFF272726),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(36, 158, 158, 158),
            radius: 30,
            child: Image.asset(
              'assets/images/logo.png',
              height: 60,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          const Text(
            'History',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
