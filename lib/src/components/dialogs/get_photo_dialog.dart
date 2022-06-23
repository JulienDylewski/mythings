import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/service/backend/logger_service.dart';
import 'package:my_things/src/service/backend/storage_service.dart';
import 'package:my_things/src/service/frontend/toaster_service.dart';


class GetPhotoDialog extends StatelessWidget {
  /// Optionally overwrite the filename of a new photo taken with the camera
  final String? newPhotoFilename;
  final Widget? alertDialogContent;

  const GetPhotoDialog({
    Key? key,
    this.newPhotoFilename,
    this.alertDialogContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.chooseImage),
      content: alertDialogContent,
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context)!.camera),
          onPressed: () => _takePhoto(context),
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.files),
          onPressed: () => _chooseFile(context),
        ),
      ],
    );
  }

  void _takePhoto(BuildContext context) async {
    final fileRepository = StorageService.instance;
    ToasterService _toasterService = ToasterService(context);
    try {
      final file = await fileRepository.takeNewPhoto(
        filename: newPhotoFilename,
      );

      Navigator.pop(context, file);
    } on StorageServiceException catch (e, s) {
      LoggerService.instance.logError(error: e, stackTrace: s);
      Navigator.pop(context);
      _toasterService.dangerToaster(AppLocalizations.of(context)!.errorUnexpected);
    }
  }

  void _chooseFile(BuildContext context) async {
    final fileRepository = StorageService.instance;
    ToasterService _toasterService = ToasterService(context);
    try {
      final file = await fileRepository.pickPhoto();

      Navigator.pop(context, file);
    } on StorageServiceException catch (e, s) {
      LoggerService.instance.logError(error: e, stackTrace: s);
      Navigator.pop(context);
      _toasterService.dangerToaster(AppLocalizations.of(context)!.errorUnexpected);
    }
  }
}