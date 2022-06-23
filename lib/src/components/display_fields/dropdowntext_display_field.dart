import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/display_fields/display_field.dart';
import 'package:my_things/src/model/item_field.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';
import 'package:provider/provider.dart';

import 'field_label.dart';

class DropDownTextDisplayField extends StatelessWidget{
  final ItemFieldDropDownText itemField;

  const DropDownTextDisplayField({
    Key? key,
    required this.itemField
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DisplayField(specificDisplayWidget: Row(children: [
      FieldLabel(label: itemField.name),
      SizedBox(
          child: Text(itemField.value != null ? itemField.value.toString() : "")
      ),
    ]));
  }

}