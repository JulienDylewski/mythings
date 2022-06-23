import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/model/app_user.dart';

class AppGlobalState extends ChangeNotifier {
  AppGlobalState._privateConstructor();
  static final AppGlobalState _instance = AppGlobalState._privateConstructor();
  static AppGlobalState get instance => _instance;

  AppUser?                _loggedUser;
  bool                    _appGlobalLoading = false;
  Locale                  _locale = const Locale.fromSubtags(languageCode: 'fr');

  AppUser?                get loggedUser        { return _loggedUser ;}
  bool                    get appGlobalLoading  { return _appGlobalLoading;}
  Locale                  get locale            { return _locale; }

  void setLoggedUser(AppUser? user) {
    _loggedUser = user;
    notifyListeners();
  }

  void deleteLoggedUser() {
    _loggedUser = null;
    notifyListeners();
  }

  void setAppGlobalLoading(bool value){
    _appGlobalLoading = value;
    notifyListeners();
  }

  void setLocale(Locale local) {
    _locale = local;
    notifyListeners();
  }

}