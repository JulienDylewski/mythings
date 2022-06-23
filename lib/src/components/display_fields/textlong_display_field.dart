import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/display_fields/display_field.dart';
import 'package:my_things/src/model/item_field.dart';

import 'field_label.dart';

class TextLongDisplayField extends StatelessWidget{
  final ItemFieldTextLong itemField;

  const TextLongDisplayField({
    Key? key,
    required this.itemField
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DisplayField(specificDisplayWidget: Row(children: [
      FieldLabel(label: itemField.name),
      Flexible(
          child: Text(itemField.value != null ? itemField.value.toString() : "")
      ),
    ]));
  }

}