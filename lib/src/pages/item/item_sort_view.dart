import 'package:flutter/material.dart';
import 'package:my_things/src/common/common.dart';

class ItemSortView extends StatelessWidget {
  const ItemSortView({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Salut"),
      insetPadding: EdgeInsets.all(0),
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
