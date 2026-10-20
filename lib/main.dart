import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'course_provider.dart';
import 'models/course.dart';
import 'services/course_service.dart';

// Identitas Global
const String studentName = 'Agus Prasetya';
const String studentId = '2415051039';

void main() {
  runApp(
    // Membungkus seluruh aplikasi dengan Provider
    ChangeNotifierProvider(
      create: (_) => CourseProvider(), // Membuat instance dari CourseProvider
      child: const MyApp(), // MyApp kini berada "di bawah" asuhan Provider
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor:
            Colors.grey.shade50, // Warna background aplikasi
      ),
      home: const MainScreen(),
    );
  }
}

// ============================================================================
// KOMPONEN APLIKASI UTAMA
// ============================================================================

// ============================================================================
// TAHAP 3: LIFTING STATE UP & SINGLE SOURCE OF TRUTH
// ============================================================================

// --- COURSE CARD (Menggunakan Model Course) ---
class CourseCard extends StatelessWidget {
  final Course course; // <-- Sekarang bertipe Course, bukan Map lagi!

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final String courseCode = course.code;

    // 1. Gunakan watch() untuk memantau apakah course ini termasuk favorit
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
                      course.title, // <-- Menggunakan properti object Course
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          course.code, // <-- Menggunakan properti object Course
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
                            '${course.credits} SKS', // <-- Menggunakan properti object Course
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Menampilkan status dari model Course
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
              // 2. Gunakan read() pada tombol toggle favorite
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

// --- FEEDBACK FORM WIDGET ---
class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final _komentarController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.indigo),
              SizedBox(width: 8),
              Text('Konfirmasi'),
            ],
          ),
          content: const Text('Apakah Anda yakin ingin mengirim feedback ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                setState(() => _isLoading = true);

                await Future.delayed(
                  const Duration(seconds: 2),
                ); // Simulasi API

                if (mounted) {
                  setState(() => _isLoading = false);
                  _komentarController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Feedback berhasil dikirim!'),
                        ],
                      ),
                      backgroundColor: Colors.teal.shade600,
                    ),
                  );
                }
              },
              child: const Text('Ya, Kirim'),
            ),
          ],
        ),
      );
    }
  }

  InputDecoration _customInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.indigo.shade300),
      filled: true,
      fillColor: Colors.indigo.shade50.withValues(alpha: 0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.indigo.shade300, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kirim Feedback',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: studentName,
            readOnly: true,
            decoration: _customInputDecoration('Nama Lengkap', Icons.person),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: studentId,
            readOnly: true,
            decoration: _customInputDecoration(
              'Nomor Induk Mahasiswa',
              Icons.badge,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _komentarController,
            maxLines: 3,
            decoration: _customInputDecoration(
              'Tulis komentar Anda...',
              Icons.chat_bubble_outline,
            ),
            validator: (value) => (value == null || value.trim().length < 5)
                ? 'Komentar minimal 5 karakter'
                : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Kirim Feedback',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HALAMAN APLIKASI -
// ============================================================================

// --- 1. COURSE DETAIL PAGE ---
class CourseDetailPage extends StatelessWidget {
  final Course course; // <-- Sekarang bertipe Course!
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Course'),
        centerTitle: true,
        elevation: 0,
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

// --- 2. MAIN SCREEN / SHELL (Navigasi Utama) ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late Future<Map<String, dynamic>> _dataFuture;

  // Inisialisasi service kita
  final CourseService _courseService = CourseService();

  @override
  void initState() {
    super.initState();
    _dataFuture = _courseService.loadStudentData(); // Mengambil JSON

    _courseService.loadCourses().then((courses) {
      debugPrint('BERHASIL UJI SERVICE: Ditemukan ${courses.length} course!');
      for (var c in courses) {
        debugPrint(' - ${c.title} (${c.credits} SKS)');
      }
    });
  }

  // Fungsi penyusun isi layar berdasarkan tab yang aktif
  Widget _buildBody(Map<String, dynamic> data, BoxConstraints constraints) {
    final student = data['student'];
    final rawCourses = data['courses'] as List<dynamic>;
    final List<Course> courses = rawCourses
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();

    if (_currentIndex == 0) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
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
                          student['name'],
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
                            student['nim'],
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

            // Kartu Statistik (17. Menampilkan nilai konsisten)
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
      // TAB COURSES
      if (constraints.maxWidth < 600) {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: courses.length,
          itemBuilder: (ctx, i) => CourseCard(course: courses[i]),
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
          itemCount: courses.length,
          itemBuilder: (ctx, i) => CourseCard(course: courses[i]),
        );
      }
    } else {
      // TAB PROFILE
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
                    student['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    student['nim'],
                    style: TextStyle(color: Colors.indigo.shade100),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Padding(
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
          'Course Explorer',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.indigo),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error memuat data JSON'));
          }
          final data = snapshot.data!;

          return LayoutBuilder(
            builder: (context, constraints) {
              // Adaptive Navigation: Layar Lebar pakai samping (Rail), layar sempit pakai konten penuh (Nanti bar di bawah)
              if (constraints.maxWidth >= 840) {
                return Row(
                  children: [
                    NavigationRail(
                      backgroundColor: Colors.white,
                      selectedIndex: _currentIndex,
                      onDestinationSelected: (int index) =>
                          setState(() => _currentIndex = index),
                      labelType: NavigationRailLabelType.all,
                      selectedIconTheme: const IconThemeData(
                        color: Colors.indigo,
                      ),
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
                    Expanded(child: _buildBody(data, constraints)),
                  ],
                );
              } else {
                return _buildBody(data, constraints);
              }
            },
          );
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          // Bottom Navigation untuk smartphone
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

// ============================================================================
// TAHAP 2: EKSPERIMEN PROP DRILLING
// ============================================================================

class Tahap2ExperimentPage extends StatefulWidget {
  const Tahap2ExperimentPage({super.key});

  @override
  State<Tahap2ExperimentPage> createState() => _Tahap2ExperimentPageState();
}

class _Tahap2ExperimentPageState extends State<Tahap2ExperimentPage> {
  // 9. Gunakan satu nilai favorites pada parent.
  int _favoriteCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 2: Prop Drilling')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'NIM: 2415051039 | Nama: Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 32),
            const Text(
              'Parent (Pemilik State)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),

            // 10. Teruskan nilai ke dua child menggunakan constructor
            CourseSummaryDummy(favoriteCount: _favoriteCount),

            const SizedBox(height: 16),

            CourseListDummy(
              favoriteCount: _favoriteCount,
              // 11. Tambahkan callback dari child ke parent untuk mengubah favorites
              onFavoriteToggle: () {
                setState(() {
                  _favoriteCount++;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- CHILD 1: CourseSummary ---
class CourseSummaryDummy extends StatelessWidget {
  final int favoriteCount; // Menerima data dari Parent

  const CourseSummaryDummy({super.key, required this.favoriteCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Child 1: CourseSummary',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Favorit: $favoriteCount',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// --- CHILD 2: CourseList ---
class CourseListDummy extends StatelessWidget {
  final int favoriteCount; // Menerima data dari Parent
  final VoidCallback onFavoriteToggle; // Menerima fungsi (callback) dari Parent

  const CourseListDummy({
    super.key,
    required this.favoriteCount,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Child 2: CourseList',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Favorit di List: $favoriteCount',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onFavoriteToggle, // Memicu fungsi di Parent
              icon: const Icon(Icons.favorite),
              label: const Text('Tambah Favorit'),
            ),
          ],
        ),
      ),
    );
  }
}
// ============================================================================
// TAHAP 4: EKSPERIMEN VALUENOTIFIER VS SETSTATE
// ============================================================================

class Tahap4ValueNotifierPage extends StatefulWidget {
  const Tahap4ValueNotifierPage({super.key});

  @override
  State<Tahap4ValueNotifierPage> createState() =>
      _Tahap4ValueNotifierPageState();
}

class _Tahap4ValueNotifierPageState extends State<Tahap4ValueNotifierPage> {
  // 1. Deklarasi State biasa (Untuk setState)
  int _stateBiasa = 0;

  // 2. Deklarasi ValueNotifier
  final ValueNotifier<int> _stateNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    // ValueNotifier memakan memori, jadi WAJIB dibuang (dispose) saat halaman ditutup
    _stateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Perintah ini akan muncul di Terminal (Debug Console) setiap kali fungsi build() berjalan.
    debugPrint(' BUILD HALAMAN DIGAMBAR ULANG KESELURUHAN!');

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 4: ValueNotifier')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'NIM: 2415051039 | Nama: Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 40),

            // --- BAGIAN 1: MENGGUNAKAN SETSTATE ---
            const Text(
              '1. Menggunakan setState()',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            Text('Nilai: $_stateBiasa', style: const TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () {
                // Saat ditekan, ini akan memicu print('BUILD HALAMAN...') di terminal!
                setState(() {
                  _stateBiasa++;
                });
              },
              child: const Text('Tambah (setState)'),
            ),

            const SizedBox(height: 40),

            // --- BAGIAN 2: MENGGUNAKAN VALUENOTIFIER ---
            const Text(
              '2. Menggunakan ValueNotifier',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Ia HANYA akan menggambar ulang widget Text di dalamnya, tanpa memanggil ulang build() halaman!
            ValueListenableBuilder<int>(
              valueListenable: _stateNotifier,
              builder: (context, value, child) {
                return Text(
                  'Nilai: $value',
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),

            ElevatedButton(
              onPressed: () {
                // Perhatikan terminal, tidak akan ada tulisan ' BUILD HALAMAN...' yang muncul.
                _stateNotifier.value++;
              },
              child: const Text('Tambah (Notifier)'),
            ),
          ],
        ),
      ),
    );
  }
}
