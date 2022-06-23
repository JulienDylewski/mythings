import 'dart:io';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/uploader_btn/uploader_btn_view_model.dart';
import 'package:my_things/src/service/frontend/dialog_service.dart';
import 'package:my_things/src/service/frontend/toaster_service.dart';
import 'package:provider/provider.dart';

class FirebaseUploaderScreen extends StatelessWidget {
  const FirebaseUploaderScreen({Key? key, required this.fileChanged, this.currentValue}) : super(key: key);
  final File?  currentValue;
  final ValueChanged<File?> fileChanged;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => FirebaseUploaderViewModel(currentValue) ,
        child: _FirebaseUploaderView(fileChanged)
    );
  }
  
}

class _FirebaseUploaderView extends StatefulWidget {
  const _FirebaseUploaderView(this.fileChanged);
  final ValueChanged<File?>  fileChanged;

  @override
  State<_FirebaseUploaderView> createState() => _FirebaseUploaderState();
}

class _FirebaseUploaderState extends State<_FirebaseUploaderView>{

  @override
  Widget build(BuildContext context) {
    ToasterService toasterService = ToasterService(context);
    DialogService  dialogService = DialogService(context);
    FirebaseUploaderViewModel viewModel = Provider.of<FirebaseUploaderViewModel>(context);
    return
        viewModel.file != null
        ? viewModel.isLoading
          ? const SizedBox(
              width: 40,
              height: 40,
              child:  CircularProgressIndicator()
            )
          : IconButton(
              onPressed: () {
                viewModel.setLastFileUploaded(null);
                widget.fileChanged(null);
              },
              icon: const Icon(Icons.delete, size: 40, color: Colors.red)
          )
        : viewModel.isLoading
          ? const SizedBox(width: 40, height: 40,  child: Center(child:SizedBox(
                width: 40,
                height: 10,
                child:  LinearProgressIndicator()
            )))
          : IconButton(
                onPressed: () async {
                  File? file = await dialogService.showGetPhotoDialog();
                  if(file != null){
                    viewModel.setLastFileUploaded(file);
                    widget.fileChanged(file);
                  }
                },
                icon: const Icon(Icons.file_upload, size: 40, color: Colors.teal)
            );
  }
}