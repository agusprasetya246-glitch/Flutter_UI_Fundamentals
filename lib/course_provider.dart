import 'package:flutter/foundation.dart';

// Class ini bertanggung jawab penuh mengelola data (state) aplikasi
class CourseProvider extends ChangeNotifier {
  // 23. Tambahkan collection favorites (Dibuat private dengan underscore).
  final Set<String> _favorites = {};

  // Getter agar UI bisa membaca data, tapi tidak bisa mengubahnya sembarangan
  Set<String> get favorites => _favorites;

  // 24. Tambahkan method toggleFavorite().
  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }

    // 25. Pastikan notifyListeners() dipanggil setelah state berubah.
    notifyListeners();
  }
}
