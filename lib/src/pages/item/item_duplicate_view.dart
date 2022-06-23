import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/model/collection.dart';
import 'package:my_things/src/model/item.dart';
import 'package:my_things/src/pages/item/item_form_view.dart';
import 'package:my_things/src/pages/item/item_form_view_model.dart';
import 'package:my_things/src/pages/item/item_list_view_model.dart';
import 'package:my_things/src/service/frontend/dialog_service.dart';
import 'package:my_things/src/service/frontend/toaster_service.dart';

class ItemDuplicateView extends StatefulWidget {
  const ItemDuplicateView({Key? key, required this.collection, required this.item}) : super(key: key);
  final Collection collection;
  final Item item;

  @override
  State<StatefulWidget> createState() => _ItemDuplicateViewState();
}

class _ItemDuplicateViewState extends State<ItemDuplicateView> {
  final GlobalKey<FormState>      _itemFormKey  = GlobalKey<FormState>();
  late final  DialogService       _dialogService      = DialogService(context);
  late final ToasterService       _toasterService     = ToasterService(context);
  late final ItemFormViewModel    _itemFormViewModel  = ItemFormViewModel.duplicateMode(widget.collection, widget.item);

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
            _itemFormViewModel.save()
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.add)),
      body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: ItemFormView(
              onChanged: (viewModel){
              },
              formKey: _itemFormKey,
              viewModel: _itemFormViewModel,
            ),
          )
      ),
    );
  }
}