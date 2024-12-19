import 'dart:convert';
import 'package:docs/features/post/domain/post.dart';
import 'package:docs/features/post/domain/post_repo.dart';
import 'package:docs/features/storage/data/storage_api_repo.dart';
import 'package:docs/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PostApiRepo implements PostRepo {
  @override
  Future<void> uploadFile(PlatformFile file, String token, String uid) async {
    try {
      //upload the files to storage and get the urls
      String fileUrl = await StorageApiRepo().uploadFileToStorage(file);

      //endpoint uri
      final uri = Uri.parse('${endPoint}files/upload-files');

      //headers
      final headers = {
        'x-auth-token': token,
        'Content-Type': 'application/json',
      };

      //request body
      final Map<String, dynamic> requestBody = {
        'name': file.name,
        'uid': uid,
        'files': fileUrl
      };

      // Convert request body to JSON string
      final body = jsonEncode(requestBody);

      //send post request
      final res = await http.post(uri, headers: headers, body: body);

      //check status code
      if (res.statusCode == 200) {
        // Decode the JSON response
        final jsonRes = jsonDecode(res.body);
        if (kDebugMode) {
          print('Upload Successful: $jsonRes');
        }
      } else {
        if (kDebugMode) {
          print('Error: ${res.statusCode}, ${res.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }
  }

  @override
  Future<List<Post>> fetchFiles(String uid, String token) async {
    try {
      final uri = Uri.parse('${endPoint}files/get-files');

      final header = {
        'x-auth-token': token,
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'uid': uid,
      });

      final res = await http.post(uri, headers: header, body: body);

      if (res.statusCode == 200) {
        final jsonRes = jsonDecode(res.body);
        print('Response: $jsonRes'); // Log the full response to inspect

        // Ensure the 'files' field exists and is a List
        final filesData = jsonRes['files'];

        if (filesData is List) {
          // Safely map each file and return the list of Post objects
          return filesData.map<Post>((file) {
            return Post.fromJson(file as Map<String, dynamic>);
          }).toList();
        } else {
          throw Exception(
              "Expected 'files' to be a List, but got: ${filesData.runtimeType}");
        }
      } else {
        print('Failed to fetch files: ${res.statusCode}, ${res.body}');
        throw Exception('Failed to fetch files: ${res.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred during fetch: $e');
      }
      rethrow; // Propagate the exception for further handling
    }
  }

  @override
  Future<void> deleteFile(String id) async {
    try {
      if (id.isEmpty) {
        print('Error: File ID is missing or empty');
        return;
      }

      final uri = Uri.parse('${endPoint}files/delete-file');

      final header = {
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        "_id": id,
      });

      final res = await http.post(uri, headers: header, body: body);

      if (res.statusCode == 200) {
        final jsonResponse = jsonDecode(res.body);
        if (kDebugMode) {
          print(jsonResponse);
        }
      } else {
        print('Error: ${res.statusCode}, ${res.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred during fetch: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> updateFile(String id, String name) async {
    try {
      final uri = Uri.parse('${endPoint}files/update-file');

      final header = {
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        "_id": id,
        "name": name,
      });

      final res = await http.post(uri, headers: header, body: body);
      if (res.statusCode == 200) {
        final jsonResponse = jsonDecode(res.body);
        if (kDebugMode) {
          print(jsonResponse);
        }
      } else {
        if (kDebugMode) {
          print('Error: ${res.statusCode}, ${res.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred during fetch: $e');
      }
      rethrow;
    }
  }
}
