import 'package:flutter/material.dart';
import 'package:flutter_menu/menu.dart';

import 'main_page.dart';

void main() {
  runApp(const PeppeApp());
}

class PeppeApp extends StatelessWidget {
  const PeppeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peppe Pizzeria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
      ),
      home: const MainPage(),
    );
  }
}
