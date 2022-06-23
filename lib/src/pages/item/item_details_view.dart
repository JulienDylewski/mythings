import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/display_fields/checkbox_display_field.dart';
import 'package:my_things/src/components/display_fields/checkboxlist_display_field.dart';
import 'package:my_things/src/components/display_fields/date_display_field.dart';
import 'package:my_things/src/components/display_fields/display_field.dart';
import 'package:my_things/src/components/display_fields/dropdowntext_display_field.dart';
import 'package:my_things/src/components/display_fields/image_display_field.dart';
import 'package:my_things/src/components/display_fields/number_display_field.dart';
import 'package:my_things/src/components/display_fields/textlong_display_field.dart';
import 'package:my_things/src/components/display_fields/textshort_display_field.dart';
import 'package:my_things/src/model/collection.dart';
import 'package:my_things/src/model/item.dart';
import 'package:my_things/src/model/item_field.dart';
import 'package:my_things/src/service/backend/database_item_service.dart';
import 'package:my_things/src/service/frontend/dialog_service.dart';

import 'item_list_view_model.dart';
import 'items_view.dart';

class ItemDetailsView extends StatelessWidget {
  const ItemDetailsView({Key? key, required this.collection, required this.item}) : super(key: key);
  final Collection collection;
  final Item item;


  @override
  Widget build(BuildContext context) {
    late final  DialogService _dialogService = DialogService(context);

    return  Scaffold(
      appBar: AppBar(title:
        Row(
          children: [
            Text(AppLocalizations.of(context)!.item_details),
            const Spacer(),
            IconButton(
                onPressed: (){
                  _dialogService.showConfirmDialog(confirmDialogTitle: AppLocalizations.of(context)!.confirmdeleteCollectionItem(""))
                      .then((deleteBool) {
                          if(deleteBool == true){
                              DatabaseItemService.instance.deleteItem(item: item)
                                .then((e) {
                                  ItemListViewModel.instance.deleteCollectionItem(item);
                                  Navigator.pop(context);
                                });
                          }
                      });
                },
                icon: const Icon(Icons.delete)
            )
          ],
        )
      ),
      body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: getItemDetailsWidget(item, context),
          )
      ),
    );
  }
}


Widget getItemDetailsWidget(Item collectionItem, BuildContext context ) {
  List<Widget> fields = List.empty(growable: true);
  for(ItemField itemField in collectionItem.fields){
    if(itemField is ItemFieldTextShort){
      fields.add(TextShortDisplayField(itemField: itemField));
    }
    if(itemField is ItemFieldTextLong ){
      fields.add(TextLongDisplayField(itemField: itemField));
    }
    if(itemField is ItemFieldNumber){
      fields.add(NumberDisplayField(itemField: itemField));
    }
    if(itemField is ItemFieldImage && itemField.value != null){
      fields.add(ImageDisplayField(itemField: itemField));
    }
    if(itemField is ItemFieldDate){
      fields.add(DateDisplayField(itemField: itemField));
    }
    if(itemField is ItemFieldCheckBox){
      fields.add(CheckboxDisplayField(itemField: itemField));
    }
    if(itemField is ItemFieldCheckBoxList){
      fields.add(CheckboxListDisplayField(itemField: itemField));
    }
    if(itemField is ItemFieldDropDownText){
      fields.add(DropDownTextDisplayField(itemField: itemField));
    }
  }
  return Padding(
    padding: const EdgeInsets.all(1.0),
    child: Column(
      children: fields,
    )
  );
}