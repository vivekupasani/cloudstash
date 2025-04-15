import 'dart:typed_data';

import 'package:cloudstash/features/storage/domain/storage_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageApiRepo implements StorageRepo {
  @override
  Future<String?> getToken(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> removeToken(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(key);
    await pref.clear();
  }

  @override
  Future<void> setToken(String key, String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, token);
  }

  @override
  Future<String> uploadFileMobile(PlatformFile appFile) {
    throw UnimplementedError();
  }

  @override
  Future<String> uploadFileWeb(Uint8List webFile) {
    throw UnimplementedError();
  }
}
