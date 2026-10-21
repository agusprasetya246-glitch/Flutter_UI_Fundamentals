import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau state provider
    final courseProvider = context.watch<CourseProvider>();
    // Menyaring course yang kodenya ada di dalam set favorites
    final favoriteCourses = courseProvider.courses
        .where((course) => courseProvider.favorites.contains(course.code))
        .toList();

    if (favoriteCourses.isEmpty) {
      const emptyWidget = Center(
        child: Text(
          'Belum ada mata kuliah favorit.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
      return emptyWidget;
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: favoriteCourses.length,
      itemBuilder: (ctx, i) => CourseCard(course: favoriteCourses[i]),
    );
  }
}
