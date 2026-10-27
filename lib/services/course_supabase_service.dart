// NIM: 2415051039 | Nama: Agus Prasetya
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    // Ambil data dari tabel courses dengan query SELECT terurut id
    final data = await supabase.from('courses').select().order('id');

    // Konversi response menjadi List<Course>
    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Tahap 13: Ganti stub createCourse pada CourseSupabaseService
  @override
  Future<Course> createCourse(Course course) async {
    final row = await supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(row);
  }

  // Tahap 14: Ganti stub updateCourse pada CourseSupabaseService
  @override
  Future<void> updateCourse(int id, Course course) async {
    await supabase.from('courses').update(course.toJson()).eq('id', id);
  }

  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}
