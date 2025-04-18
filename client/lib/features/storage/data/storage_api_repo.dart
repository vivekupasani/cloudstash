// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:typed_data';
import 'package:cloudstash/features/storage/domain/storage_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

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
  Future<String?> uploadProfileImageMobile(
    String filePath,
    String fileName,
  ) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final file = File(filePath);

      final mimeType = _getMimeType(fileName);
      // debugPrint("Uploading file: $fileName with MIME type: $mimeType");

      final ref = storage.ref().child('cloudstash/media/$fileName');
      final metadata = SettableMetadata(contentType: mimeType);

      await ref.putFile(file, metadata);
      final downloadUrl = await ref.getDownloadURL();

      // debugPrint("Download URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      // debugPrint("Error in uploadProfileImageMobile: $e");
      return null;
    }
  }

  @override
  Future<String?> uploadProfileImageWeb(
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;

      final mimeType = _getMimeType(fileName);
      // debugPrint("Uploading file: $fileName with MIME type: $mimeType");

      final ref = storage.ref().child('cloudstash/media/$fileName');
      final metadata = SettableMetadata(contentType: mimeType);

      await ref.putData(bytes, metadata);
      final downloadUrl = await ref.getDownloadURL();

      // debugPrint("Download URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      // debugPrint("Error in uploadProfileImageWeb: $e");
      return null;
    }
  }

  /// Returns the appropriate content-type based on file extension
  String _getMimeType(String fileName) {
    final extension = path.extension(fileName).toLowerCase();

    switch (extension) {
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.pdf':
        return 'application/pdf';
      case '.mp4':
        return 'video/mp4';
      case '.mov':
        return 'video/quicktime';
      case '.avi':
        return 'video/x-msvideo';
      case '.mp3':
        return 'audio/mpeg';
      case '.wav':
        return 'audio/wav';
      default:
        return 'application/octet-stream';
    }
  }
}
