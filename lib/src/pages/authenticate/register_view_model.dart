import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/service/backend/authentication_service.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';
import 'package:my_things/src/service/frontend/toaster_service.dart';

class RegisterViewModel with ChangeNotifier {

  RegisterViewModel(this.viewContext) :
        _authService = AuthenticationService.instance,
        _toasterService =  ToasterService(viewContext);

  final BuildContext  viewContext;
  final AuthenticationService _authService;
  final ToasterService        _toasterService ;
  final AppGlobalState        _appGlobalState = AppGlobalState.instance;

  Future<bool> register(String email, String password, String username) async {
    _appGlobalState.setAppGlobalLoading(true);
    bool success = true;
    await _authService.register(email:email, password: password, username: username)
        .then( (user) {
      _appGlobalState.setLoggedUser(user);
      _toasterService.successToaster(AppLocalizations.of(viewContext)!.loginSuccess);
    })
        .catchError( (e) {
      if(e is AuthenticationServiceException){
        success =  false;
        switch(e.errorCode){
          case 'email-already-in-use':
            _toasterService.warningToaster(AppLocalizations.of(viewContext)!.errorEmailAlreadyExist);
            break;
          default:
            _toasterService.dangerToaster(AppLocalizations.of(viewContext)!.errorUnexpected);
        }
      }else{
        _toasterService.dangerToaster(AppLocalizations.of(viewContext)!.errorUnexpected);
      }
    });
    _appGlobalState.setAppGlobalLoading(false);
    return success;
  }

}