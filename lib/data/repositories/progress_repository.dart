import 'package:hive/hive.dart';
import 'package:app/data/database/app_database.dart';
import 'package:app/data/models/test_progress.dart';

class ProgressRepository {
  final Box _box = AppDatabase.progressBox;

  /// Сохранить результат теста
  /// Используем комбинацию userId + subjectId как ключ
  Future<void> saveProgress(TestProgress progress) async {
    final key = '${progress.userId}_${progress.subjectId}';
    await _box.put(key, progress.toMap());
  }

  /// Получить последний результат для пользователя и предмета
  TestProgress? getLastProgress(String userId, String subjectId) {
    final key = '${userId}_$subjectId';
    final progressData = _box.get(key);
    if (progressData != null) {
      return TestProgress.fromMap(Map<String, dynamic>.from(progressData as Map));
    }
    return null;
  }

  /// Получить все результаты для пользователя
  List<TestProgress> getAllProgressForUser(String userId) {
    final allProgress = <TestProgress>[];
    for (var key in _box.keys) {
      final keyString = key.toString();
      if (keyString.startsWith('${userId}_')) {
        final progressData = _box.get(key);
        if (progressData != null) {
          allProgress.add(
            TestProgress.fromMap(Map<String, dynamic>.from(progressData as Map)),
          );
        }
      }
    }
    return allProgress;
  }

  /// Удалить прогресс для пользователя и предмета
  Future<void> deleteProgress(String userId, String subjectId) async {
    final key = '${userId}_$subjectId';
    await _box.delete(key);
  }
}

