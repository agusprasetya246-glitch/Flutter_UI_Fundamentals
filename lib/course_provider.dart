import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';
import '../services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  // 1. Menyiapkan repository melalui dependency injection sederhana
  final CourseRepository repository = CourseRepository(CourseService());

  List<Course> _courses = [];
  List<Course> get courses => _courses;

  // Status Async State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  // Implementasikan loadCourses()
  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 5));

    try {
      _courses = await repository.getCourses();
    } catch (e) {
      _error = e.toString(); // Menangkap pesan jika terjadi error
    } finally {
      _isLoading = false;
      notifyListeners(); // Mengabari UI bahwa proses telah selesai (Success atau Error)
    }
  }

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }
}
