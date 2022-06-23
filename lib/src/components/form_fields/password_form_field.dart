import 'package:flutter/services.dart';
import 'package:my_things/src/common/common.dart';

class PasswordFormField extends StatefulWidget{
  final ValueChanged<String>         onChanged;
  final FormFieldValidator<String>?  validator;
  final String? labelText;
  final String? currentValue;
  final int     maxLength;


  const PasswordFormField({
    Key? key,
    required this.onChanged,
    required this.currentValue,
    this.maxLength = 50,
    this.validator,
    this.labelText

  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PasswordFormFieldState();

}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.currentValue,
      onChanged: widget.onChanged,
      obscureText: obscurePassword,
      maxLength: widget.maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      keyboardType: TextInputType.visiblePassword,

      validator: (s) {
        if(s!.isWhitespace()){
          return AppLocalizations.of(context)!.emptyField(AppLocalizations.of(context)!.password);
        }
        if(!s.isValidPassword()){
          return AppLocalizations.of(context)!.errorPasswordToWeak;
        }
      },
      decoration: InputDecoration(
        labelText: widget.labelText ?? AppLocalizations.of(context)!.password,
        hintText: AppLocalizations.of(context)!.password,
        suffixIcon: IconButton(
          onPressed: () => setState(() {
            obscurePassword = !obscurePassword;
          }),
          icon: Icon(
            obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.teal,
          ),
        )
      ),
    );
  }
}