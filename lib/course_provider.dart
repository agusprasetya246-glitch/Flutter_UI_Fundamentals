import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';
import '../services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  // 1. Menyiapkan repository melalui dependency injection sederhana
  final CourseRepository repository = CourseRepository(CourseService());

  // 2. Collection untuk favorites
  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  // 3. Menyimpan daftar course hasil dari repository
  List<Course> _courses = [];
  List<Course> get courses => _courses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 4. Method untuk memuat data via Repository (Poin 45: Provider memanggil repository, bukan rootBundle)
  Future<void> loadCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Memanggil repository, bersih dari urusan rootBundle/jsonDecode!
      _courses = await repository.getCourses();
    } catch (e) {
      debugPrint('Error loading courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method toggle favorite seperti biasa
  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }
}
