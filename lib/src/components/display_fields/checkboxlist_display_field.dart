import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/display_fields/display_field.dart';
import 'package:my_things/src/model/item_field.dart';

import 'field_label.dart';

class CheckboxListDisplayField extends StatelessWidget{
  final ItemFieldCheckBoxList itemField;

  const CheckboxListDisplayField({
    Key? key,
    required this.itemField
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DisplayField(specificDisplayWidget: Row(children: [
      FieldLabel(label: itemField.name),
      SizedBox(
          child: Text(itemField.value.isNotEmpty  ? itemField.value.toString() : "")
      ),
    ]));
  }

}