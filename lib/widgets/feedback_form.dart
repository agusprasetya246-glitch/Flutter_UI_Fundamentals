import 'package:flutter/material.dart';

// Variabel global identitas (dapat diakses dari main.dart)
const String studentName = 'Agus Prasetya';
const String studentId = '2415051039';

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
