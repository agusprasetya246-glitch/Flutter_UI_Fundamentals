import 'package:flutter/material.dart';

// TAHAP 12: Import untuk JSON dan pembacaan asset lokal
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Agus Prasetya';
const String studentId = '2415051039';

// TAHAP 10: Tambahkan data collection ini
final List<Map<String, dynamic>> topics = [
  {'title': 'Git & GitHub', 'subtitle': 'Version control', 'done': true},
  {'title': 'Dart Fundamentals', 'subtitle': 'Language basics', 'done': true},
  {
    'title': 'Flutter UI Fundamentals',
    'subtitle': 'Widgets & layout',
    'done': false,
  },
  {
    'title': '$studentId - $studentName',
    'subtitle': 'Pemilik aplikasi',
    'done': false,
  },
  {
    'title': 'State Management',
    'subtitle': 'Data flow',
    'done': false,
  }, // Tambahan item agar bisa di-scroll
];

// TAHAP 12: Fungsi untuk membaca file JSON
Future<Map<String, dynamic>> loadStudentData() async {
  // Membaca file teks dari lokal asset
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
  // Mengubah teks string menjadi objek Map di Dart
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: Colors.blue.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: Colors.blue.shade700),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      home: const Tahap1Page(), // Ubah sementara ke sini
    );
  }
}

// TAHAP 9: Tambahkan StatefulWidget ini di bagian paling bawah file main.dart
class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final TextEditingController controller = TextEditingController();
  String message = 'Belum ada pesan';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 24), // Jarak dari atas
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Identitas wajib agar diverifikasi
            Text(
              '$studentId - $studentName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            // Kolom Input (TextField)
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Tuliskan sesuatu...',
              ),
            ),
            const SizedBox(height: 12),

            // Tombol
            ElevatedButton(
              onPressed: () {
                // Memanggil setState agar UI diperbarui
                setState(() {
                  message = controller.text.trim().isEmpty
                      ? 'Input masih kosong'
                      : controller.text.trim();
                });
              },
              child: const Text('Tampilkan'),
            ),
            const SizedBox(height: 12),

            // Hasil teks
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TAHAP 13: Membuat halaman Dashboard berbasis StatefulWidget
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Deklarasi variabel Future menggunakan 'late'
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    // Menginisialisasi pemanggilan data SATU KALI saja saat halaman dimuat
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Dashboard')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          // Menampilkan indikator loading saat menunggu data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Menampilkan pesan error jika JSON gagal dibaca/rusak
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          // Mengekstrak data JSON yang berhasil dimuat
          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          // Menampilkan data ke layar (Tahap 14: Integrasi UI Final)
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Profile / Identity Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpg',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student['name'] as String,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                student['nim'] as String,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.school,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Flutter Student',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Summary Row (Menggunakan fungsi buildStatCard dari MyApp)
                Row(
                  children: [
                    const MyApp().buildStatCard(
                      courses.length.toString(),
                      'Topik',
                      Icons.library_books,
                    ),
                    const SizedBox(width: 8),
                    // Menghitung jumlah SKS (credits) dari seluruh mata kuliah di JSON
                    const MyApp().buildStatCard(
                      courses
                          .fold(
                            0,
                            (sum, item) => sum + (item['credits'] as int),
                          )
                          .toString(),
                      'Total SKS',
                      Icons.star,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Judul List
                const Text(
                  'Daftar Materi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // 3. ListView.builder dengan Conditional UI
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index] as Map<String, dynamic>;
                      // Menentukan status selesai atau belum
                      final bool isDone = course['status'] == 'done';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: isDone
                                ? Colors.green.shade200
                                : Colors.orange.shade200,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isDone
                                ? Icons.check_circle
                                : Icons.play_circle_filled,
                            color: isDone ? Colors.green : Colors.orange,
                            size: 32,
                          ),
                          title: Text(
                            course['title'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${course['code']} • ${course['credits']} SKS',
                          ),
                          trailing: Text(
                            isDone ? 'Selesai' : 'Berjalan',
                            style: TextStyle(
                              color: isDone ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
// Praktikum Flutter UI Fundamentals Selesai.
// Menjawab Debugging Challenge Kasus A, B, C pada lembar laporan.

// Halaman sementara untuk Tahap 1
class Tahap1Page extends StatelessWidget {
  const Tahap1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 1: Masalah Layout')),
      body: Row(
        children: [
          // KODE BENAR: Menggunakan Expanded
          Expanded(
            child: Container(
              color: Colors.green.shade100,
              padding: const EdgeInsets.all(16),
              child: const Text(
                '2415051039 - Agus Prasetya',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
