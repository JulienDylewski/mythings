import 'dart:io';
import 'package:my_things/src/model/item.dart';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/model/collection.dart';
import 'package:my_things/src/model/collection_field.dart';
import 'package:my_things/src/model/item_field.dart';
import 'package:my_things/src/service/backend/database_item_service.dart';
import 'package:my_things/src/service/backend/storage_service.dart';

enum ItemFormMode{
  CREATE,
  EDIT,
  DUPLICATE
}

class ItemFormViewModel extends ChangeNotifier {
  ItemFormViewModel(this.collection)
  :mode = ItemFormMode.CREATE, fields = List.empty(growable: true)
  {
    for(CollectionField field in collection.fields){
      switch(field.type.type){
        case ItemFieldNumber.TYPE_NAME:
          fields.add(ItemFieldNumber(name: field.name));
          break;
        case ItemFieldImage.TYPE_NAME:
          fields.add(ItemFieldImage(name: field.name));
          break;
        case ItemFieldTextLong.TYPE_NAME:
          fields.add(ItemFieldTextLong(name: field.name));
          break;
        case ItemFieldTextShort.TYPE_NAME:
          fields.add(ItemFieldTextShort(name: field.name));
          break;
        case ItemFieldDate.TYPE_NAME:
          fields.add(ItemFieldDate(name: field.name));
          break;
        case ItemFieldDropDownText.TYPE_NAME:
          fields.add(ItemFieldDropDownText(name: field.name));
          break;
        case ItemFieldCheckBoxList.TYPE_NAME:
          fields.add(ItemFieldCheckBoxList(name: field.name, value: List.empty(growable: true)));
          break;
        case ItemFieldCheckBox.TYPE_NAME:
          fields.add(ItemFieldCheckBox(name: field.name, value: false));
          break;
      }
    }
  }

  ItemFormViewModel.editMode(this.collection, this.item)
    : mode = ItemFormMode.EDIT , fields = item!.fields;

  ItemFormViewModel.duplicateMode(this.collection, this.item)
    : mode = ItemFormMode.DUPLICATE , fields = ItemField.cloneList(item!.fields);

  ItemFormMode mode;
  Collection collection;
  Item? item;
  late List<ItemField> fields;

  setShortTextItemValue(String name, String? value){
    ItemFieldTextShort field = fields
                              .where((element) => element.name == name)
                              .toList().first as ItemFieldTextShort;
    field.value = value;
    notifyListeners();
  }
  setLongTextItemValue(String name, String? value){
    ItemFieldTextLong field = fields
                              .where((element) => element.name == name)
                              .toList().first as ItemFieldTextLong;
    field.value = value;
    notifyListeners();
  }
  setNumberItemValue(String name, double? value){
    ItemFieldNumber field = fields
                            .where((element) => element.name == name)
                            .toList().first as ItemFieldNumber;
    field.value = value;
    notifyListeners();
  }
  setImageItemValue(String name, File? value){
    ItemFieldImage field = fields
                            .where((element) => element.name == name)
                            .toList().first as ItemFieldImage;
    field.file = value;
    notifyListeners();
  }
  setDateItemValue(String name, DateTime? value){
    ItemFieldDate field = fields
                            .where((element) => element.name == name)
                            .toList().first as ItemFieldDate;
    field.value = value;
    notifyListeners();
  }

  setDropDownTextValue(String name, String? value){
    ItemFieldDropDownText field = fields.where((element) => element.name == name).toList().first as ItemFieldDropDownText;
    field.value = value;
    notifyListeners();
  }

  setCheckboxListValue(String name, String value, bool checked){
    ItemFieldCheckBoxList field = fields.where((element) => element.name == name).toList().first as ItemFieldCheckBoxList;
    bool isAlreadChecked = field.value.contains(value);
    if(checked && !isAlreadChecked){
      field.value.add(value);
    } else{
      field.value.remove(value);
    }
    notifyListeners();
  }

  setCheckBoxValue(String name, bool checked){
    ItemFieldCheckBox field = fields.where((element) => element.name == name).toList().first as ItemFieldCheckBox;
    field.value = checked;
    notifyListeners();
  }



  Future<Item?> save() async {
    if(mode == ItemFormMode.CREATE || mode == ItemFormMode.DUPLICATE){
      for(ItemField field in fields){
        if(field is ItemFieldImage){
          if(field.file != null && await field.file!.exists()){
            field.value = await StorageService.instance.uploadFileAndGetAppFile(field.file!, collection.userUid!);
          }
        }
      }
      Item item = Item(collection.docRef!, collection.userUid!, fields, DateTime.now(), DateTime.now());
      return await DatabaseItemService.instance.addItem(item: item);
    }

    if (mode == ItemFormMode.EDIT) {
      for (ItemField field in fields) {
        if (field is ItemFieldImage) {
          if (field.file != null && await field.file!.exists()) {
            if (field.value != null) {
              await StorageService.instance.deleteFile(field.value!.ref);
            }
            field.value = await StorageService.instance.uploadFileAndGetAppFile(field.file!, collection.userUid!);
          }
          // TODO: find how to delete file without replace it with local
        }

      }
      item!.fields = fields;
      item!.updatedAt = DateTime.now();
      return await DatabaseItemService.instance.saveCollectionItem(item: item!);
    }

    return null;
  }
}