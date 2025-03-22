import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';
import 'package:listify/pages/completed_tasks_page.dart';
import 'package:listify/pages/home_page.dart';
import 'package:listify/pages/scheduled_tasks_page.dart';
import 'package:listify/utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Archivo',
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: tdBlue, // Default cursor color for all text fields
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: _routes(),
    );
  }

  Map<String, Widget Function(BuildContext)> _routes() {
    return {
      AppRoutes.home: (context) => const HomePage(),
      AppRoutes.scheduledTasks: (context) => const ScheduledTasksPage(),
      AppRoutes.completedTasks: (context) => const CompletedTasksPage(),
    };
  }
}
