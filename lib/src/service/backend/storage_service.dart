import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_things/src/model/app_file.dart';
import 'package:my_things/src/service/backend/database_collection_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'logger_service.dart';

class StorageServiceException implements Exception {
  StorageServiceException(this.errorMsg);
  String errorMsg;

  @override
  String toString() {
    return errorMsg;
  }
}

class StorageService {
  StorageService._privateConstructor();
  static final StorageService _instance = StorageService._privateConstructor();
  static StorageService get instance => _instance;

  static const acceptedImageFormats = [
    "png",
    "jpg",
    "jpeg",
  ];

  final FirebaseStorage _cloudStorage = FirebaseStorage.instance;
  final ImagePicker     _imagePicker = ImagePicker();
  final                 _uuid = const Uuid();


  Future<File?> pickFile({List<String>? allowedExtensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        // Some devices do not respect the allowedExtensions
        allowedExtensions: allowedExtensions,
        // You must put FileType.custom for type if you provide allowedExtensions
        type: [allowedExtensions ?? []].isNotEmpty
            ? FileType.custom
            : FileType.any,
      );

      final path = result?.files.single.path;

      if (path == null) return null;

      final file = File(path);

      // Double check extension to ensure it was the correct type of file
      if (allowedExtensions != null &&
          !allowedExtensions.contains(extension(file.path).replaceAll('.', ''))) {
        throw StorageServiceException(
            "Files of the type ${extension(file.path)} are not allowed here");
      }

      return file;
    } catch (e, s) {
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw StorageServiceException("pickFile");
    }
  }

  Future<File?> pickPhoto() => pickFile(allowedExtensions: acceptedImageFormats);

  Future<File?> takeNewPhoto({
    String? filename,
    int imageQuality = 100,
  }) async {
    assert(filename == null || !filename.contains("."),
    "Do not include the extension in the desired filename");

    try {
      final result = await _imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: imageQuality);

      if (result == null) return null;

      filename ??= const Uuid().v4();

      final ext = result.path.split(".").last;
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$filename.$ext';
      await result.saveTo(path);

      return File(path);
    } catch (e, s) {
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw StorageServiceException("takeNewPhoto");
    }
  }

  Future<AppFile> uploadFileAndGetAppFile(File file, String userId) async {
    UploadTask task = await StorageService.instance.uploadFile(file, userId);
    AppFile appFile = AppFile(ref: task.snapshot.ref.fullPath, name: basename(file.path));
    Stopwatch watch = Stopwatch();
    watch.start();
    while(appFile.downloadUrl == null && watch.elapsed < const Duration(seconds: 10)){
      try{
        appFile.downloadUrl =  await task.snapshot.ref.getDownloadURL();
      }catch (e,s){
        // TODO: find why getDownloadURL throw 404 and we need to retry the request while
      }
    }
    watch.stop();
    return appFile;
  }

  // https://firebase.flutter.dev/docs/storage/usage
  Future<UploadTask> uploadFile(File file, String userId) async {
    if(!await file.exists()){
      throw StorageServiceException("File do not exist");
    }
    String randomUid = _uuid.v4();

    if(acceptedImageFormats.contains(extension(file.path).replaceAll('.', ''))){
      Uint8List? result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 1000,
        minHeight: 1000,
        quality: 94,
      );
      return  FirebaseStorage.instance
          .ref('uploads/$userId/$randomUid-${basename(file.path)}')
          .putData(result!);
    }
    return  FirebaseStorage.instance
        .ref('uploads/$userId/$randomUid-${basename(file.path)}')
        .putFile(file);
  }

  Future<void> deleteFile(String ref)async {
    try{
      await _cloudStorage.ref(ref).delete();
    }catch(e, s){
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw DatabaseCollectionServiceException("deleteFile");
    }
  }

  Future<String?> getDownloadUrl(String ref) async {
    try{
      return await _cloudStorage
          .ref(ref)
          .getDownloadURL();
    }catch(e, s){

      LoggerService.instance.logError(error: s, stackTrace: s);
      return null;
    }
  }
}