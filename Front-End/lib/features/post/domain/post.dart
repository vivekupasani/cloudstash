class Post {
  final String id;
  late final String name;
  final String uid;
  final String files;
  final String createdAt;
  final String updatedAt;

  Post(
      {required this.id,
      required this.name,
      required this.uid,
      required this.files,
      required this.createdAt,
      required this.updatedAt});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      uid: json['uid'] ?? '',
      files: json['files'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
