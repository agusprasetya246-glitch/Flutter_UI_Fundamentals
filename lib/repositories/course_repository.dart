// NIM: 2415051039 | Nama: Agus Prasetya
import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  CourseRepository(this.apiService);
  final CourseApiService apiService;

  Future<List<Course>> getCourses() async {
    return await apiService.getCourses();
  }
}
