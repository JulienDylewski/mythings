import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';

class AccountView extends StatelessWidget{
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Selected Language : ${AppGlobalState.instance.locale.languageCode}"),
        ElevatedButton(
            onPressed: (){AppGlobalState.instance.setLoggedUser(null);Navigator.pushReplacementNamed(context, "/");},
            child: Text(AppLocalizations.of(context)!.logout)
        )
      ],
    );
  }

}