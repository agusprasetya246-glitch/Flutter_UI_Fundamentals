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
      home: const Tahap6Page(), // Ubah ke Tahap6Page
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

// Halaman sementara untuk Tahap 2
class Tahap2Page extends StatelessWidget {
  const Tahap2Page({super.key});

  @override
  Widget build(BuildContext context) {
    // TAHAP 2: Membaca karakteristik layar menggunakan MediaQuery
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    // Menentukan kategori layout berdasarkan lebar
    final String layoutCategory = size.width < 600 ? 'Compact' : 'Wide';

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 2: MediaQuery')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '2415051039 - Agus Prasetya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              'Width: ${size.width.toStringAsFixed(0)} px',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Height: ${size.height.toStringAsFixed(0)} px',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Orientation: ${orientation.name}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: size.width < 600
                    ? Colors.blue.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Layout: $layoutCategory',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- TAHAP 3: Komponen Layout Sesuai Breakpoint ---

class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.phone_android, size: 80, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'COMPACT LAYOUT',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('< 600 px (Smartphone)'),
          SizedBox(height: 16),
          Text(
            '2415051039 - Agus Prasetya',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple.shade50,
      alignment: Alignment.center,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.tablet_mac, size: 80, color: Colors.purple),
          SizedBox(width: 24),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MEDIUM LAYOUT',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('600 - 839 px (Tablet Portrait)'),
              SizedBox(height: 16),
              Text(
                '2415051039 - Agus Prasetya',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal.shade50,
      alignment: Alignment.center,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.laptop_mac, size: 120, color: Colors.teal),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'EXPANDED LAYOUT',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text('>= 840 px (Desktop / Tablet Landscape)'),
              SizedBox(height: 24),
              Text(
                'NIM: 2415051039 | Nama: Agus Prasetya',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Halaman utama untuk Tahap 3
class Tahap3Page extends StatelessWidget {
  const Tahap3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3: Breakpoints')),
      // TAHAP 3: LayoutBuilder
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const CompactLayout(); // Panggil layar smartphone
          } else if (constraints.maxWidth < 840) {
            return const MediumLayout(); // Panggil layar tablet
          } else {
            return const ExpandedLayout(); // Panggil layar lebar
          }
        },
      ),
    );
  }
}

// Halaman sementara untuk Tahap 4
class Tahap4Page extends StatelessWidget {
  const Tahap4Page({super.key});

  // Fungsi helper untuk membuat kotak warna (panel)
  Widget buildBox(String text, Color color) {
    return Container(
      color: color,
      height: 100,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Daftar keahlian (skills)
    final List<String> skills = [
      'Dart',
      'Flutter',
      'UI/UX',
      'Git',
      'GitHub',
      'Firebase',
      'State Management',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 4: Expanded & Wrap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '2415051039 - Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 24),

            // TAHAP 4: Row dengan Expanded (Flex 2:1)
            const Text(
              '1. Expanded (Rasio Flex 2:1)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(flex: 2, child: buildBox('Panel A (2x)', Colors.blue)),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: buildBox('Panel B (1x)', Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // TAHAP 4: Wrap untuk kumpulan Chip
            const Text(
              '2. Widget Wrap',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0, // Jarak horizontal antar chip
              runSpacing: 8.0, // Jarak vertikal antar baris chip
              children: skills
                  .map(
                    (e) => Chip(
                      label: Text(e),
                      backgroundColor: Colors.blue.shade50,
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman sementara untuk Tahap 5
class Tahap5Page extends StatelessWidget {
  const Tahap5Page({super.key});

  // TAHAP 5: Fungsi penentu jumlah kolom berdasarkan breakpoint lebar layar
  int columnsFor(double width) {
    if (width < 600) return 1; // Compact -> 1 Kolom
    if (width < 840) return 2; // Medium -> 2 Kolom
    return 3; // Expanded -> 3 Kolom
  }

  @override
  Widget build(BuildContext context) {
    // Data statis (dummy) dari pertemuan sebelumnya
    final List<Map<String, dynamic>> courses = [
      {"code": "MOB01", "title": "Git & GitHub", "credits": 2},
      {"code": "MOB02", "title": "Dart Fundamentals", "credits": 2},
      {"code": "MOB03", "title": "Flutter UI", "credits": 3},
      {"code": "MOB04", "title": "Navigation", "credits": 2},
      {"code": "MOB05", "title": "State Management", "credits": 3},
      {"code": "MOB06", "title": "API & Database", "credits": 3},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 5: GridView Responsif')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Identitas
            const Text(
              '2415051039 - Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            // GridView dibungkus Expanded & LayoutBuilder
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnsFor(
                        constraints.maxWidth,
                      ), // Panggil fungsi penentu kolom
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3, // Mengatur rasio tinggi vs lebar agar kotak tidak terlalu tinggi
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Card(
                        elevation: 2,
                        color: Colors.blue.shade50,
                        child: ListTile(
                          title: Text(
                            course['title'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${course['code']} • ${course['credits']} SKS',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman sementara untuk Tahap 6
class Tahap6Page extends StatelessWidget {
  const Tahap6Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 6: Scroll & Keyboard')),
      // TAHAP 6: Membungkus Column dengan SingleChildScrollView
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '2415051039 - Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),

            // Elemen kosong untuk menghabiskan ruang layar
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Text('Profil Placeholder (Tinggi 400px)'),
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Text('Statistik Placeholder (Tinggi 200px)'),
            ),
            const SizedBox(height: 24),

            // TextField ini akan berada di bagian paling bawah
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ketik sesuatu di sini (Pancing Keyboard)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
