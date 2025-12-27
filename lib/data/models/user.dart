class User {
  static const String defaultName = 'Пользователь';
  static const String defaultAvatarId = 'default';

  final String id;
  final String email;
  final String hashedPassword;
  final DateTime createdAt;
  final String name;
  final String avatarId;

  User({
    required this.id,
    required this.email,
    required this.hashedPassword,
    required this.createdAt,
    String? name,
    String? avatarId,
  })  : name = name ?? defaultName,
        avatarId = avatarId ?? defaultAvatarId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'hashedPassword': hashedPassword,
      'createdAt': createdAt.toIso8601String(),
      'name': name,
      'avatarId': avatarId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      hashedPassword: map['hashedPassword'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      // Обратная совместимость: используем значения по умолчанию, если полей нет
      name: map['name'] as String? ?? defaultName,
      avatarId: map['avatarId'] as String? ?? defaultAvatarId,
    );
  }
}
