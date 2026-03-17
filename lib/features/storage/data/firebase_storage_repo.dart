import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_bloc/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // PROFILE PICTURES --> UPLOAD PROFILE IMAGES TO STORAGE
  @override
  // UPLOAD PROFILE IMAGES ON MOBILE PLATFORM
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  @override
  // UPLOAD PROFILE IMAGES ON WEB PLATFORM
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }

  // POST PICTURE --> UPLOAD POST IMAGES TO STORAGE
  @override
  // UPLOAD PROFILE IMAGES ON MOBILE PLATFORM
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  // UPLOAD PROFILE IMAGES ON WEB PLATFORM
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }

  /*

    HELPER METHOD TO UPLOAD FILES TO FIREBASE STORAGE

  */

  // MOBILE PLATFORM (USING FILE PATH)
  Future<String?> _uploadFile(
    String path,
    String fileName,
    String folder,
  ) async {
    try {
      // GET FILE
      final file = File(path);

      // FIND PLACE TO STORE
      final storageRef = storage.ref().child("$folder/$fileName");

      // UPLOAD FILE
      final uploadTask = await storageRef.putFile(file);

      // GET IMAGE DOWNLOAD URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  // WEB PLATFORM (USING FILE BYTES)
  Future<String?> _uploadFileBytes(
    Uint8List fileBytes,
    String fileName,
    String folder,
  ) async {
    try {
      // FIND PLACE TO STORE
      final storageRef = storage.ref().child("$folder/$fileName");

      // UPLOAD FILE
      final uploadTask = await storageRef.putData(fileBytes);

      // GET IMAGE DOWNLOAD URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
