import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_things/src/model/app_user.dart';

import 'logger_service.dart';

class DatabaseUserServiceException implements Exception {
  DatabaseUserServiceException(this.errorMsg);
  String errorMsg;

  @override
  String toString() {
    return errorMsg;
  }
}

/// (Singleton) Service traitant avec la collection users dans firestore
class DatabaseUserService {
  DatabaseUserService._privateConstructor();
  static final DatabaseUserService _instance = DatabaseUserService._privateConstructor();
  static DatabaseUserService get instance => _instance;


  /// le withConverter, permet des opérations sans avoir à faire les serialisations en json
  /// pour être utilisé nécessite deux methodes dans le mode : toJson et fromJson
  final usersRef = FirebaseFirestore.instance.collection('users').withConverter<AppUser>(
    fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
    toFirestore: (user, _) => user.toJson(),
  );

  Future<AppUser?> addUser({required String uid, required String username, required String email})async {
    AppUser user = AppUser(uid: uid, email: email, username: username);
    try{
      await usersRef.doc(uid).set(user);
      return user;
    }catch (e, s){
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw DatabaseUserServiceException("addUser");
    }
  }

  Future<AppUser?> getUserByUid(String uid) async {
    AppUser? user;
    try{
      await usersRef.doc(uid).get()
          .then((u) => user = u.data()!);
      user!.uid = uid;
    }catch(e,s){
      LoggerService.instance.logFatalError(error: s, stackTrace: s);
      throw DatabaseUserServiceException("getUserByUid");
    }
    return user;

  }
}