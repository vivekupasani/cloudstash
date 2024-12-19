import 'package:docs/features/post/domain/post.dart';
import 'package:file_picker/file_picker.dart';

abstract class PostRepo {
  Future<void> uploadFile(PlatformFile file, String token, String uid);
  Future<List<Post>> fetchFiles(String uid, String token);
  Future<void> deleteFile(String id);
  Future<void> updateFile(String id, String name);
}
