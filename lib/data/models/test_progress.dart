class TestProgress {
  final String userId;
  final String subjectId; // "math", "informatics", "biology", "obshchestvo"
  final int correctAnswers;
  final int totalQuestions;
  final DateTime updatedAt;

  TestProgress({
    required this.userId,
    required this.subjectId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.updatedAt,
  });

  double get percentage => totalQuestions > 0 
      ? (correctAnswers / totalQuestions * 100) 
      : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'subjectId': subjectId,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TestProgress.fromMap(Map<String, dynamic> map) {
    return TestProgress(
      userId: map['userId'] as String,
      subjectId: map['subjectId'] as String,
      correctAnswers: map['correctAnswers'] as int,
      totalQuestions: map['totalQuestions'] as int,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
