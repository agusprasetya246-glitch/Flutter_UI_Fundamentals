import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/feedback_form.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  Widget _buildBody(BoxConstraints constraints) {
    // Data Mahasiswa dari Global Identitas
    final student = {'name': studentName, 'nim': studentId};
    final courseProvider = context.watch<CourseProvider>();
    final List<Course> courses = courseProvider.courses;

    if (_currentIndex == 0) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade600, Colors.indigo.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.indigo.shade200,
                      backgroundImage: const AssetImage(
                        'assets/images/profile.jpg',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo,',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.indigo.shade100,
                          ),
                        ),
                        Text(
                          student['name']!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            student['nim']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Ringkasan Belajar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.library_books_rounded,
                            color: Colors.orange.shade400,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${courses.length}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const Text(
                          'Total Topik',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: Colors.pink.shade400,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Consumer<CourseProvider>(
                          builder: (context, provider, child) {
                            return Text(
                              '${provider.favorites.length}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            );
                          },
                        ),
                        const Text(
                          'Total Favorit',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (_currentIndex == 1) {
      return Consumer<CourseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.indigo),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Text(
                'Terjadi Kesalahan:\n${provider.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final coursesList = provider.courses;
          if (coursesList.isEmpty) {
            return const Center(child: Text('Tidak ada data mata kuliah.'));
          }

          if (constraints.maxWidth < 600) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: coursesList.length,
              itemBuilder: (ctx, i) => CourseCard(course: coursesList[i]),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: coursesList.length,
              itemBuilder: (ctx, i) => CourseCard(course: coursesList[i]),
            );
          }
        },
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 24),
              decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    student['name']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    student['nim']!,
                    style: TextStyle(color: Colors.indigo.shade100),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(24),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: FeedbackForm(),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Course Explorer v2',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 840) {
            return Row(
              children: [
                NavigationRail(
                  backgroundColor: Colors.white,
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (int index) =>
                      setState(() => _currentIndex = index),
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(color: Colors.indigo),
                  selectedLabelTextStyle: const TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school_rounded),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: Colors.black12,
                ),
                Expanded(child: _buildBody(constraints)),
              ],
            );
          } else {
            return _buildBody(constraints);
          }
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 840) {
            return NavigationBar(
              backgroundColor: Colors.white,
              elevation: 10,
              shadowColor: Colors.black45,
              indicatorColor: Colors.indigo.shade100,
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) =>
                  setState(() => _currentIndex = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded, color: Colors.indigo),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.school_outlined),
                  selectedIcon: Icon(
                    Icons.school_rounded,
                    color: Colors.indigo,
                  ),
                  label: 'Courses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(
                    Icons.person_rounded,
                    color: Colors.indigo,
                  ),
                  label: 'Profile',
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
