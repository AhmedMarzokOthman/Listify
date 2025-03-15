import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';
import 'package:listify/model/todo.dart';
import 'package:listify/screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TodoAdapter());

  await Hive.openBox<Todo>("todo_database");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: tdBlue,
          selectionColor: tdBlue.withOpacity(0.3),
          selectionHandleColor: tdBlue,
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
