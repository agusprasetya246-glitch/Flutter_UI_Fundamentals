// NIM: 2415051039 | Nama: Agus Prasetya
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/main_screen.dart';
import 'services/course_api_service.dart'; // Ganti service lama dengan API service

const String studentName = 'Agus Prasetya';
const String studentId = '2415051039';

// Base URL sesuai koleksi Postman
const String apiBaseUrl = 'https://course-api-pearl.vercel.app';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi arsitektur: Service -> Repository -> Provider
  final apiService = CourseApiService(apiBaseUrl);
  final courseRepository = CourseRepository(apiService);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(courseRepository)..loadCourses(),
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
      title: 'Course Data Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
    );
  }
}
