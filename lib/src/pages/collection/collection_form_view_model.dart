import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/model/app_file.dart';
import 'package:my_things/src/model/collection.dart';
import 'package:my_things/src/model/collection_field.dart';
import 'package:my_things/src/model/collection_field_view.dart';
import 'package:my_things/src/model/item_field.dart';
import 'package:my_things/src/service/backend/database_collection_service.dart';
import 'package:my_things/src/service/backend/storage_service.dart';
import 'package:path/path.dart';

enum CollectionFormMode {
  CREATE,
  READ,
  EDIT,
}

class CollectionFormViewModel extends ChangeNotifier{
  CollectionFormMode              _mode;
  Collection?                     _collectionUsedToCreate;
  String                          _userId;
  BuildContext                    _context;

  String?                         _name;
  File?                           _image;
  List<CollectionField>           _fields = List.empty(growable: true);
  List<String>                    _defaultViewFields = List.empty(growable: true);

  CollectionFormMode              get mode => _mode;
  Collection?                     get collectionUsedToCreate => _collectionUsedToCreate;
  String?                         get name => _name;
  File?                           get image => _image;
  List<CollectionField>           get fields => _fields;
  List<String>                    get defaultViewFields => _defaultViewFields;

  CollectionFormViewModel(
      this._mode,
      this._userId,
      this._context
  ) {
    _name = null;
    _image = null;
  }

  CollectionFormViewModel._(this._mode, this._name, this._image, this._fields, this._defaultViewFields, this._collectionUsedToCreate, this._userId, this._context);

  factory CollectionFormViewModel.fromCollection(Collection collection, CollectionFormMode mode, BuildContext context){
      return CollectionFormViewModel._(
        mode,
        collection.name,
        null,
        collection.fields,
        collection.fieldViews.where((fieldView) => fieldView.name == CollectionFieldView.DEFAULT_VIEW).first.fieldShowed,
        collection,
        collection.userUid!,
        context
      );
  }

  setTitle(String? title){
    _name = title;
    notifyListeners();
  }

  setImage(File? image){
    _image = image;
    notifyListeners();
  }

  addFieldView(String name ){
    _defaultViewFields.add(name);
    notifyListeners();
  }

  removeFieldView(String name){
    _defaultViewFields.remove(name);
    notifyListeners();
  }

  addField(CollectionField field){
    _fields.add(field);
    notifyListeners();
  }

  removeField(CollectionField field){
    _fields.remove(field);
    notifyListeners();
  }

  bool hasField(CollectionField field){
    for (var element in _fields) {
      if(field == element){
        return true;
      }
    }
    return false;
  }


  String? isValid(){
    if(fields.isEmpty){
      return AppLocalizations.of(_context)!.errorCollectionFields;
    }
    if(defaultViewFields.isEmpty){
      return AppLocalizations.of(_context)!.errorCollectionFieldsViewDefault;
    }
    return null;
  }

  Future<Collection?> save() async {
    if(_mode == CollectionFormMode.EDIT){
      if(image == null){
        return DatabaseCollectionService.instance.saveCollection(_collectionUsedToCreate!.docRef!, _defaultViewFields,
            collectionUsedToCreate!.image , name);
      }
      await StorageService.instance.deleteFile(collectionUsedToCreate!.image.ref);
      AppFile appFile = await StorageService.instance.uploadFileAndGetAppFile(image!, _userId);
      return await DatabaseCollectionService.instance.saveCollection(_collectionUsedToCreate!.docRef!,
          _defaultViewFields, appFile, name);
    }
    if(_mode == CollectionFormMode.CREATE){
      UploadTask task = await StorageService.instance.uploadFile(image!, _userId);
      AppFile appFile = AppFile(ref: task.snapshot.ref.fullPath, name: basename(image!.path));
      return await DatabaseCollectionService.instance.addCollection(image: appFile, name: _name!, fields: _fields, defaultShowedFields: defaultViewFields);

    }
    return null;

  }

}