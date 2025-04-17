import 'dart:typed_data';

abstract class StorageRepo {
  Future<void> setToken(String key, String token);
  Future<String?> getToken(String key);
  Future<void> removeToken(String key);
  Future<String?> uploadProfileImageMobile(String path, String fileName);
  Future<String?> uploadProfileImageWeb(Uint8List bytes, String fileName);
}
