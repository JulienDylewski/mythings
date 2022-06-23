import 'package:my_things/src/common/common.dart';


class NumberFormField extends StatefulWidget {
  final ValueChanged<double?>          onChanged;
  final FormFieldValidator<double?>?   validator;
  final double?                        currentValue;
  final bool                           enabled;
  final String                         label;
  final String?                        placeholder;

  const NumberFormField({
    Key? key,
    required this.onChanged,
    required this.currentValue,
    required this.label,
    this.enabled = true,
    this.placeholder,
    this.validator
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NumberFormFieldState();

}

class _NumberFormFieldState extends State<NumberFormField> {
  bool   showNetworkImage = false;
  final TextEditingController _textFieldController = TextEditingController();

  bool isValidTextFieldValue(){
    if(_textFieldController.text.isEmpty){
      return false;
    }
    if(double.tryParse(_textFieldController.text) != null){
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _textFieldController.text = widget.currentValue != null ? widget.currentValue.toString()  : "";
  }

  @override
  Widget build(BuildContext context) {
    return FormField<double?>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.currentValue,
      enabled: widget.enabled,
      validator: widget.validator,
      builder: (formState){
        return TextField(
            onChanged: (value){
              widget.onChanged(double.tryParse(value));
            },
            keyboardType: TextInputType.number,
            controller: _textFieldController ,
            decoration: InputDecoration(labelText: widget.label,
              errorText: isValidTextFieldValue() ? AppLocalizations.of(context)!.errorValueNumber : null,
              hintText: widget.placeholder
            ),

        );

      },
    );
  }

}