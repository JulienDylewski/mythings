import 'package:my_things/src/common/common.dart';
import 'package:intl/intl.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';
import 'package:provider/provider.dart';

class DateFormField extends StatefulWidget {
  final ValueChanged<DateTime?>          onChanged;
  final FormFieldValidator<DateTime?>?   validator;
  final DateTime?                        currentValue;
  final bool                           enabled;
  final String                         label;
  final String?                        placeholder;

  const DateFormField({
    Key? key,
    required this.onChanged,
    required this.currentValue,
    required this.label,
    this.enabled = true,
    this.placeholder,
    this.validator
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateFormField();

}

class _DateFormField extends State<DateFormField> {
  DateTime? _pickedDateTime;
  final TextEditingController _textFieldController = TextEditingController();
  late final AppGlobalState? appState;

  String get dateTimeStr {
    return _pickedDateTime == null
        ? ""
        : DateFormat.yMEd(appState?.locale.languageCode ?? "fr").format(_pickedDateTime!);
  }

  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppGlobalState>(context, listen: false);
    setState(() {
      _pickedDateTime =  widget.currentValue;
      _textFieldController.text = dateTimeStr;
    });

  }


  @override
  Widget build(BuildContext context) {
    return FormField<DateTime?>(

      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.currentValue,
      validator: widget.validator,
      builder: (formState){
        return GestureDetector(
          child: TextField(
            controller: _textFieldController,
            enabled: false,
            decoration: InputDecoration(labelText: widget.label,
                hintText: widget.placeholder
            ),
          ),
          onTap: !widget.enabled ? null :(){
            showDatePicker(
                context: context,
                initialDate: _pickedDateTime ?? DateTime.now(),
                firstDate: DateTime(0),
                lastDate: DateTime(3000)
            ).then((value) {
              setState(() {
                widget.onChanged(value);
                _pickedDateTime = value;
                _textFieldController.text = dateTimeStr;
              });
            });
          },
        );
      },
    );
  }

}