import 'package:my_things/src/common/common.dart';

import 'field_label.dart';

class DisplayField extends StatelessWidget{
  final Widget specificDisplayWidget;

  const DisplayField({
    Key? key,
    required this.specificDisplayWidget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: specificDisplayWidget
        ),
      );
  }

}