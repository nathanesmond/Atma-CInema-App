import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubez/screens/login.dart';
import 'package:tubez/screens/splashScreen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  
      theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: const Color.fromARGB(115, 56, 55, 55)),
      home: const Splashscreen(),
    );
  }
}
