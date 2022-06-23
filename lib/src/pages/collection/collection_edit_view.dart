import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/model/collection.dart';
import 'package:my_things/src/pages/collection/collection_form_view.dart';
import 'package:my_things/src/pages/collection/collections_list_view_model.dart';
import 'package:my_things/src/service/backend/database_collection_service.dart';
import 'package:my_things/src/service/frontend/dialog_service.dart';
import 'package:my_things/src/service/frontend/toaster_service.dart';
import 'collection_form_view_model.dart';


class CollectionEditView extends StatefulWidget {
  const CollectionEditView({Key? key , required this.collection}) : super(key: key);
  final Collection collection;

  @override
  State<StatefulWidget> createState() => _CollectionEditViewState();
}

class _CollectionEditViewState extends State<CollectionEditView> {
  final GlobalKey<FormState>      _collectionFormKey = GlobalKey<FormState>();
  late final  DialogService       _dialogService = DialogService(context);
  late final ToasterService       _toasterService = ToasterService(context);
  CollectionFormMode              _mode = CollectionFormMode.EDIT;

  final GlobalKey<State>          _keyLoader = GlobalKey<State>();

  startLoading() async {
    await _dialogService.showLoadingDialog( loadingDialogKey: _keyLoader);
  }
  stopLoading(){
    Navigator.of(_keyLoader.currentContext!,rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final CollectionFormViewModel   _collectionFormViewModel = CollectionFormViewModel.fromCollection(widget.collection, _mode, context);

    return  Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text(AppLocalizations.of(context)!.editCollection),
          const Spacer(),
          IconButton(
              onPressed: () async {
                bool? confirmation = await _dialogService.showConfirmDialog(
                    confirmDialogTitle: AppLocalizations.of(context)!.confirmDeletion,
                    confirmDialogContent: Text(AppLocalizations.of(context)!.confirmdeleteCollection(widget.collection.name)) );
                if(confirmation != null && confirmation){
                  startLoading();
                  DatabaseCollectionService.instance.deleteCollection(widget.collection)
                      .then((e) {
                    CollectionsListViewModel.instance.deleteCollection(widget.collection);
                    stopLoading();
                    Navigator.pop(context);
                  });
                }

              },
              icon: const Icon(Icons.delete)
          ),
        ],),
      ),
      floatingActionButton:  FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () {
          if (_collectionFormKey.currentState!.validate()) {
            String? validation = _collectionFormViewModel.isValid();
            if(validation == null){
              startLoading();
              _collectionFormViewModel.save()
              .then((collection) {
                if(_mode == CollectionFormMode.EDIT){
                  CollectionsListViewModel.instance.editCollection(collection!);
                }else{
                  CollectionsListViewModel.instance.addCollection(collection!);
                }
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
        label: Text(AppLocalizations.of(context)!.update.toUpperCase()),
      ),
      body: SingleChildScrollView(
          child:CollectionFormView(
              viewModel: _collectionFormViewModel,
              formKey: _collectionFormKey,
              onChanged: (viewModel){}
          )


    ));
  }
}