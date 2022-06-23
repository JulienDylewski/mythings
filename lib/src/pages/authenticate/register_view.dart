import 'package:flutter/services.dart';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/form_fields/email_form_field.dart';
import 'package:my_things/src/components/form_fields/password_form_field.dart';
import 'package:my_things/src/pages/authenticate/register_view_model.dart';
import 'package:my_things/src/service/frontend/toaster_service.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RegisterViewModel(context) ,
        child: const _RegisterView()
    );
  }
}

class _RegisterView extends StatefulWidget{
  const _RegisterView({Key? key}) : super(key: key);

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {

  final _formKey = GlobalKey<FormState>();

  String usernameField          = "";
  String emailField             = "";
  String passwordField          = "";
  String passwordConfirmField   = "";

  @override
  Widget build(BuildContext context) {
    RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);
    ToasterService        toasterService = ToasterService(context);

    return SingleChildScrollView(child:Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) => usernameField = value,

              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.username,
                  hintText: AppLocalizations.of(context)!.username
              ),
              maxLength: 50,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              validator: (value) => value == null || value.isWhitespace() ? AppLocalizations.of(context)!.errorIncorrectUsername : null,
            ),
            const SizedBox(height: 15.0),
            EmailFormField(
              onChanged: (value) => emailField = value,
              currentValue: emailField,
            ),
            const SizedBox(height: 15.0),
            PasswordFormField(
              onChanged: (value) => passwordField = value,
              currentValue: passwordField,
              maxLength: 30,
            ),
            const SizedBox(height: 15.0),
            PasswordFormField(
              onChanged: (value) => passwordConfirmField = value,
              currentValue: passwordConfirmField,
              labelText: AppLocalizations.of(context)!.passwordConfimation,
              maxLength: 30,
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              child: Text(
                AppLocalizations.of(context)!.createAnAccount,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState?.validate() == true) {
                  if(passwordField != passwordConfirmField){
                    toasterService.warningToaster(AppLocalizations.of(context)!.errorPasswordNotIdentical);
                  }else{
                    await viewModel.register(emailField, passwordField, usernameField)
                    .then((success){
                      if(success){
                        Navigator.pushReplacementNamed(context, "/");
                      }
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    ));
  }
}