import 'package:cloudstash/features/upload/domain/File.dart';

abstract class FileRepo {
  Future<FileModel?> uploadFile({
    required String userId,
    required String name,
    required String url,
    required String type,
    required String size,
    required String token,
  });
  Future<void> deleteFile(String fileId, String token);
  Future<List<FileModel>> getFiles(String token);
  Future<FileModel> renameFile(String fileId, String newName, String token);
}
