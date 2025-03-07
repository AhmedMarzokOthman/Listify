import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listify/screens/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
