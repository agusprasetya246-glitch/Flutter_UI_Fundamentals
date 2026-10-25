// NIM: 2415051039 | Nama: Agus Prasetya

class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  // Factory constructor untuk konversi Map JSON ke objek Course (Poin 18 & 19)
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: (json['credits'] as num).toInt(),
      status: (json['status'] as String?) ?? 'planned',
    );
  }

  // Method toJson untuk mengubah objek Course kembali ke Map JSON (Poin 18)
  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
  };
}
