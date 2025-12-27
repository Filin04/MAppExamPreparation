import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:app/data/models/user.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final UserRepository _userRepository = UserRepository();
  User? _currentUser;

  /// Получить текущего авторизованного пользователя
  User? get currentUser => _currentUser;

  /// Проверить, авторизован ли пользователь
  bool get isAuthenticated => _currentUser != null;

  /// Хеширование пароля с использованием SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Регистрация нового пользователя
  /// Возвращает результат: true - успешно, false - email уже занят
  Future<AuthResult> register(
    String email,
    String password, {
    String? name,
  }) async {
    // Проверяем, не существует ли уже пользователь с таким email
    if (_userRepository.emailExists(email)) {
      return AuthResult(
        success: false,
        message: 'Пользователь с таким email уже зарегистрирован',
      );
    }

    // Создаем нового пользователя
    final user = User(
      id: const Uuid().v4(),
      email: email.toLowerCase().trim(),
      hashedPassword: _hashPassword(password),
      createdAt: DateTime.now(),
      name: name,
      avatarId: User.defaultAvatarId, // Всегда используем значение по умолчанию для новых пользователей
    );

    // Сохраняем в базу данных
    await _userRepository.save(user);

    // Автоматически входим после регистрации
    _currentUser = user;

    return AuthResult(
      success: true,
      message: 'Регистрация успешна',
      user: user,
    );
  }

  /// Вход пользователя
  /// Возвращает результат: true - успешно, false - неверные данные
  Future<AuthResult> login(String email, String password) async {
    final user = _userRepository.findByEmail(email);
    
    if (user == null) {
      return AuthResult(
        success: false,
        message: 'Пользователь с таким email не найден',
      );
    }

    // Проверяем пароль
    final hashedPassword = _hashPassword(password);
    if (user.hashedPassword != hashedPassword) {
      return AuthResult(
        success: false,
        message: 'Неверный пароль',
      );
    }

    // User.fromMap уже обрабатывает отсутствие полей name и avatarId, устанавливая значения по умолчанию
    // Сохраняем пользователя обратно, чтобы новые поля были записаны в Hive (миграция данных)
    // Это гарантирует, что при следующем входе все поля будут в БД
    await _userRepository.save(user);

    // Входим
    _currentUser = user;

    return AuthResult(
      success: true,
      message: 'Вход выполнен успешно',
      user: user,
    );
  }

  /// Выход пользователя
  void logout() {
    _currentUser = null;
  }
}

/// Результат операции аутентификации
class AuthResult {
  final bool success;
  final String message;
  final User? user;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
  });
}

