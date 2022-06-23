import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_things/src/model/app_file.dart';
import 'package:my_things/src/model/collection.dart';
import 'package:my_things/src/model/collection_field.dart';
import 'package:my_things/src/model/collection_field_view.dart';
import 'package:my_things/src/service/backend/storage_service.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';

import 'package:my_things/src/service/backend/database_item_service.dart';
import 'logger_service.dart';

class DatabaseCollectionServiceException implements Exception {
  DatabaseCollectionServiceException(this.errorMsg);
  String errorMsg;

  @override
  String toString() {
    return errorMsg;
  }
}

class DatabaseCollectionService {
  DatabaseCollectionService._privateConstructor();
  static final DatabaseCollectionService _instance = DatabaseCollectionService._privateConstructor();
  static DatabaseCollectionService get instance => _instance;

  final collectionRef = FirebaseFirestore.instance.collection('collections').withConverter<Collection>(
    fromFirestore: (snapshot, _) => Collection.fromJson(snapshot.data()!),
    toFirestore: (collection, _) => collection.toJson(),
  );
  final StorageService _storageService = StorageService.instance;
  final DatabaseItemService _databaseCollectionItemServiceService = DatabaseItemService.instance;

  Future<Collection?> addCollection({ required AppFile image, required String name,
    required List<CollectionField> fields, required List<String> defaultShowedFields})async {

    Collection collection = Collection(
        image: image,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userUid: AppGlobalState.instance.loggedUser!.uid,
        fields: fields,
        fieldViews: <CollectionFieldView>[CollectionFieldView(CollectionFieldView.DEFAULT_VIEW, defaultShowedFields)]
    );

    try{
      DocumentReference<Collection> doc =  await collectionRef.add(collection);
      collection.docRef = doc.id;
      // TODO: Find why getDownloadURL throw 404 and delete this sleep method
      sleep(const Duration(milliseconds: 1000));
      collection.image.downloadUrl = await StorageService.instance.getDownloadUrl(collection.image.ref);
      return collection;
    }catch (e, s){
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw DatabaseCollectionServiceException("addCollection");
    }
  }

  Future<Collection?> saveCollection(String docRef, List<String> defaultShowedFields, AppFile image, String? collectionName ) async {
    try{

      Collection? collection = await  get(docRef);
      collection!.docRef = docRef;
      if(collectionName != null){
        collection.name = collectionName;
      }

      collection.image = image;

      collection.fieldViews.where((element) => element.name == CollectionFieldView.DEFAULT_VIEW).first.fieldShowed = defaultShowedFields;
      collection.updatedAt = DateTime.now();
      await collectionRef.doc(docRef).set(collection);
      return collection;
    }catch (e, s){
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw DatabaseCollectionServiceException("saveCollection");
    }
  }

  Future<void> deleteCollection(Collection collection) async {
    try{
        //delete collection image
        await _storageService.deleteFile(collection.image.ref);
        //delete collection items
        await _databaseCollectionItemServiceService.deleteItems(collectionRef: collection.docRef!);
        //delete collection
        return collectionRef.doc(collection.docRef).delete();
    }catch (e, s){
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw DatabaseCollectionServiceException("deleteCollection");
    }
  }


  Future<Collection?> get(String ref) async {
    try{
      return await collectionRef.doc(ref).get().then((document) => document.data());
    }catch(e, s){
      LoggerService.instance.logError(error: s, stackTrace: s);
      return null;
    }
  }

  Future<List<Collection>> getAll() async {
    List<Collection> collections = List<Collection>.empty(growable: true);
    try{
      QuerySnapshot c =await  collectionRef
          .where('userUid', isEqualTo: AppGlobalState.instance.loggedUser!.uid)
          .orderBy('createdAt', descending: true)
          .get();
      for (var snapshotObject in c.docs) {
        Collection collection = snapshotObject.data() as Collection;
        collection.docRef = snapshotObject.id;
        collection.image.downloadUrl = await _storageService.getDownloadUrl(collection.image.ref);

        collections.add(collection);
      }
    }catch (e, s){
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw DatabaseCollectionServiceException("getAll");
    }
    return collections;
  }


}