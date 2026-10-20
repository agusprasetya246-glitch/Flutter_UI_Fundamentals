import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/course.dart';

// ============================================================================
// TAHAP 9: COURSE SERVICE (Data Source)
// Identitas: 2415051039 - Agus Prasetya
// ============================================================================

class CourseService {
  // Membaca asset JSON dan mengembalikan dalam bentuk List<Course>
  Future<Map<String, dynamic>> loadStudentData() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    return data;
  }

  Future<List<Course>> loadCourses() async {
    final data = await loadStudentData();
    final list = data['courses'] as List<dynamic>;
    return list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }
}
