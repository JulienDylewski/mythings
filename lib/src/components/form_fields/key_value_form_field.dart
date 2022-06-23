import 'package:my_things/src/common/common.dart';
import 'package:tuple/tuple.dart';

class KeyValueFormField extends StatefulWidget{
  final ValueChanged<Tuple2<String, String>>            onChanged;
  final Tuple2<String, String>                          currentValue;
  final List<DropdownMenuItem<String>>                  valueList;

  const KeyValueFormField({
    Key? key,
    required this.onChanged,
    required this.currentValue,
    required this.valueList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _KeyValueFormFieldState();

}

class _KeyValueFormFieldState extends State<KeyValueFormField> {
  final         formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FormField<Tuple2<String, String>>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.currentValue,
      builder: (formState){
        return  Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.fieldName,

                ),
                validator: (fieldName)  {
                  if(fieldName!.length < 3 || fieldName.length > 30 ){
                    return AppLocalizations.of(context)!.errorLength(3, 30);
                  }
                },
                onChanged: (newFieldName) {
                  final newFormValue = Tuple2<String, String>(newFieldName,formState.value!.item2);
                  widget.onChanged(newFormValue);
                  formState.didChange(newFormValue);
                },
              )
            ,flex: 1,),
            const SizedBox(width: 10.0),
            Expanded(
                child: DropdownButtonFormField<String>(
                    value: formState.value!.item2,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.fieldValue,
                        contentPadding: const EdgeInsets.only(top: 0, bottom: 0,left: 10)
                    ),
                    onChanged: (newFieldValue) {
                      final newFormValue = Tuple2<String, String>(formState.value!.item1, newFieldValue!);
                      widget.onChanged(newFormValue);
                      formState.didChange(newFormValue);
                    },
                    items: widget.valueList
                )
              ,flex: 1,)
          ]
        );
      },
    );
  }

}
