import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/form_fields/email_form_field.dart';
import 'package:my_things/src/components/form_fields/password_form_field.dart';
import 'package:my_things/src/pages/authenticate/signin_view_model.dart';
import 'package:provider/provider.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SignInViewModel(context) ,
        child: const _SignInView()
    );
  }
}

class _SignInView extends StatefulWidget{
  const _SignInView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInViewState();

}

class _SignInViewState extends State<_SignInView> {

  final _formKey = GlobalKey<FormState>();

  String emailField           = "";
  String passwordField        = "";

  @override
  Widget build(BuildContext context) {
    SignInViewModel viewModel = Provider.of<SignInViewModel>(context);

    return SingleChildScrollView(child:Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
      child: Column(
        children: [
        const Image(image: AssetImage('assets/logo.png'), width: 70,),
          SizedBox(height: 10,),
          Image(image: AssetImage('assets/mythings.png'), height: 30,),
          SizedBox(height: 50,),
          Form(
            key: _formKey,
            child: Column(
              children: [
                EmailFormField(
                  onChanged: (value) => emailField = value,
                  currentValue: emailField,
                ),
                const SizedBox(height: 20.0),
                PasswordFormField(
                  onChanged: (value) => passwordField = value,
                  currentValue: passwordField,
                  maxLength: 30,
                ),
                const SizedBox(height: 15.0),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        await viewModel.signIn(emailField, passwordField)
                            .then((success){
                          if(success){
                            Navigator.pushReplacementNamed(context, "/");
                          }
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),),
              child: Row(
                children: [
                  Image(image: AssetImage('assets/google_logo.png'), height: 20,),
                  SizedBox(width: 20,),
                  Expanded(child: Text(
                    AppLocalizations.of(context)!.signInWithGoogle,
                    style: const TextStyle(color: Colors.black),
                  )),
                ],
              ),
              onPressed: () async {

              },
            ),
          )
        ],
      )
    ));
  }
}