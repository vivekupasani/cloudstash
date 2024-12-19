import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:docs/features/storage/domain/storage_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageApiRepo implements StorageRepo {
  //-------------------------------------------------------------------------------------------

  @override
  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('x-auth-token');
    return token; // If token is null, it will return null, otherwise it will return the token.
  }

  //-------------------------------------------------------------------------------------------

  @override
  Future<void> storeToken(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('x-auth-token', token);
  }

  //-------------------------------------------------------------------------------------------

  @override
  Future<void> deleteToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('x-auth-token');
  }

  //-------------------------------------------------------------------------------------------
  @override
  Future<String> uploadFileToStorage(PlatformFile file) async {
    CloudinaryResponse res;
    try {
      final cloudinary =
          CloudinaryPublic('djk5h78ne', 'uploadpreset', cache: false);

      if (file.bytes != null) {
        res = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            file.bytes!,
            identifier: file.name,
          ),
        );
      } else {
        res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            file.path!,
          ),
        );
      }
      print(res.secureUrl);
      return res.secureUrl;
    } catch (e) {
      throw Exception('Error uploading files: $e');
    }
  }

  //-------------------------------------------------------------------------------------------
}
