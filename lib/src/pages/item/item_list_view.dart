import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/image_box/image_box_view.dart';
import 'package:my_things/src/model/collection.dart';
import 'package:my_things/src/model/collection_field.dart';
import 'package:my_things/src/model/collection_field_view.dart';
import 'package:my_things/src/model/item.dart';
import 'package:my_things/src/model/item_field.dart';
import 'package:my_things/src/pages/item/item_add_view.dart';
import 'package:my_things/src/pages/item/item_edit_view.dart';
import 'package:my_things/src/service/backend/database_item_service.dart';
import 'package:my_things/src/service/frontend/dialog_service.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';
import 'package:provider/provider.dart';

import 'item_details_view.dart';
import 'item_duplicate_view.dart';
import 'item_list_view_model.dart';

class ItemListView extends StatefulWidget{
  const ItemListView({Key? key, required this.collection, this.activeView =  CollectionFieldView.DEFAULT_VIEW}) : super(key: key);
  final Collection collection;
  final String activeView;

  @override
  State<StatefulWidget> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView>{
  late final  DialogService       _dialogService = DialogService(context);
  late final AppGlobalState _appState = Provider.of<AppGlobalState>(context, listen: false);
  Widget cardsRender(List<Item> items, List<String> activeViewFieldToDisplay){
    List<Widget> widgets = List.empty(growable: true);
    for(Item item in items){
      List<Widget> itemDisplayed = List.empty(growable: true);

      List<ItemField> fieldsToDisplay =  item.fields.where((field) => activeViewFieldToDisplay.contains(field.name)).toList();
      for(ItemField field in fieldsToDisplay){
        if(field is ItemFieldTextShort ){
          itemDisplayed.add(Row(children: [Text(field.name), const Spacer(),
            Text(field.value != null ? field.value.toString() : "")
          ]));
        }
        if(field is ItemFieldTextLong ){
          itemDisplayed.add(Row(children: [Text(field.name), const Spacer(),
            Text(field.value != null ? field.value.toString().shorten(100) : "")
          ]));
        }
        if(field is ItemFieldNumber ){
          itemDisplayed.add(Row(children: [Text(field.name), const Spacer(),
            Text(field.value != null ? field.value.toString() : "")
          ]));
        }
        if(field is ItemFieldImage ){
          itemDisplayed.add(Row(children: [Text(field.name), const Spacer(),
            field.value != null ? Expanded(child: ImageBoxView.network(field.value!.safeDownloadUrl, 100),) : Text("")
          ]));
        }
        if(field is ItemFieldDate){
          itemDisplayed.add(Row(children: [Text(field.name), const Spacer(),
            Text(field.value != null ? DateFormat.yMEd(_appState.locale.languageCode).format(field.value!) : "")
          ]));
        }
        if(field is ItemFieldCheckBox){
          itemDisplayed.add(Row(children: [
            Text(field.name), const Spacer(),
            Text(field.value ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no)
          ]));
        }
        if(field is ItemFieldCheckBoxList){
          itemDisplayed.add(Row(children: [Text(field.name), const Spacer(),
            Text(field.value.isNotEmpty ? field.value.toString() : "")
          ]));
        }
        if(field is ItemFieldDropDownText){
          itemDisplayed.add(Row(children: [Text(field.name), const Spacer(),
            Text(field.value != null ? field.value.toString() : "")
          ]));
        }
      }
      itemDisplayed.insert(0, ListTile(
          title: Row(
            children: [
              const Spacer(),
              IconButton(
                  onPressed: (){
                    Navigator.push(context,  MaterialPageRoute(
                        builder: (context) => ItemEditView(collection: widget.collection, item: item,)));
                  },
                  icon: const Icon(Icons.edit)
              ),
              IconButton(
                  onPressed: (){
                    _dialogService.showConfirmDialog(confirmDialogTitle: AppLocalizations.of(context)!.dialogDuplicate)
                        .then((duplicateBool) {
                          if(duplicateBool == true){
                            Navigator.push(context,  MaterialPageRoute(
                                builder: (context) => ItemDuplicateView(collection: widget.collection, item: item)));
                          }
                        });
                  },
                  icon: const Icon(Icons.content_copy)
              )

            ],
          )
        ));



      widgets.add(Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(5),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child:
        GestureDetector(
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => ItemDetailsView(collection: widget.collection, item: item)));
            },
            behavior: HitTestBehavior.translucent,
            child:
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: itemDisplayed,
              ),
            )

        )
      )
      );
    }
    return Column(
      children: widgets,
    );
  }

  Widget renderCollectionItemList(List<Item> items, List<String> activeViewFieldToDisplay){
    switch(widget.activeView){
      case CollectionFieldView.DEFAULT_VIEW:
        return cardsRender(items, activeViewFieldToDisplay);
      default:
        return const Text("No View Selected");
    }
  }




  @override
  Widget build(BuildContext context) {
    ItemListViewModel viewModel = Provider.of<ItemListViewModel>(context);
    List<String> activeViewDisplayedFields =  widget.collection.fieldViews
          .where((fv) => fv.name == widget.activeView).first.fieldShowed;

    return SingleChildScrollView(
      child: Column(
        children: [renderCollectionItemList(viewModel.items, activeViewDisplayedFields)],
      ),
    );
  }

}