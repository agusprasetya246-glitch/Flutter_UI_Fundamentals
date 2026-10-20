import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final String courseCode = course.code;
    final bool isFavorite = context.watch<CourseProvider>().favorites.contains(
      courseCode,
    );

    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(course: course),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 28,
                  color: Colors.indigo.shade400,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          course.code,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${course.credits} SKS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${course.status}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                ),
                color: isFavorite ? Colors.pink.shade400 : Colors.grey.shade400,
                onPressed: () {
                  context.read<CourseProvider>().toggleFavorite(courseCode);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
