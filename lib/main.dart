// NIM: 2415051039 | Nama: Agus Prasetya
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'screens/main_screen.dart';

const String studentName = 'Agus Prasetya';
const String studentId = '2415051039';

// 13. Konstanta apiUrl sesuai endpoint latihan
const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

// 14. Function asynchronous untuk memanggil HTTP GET (sementara)
Future<List<dynamic>> fetchCourses() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  }

  throw Exception('HTTP ${response.statusCode}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 15. Panggil fetchCourses() dan tampilkan jumlah item pada debugPrint
  try {
    final courses = await fetchCourses();
    debugPrint(
      '[$studentId - $studentName] HTTP GET Berhasil! Jumlah item course: ${courses.length}',
    );
  } catch (e) {
    debugPrint('[$studentId - $studentName] HTTP GET Gagal: $e');
  }

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
