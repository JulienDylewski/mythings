import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_things/src/model/item.dart';
import 'package:my_things/src/model/item_field.dart';
import 'package:my_things/src/service/backend/logger_service.dart';
import 'package:my_things/src/service/backend/storage_service.dart';

class DatabaseItemServiceException implements Exception {
  DatabaseItemServiceException(this.errorMsg);
  String errorMsg;

  @override
  String toString() {
    return errorMsg;
  }
}

class DatabaseItemService {
  DatabaseItemService._privateConstructor();
  static final DatabaseItemService _instance = DatabaseItemService._privateConstructor();
  static DatabaseItemService get instance => _instance;

  final collectionItemRef = FirebaseFirestore.instance.collection('collection_items').withConverter<Item>(
    fromFirestore: (snapshot, _) => Item.fromJson(snapshot.data()!),
    toFirestore: (collectionItem, _) => collectionItem.toJson(),
  );

  Future<Item?> saveCollectionItem({required Item item})async {
    try{
      await collectionItemRef.doc(item.docRef).set(item);
      return item;
    }catch (e, s){
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw DatabaseItemServiceException("saveCollectionItem");
    }
  }

  Future<void> deleteItem({required Item item}) async{
    try{
      for(ItemField field in item.fields){
        if(field is ItemFieldImage){
          if(field.value != null){
            await StorageService.instance.deleteFile(field.value!.ref);
          }
        }
      }

      await collectionItemRef.doc(item.docRef).delete();
    }catch (e, s){
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw DatabaseItemServiceException("deleteCollectionItem");
    }
  }
  
  Future<Item?> addItem({required Item item})async {
    try{
      DocumentReference<Item> ref =  await collectionItemRef.add(item);
      item.docRef = ref.id;
      return item;
    }catch (e, s){
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw DatabaseItemServiceException("addCollectionItem");
    }
  }

  Future<List<Item>?> getItems({required String collectionRef}) async {
    List<Item> items = List.empty(growable: true);
    try{
      QuerySnapshot c =await  collectionItemRef
          .where('collectionRef', isEqualTo: collectionRef)
          .orderBy('createdAt', descending: true)
          .get();
      for (var snapshotObject in c.docs) {
        Item item = snapshotObject.data() as Item;
        for(ItemField field in item.fields){
          if(field is ItemFieldImage){
            if(field.value != null){
              field.value!.downloadUrl =  await StorageService.instance.getDownloadUrl(field.value!.ref);

            }
          }
        }
        item.docRef = snapshotObject.id;
        items.add(item);
      }
    }catch (e, s){
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw DatabaseItemServiceException("getCollectionItems");
    }
    return items;
  }

  Future<void> deleteItems({required String collectionRef}) async {
    try{
      WriteBatch batch = FirebaseFirestore.instance.batch();

      await collectionItemRef
          .where('collectionRef', isEqualTo: collectionRef)
          .get()
          .then((querySnapshot) async {
            //delete item images from storage
            for (var document in querySnapshot.docs) {
              for(ItemField field in document.data().fields){
                if(field is ItemFieldImage){
                  if(field.value != null){
                    await StorageService.instance.deleteFile(field.value!.ref);
                  }
                }
              }
              //delete item from db
              batch.delete(document.reference);
            }
          return batch.commit();
        });
    }catch (e, s){
      LoggerService.instance.logFatalError(error: e, stackTrace: s);
      throw DatabaseItemServiceException(e.toString());
    }
  }

}