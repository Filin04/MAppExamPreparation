import 'package:hive/hive.dart';
import 'package:app/data/database/app_database.dart';
import 'package:app/data/models/user.dart';

class UserRepository {
  final Box _box = AppDatabase.usersBox;

  /// Найти пользователя по email
  User? findByEmail(String email) {
    final allUsers = _box.values.toList();
    for (var userData in allUsers) {
      final user = User.fromMap(Map<String, dynamic>.from(userData as Map));
      if (user.email.toLowerCase() == email.toLowerCase()) {
        return user;
      }
    }
    return null;
  }

  /// Найти пользователя по ID
  User? findById(String id) {
    final userData = _box.get(id);
    if (userData != null) {
      return User.fromMap(Map<String, dynamic>.from(userData as Map));
    }
    return null;
  }

  /// Сохранить пользователя
  Future<void> save(User user) async {
    await _box.put(user.id, user.toMap());
  }

  /// Проверить, существует ли пользователь с таким email
  bool emailExists(String email) {
    return findByEmail(email) != null;
  }

  /// Получить всех пользователей (для отладки)
  List<User> getAllUsers() {
    return _box.values
        .map((data) => User.fromMap(Map<String, dynamic>.from(data as Map)))
        .toList();
  }
}

