import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'screens/main_screen.dart';

const String studentName = 'Agus Prasetya';
const String studentId = '2415051039';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer v2',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
      home: const MainScreen(),
    );
  }
}
