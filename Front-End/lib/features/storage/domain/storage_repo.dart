import 'package:file_picker/file_picker.dart';

abstract class StorageRepo {
  //Token Methods
  Future<void> storeToken(String token);
  Future<void> deleteToken();
  Future<String?> getToken();

  //Cloudinary methods
  Future<String> uploadFileToStorage(PlatformFile files);
}
