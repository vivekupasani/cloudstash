class User {
  final String email;
  final String id;
  final String username;
  final String token;

  User({
    required this.email,
    required this.username,
    required this.token,
    required this.id,
  });

  // Convert a User into a Map. This is for JSON serialization.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'id': id,
      'username': username,
      'token': token,
    };
  }

  // Convert a Map into a User. This is for JSON deserialization.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '', // Default to empty string if _id is null
      username:
          json['username'] ?? '', // Default to empty string if username is null
      email: json['email'] ?? '',
      token: json['token'] ?? '', 
    );
  }
}
