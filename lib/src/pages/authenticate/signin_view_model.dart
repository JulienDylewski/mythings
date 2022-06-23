import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/service/backend/authentication_service.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';
import 'package:my_things/src/service/frontend/toaster_service.dart';

class SignInViewModel with ChangeNotifier {

  SignInViewModel(this.viewContext) :
        _authService = AuthenticationService.instance,
        _toasterService =  ToasterService(viewContext);

  final BuildContext  viewContext;
  final AuthenticationService _authService;
  final ToasterService        _toasterService ;
  final AppGlobalState        _appGlobalState = AppGlobalState.instance;

  Future<bool> signIn(String email, String password) async {
    _appGlobalState.setAppGlobalLoading(true);
    bool success = true;
    await _authService.signInWithEmailAndPassword(email: email, password: password)
        .then( (user) {
      _appGlobalState.setLoggedUser(user);
      _toasterService.successToaster(AppLocalizations.of(viewContext)!.loginSuccess);
    })
        .catchError( (e) {
      if(e is AuthenticationServiceException){
        success =  false;
        switch(e.errorCode){
          case 'user-not-found':
            _toasterService.warningToaster(AppLocalizations.of(viewContext)!.errorEmailNoUserFound);
            break;
          case 'wrong-password':
            _toasterService.warningToaster(AppLocalizations.of(viewContext)!.errorPasswordWrong);
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