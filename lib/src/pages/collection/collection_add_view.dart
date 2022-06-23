import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/pages/collection/collection_form_view.dart';
import 'package:my_things/src/pages/collection/collection_form_view_model.dart';
import 'package:my_things/src/pages/collection/collections_list_view_model.dart';
import 'package:my_things/src/service/frontend/dialog_service.dart';
import 'package:my_things/src/service/frontend/toaster_service.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';


class CollectionAddView extends StatefulWidget {
  const CollectionAddView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionAddViewState();
}

class _CollectionAddViewState extends State<CollectionAddView> {
  final GlobalKey<FormState>      _collectionFormKey = GlobalKey<FormState>();
  late final  DialogService       _dialogService = DialogService(context);
  late final ToasterService       _toasterService = ToasterService(context);
  late final CollectionFormViewModel   _collectionFormViewModel
  = CollectionFormViewModel(CollectionFormMode.CREATE, AppGlobalState.instance.loggedUser!.uid!, context);

  final GlobalKey<State>          _keyLoader = GlobalKey<State>();

  startLoading() async {
    await _dialogService.showLoadingDialog(loadingDialogKey: _keyLoader);
  }
  stopLoading(){
    Navigator.of(_keyLoader.currentContext!,rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () {
          if (_collectionFormKey.currentState!.validate()) {
            String? validation = _collectionFormViewModel.isValid();
              if(validation == null){
                startLoading();
                _collectionFormViewModel.save()
                  .then((collection) {
                    CollectionsListViewModel.instance.addCollection(collection!);
                    stopLoading();
                    Navigator.pop(context);
                  })
                  .catchError(  (e) {
                    stopLoading();
                    _toasterService.dangerToaster(AppLocalizations.of(context)!.errorUnexpected);
                  });
              }else{
                _toasterService.dangerToaster(validation);
              }
          }
        },
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.add.toUpperCase()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.addCollection),),
      body: SingleChildScrollView(
          child: CollectionFormView(
            onChanged: (viewModel){
            },
            formKey: _collectionFormKey,
            viewModel: _collectionFormViewModel,
          )

      ),
    );
  }
}