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
      home: const Tahap15ResponsiveShell(), // UBAH KE SINI
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
// --- TAHAP 7: Navigasi Dasar ---

// Halaman Pertama (Home)
class Tahap7HomePage extends StatelessWidget {
  const Tahap7HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 7: Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '2415051039 - Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TAHAP 7: Menggunakan Navigator.push untuk pindah ke halaman detail
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Tahap7DetailPage(),
                  ),
                );
              },
              child: const Text('Buka Detail Page'),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Kedua (Detail)
class Tahap7DetailPage extends StatelessWidget {
  const Tahap7DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 7: Detail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '2415051039 - Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text('Ini adalah Halaman Detail'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TAHAP 7: Menggunakan Navigator.pop untuk kembali ke halaman sebelumnya
                Navigator.pop(context);
              },
              child: const Text('Kembali (Pop)'),
            ),
          ],
        ),
      ),
    );
  }
}
// --- TAHAP 8: Passing Data ---

// Halaman Penerima Data (Detail)
class Tahap8DetailPage extends StatelessWidget {
  final Map<String, dynamic> course; // Variabel penampung data

  const Tahap8DetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course['title'] as String)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identitas Mahasiswa wajib ada di detail
            const Text(
              '2415051039 - Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const Divider(),
            const SizedBox(height: 16),

            // Menampilkan data yang ditangkap
            Text(
              course['title'] as String,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Kode: ${course['code']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Bobot: ${course['credits']} SKS',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),

            // Tombol kembali (Tahap 7)
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali ke Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Pengirim Data (List) menggunakan JSON
class Tahap8ListPage extends StatefulWidget {
  const Tahap8ListPage({super.key});

  @override
  State<Tahap8ListPage> createState() => _Tahap8ListPageState();
}

class _Tahap8ListPageState extends State<Tahap8ListPage> {
  // Variabel penampung data Future
  late Future<Map<String, dynamic>> dataFuture;

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi global yang sudah Anda buat di atas
    dataFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 8: Passing Data (JSON)')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'NIM: 2415051039 | Nama: Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: dataFuture,
              builder: (context, snapshot) {
                // Menangani state loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Menangani error jika JSON gagal dimuat
                if (snapshot.hasError) {
                  return const Center(child: Text('Error memuat data JSON'));
                }

                // Mengekstrak array 'courses' dari objek JSON
                final courses = snapshot.data!['courses'] as List<dynamic>;

                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          course['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${course['code']} • ${course['credits']} SKS',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TAHAP 8: Melempar data spesifik JSON ke halaman detail
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Tahap8DetailPage(course: course),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// --- TAHAP 9: Returning Data ---

// Halaman Penerima Data & Pengirim Nilai Balik (Detail)
class Tahap9DetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const Tahap9DetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course['title'] as String)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '2415051039 - Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              course['title'] as String,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Kode: ${course['code']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Bobot: ${course['credits']} SKS',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),

            // TAHAP 9: Tombol Favorite yang mengirim nilai true saat pop
            ElevatedButton.icon(
              onPressed: () {
                // Mengirim data balik (true) ke halaman sebelumnya
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.favorite),
              label: const Text('Pilih / Favorite'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade50,
                foregroundColor: Colors.pink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Pengirim Data & Penerima Nilai Balik (List)
class Tahap9ListPage extends StatefulWidget {
  const Tahap9ListPage({super.key});

  @override
  State<Tahap9ListPage> createState() => _Tahap9ListPageState();
}

class _Tahap9ListPageState extends State<Tahap9ListPage> {
  late Future<Map<String, dynamic>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 9: Returning Data')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'NIM: 2415051039 | Nama: Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error memuat data JSON'));
                }

                final courses = snapshot.data!['courses'] as List<dynamic>;

                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          course['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${course['code']} • ${course['credits']} SKS',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          // TAHAP 9: Menunggu hasil dari halaman detail menggunakan 'await'
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Tahap9DetailPage(course: course),
                            ),
                          );

                          // TAHAP 9: Menampilkan SnackBar jika result == true
                          // context.mounted digunakan untuk memastikan halaman tidak di-destroy saat menunggu
                          if (result == true && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${course['title']} berhasil ditambahkan ke Favorite!',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// --- TAHAP 10: NavigationBar (Dinamis dari JSON) ---

class Tahap10MainScreen extends StatefulWidget {
  const Tahap10MainScreen({super.key});

  @override
  State<Tahap10MainScreen> createState() => _Tahap10MainScreenState();
}

class _Tahap10MainScreenState extends State<Tahap10MainScreen> {
  int currentIndex = 0;
  late Future<Map<String, dynamic>> dataFuture;

  @override
  void initState() {
    super.initState();
    // Memuat data JSON saat halaman pertama kali dibuka
    dataFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 10: NavigationBar')),

      // Menggunakan FutureBuilder untuk membungkus halaman tab
      body: FutureBuilder<Map<String, dynamic>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error memuat data JSON'));
          }

          // Mengekstrak data JSON
          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          // Menyusun daftar halaman secara dinamis menggunakan data JSON
          final List<Widget> pages = [
            // Tab 0: Home (Menampilkan Identitas dari JSON)
            Center(
              child: Text(
                'Halaman Home\n${student['nim']} - ${student['name']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Tab 1: Courses (Menampilkan Daftar ListView dari JSON)
            ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.book, color: Colors.blue),
                    title: Text(
                      course['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${course['code']} • ${course['credits']} SKS',
                    ),
                  ),
                );
              },
            ),

            // Tab 2: Profile (Menampilkan Profil dari JSON)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    student['name'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'NIM: ${student['nim']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ];

          // Menampilkan halaman sesuai indeks yang dipilih di bottom navigation
          return pages[currentIndex];
        },
      ),

      // Bottom Navigation Bar tetap sama
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
// --- TAHAP 11: Adaptive Navigation (NavigationBar vs NavigationRail) ---

class Tahap11MainScreen extends StatefulWidget {
  const Tahap11MainScreen({super.key});

  @override
  State<Tahap11MainScreen> createState() => _Tahap11MainScreenState();
}

class _Tahap11MainScreenState extends State<Tahap11MainScreen> {
  int currentIndex = 0;
  late Future<Map<String, dynamic>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = loadStudentData(); // Mengambil data dari JSON
  }

  // Fungsi helper untuk membangun konten utama (pages)
  Widget _buildContent(Map<String, dynamic> data) {
    final student = data['student'] as Map<String, dynamic>;
    final courses = data['courses'] as List<dynamic>;

    final List<Widget> pages = [
      Center(
        child: Text(
          'Home\n${student['nim']} - ${student['name']}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.school),
              title: Text(course['title']),
              subtitle: Text('${course['code']} • ${course['credits']} SKS'),
            ),
          );
        },
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            Text(
              student['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('NIM: ${student['nim']}'),
          ],
        ),
      ),
    ];

    return pages[currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 11: Adaptive Navigation')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return const Center(child: Text('Error memuat data JSON'));

          final data = snapshot.data!;

          // TAHAP 11: LayoutBuilder untuk menentukan bentuk navigasi
          return LayoutBuilder(
            builder: (context, constraints) {
              // Jika layar lebar (Expanded/Tablet/Desktop), gunakan NavigationRail di samping
              if (constraints.maxWidth >= 840) {
                return Row(
                  children: [
                    NavigationRail(
                      selectedIndex: currentIndex,
                      onDestinationSelected: (int index) =>
                          setState(() => currentIndex = index),
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.school),
                          label: Text('Courses'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person),
                          label: Text('Profile'),
                        ),
                      ],
                    ),
                    const VerticalDivider(
                      thickness: 1,
                      width: 1,
                    ), // Garis pemisah vertikal
                    Expanded(
                      child: _buildContent(data),
                    ), // Konten mengisi sisa ruang
                  ],
                );
              }
              // Jika layar sempit (Compact/Medium/Phone), gunakan UI default Scaffold dengan NavigationBar di bawah
              else {
                return _buildContent(data); // Body hanya berisi konten
              }
            },
          );
        },
      ),

      // Menampilkan Bottom NavigationBar HANYA jika layarnya bukan layar lebar (< 840)
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 840) {
            return NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (int index) =>
                  setState(() => currentIndex = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(
                  icon: Icon(Icons.school),
                  label: 'Courses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            );
          }
          return const SizedBox.shrink(); // Sembunyikan bottom bar jika layar lebar
        },
      ),
    );
  }
}
// --- TAHAP 12: User Interaction & Feedback ---

// 1. Membuat widget kartu khusus yang memiliki state (untuk status favorite)
class InteractiveCourseCard extends StatefulWidget {
  final Map<String, dynamic> course;

  const InteractiveCourseCard({super.key, required this.course});

  @override
  State<InteractiveCourseCard> createState() => _InteractiveCourseCardState();
}

class _InteractiveCourseCardState extends State<InteractiveCourseCard> {
  // State boolean untuk tombol favorite (Syarat 48)
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // clipBehavior penting agar efek ripple dari InkWell tidak bocor keluar sudut Card
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Syarat 47: Aksi tap pada CourseCard (Efek Ripple)
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Anda menekan: ${widget.course['title']}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        // Syarat 50: Gesture lain (Long Press) untuk menampilkan informasi
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Informasi Detail'),
              content: Text(
                'Mata Kuliah: ${widget.course['title']}\nKode: ${widget.course['code']}\nBobot: ${widget.course['credits']} SKS',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.book, size: 32, color: Colors.blue),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${widget.course['code']} • ${widget.course['credits']} SKS',
                    ),
                  ],
                ),
              ),
              // Syarat 48 & 49: Tombol Favorite dengan icon berubah
              IconButton(
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border, // Ganti icon
                  color: isFavorite ? Colors.red : Colors.grey, // Ganti warna
                ),
                onPressed: () {
                  // Mengubah state dan merender ulang UI
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. Membuat Halaman Utama untuk Tahap 12
class Tahap12Page extends StatefulWidget {
  const Tahap12Page({super.key});

  @override
  State<Tahap12Page> createState() => _Tahap12PageState();
}

class _Tahap12PageState extends State<Tahap12Page> {
  late Future<Map<String, dynamic>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = loadStudentData(); // Mengambil data dari JSON
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 12: Interaksi')),
      body: Column(
        children: [
          // Identitas agar terlihat di screenshot
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'NIM: 2415051039 | Nama: Agus Prasetya',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError)
                  return const Center(child: Text('Error memuat data'));

                final courses = snapshot.data!['courses'] as List<dynamic>;

                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    // Memanggil widget interaktif yang baru dibuat
                    return InteractiveCourseCard(course: course);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// --- TAHAP 13: Form Input dan Validasi ---

class Tahap13Page extends StatefulWidget {
  const Tahap13Page({super.key});

  @override
  State<Tahap13Page> createState() => _Tahap13PageState();
}

class _Tahap13PageState extends State<Tahap13Page> {
  // TAHAP 13: Identifier unik untuk mengontrol dan memvalidasi Form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk menangkap teks input komentar
  final TextEditingController _komentarController = TextEditingController();

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 13: Form Validasi')),
      // Menggunakan SingleChildScrollView agar layar bisa di-scroll saat keyboard muncul
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // Memasang kunci pada form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Form Feedback',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // 1. Field Nama (Terisi otomatis)
              TextFormField(
                initialValue: studentName, // Mengambil dari konstanta global
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Nama wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Field NIM (Terisi otomatis)
              TextFormField(
                initialValue: studentId, // Mengambil dari konstanta global
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'NIM wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Field Komentar (Kosong)
              TextFormField(
                controller: _komentarController,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                // Validasi khusus untuk Komentar
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Komentar wajib diisi';
                  } else if (value.trim().length < 5) {
                    return 'Komentar minimal 5 karakter'; // Syarat 53
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Tombol Submit
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TAHAP 13: Menjalankan validasi form saat tombol ditekan
                    if (_formKey.currentState!.validate()) {
                      // Jika semua return validator adalah null (lolos validasi)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Feedback dari $studentName terkirim!\nKomentar: ${_komentarController.text}',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Kirim Feedback',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// --- TAHAP 14: SnackBar, Dialog, dan Loading Feedback ---

class Tahap14Page extends StatefulWidget {
  const Tahap14Page({super.key});

  @override
  State<Tahap14Page> createState() => _Tahap14PageState();
}

class _Tahap14PageState extends State<Tahap14Page> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _komentarController = TextEditingController();

  // TAHAP 14: State boolean untuk mengontrol tampilan loading
  bool _isLoading = false;

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  // TAHAP 14: Fungsi untuk memproses pengiriman data (Syarat 56 & 57)
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Syarat 56: Menampilkan AlertDialog sebelum aksi penting
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Konfirmasi Pengiriman'),
            content: const Text(
              'Apakah Anda yakin ingin mengirim feedback ini? Data tidak dapat diubah setelah dikirim.',
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext), // Batal dan tutup dialog
                child: const Text('Batal', style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Tutup dialog terlebih dahulu
                  Navigator.pop(dialogContext);

                  // Syarat 57: Simulasi loading (Update state menjadi true)
                  setState(() {
                    _isLoading = true;
                  });

                  // Menunggu 2 detik (simulasi koneksi internet)
                  await Future.delayed(const Duration(seconds: 2));

                  // Mengembalikan state loading ke false jika widget masih aktif
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });

                    // Bersihkan form
                    _komentarController.clear();

                    // Syarat 55: Menampilkan SnackBar setelah aksi selesai dan valid
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Terima kasih, $studentName! Feedback berhasil disimpan.',
                        ),
                        backgroundColor: Colors.green,
                        behavior:
                            SnackBarBehavior.floating, // Tampilan melayang
                      ),
                    );
                  }
                },
                child: const Text('Ya, Kirim'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 14: UX Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Form Feedback Akhir',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              TextFormField(
                initialValue: studentName,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Nama tidak perlu diedit
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: studentId,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // NIM tidak perlu diedit
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _komentarController,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Komentar wajib diisi';
                  if (value.trim().length < 5)
                    return 'Komentar minimal 5 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Tombol Submit dengan Conditional Rendering untuk Loading
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // Jika sedang loading, tombol tidak bisa ditekan (null)
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      // Syarat 57: Tampilkan CircularProgressIndicator jika loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : const Text(
                          'Kirim Feedback',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ============================================================================
// TAHAP 15: MINI PROJECT INTEGRASI (RESPONSIVE COURSE EXPLORER)
// ============================================================================

// --- REUSABLE WIDGET 1: Course Card (Polished) ---
class Tahap15CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;
  const Tahap15CourseCard({super.key, required this.course});

  @override
  State<Tahap15CourseCard> createState() => _Tahap15CourseCardState();
}

class _Tahap15CourseCardState extends State<Tahap15CourseCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
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
              builder: (context) =>
                  Tahap15CourseDetailPage(course: widget.course),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Ikon dengan latar belakang melingkar yang lembut
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
                      widget.course['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Menggunakan Chip kecil untuk SKS
                    Row(
                      children: [
                        Text(
                          widget.course['code'],
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
                            '${widget.course['credits']} SKS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
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
                onPressed: () => setState(() => isFavorite = !isFavorite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- REUSABLE WIDGET 2: Feedback Form (Polished) ---
class Tahap15FeedbackForm extends StatefulWidget {
  const Tahap15FeedbackForm({super.key});

  @override
  State<Tahap15FeedbackForm> createState() => _Tahap15FeedbackFormState();
}

class _Tahap15FeedbackFormState extends State<Tahap15FeedbackForm> {
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
                await Future.delayed(const Duration(seconds: 2));
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

  // Dekorasi khusus untuk input form yang lebih elegan
  InputDecoration _customInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.indigo.shade300),
      filled: true,
      fillColor: Colors.indigo.shade50.withOpacity(0.5),
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

// --- HALAMAN DETAIL (Polished) ---
class Tahap15CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  const Tahap15CourseDetailPage({super.key, required this.course});

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
            // Banner Header
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
                    course['title'],
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
            // Konten Detail
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn('Kode', course['code'], Icons.qr_code),
                      _buildInfoColumn(
                        'SKS',
                        '${course['credits']}',
                        Icons.star_border_rounded,
                      ),
                      _buildInfoColumn(
                        'Status',
                        'Tersedia',
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
                    'Mata kuliah ${course['title']} merupakan bagian dari kurikulum yang wajib diselesaikan. Silakan kerjakan semua modul yang diberikan.',
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
}

// --- SHELL UTAMA (Polished Profile & Navigation) ---
class Tahap15ResponsiveShell extends StatefulWidget {
  const Tahap15ResponsiveShell({super.key});

  @override
  State<Tahap15ResponsiveShell> createState() => _Tahap15ResponsiveShellState();
}

class _Tahap15ResponsiveShellState extends State<Tahap15ResponsiveShell> {
  int _currentIndex = 0;
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = loadStudentData();
  }

  Widget _buildBody(Map<String, dynamic> data, BoxConstraints constraints) {
    final student = data['student'];
    final courses = data['courses'] as List<dynamic>;

    if (_currentIndex == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/profile.jpg',
              width: 120,
              height: 120,
              errorBuilder: (ctx, err, stack) => const Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Selamat Datang,\n${student['name']}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              student['nim'],
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      );
    } else if (_currentIndex == 1) {
      if (constraints.maxWidth < 600) {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: courses.length,
          itemBuilder: (ctx, i) => Tahap15CourseCard(course: courses[i]),
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
          itemBuilder: (ctx, i) => Tahap15CourseCard(course: courses[i]),
        );
      }
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile Berwarna
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
            // Form Card
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
                  child: Tahap15FeedbackForm(),
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
      backgroundColor: Colors
          .grey
          .shade50, // Latar belakang abu-abu sangat terang agar Card menonjol
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
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(
              child: CircularProgressIndicator(color: Colors.indigo),
            );
          if (snapshot.hasError)
            return const Center(child: Text('Error memuat data JSON'));

          final data = snapshot.data!;
          return LayoutBuilder(
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
