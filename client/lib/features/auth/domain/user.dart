class User {
  String id;
  String username;
  String email;
  String password;
  String profession;
  String about;
  DateTime createdAt;
  DateTime updatedAt;
  String? token;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.profession,
    required this.about,
    required this.createdAt,
    required this.updatedAt,
    this.token,
  });

  // Method to convert the User object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'password': password,
      'proffession': profession,
      'about': about,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'token': token,
    };
  }

  // Factory method to create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      profession: json['proffession'],
      about: json['about'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      token: json['token'],
    );
  }
}
