# Course Explorer v2 - State Management & Architecture

* **Nama:** Agus Prasetya
* **NIM:** 2415051039
* **Kelas:** PTI-5B

## Arah Dependency (Dependency Direction)
`Screen / Widget` ➔ `Provider` ➔ `Repository` ➔ `Service / Data Source`

UI tidak memanggil `rootBundle` atau `jsonDecode` secara langsung, melainkan hanya membaca *state* dan memicu aksi melalui `CourseProvider`.

## Tanggung Jawab Setiap Folder (`lib/`)

* **`models/` (`course.dart`)**: Menyimpan representasi struktur data aplikasi (`Course`) yang *type-safe* beserta fungsi *parsing* `Course.fromJson()` untuk mengubah Map JSON menjadi objek Dart.
* **`services/` (`course_service.dart`)**: Bertanggung jawab penuh terhadap detail teknis pengambilan data mentah dari sumber data lokal (`rootBundle.loadString` dan `jsonDecode` pada file asset JSON) tanpa mencampurkannya dengan logika UI.
* **`repositories/` (`course_repository.dart`)**: Menjadi lapisan abstraksi (*jembatan*) antara `CourseProvider` dan `CourseService`. Menyediakan *method* `getCourses()` sehingga *Provider* tidak perlu mengetahui dari mana data berasal (JSON lokal, API, atau database).
* **`providers/` (`course_provider.dart`)**: Mengelola *shared state* / *application state* berbasis `ChangeNotifier` (daftar `courses`, koleksi `favorites`, status `isLoading`, dan `error`) serta memberi sinyal pembaruan ke UI melalui `notifyListeners()`.
* **`screens/` (`main_screen.dart`, `course_detail_page.dart`, `favorites_page.dart`)**: Berisi halaman-halaman utama aplikasi yang menampilkan antarmuka pengguna (UI) secara utuh dan mendengarkan perubahan *state* dari *Provider*.
* **`widgets/` (`course_card.dart`, `feedback_form.dart`)**: Menyimpan komponen-komponen UI modular berukuran kecil yang spesifik dan dapat digunakan kembali (*reusable*) di berbagai *screen*.

---
*Status Praktikum: Selesai (Tahap 0 - Tahap 17)*