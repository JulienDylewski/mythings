import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_things/src/model/app_user.dart';
import 'package:my_things/src/service/backend/database_user_service.dart';
import 'logger_service.dart';

class AuthenticationServiceException implements Exception {
  AuthenticationServiceException(this.errorMsg, this.errorCode);
  String errorMsg;
  String errorCode;

  @override
  String toString() {
    return errorMsg;
  }
}

/// (Singleton) Service d'authentification , utilise firebase_auth et firestore
class AuthenticationService {
  /// Singleton syntax
  AuthenticationService._privateConstructor();
  static final AuthenticationService _instance = AuthenticationService._privateConstructor();
  static AuthenticationService get instance => _instance;

  final DatabaseUserService _databaseUserService = DatabaseUserService.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AppUser?> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      AppUser? user = await  _databaseUserService.getUserByUid(result.user!.uid);
      FirebaseCrashlytics.instance.setUserIdentifier(user!.uid!);
      return user;
    } on FirebaseAuthException catch (e,s) {
      switch(e.code){
        case 'user-not-found':
        case 'wrong-password':
          throw AuthenticationServiceException(e.toString(), e.code);
        default:
          LoggerService.instance.logFatalError(error: e, stackTrace: s);
          throw AuthenticationServiceException(e.toString(), 'signInWithEmailAndPassword  unHandled FirebaseAuthException');
      }
    }catch(e, s){
      LoggerService.instance.logFatalError(error: e, stackTrace: s);
      throw AuthenticationServiceException(e.toString(), 'signInWithEmailAndPassword');
    }
  }

  Future<AppUser?> register({ required String email, required String password, required String username }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return _databaseUserService.addUser(uid: result.user!.uid, email:email, username: username);
    } on FirebaseAuthException catch (e,s) {
      if (e.code == 'email-already-in-use') {
        throw AuthenticationServiceException(e.toString(), e.code);
      }
      LoggerService.instance.logFatalError(error: e, stackTrace: s);
      throw AuthenticationServiceException("register unHandled FirebaseAuthException", 'error');
    }catch(e,s){
      LoggerService.instance.logFatalError(error: e, stackTrace: s);
      throw AuthenticationServiceException("register", 'error');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e,s) {
      LoggerService.instance.logFatalError(error: e, stackTrace: s);
      throw AuthenticationServiceException("signOut", 'error');
    }
  }
}