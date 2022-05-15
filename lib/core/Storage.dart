import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Storage {
  static final Storage _instance = Storage._foo();

  Storage._foo();

  static Storage get instance => _instance;

  /// The user selects a file, and the task is added to the list.
  Future<UploadTask?> uploadImage(XFile? file,
      {required String path, required String name}) async {
    if (file == null) {
      Get.showSnackbar(Get.snackbar("Error", 'No file was selected').snackbar);
      return null;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance.ref('$path/$name.jpg');

    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(file.path), metadata);
    }

    return Future.value(uploadTask);
  }

  Future<Image> getMyProfileImage({bool cache = true}) async {
    final ref = FirebaseStorage.instance
        .ref('Profiles/${FirebaseAuth.instance.currentUser!.uid}.jpg');

    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/temp-${ref.name}');

    if (cache && await tempFile.exists()) return Image.file(tempFile);

    final task = await ref.writeToFile(tempFile).snapshotEvents.firstWhere(
        (element) =>
            element.state == TaskState.success ||
            element.state == TaskState.error);

    print("My Profile Image Last state : ${task.state}");

    return Image.file(
      tempFile,
      width: 200,
    );
  }

  Future<Image> getProfileImage(String userID, {bool cache = true}) async {
    final ref = FirebaseStorage.instance.ref('Profiles/$userID.jpg');

    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/temp-${ref.name}');

    if (cache && await tempFile.exists()) return Image.file(tempFile);

    final task = await ref.writeToFile(tempFile).snapshotEvents.firstWhere(
        (element) =>
            element.state == TaskState.success ||
            element.state == TaskState.error);

    return Image.file(
      tempFile,
      width: 200,
    );
  }

  Future<String> downloadLink(Reference ref) async {
    return await ref.getDownloadURL();
  }

  Future<File> downloadFile(Reference ref) async {
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/temp-${ref.name}');
    if (tempFile.existsSync()) await tempFile.delete();

    await ref.writeToFile(tempFile);

    print('Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
        'at path: ${ref.fullPath} \n'
        'Wrote "${ref.fullPath}" to tmp-${ref.name}');

    return tempFile;
  }
}
