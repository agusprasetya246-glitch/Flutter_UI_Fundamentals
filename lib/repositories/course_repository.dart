import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  // Menerima CourseService melalui constructor (Dependency Injection)
  final CourseService service;

  CourseRepository(this.service);

  // Membuat method getCourses() sebagai API data sederhana bagi Provider
  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}
