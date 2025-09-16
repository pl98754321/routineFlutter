class UserDB {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;

  UserDB({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory UserDB.fromJson(Map<String, dynamic> json) {
    return UserDB(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
