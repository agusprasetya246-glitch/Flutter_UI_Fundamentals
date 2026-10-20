// ============================================================================
// TAHAP 8: MODEL COURSE
// Identitas: 2415051039 - Agus Prasetya
// ============================================================================

class Course {
  // code, title, credits, status
  final String code;
  final String title;
  final int credits;
  final String status;

  Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  // factory Course.fromJson() untuk mem-parsing Map menjadi Object
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: (json['status'] ?? 'Tersedia') as String,
    );
  }
}
