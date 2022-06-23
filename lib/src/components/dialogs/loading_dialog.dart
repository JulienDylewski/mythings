import 'package:my_things/src/common/common.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    Key? key,
    required  this.loadingDialogKey
  }) : super(key: key);

  final GlobalKey loadingDialogKey;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =   AppLocalizations.of(context)!;

    return WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(
            key: loadingDialogKey,
            backgroundColor: Colors.black,
            children: <Widget>[
              Center(
                child: Column(children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10,),
                  Text(localizations.loadingProgress,style: const TextStyle(color: Colors.white),)
                ]),
              )
            ]
        )
    );
  }

}