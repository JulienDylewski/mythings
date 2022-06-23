import 'package:flutter/material.dart';

/// service/notifier/AppGlobalState.appGlobalLoading
class AppGlobalLoading extends StatelessWidget {
  const AppGlobalLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black.withOpacity(0.3),
        child: const Center(
            child: CircularProgressIndicator()
        )
      );
  }
}