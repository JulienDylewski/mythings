import 'package:flutter/services.dart';
import 'package:my_things/src/common/common.dart';

class EmailFormField extends StatelessWidget {
  final ValueChanged<String>         onChanged;
  final FormFieldValidator<String>?  validator;
  final String? currentValue;
  final int     maxLength;


  const EmailFormField({
    Key? key,
    required this.onChanged,
    required this.currentValue,
    this.maxLength = 50,
    this.validator,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: currentValue,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      validator: validator ?? (s) {
        if(!s!.isValidEmail()){
          return AppLocalizations.of(context)!.errorEmailInvalid;
        }
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.email,
        hintText: "email@test.com"
      ),
    );
  }

}