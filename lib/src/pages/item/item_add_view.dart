import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/model/collection.dart';
import 'package:my_things/src/pages/item/item_form_view.dart';
import 'package:my_things/src/pages/item/item_form_view_model.dart';
import 'package:my_things/src/pages/item/item_list_view_model.dart';
import 'package:my_things/src/service/frontend/dialog_service.dart';
import 'package:my_things/src/service/frontend/toaster_service.dart';

class ItemAddPopUpView extends StatefulWidget {
  const ItemAddPopUpView({Key? key, required this.collection}) : super(key: key);
  final Collection collection;

  @override
  State<StatefulWidget> createState() => _ItemAddPopUpViewState();
}

class _ItemAddPopUpViewState extends State<ItemAddPopUpView> {
  final GlobalKey<FormState>      _itemFormKey = GlobalKey<FormState>();
  late final  DialogService       _dialogService = DialogService(context);
  late final ToasterService       _toasterService = ToasterService(context);
  late final ItemFormViewModel    _collectionItemFormViewModel = ItemFormViewModel(widget.collection);

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
          if(_itemFormKey.currentState!.validate()){
            startLoading();
            _collectionItemFormViewModel.save()
              .then((itemAdded) {
                stopLoading();
                ItemListViewModel.instance.addCollectionItem(itemAdded!);
                Navigator.pop(context);

              })
              .catchError((ret) {
                stopLoading();
                _toasterService.dangerToaster(AppLocalizations.of(context)!.errorUnexpected);
              });
          }
        },
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.add.toUpperCase()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.addNamed(widget.collection.name))),
      body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: ItemFormView(
              onChanged: (viewModel){
              },
              formKey: _itemFormKey,
              viewModel: _collectionItemFormViewModel,
            ),
          )
      ),
    );
  }
}