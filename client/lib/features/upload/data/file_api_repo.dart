import 'dart:convert';

import 'package:cloudstash/features/upload/domain/File.dart';
import 'package:cloudstash/features/upload/domain/file_repo.dart';
import 'package:http/http.dart' as http;

class FileApiRepo implements FileRepo {
  final baseUrl = "http://192.168.1.11:3000/files";

  @override
  Future<void> deleteFile(String fileId, String token) async {
    final Uri url = Uri.parse("$baseUrl/delete-file");
    final headers = {"Content-Type": "application/json", "x-auth-token": token};
    final Map<String, dynamic> body = {"_id": fileId};

    try {
      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        return; // File deleted successfully
      } else {
        throw Exception(
          "Failed to delete file. Status code: ${res.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Failed to delete file. Error: $e");
    }
  }

  @override
  Future<List<FileModel>> getFiles(String token) async {
    final Uri url = Uri.parse("$baseUrl/get-file");
    final headers = {"Content-Type": "application/json", "x-auth-token": token};
    try {
      final res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        final decode = (jsonDecode(res.body)['files']) as List;
        final List<FileModel> files =
            decode.map((ele) => FileModel.fromJson(ele)).toList();

        return files;
      } else {
        throw Exception(
          "Failed to fetch files. Status code: ${res.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Failed to fetch files. Error: $e");
    }
  }

  @override
  Future<FileModel> renameFile(
    String fileId,
    String newName,
    String token,
  ) async {
    final Uri url = Uri.parse("$baseUrl/rename-file");
    final headers = {"Content-Type": "application/json", "x-auth-token": token};
    final Map<String, dynamic> body = {"fileId": fileId, "name": newName};

    try {
      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final decode = jsonDecode(res.body);
        return FileModel.fromJson(decode['file']);
      } else {
        throw Exception(
          "Failed to rename file. Status code: ${res.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Failed to rename file. Error: $e");
    }
  }

  @override
  Future<FileModel?> uploadFile({
    required String userId,
    required String name,
    required String url,
    required String type,
    required String size,
    required String token,
  }) async {
    final Uri urlEndpoint = Uri.parse('$baseUrl/upload-file');
    final headers = {'Content-Type': 'application/json', 'x-auth-token': token};
    final Map<String, dynamic> body = {
      'userId': userId,
      'name': name,
      'file': url,
      'fileType': type,
      'fileSize': size,
    };

    try {
      final response = await http.post(
        urlEndpoint,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FileModel.fromJson(data['saveFile']);
      } else {
        throw Exception("Upload failed. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during upload. Error: $e");
    }
  }
}
