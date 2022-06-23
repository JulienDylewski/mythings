import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_things/src/components/dialogs/confirm_dialog.dart';
import 'package:my_things/src/components/dialogs/get_photo_dialog.dart';
import 'package:my_things/src/components/dialogs/edit_text_list_dialog.dart';
import 'package:my_things/src/components/dialogs/loading_dialog.dart';


class DialogService {
  DialogService(this.viewContext) ;

  final BuildContext viewContext;

  Future<File?> showGetPhotoDialog({String? newPhotoFilename,Widget? alertDialogContent,}) async {
    return await showDialog<File>(
      context: viewContext,
      builder: (context) {
        return GetPhotoDialog(
          newPhotoFilename: newPhotoFilename,
          alertDialogContent: alertDialogContent,
        );
      },
    );
  }

  Future<bool?> showConfirmDialog({required String confirmDialogTitle, Widget? confirmDialogContent }) async {
    return await showDialog<bool>(
      context: viewContext,
      builder: (context) {
        return ConfirmDialog(
          confirmDialogTitle: confirmDialogTitle,
          confirmDialogContent: confirmDialogContent,
        );
      },
    );
  }

  // Used to have loader when appGlobalState is out of scope (popup)
  Future<void> showLoadingDialog({required GlobalKey loadingDialogKey}) async{
    return await showDialog<void>(
      context: viewContext,
      builder: (context) {
        return LoadingDialog(
          loadingDialogKey: loadingDialogKey
        );
      },
    );
  }

  Future<List<String>?> showEditTextListDialog(List<String> list, String dialogTitle) async{
    return await showDialog<List<String>?>(
      context: viewContext,
      builder: (context) {
        return EditTextListDialog(dialogTitle, list);
      },
    );
  }
}