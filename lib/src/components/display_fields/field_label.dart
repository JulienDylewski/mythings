import 'package:my_things/src/common/common.dart';

class FieldLabel extends StatelessWidget{
  final String label;

  const FieldLabel({
    Key? key,
    required this.label
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return SizedBox(
        width: 120,
        child:
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child:Text(label)
            )
          )
      );
  }

}