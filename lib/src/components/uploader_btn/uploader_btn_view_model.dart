import 'dart:io';
import 'package:my_things/src/common/common.dart';
class FirebaseUploaderViewModel extends ChangeNotifier {
  FirebaseUploaderViewModel(this._file);

  bool _isLoading = false;
  File? _file;

  bool get isLoading {
    return _isLoading;
  }

  File? get file {
    return _file;
  }



  void setIsLoading(bool isUploading) {
    _isLoading = isUploading;
    notifyListeners();
  }


  void setLastFileUploaded(File? file) {
    _file = file;
    notifyListeners();
  }
}