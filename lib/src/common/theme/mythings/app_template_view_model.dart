import 'package:flutter/cupertino.dart';
import 'package:my_things/src/service/backend/authentication_service.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';
import 'package:my_things/src/service/frontend/toaster_service.dart';
import 'package:my_things/src/common/common.dart';

class AppTemplateViewModel extends ChangeNotifier {
  AppTemplateViewModel(this._viewContext) :
      _authService = AuthenticationService.instance,
      _toasterService =  ToasterService(_viewContext);

  final BuildContext _viewContext;
  final AuthenticationService _authService;
  final ToasterService        _toasterService;
  final AppGlobalState        _appGlobalState = AppGlobalState.instance;

  Future<void> signOut() async {
    Navigator.of(_viewContext).pop();
    _appGlobalState.setAppGlobalLoading(true);
    _authService.signOut()
      .then((_) {
        _appGlobalState.deleteLoggedUser();
        _toasterService.successToaster(AppLocalizations.of(_viewContext)!.logoutSuccess);
      })
      .catchError((_) {
        _toasterService.dangerToaster(AppLocalizations.of(_viewContext)!.errorUnexpected);
      });
    _appGlobalState.setAppGlobalLoading(false);
  }
}