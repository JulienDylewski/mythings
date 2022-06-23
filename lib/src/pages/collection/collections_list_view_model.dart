import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_things/src/model/collection.dart';


class CollectionsListViewModel with ChangeNotifier {
  CollectionsListViewModel._privateConstructor();
  static final CollectionsListViewModel _instance = CollectionsListViewModel._privateConstructor();
  static CollectionsListViewModel get instance => _instance;

  late List<Collection> _collections;

  List<Collection> get collections => _collections;

  setCollection(List<Collection> newItems){
    _collections = newItems;
    notifyListeners();
  }

  addCollection(Collection item){
    _collections.insert(0, item);
    notifyListeners();
  }

  editCollection(Collection newItem){
    _collections[_collections.indexWhere((item) => item.docRef == newItem.docRef)] = newItem;
    notifyListeners();
  }

  deleteCollection(Collection itemToDelete){
    _collections.removeAt(_collections.indexWhere((item) => item.name == itemToDelete.name));
    notifyListeners();
  }
}