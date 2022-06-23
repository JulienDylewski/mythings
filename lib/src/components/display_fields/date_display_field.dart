import 'package:intl/intl.dart';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/display_fields/display_field.dart';
import 'package:my_things/src/model/item_field.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';
import 'package:provider/provider.dart';

import 'field_label.dart';

class DateDisplayField extends StatelessWidget{
  final ItemFieldDate itemField;

  const DateDisplayField({
    Key? key,
    required this.itemField
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late AppGlobalState _appState = Provider.of<AppGlobalState>(context, listen: false);

    return DisplayField(specificDisplayWidget: Row(children: [
      FieldLabel(label: itemField.name),
      SizedBox(
          child: Text(itemField.value != null ? DateFormat.yMEd(_appState.locale.languageCode).format(itemField.value!) : "")
      ),
    ]));
  }

}