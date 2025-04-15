import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

abstract class StorageRepo {
  Future<void> setToken(String key, String token);
  Future<String?> getToken(String key);
  Future<void> removeToken(String key);
  Future<String> uploadFileMobile(PlatformFile appFile);
  Future<String> uploadFileWeb(Uint8List webFile);
}
