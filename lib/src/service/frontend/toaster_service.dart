
import 'package:flutter/material.dart';

/// Service pour l'affichage de Snackbar https://docs.flutter.dev/cookbook/design/snackbars, doit être
/// instancié avec le BuildContext
class ToasterService {
  ToasterService(this.viewContext) ;

  final BuildContext viewContext;

  void warningToaster(String message){
    ScaffoldMessenger.of(viewContext).clearSnackBars();
    ScaffoldMessenger.of(viewContext).showSnackBar(
        SnackBar(
            content: Text(message),
            backgroundColor: Colors.amber.shade800,

        )
    );
  }

  void dangerToaster(String message){
    ScaffoldMessenger.of(viewContext).clearSnackBars();
    ScaffoldMessenger.of(viewContext).showSnackBar(
        SnackBar(
            content: Text(message),
            backgroundColor: Colors.red.shade500
        )
    );
  }

  void successToaster(String message){
    ScaffoldMessenger.of(viewContext).clearSnackBars();
    ScaffoldMessenger.of(viewContext).showSnackBar(
        SnackBar(
            content: Text(message),
            backgroundColor: Colors.green.shade500
        )
    );
  }
}