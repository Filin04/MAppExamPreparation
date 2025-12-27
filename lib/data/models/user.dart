class User {
  final String id;
  final String email;
  final String hashedPassword;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.hashedPassword,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'hashedPassword': hashedPassword,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      hashedPassword: map['hashedPassword'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
