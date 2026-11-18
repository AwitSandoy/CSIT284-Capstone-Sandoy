import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MandelaApp());
}

class MandelaApp extends StatelessWidget {
  const MandelaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandela Timetable Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}