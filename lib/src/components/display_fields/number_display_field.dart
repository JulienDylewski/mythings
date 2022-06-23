import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/display_fields/display_field.dart';
import 'package:my_things/src/model/item_field.dart';

import 'field_label.dart';

class NumberDisplayField extends StatelessWidget{
  final ItemFieldNumber itemField;

  const NumberDisplayField({
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