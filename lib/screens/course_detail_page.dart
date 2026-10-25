import 'package:flutter/material.dart';

import '../models/course.dart';

import 'package:provider/provider.dart';

import '../providers/course_provider.dart';

import '../screens/course_form_page.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade600),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final bool isFavorite = courseProvider.favorites.contains(course.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Course'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              color: isFavorite ? Colors.pink.shade400 : Colors.grey.shade400,
            ),
            onPressed: () {
              context.read<CourseProvider>().toggleFavorite(course.code);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.indigo),
            tooltip: 'Edit Course',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseFormPage(initialCourse: course),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.indigo.shade50,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 80,
                    color: Colors.indigo.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    course.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn('Kode', course.code, Icons.qr_code),
                      _buildInfoColumn(
                        'SKS',
                        '${course.credits}',
                        Icons.star_border_rounded,
                      ),
                      _buildInfoColumn(
                        'Status',
                        course.status,
                        Icons.check_circle_outline,
                      ),
                    ],
                  ),
                  const Divider(height: 48, thickness: 1),
                  const Text(
                    'Tentang Mata Kuliah',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mata kuliah ${course.title} merupakan bagian dari kurikulum yang wajib diselesaikan.',
                    style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
