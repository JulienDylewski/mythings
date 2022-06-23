import 'dart:io';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/image_box/image_box_view.dart';
import 'package:my_things/src/components/uploader_btn/uploader_btn_view.dart';


class ImageFormField extends StatefulWidget {
  final ValueChanged<File?>          onChanged;
  final File?                           currentValue;
  final String?                         startNetworkImage;
  final String?                         label;
  final bool                            enabled;
  final FormFieldValidator<File?>?   validator;

  const ImageFormField({
    Key? key,
    required this.onChanged,
    required this.currentValue,
    this.enabled = false,
    this.label,
    this.validator,
    this.startNetworkImage
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageFormFieldState();

}

class _ImageFormFieldState extends State<ImageFormField> {
  bool   showNetworkImage = false;
  @override
  void initState() {
    super.initState();

    showNetworkImage = widget.startNetworkImage != null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<File>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: showNetworkImage ? File("") : widget.currentValue,
      validator: widget.validator ?? (file) {
        if((file == null || file.path.isEmpty) && !showNetworkImage){
          return AppLocalizations.of(context)!.errorImage;
        }
      },
      builder: (formState){
        Theme.of(context).inputDecorationTheme.errorBorder;
        return Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: widget.currentValue != null
                      ? ImageBoxView.file(widget.currentValue!.path, 150, onTapFullScreenEnabled: true )
                      : showNetworkImage
                        ? ImageBoxView.network(widget.startNetworkImage!, 150, onTapFullScreenEnabled: true )
                        :  formState.hasError
                          ? Text(AppLocalizations.of(context)!.errorImage, style: const TextStyle(color: Colors.red),)
                          : Text(AppLocalizations.of(context)!.errorImage),
                )

                      ,
                widget.enabled ? FirebaseUploaderScreen(
                  currentValue: showNetworkImage ? File("") : widget.currentValue,
                  fileChanged: (File? file) {
                        setState(() {
                          showNetworkImage = false;
                          widget.onChanged(file);
                          formState.didChange(file);
                        });
                    }
                ) : const SizedBox(width: 0,height: 0,)
              ],
            ),
            Positioned(
                left: 12.0,
                top: 0.0,
                child: Text(widget.label ?? " Image ",
                  style: const TextStyle( backgroundColor: Colors.white, color: Colors.black, fontSize: 12),),
            ),
          ],
        );

      },
    );
  }

}