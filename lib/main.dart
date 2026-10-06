import 'package:flutter/material.dart';

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
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter UI Fundamentals')),
        body: Center(
          // Membungkus seluruh konten dengan Padding agar tidak menempel di tepi layar
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tahap 7: Membungkus profil dengan Card dan menambahkan Padding di dalamnya
                Card(
                  elevation: 4, // Memberikan efek bayangan
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 46,
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpg',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          studentName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(studentId),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone_android),
                            SizedBox(width: 8),
                            Text('Mobile Programming Student'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ), // Akhir dari Card Profil

                const SizedBox(height: 24),
                Row(
                  children: [
                    buildStatCard('8', 'Widget', Icons.widgets),
                    const SizedBox(width: 8), // Jarak antar kartu
                    buildStatCard('4', 'Layout', Icons.view_quilt),
                    const SizedBox(width: 8),
                    buildStatCard('1', 'State', Icons.sync),
                  ],
                ),
                const GreetingCard(),
              ],
            ),
          ),
        ),
      ),
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
