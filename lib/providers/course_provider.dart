// NIM: 2415051039 | Nama: Agus Prasetya
import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this.repository);

  final CourseRepository repository;

  List<Course> _courses = [];
  List<Course> get courses => _courses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Flag isSaving untuk mencegah submit ganda selama request berjalan
  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _error;
  String? get error => _error;

  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await repository.getCourses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Buat course melalui repository lalu refresh list dengan loadCourses()
  Future<void> createCourse(Course course) async {
    _isSaving = true;
    notifyListeners();

    try {
      await repository.createCourse(course);
      await loadCourses(); // ganti isi list dari server
    } finally {
      _isSaving = false;
      notifyListeners();
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

  // Tahap 7: Update course lalu refresh list dengan loadCourses()
  Future<void> updateCourse(int id, Course course) async {
    _isSaving = true;
    notifyListeners();

    try {
      await repository.updateCourse(id, course);
      await loadCourses();
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
