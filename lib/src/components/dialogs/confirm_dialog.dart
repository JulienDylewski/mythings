import 'package:flutter/material.dart';
import 'package:my_things/src/common/common.dart';

class ConfirmDialog extends StatelessWidget {
  /// Optionally overwrite the filename of a new photo taken with the camera
  final String confirmDialogTitle;
  final Widget? confirmDialogContent;

  const ConfirmDialog({
    Key? key,
    required this.confirmDialogTitle,
    this.confirmDialogContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(confirmDialogTitle),
      content: confirmDialogContent,
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context)!.confirmAction),
          onPressed: () => Navigator.pop(context, true),
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
