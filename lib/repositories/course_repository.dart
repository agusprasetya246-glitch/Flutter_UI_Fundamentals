// NIM: 2415051039 | Nama: Agus Prasetya
import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  CourseRepository(this.apiService);
  final CourseApiService apiService;

  Future<List<Course>> getCourses() async {
    return await apiService.getCourses();
  }

  // Tahap 6: Teruskan request POST ke CourseApiService
  Future<Course> createCourse(Course course) async {
    return await apiService.createCourse(course);
  }

  // Tahap 7: Teruskan request PUT ke CourseApiService
  Future<void> updateCourse(int id, Course course) async {
    await apiService.updateCourse(id, course);
  }

  // Tahap 8: Teruskan request DELETE ke CourseApiService
  Future<void> deleteCourse(int id) async {
    await apiService.deleteCourse(id);
  }
}
