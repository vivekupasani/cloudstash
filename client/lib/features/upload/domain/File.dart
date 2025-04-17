class FileModel {
  final String id;
  final String name;
  final String userId;
  final String file;
  final String fileType;
  final String fileSize;
  final DateTime createdAt;
  final DateTime updatedAt;

  FileModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.file,
    required this.fileType,
    required this.fileSize,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "userId": userId,
      "file": file,
      "fileType": fileType,
      "fileSize": fileSize,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['_id'],
      name: json['name'],
      userId: json["userId"],
      file: json["file"],
      fileType: json["fileType"],
      fileSize: json["fileSize"],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }
}
