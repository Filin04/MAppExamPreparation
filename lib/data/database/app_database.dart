import 'package:hive_flutter/hive_flutter.dart';

class AppDatabase {
  static const String _usersBoxName = 'users';
  static const String _progressBoxName = 'progress';

  static Box? _usersBox;
  static Box? _progressBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Открываем боксы для хранения данных
    _usersBox = await Hive.openBox(_usersBoxName);
    _progressBox = await Hive.openBox(_progressBoxName);
  }

  static Box get usersBox {
    if (_usersBox == null) {
      throw Exception('Database not initialized. Call AppDatabase.init() first.');
    }
    return _usersBox!;
  }

  static Box get progressBox {
    if (_progressBox == null) {
      throw Exception('Database not initialized. Call AppDatabase.init() first.');
    }
    return _progressBox!;
  }

  static Future<void> clearAll() async {
    await _usersBox?.clear();
    await _progressBox?.clear();
  }
}

