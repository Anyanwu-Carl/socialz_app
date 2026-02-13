import 'dart:typed_data';

abstract class StorageRepo {
  // UPLOAD PROFILE IMAGES ON MOBILE PLATFORM
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  // UPLOAD PROFILE IMAGES ON WEB PLATFORM
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);
}
