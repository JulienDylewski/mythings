import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/display_fields/display_field.dart';
import 'package:my_things/src/components/image_box/image_box_view.dart';
import 'package:my_things/src/model/item_field.dart';

import 'field_label.dart';

class ImageDisplayField extends StatelessWidget{
  final ItemFieldImage itemField;

  const ImageDisplayField({
    Key? key,
    required this.itemField
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DisplayField(specificDisplayWidget: Row(children: [
      FieldLabel(label: itemField.name),
      Expanded(
          child: ImageBoxView.network(itemField.value!.safeDownloadUrl, 100, onTapFullScreenEnabled:true)
      ),
    ]));
  }

}